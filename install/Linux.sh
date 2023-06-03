#!/usr/bin/env bash

set -e

# These will get installed.
PACKAGES="$(< ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/apt-packages)"

# Don't ask questions!
export DEBIAN_FRONTEND=noninteractive

# Check for an X Server
if [ ! -z "${DISPLAY}" ]; then
  PACKAGES="gnome-tweaks code chromium-browser firefox ulauncher ${PACKAGES}"
fi

sudo apt-get update
echo "Attempting to install:  ${PACKAGES}"
sudo apt-get install ${PACKAGES}

if [ ! -z "${USER}" ]; then
  echo "Adding ${USER} to the \"docker\" group."
  sudo usermod -aG docker ${USER}
fi

