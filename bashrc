#!/bin/bash

for rcfile in $HOME/.config/dotfiles/shellrc/*; do
  source $rcfile
done

[[ -n "$(which oh-my-posh)" ]] && eval "$(oh-my-posh --init --shell bash --config "$HOME/code/dotfiles/omp.json")"

