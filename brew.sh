#!/bin/bash

DOTFILES_PATH=`cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd `

if [ -d "$HOME/.brew/Homebrew" ]; then
  echo Homebrew already installed.
else
  git clone https://github.com/Homebrew/brew $HOME/.brew/Homebrew
  ln -s $HOME/.brew/Homebrew/bin $HOME/.brew/bin
fi
export PATH="$HOME/.brew/bin:$PATH" # Also in zshrc.
BREW=$(which brew)
[[ -x "$BREW" ]] || (echo "Could not find brew after install!"; exit 1)
$BREW bundle --file=$DOTFILES_PATH/brewfiles/base

