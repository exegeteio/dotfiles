#!/usr/bin/env bash
file="~/logseq/journals/$(date +%Y_%m_%d).md"

# if ! tmux list-windows | grep -q 'logseq'; then
#   tmux new-window -d -n logseq "(cd ~/logseq && nvim $file)"
# fi

tmux display-popup -E -w 90% -h 80% -E "z"
