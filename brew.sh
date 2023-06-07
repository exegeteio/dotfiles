#!/usr/bin/env bash

set -e

OS="$(uname)"
if [ "$OS" == "Linux" ]; then
  prefix="/home/linuxbrew/.linuxbrew"
  brew="${prefix}/bin/brew"
elif [ "$OS" == "Darwin" ]; then
  brew="$(which brew)"
  if [ ! -x "$brew" ]; then
    prefix="$HOME/.brew"
    brew="${prefix}/bin/brew"
  fi
fi

if [ ! -d "$prefix" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

local="$HOME/.config/dotfiles/brew/"
brewfilecmd="curl -fsSL https://raw.githubusercontent.com/exegeteio/dotfiles/main/brew/"
if [ -d "$local" ]; then
  brewfilecmd="cat $local"
fi

eval "$($brew shellenv)"

${brewfilecmd}/base | brew bundle install -q --file=-

if [ "$OS" == "Darwin" ]; then
  ${brewfilecmd}/Darwin | brew bundle install -q --file=-
elif [ "$OS" == "Linux" ]; then
  ${brewfilecmd}/Linux | brew bundle install -q --file=-
fi

