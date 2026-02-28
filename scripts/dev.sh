#!/bin/bash

dev() {
    if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        echo "Usage: dev <project-folder>"
        echo ""
        echo "Opens a project in a new tmux session with nvim."
        echo ""
        echo "Arguments:"
        echo "  <project-folder>  Name of a folder to find in REPOS_PATH, or '.' for the current directory"
        echo ""
        echo "Options:"
        echo "  -h, --help        Show this help message"
        echo ""
        echo "Environment:"
        echo "  REPOS_PATH        Colon-separated list of base directories to search for projects"
        echo "                    Example: /home/user/repos:/home/user/work"
        echo ""
        echo "Behavior:"
        echo "  - Searches REPOS_PATH left-to-right and opens the first matching folder"
        echo "  - Creates a tmux session named after the first letter of the project folder"
        echo "  - Names the tmux window after the current git branch"
        echo "  - If a session with the same name exists, it will be replaced"
        [ -z "$1" ] && return 1 || return 0
    fi

    local project_path=""

    if [ "$1" = "." ]; then
        project_path="$(pwd)"
    else
        if [ -z "$REPOS_PATH" ]; then
            echo "Error: REPOS_PATH environment variable is not set"
            return 1
        fi

        local IFS=":"
        for base in $REPOS_PATH; do
            if [ -d "$base/$1" ]; then
                project_path="$base/$1"
                break
            fi
        done

        if [ -z "$project_path" ]; then
            echo "Error: No directory '$1' found in REPOS_PATH"
            return 1
        fi
    fi

    cd "$project_path" || return 1

    local folder_name
    folder_name=$(basename "$project_path")

    local branch_name
    if git rev-parse --git-dir > /dev/null 2>&1; then
        branch_name=$(git branch --show-current 2>/dev/null || echo "detached")
    else
        branch_name="main"
    fi

    # Set WSL terminal window title to project folder name
    echo -ne "\033]0;$folder_name\007"

    # Get first letter of folder name for session
    local session_name="${folder_name:0:1}"

    if [ -n "$TMUX" ]; then
        echo "Already in a tmux session."
    else
        # Check if session already exists and kill it
        if tmux has-session -t "$session_name" 2>/dev/null; then
            echo "Session '$session_name' already exists. Killing old session..."
            tmux kill-session -t "$session_name"
        fi

        # Start tmux session with first letter of folder, window named after branch
        tmux new-session -s "$session_name" -n "$branch_name"
    fi
}
