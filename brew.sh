#!/usr/bin/env bash
# Install Homebrew on macOS. This script does not support Linux.
set -e

prefix="/opt/homebrew"

if [ ! -d "$prefix" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x "$(which brew)" ]; then
  eval "$(${prefix}/bin/brew shellenv)"
fi

local="$HOME/.config/dotfiles"
brewfilecmd="curl -fsSL https://raw.githubusercontent.com/exegeteio/dotfiles/main"
if [ -d "$local" ]; then
  brewfilecmd="cat $local"
fi

${brewfilecmd}/macos/Brewfile | brew bundle install -q --file=-
