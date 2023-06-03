#!/usr/bin/env bash

dotfiles="${DOTFILES_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles}"

if [ ! -e "$dotfiles" ]; then
  if [ -d "$(dirname $0)/dotfiles" ]; then
    echo "Linking $(dirname $0) to ${dotfiles}..."
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
    ln -s "$(realpath $(dirname $0))" "$dotfiles"
  else
    git clone https://github.com/exegeteio/dotfiles.git "$dotfiles"
  fi
fi

files=$(ls -1 "${dotfiles}/dotfiles")
for file in $files; do
  outfile="${HOME}/.$(basename "$file")"
  rm -Rf "$outfile"
  ln -s "$(realpath "${dotfiles}/dotfiles/${file}")" "$outfile"
done

configs=$(ls -1 "${dotfiles}/xdg_config")
for config in $configs; do
  outfile="${XDG_CONFIG_HOME:-$HOME/.config}/$(basename "$config")"
  rm -Rf "$outfile"
  ln -s "${dotfiles}/xdg_config/${config}" "$outfile"
done
