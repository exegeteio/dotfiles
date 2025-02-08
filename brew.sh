#!/usr/bin/env bash

set -e

OS="$(uname)"
if [ "$OS" == "Linux" ]; then
  prefix="/home/linuxbrew/.linuxbrew"
elif [ "$OS" == "Darwin" ]; then
  prefix="/opt/homebrew"
fi

if [ ! -d "$prefix" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x "$(which brew)" ]; then
  eval "$(${prefix}/bin/brew shellenv)"
fi

local="$HOME/.config/dotfiles/brew/"
brewfilecmd="curl -fsSL https://raw.githubusercontent.com/exegeteio/dotfiles/main/brew/"
if [ -d "$local" ]; then
  brewfilecmd="cat $local"
fi

${brewfilecmd}/base | brew bundle install -q --file=-

if [ "$OS" == "Darwin" ]; then
  ${brewfilecmd}/Darwin | brew bundle install -q --file=-
elif [ "$OS" == "Linux" ]; then
  ${brewfilecmd}/Linux | brew bundle install -q --file=-
fi

