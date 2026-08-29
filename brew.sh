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

dotfiles="${DOTFILES_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles}"
brew bundle install -q --file="$dotfiles/macos/Brewfile"
