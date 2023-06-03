#!/usr/bin/env bash

dotfiles="${DOTFILES_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles}"

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
