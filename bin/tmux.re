#!/usr/bin/env bash

target="$HOME/code/$1"
[ -d "$target" ] && dir="$target"

if tmux has-session -t "$1" 2>/dev/null; then
  if [ -z "$TMUX" ]; then
    exec tmux -2 attach-session -t "$*"
  else
    exec tmux -2 switchc -t "$*"
  fi
else
  tmux -2 new-session -t "$*" -c "${dir:-$HOME}" -d
  if [ -z "$TMUX" ]; then
    exec tmux -2 attach -t "$*"
  else
    exec tmux -2 switchc -t "$*"
  fi
fi
