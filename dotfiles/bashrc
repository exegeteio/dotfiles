#!/usr/bin/env bash

for rcfile in $HOME/.config/dotfiles/shellrc/*; do
  source $rcfile
done

[[ -n "$(which oh-my-posh)" ]] && eval "$(oh-my-posh --init --shell bash --config "$HOME/.config/dotfiles/omp.json")"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Rust me one more time!
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
