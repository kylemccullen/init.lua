#!/bin/bash
# tmux-notify.sh — Update tmux window name when Claude Code stops/resumes
#
# stop:  Append [!] to window name (Claude waiting for input)
# clear: Remove [!] from window name (user submitted prompt)

set -euo pipefail

ACTION="${1:-stop}"

# Only act if running inside tmux
if [ -z "${TMUX:-}" ] || [ -z "${TMUX_PANE:-}" ]; then
    exit 0
fi

current_name=$(tmux display-message -p -t "$TMUX_PANE" '#W' 2>/dev/null) || exit 0

case "$ACTION" in
    stop)
        if [[ "$current_name" != *"[!]"* ]]; then
            tmux rename-window -t "$TMUX_PANE" "${current_name}[!]"
        fi
        ;;
    clear)
        new_name="${current_name%\[!\]}"
        if [ "$new_name" != "$current_name" ]; then
            tmux rename-window -t "$TMUX_PANE" "$new_name"
        fi
        ;;
esac

exit 0
