#!/usr/bin/env bash
#
# Before `set -e` so this can continue even if xcode already setup.
[ -x "$(which xcode-select)" ] && xcode-select --install

set -e

dotfiles="${DOTFILES_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles}"
if [ ! -e "$dotfiles" ]; then
  if [ -d "$(dirname $0)/dotfiles" ]; then
    echo "Linking $(dirname $0) to ${dotfiles}..."
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
    ln -s "$(realpath $(dirname $0))" "$dotfiles"
  else
    echo "Cloning dotfiles repo to ${dotfiles}..."
    git clone https://github.com/exegeteio/dotfiles.git "$dotfiles"
  fi
fi

os=$(uname)

cd "$dotfiles"

./dotfiles.sh
./brew.sh
./build.sh
[ "$os" == "Linux" ] && sudo ./linux.sh

installer="$dotfiles/install/$os.sh"
[[ -x "$installer" ]] && bash "$installer"

cd -
