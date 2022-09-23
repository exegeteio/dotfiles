#!/usr/bin/env bash

set -e

# These will get installed.
PACKAGES="$(< apt-packages)"

# Don't ask questions!
export DEBIAN_FRONTEND=noninteractive

echo "Attempting to install:  $(echo "${PACKAGES}" | xargs)"
sudo apt update && sudo apt install --no-install-recommends -qqy $PACKAGES

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

if [ ! -z "${SUDO_USER}" ]; then
  sudo usermod -aG docker ${SUDO_USER}
fi

echo sudo chsh -s $(which zsh) $(whoami)

