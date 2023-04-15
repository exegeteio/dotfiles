#!/usr/bin/env bash

target="$CODE_PATH/$*"
[ -d "$target" ] && dir="$target"

if tmux has-session -t "=$*" 2>/dev/null; then
  if [ -z "$TMUX" ]; then
    exec tmux -2 attach-session -t "$*"
  else
    exec tmux -2 switchc -t "$*"
  fi
else
  tmux -2 new-session -s "$*" -c "${dir:-$CODE_PATH}" -d
  if [ -z "$TMUX" ]; then
    exec tmux -2 attach -t "$*"
  else
    exec tmux -2 switchc -t "$*"
  fi
fi