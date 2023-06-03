#!/usr/bin/env bash

set -e

OS="$(uname)"
if [ "$OS" == "Linux" ]; then
  prefix="/home/linuxbrew/.linuxbrew"
elif [ "$OS" == "Darwin" ]; then
  prefix="$HOME/.brew"
fi


export NONINTERACTIVE=1
if [ ! -d "$prefix" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

local="$HOME/.config/dotfiles/brew/"
brewfilecmd="curl -fsSL https://raw.githubusercontent.com/exegeteio/dotfiles/main/brew/"
if [ -d "$local" ]; then
  brewfilecmd="cat $local"
fi

eval "$($prefix/bin/brew shellenv)"

${brewfilecmd}/base | brew bundle install -q --file=-

if [ "$OS" == "Darwin" ]; then
  ${brewfilecmd}/Darwin | brew bundle install -q --file=-
fi

