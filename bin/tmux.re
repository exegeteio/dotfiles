#!/usr/bin/env bash

target="${CODE_PATH:-"$HOME/code"}/$*"
[ -e "$target" ] && dir="$target"
cur_path=$(realpath $*)
code_path=$(realpath $HOME/code/)
[[ $cur_path == $code_path* ]] && dir="$*"
name=$(basename $*)


if tmux has-session -t "=$*" 2>/dev/null; then
  if [ -z "$TMUX" ]; then
    exec tmux -2 attach-session -t "$name"
  else
    exec tmux -2 switchc -t "$name"
  fi
else
  tmux -2 new-session -s "$name" -c "${dir:-$CODE_PATH}" -d
  # Recurse
  exec tmux.re "$name"
fi
