#!/usr/bin/env bash

ln -s $HOME/.config/dotfiles/nvim $HOME/.config/nvim

# Packer for managing packages.
packer="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
[ -d "$packer" ] || git clone --depth 1 \
	https://github.com/wbthomason/packer.nvim \
	"$packer";
(cd "$packer" && git pull)

nvim +PackerSync +qall


