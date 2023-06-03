#!/usr/bin/env bash

dotfiles="${DOTFILES_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}}/dotfiles"

if [ ! -e "$dotfiles" ]; then
  if [ -d "$(dirname $0)/dotfiles" ]; then
    ln -s "$(dirname $0)" "$dotfiles"
  else
    git clone https://github.com/exegeteio/dotfiles.git "$dotfiles"
  fi
fi

files=$(ls -1 "${dotfiles}/dotfiles")
for file in $files; do
  outfile="${HOME}/.$(basename "$file")"
  [ -L "$outfile" ] || ln -s "$(realpath "${dotfiles}/dotfiles/${file}")" "$outfile"
done
