#!/usr/bin/env bash

target="${CODE_PATH:-"$HOME/code"}/$*"
[ -e "$target" ] && dir="$target"
cur_path=$(realpath -q $*)
code_path=$(realpath -q $HOME/code/)
[[ $cur_path == $code_path* ]] && dir="$*"
name=$(basename $*)


if tmux has-session -t "=$*" 2>/dev/null; then
  tmux setenv -t "$name" TMUX_NAME "$name"
  tmux setenv -t "$name" TERM_PROGRAM "$TERM_PROGRAM"
  tmux setenv -t "$name" TERM_EMULATOR "$TERMINAL_EMULATOR"
  tmux setenv -t "$name" IDEA_INITIAL_DIRECTORY "$IDEA_INITIAL_DIRECTORY"
  tmux setenv -t "$name" CURRENT_DIR "$cur_path"
  tmux setenv -t "$name" EDITOR ""
  if [ -z "$TMUX" ]; then
    exec tmux attach-session -t "$name"
  else
    exec tmux switchc -t "$name"
  fi
else
  tmux new-session -s "$name" -c "${dir:-${cur_path:-$CODE_PATH}}" \
    -e TMUX_NAME="$name" \
    -e TERM_PROGRAM="$TERM_PROGRAM" \
    -e TERM_EMULATOR="$TERMINAL_EMULATOR" \
    -e IDEA_INITIAL_DIRECTORY="$IDEA_INITIAL_DIRECTORY" \
    -e CURRENT_DIR="$cur_path" \
    -e EDITOR="" \
    -d
  # Recurse
  exec tmux.re "$name"
fi
