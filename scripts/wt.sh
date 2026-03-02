#!/bin/bash

_wt_complete() {
    local project_name=$(basename "$PWD")
    local parent_dir=$(dirname "$PWD")
    local worktrees_dir="$parent_dir/${project_name}-worktrees"

    if [ -d "$worktrees_dir" ]; then
        local folders=$(ls -1 "$worktrees_dir" 2>/dev/null)
        COMPREPLY=($(compgen -W "$folders" -- "${COMP_WORDS[COMP_CWORD]}"))
    fi
}
complete -F _wt_complete wt

_wt_extract_issue_number() {
    local branch="$1"
    # Extract trailing digits from the branch name (e.g. feature/123 → 123)
    echo "$branch" | grep -oE '[0-9]+$'
}

_wt_get_github_repo() {
    local remote_url
    remote_url=$(git remote get-url origin 2>/dev/null) || return 1
    # Handle both SSH (git@github.com:owner/repo.git) and HTTPS forms
    echo "$remote_url" | sed -E 's|.*github\.com[:/]||; s|\.git$||'
}

_wt_fetch_gh_context() {
    local repo="$1"
    local issue="$2"

    if command -v gh &>/dev/null; then
        gh issue view "$issue" --repo "$repo" --json number,title,body,url \
            --template '## GitHub Issue #{{.number}}: {{.title}}

**URL:** {{.url}}

{{.body}}'
    elif [ -n "$GITHUB_TOKEN" ]; then
        local resp
        resp=$(curl -sf -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/$repo/issues/$issue")
        if [ -z "$resp" ]; then
            return 1
        fi
        local title url body
        title=$(echo "$resp" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('title',''))" 2>/dev/null)
        url=$(echo "$resp"   | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('html_url',''))" 2>/dev/null)
        body=$(echo "$resp"  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('body',''))" 2>/dev/null)
        printf '## GitHub Issue: %s\n\n**URL:** %s\n\n%s\n' "$title" "$url" "$body"
    else
        return 1
    fi
}

_wt_write_ticket_file() {
    local worktree_path="$1"
    local context="$2"
    printf '%s\n' "$context" > "$worktree_path/.claude-ticket.md"
    echo "Written ticket context to .claude-ticket.md"
}

_wt_add_gitignore_entry() {
    local worktree_path="$1"
    local gitignore="$worktree_path/.gitignore"
    if ! grep -qxF '.claude-ticket.md' "$gitignore" 2>/dev/null; then
        printf '\n.claude-ticket.md\n' >> "$gitignore"
        echo "Added .claude-ticket.md to .gitignore"
    fi
}

_wt_inject_claude_context() {
    local worktree_path="$1"
    local claude_md="$worktree_path/CLAUDE.md"
    local marker="<!-- TICKET-CONTEXT -->"

    local header
    header="$(cat <<EOF
$marker
> Claude: read \`.claude-ticket.md\` in this directory for ticket context. Print its contents so the user can confirm it loaded correctly, then wait for explicit instructions before starting any work.
$marker

EOF
)"
    if [ -f "$claude_md" ]; then
        # Skip if pointer already present
        if grep -qF "$marker" "$claude_md"; then
            return
        fi
        printf '\n%s\n' "$header" >> "$claude_md"
    else
        printf '%s\n' "$header" > "$claude_md"
    fi
    echo "Added ticket context pointer to CLAUDE.md"
}

wt() {
    local fetch_gh=false
    local branch_name=""

    for arg in "$@"; do
        if [ "$arg" = "-gh" ]; then
            fetch_gh=true
        else
            branch_name="$arg"
        fi
    done

    if [ -z "$branch_name" ]; then
        echo "Usage: wt <branch-name> [-gh]"
        echo "  -gh  Fetch GitHub issue #N from the branch name, write it to .claude-ticket.md"
        echo "       (gitignored), and append a pointer to CLAUDE.md. The ticket is printed in"
        echo "       the terminal before claude launches. Omitting -gh deletes any existing"
        echo "       .claude-ticket.md to prevent stale context."
        return 1
    fi

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    # Get the current project name (folder name)
    local project_name=$(basename "$PWD")

    # Get the parent directory
    local parent_dir=$(dirname "$PWD")

    # Create worktrees directory if it doesn't exist
    local worktrees_dir="$parent_dir/${project_name}-worktrees"
    if [ ! -d "$worktrees_dir" ]; then
        mkdir -p "$worktrees_dir"
        echo "Created worktrees directory: $worktrees_dir"
    fi

    # Replace / with - in branch name for folder name
    local folder_name="${branch_name//\//-}"
    local worktree_path="$worktrees_dir/$folder_name"

    # Check if worktree already exists
    if [ -d "$worktree_path" ]; then
        echo "Worktree already exists at: $worktree_path"
    else
        # Check if branch exists
        if git rev-parse --verify "$branch_name" >/dev/null 2>&1; then
            # Branch exists, checkout existing branch
            echo "Checking out existing branch '$branch_name'..."
            git worktree add "$worktree_path" "$branch_name"
        else
            # Branch doesn't exist, create new branch
            echo "Creating new branch '$branch_name' and worktree..."
            git worktree add -b "$branch_name" "$worktree_path"
        fi

        if [ $? -ne 0 ]; then
            echo "Error: Failed to create worktree"
            return 1
        fi

        # Copy temp/gitignored files to the new worktree
        # Reads file list from .wt-files if present, otherwise uses defaults
        local copy_files=()
        if [ -f ".wt-files" ]; then
            while IFS= read -r line || [ -n "$line" ]; do
                [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
                copy_files+=("$line")
            done < ".wt-files"
        else
            # Default: common env/secret files
            copy_files=(.env .env.local .env.development .env.development.local .env.test .env.test.local .env.production .env.production.local)
        fi

        for file in "${copy_files[@]}"; do
            if [ -e "$file" ]; then
                cp -r "$file" "$worktree_path/$file" && echo "Copied $file" || echo "Warning: failed to copy $file"
            fi
        done
    fi

    # Clean up stale ticket context if not fetching fresh
    if [ "$fetch_gh" = false ]; then
        local ticket_file="$worktree_path/.claude-ticket.md"
        [ -f "$ticket_file" ] && rm "$ticket_file" && echo "Removed stale .claude-ticket.md"
    fi

    # Fetch GitHub issue context if requested
    if [ "$fetch_gh" = true ]; then
        local issue_num
        issue_num=$(_wt_extract_issue_number "$branch_name")
        if [ -z "$issue_num" ]; then
            echo "Warning: no issue number found in branch name '$branch_name', skipping -gh"
        else
            local gh_repo
            gh_repo=$(_wt_get_github_repo)
            if [ -z "$gh_repo" ]; then
                echo "Warning: could not determine GitHub repo from origin, skipping -gh"
            else
                echo "Fetching GitHub issue #$issue_num from $gh_repo..."
                local issue_context
                if issue_context=$(_wt_fetch_gh_context "$gh_repo" "$issue_num"); then
                    echo ""
                    echo "─────────────────────────────────────────"
                    echo "$issue_context"
                    echo "─────────────────────────────────────────"
                    echo ""
                    _wt_write_ticket_file "$worktree_path" "$issue_context"
                    _wt_add_gitignore_entry "$worktree_path"
                    _wt_inject_claude_context "$worktree_path"
                else
                    echo "Error: could not fetch issue #$issue_num from $gh_repo"
                    echo "  Ensure 'gh' is authenticated (gh auth login) or \$GITHUB_TOKEN is set."
                fi
            fi
        fi
    fi

    # Check if we're in a tmux session
    if [ -z "$TMUX" ]; then
        echo "Not in a tmux session. Changing directory to worktree..."
        cd "$worktree_path"
    else
        # Create new tmux window with branch name
        tmux new-window -n "$branch_name" -c "$worktree_path" \; set-window-option automatic-rename off \; send-keys "nvim . +OpenClaude" C-m
    fi
}
