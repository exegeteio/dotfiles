#!/usr/bin/env bash

set -e

[[ "$EUID" -eq 0 ]] || (echo "Must use sudo or be root for this script! - $EUID"; exit 1)

# These will get installed.
PACKAGES="$(< apt-packages)"

# Don't ask questions!
export DEBIAN_FRONTEND=noninteractive

# Check for an X Server
if [ ! -z "${DISPLAY}" ]; then
  PACKAGES="gnome-tweaks code chromium-browser firefox ulauncher ${PACKAGES}"
fi

echo "Attempting to install:  ${PACKAGES}"

curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

if [ ! -z "${SUDO_USER}" ]; then
  echo "Adding ${SUDO_USER} to the \"docker\" group."
  usermod -aG docker ${SUDO_USER}
fi

