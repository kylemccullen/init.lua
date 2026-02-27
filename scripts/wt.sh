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

wt() {
    if [ -z "$1" ]; then
        echo "Usage: wt <branch-name>"
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
    local folder_name="${1//\//-}"
    local worktree_path="$worktrees_dir/$folder_name"
    
    # Check if worktree already exists
    if [ -d "$worktree_path" ]; then
        echo "Worktree already exists at: $worktree_path"
    else
        # Check if branch exists
        if git rev-parse --verify "$1" >/dev/null 2>&1; then
            # Branch exists, checkout existing branch
            echo "Checking out existing branch '$1'..."
            git worktree add "$worktree_path" "$1"
        else
            # Branch doesn't exist, create new branch
            echo "Creating new branch '$1' and worktree..."
            git worktree add -b "$1" "$worktree_path"
        fi
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create worktree"
            return 1
        fi
    fi
    
    # Check if we're in a tmux session
    if [ -z "$TMUX" ]; then
        echo "Not in a tmux session. Changing directory to worktree..."
        cd "$worktree_path"
    else
        # Create new tmux window with branch name
        tmux new-window -n "$1" -c "$worktree_path" \; set-window-option automatic-rename off \; send-keys "nvim . +OpenClaude" C-m
    fi
}
