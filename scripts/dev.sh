#!/bin/bash

dev() {
    if [ -z "$1" ]; then
        echo "Usage: dev <project-folder>"
        return 1
    fi

    if [ -z "$REPOS_PATH" ]; then
        echo "Error: REPOS_PATH environment variable is not set"
        return 1
    fi

    local project_path=""
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

    cd "$project_path" || return 1

    local branch_name
    if git rev-parse --git-dir > /dev/null 2>&1; then
        branch_name=$(git branch --show-current 2>/dev/null || echo "detached")
    else
        branch_name="main"
    fi

    # Set WSL terminal window title to project folder name
    echo -ne "\033]0;$1\007"

    # Get first letter of folder name for session
    local session_name="${1:0:1}"

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
