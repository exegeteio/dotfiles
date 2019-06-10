#!/bin/sh

PACKAGES='vim git zsh build-essential docker-ce docker-ce-cli containerd.io libpq-dev libsqlite3-dev libxml2-dev libxslt-dev ruby-dev nodejs npm'

# Check for an X Server
if [ ! -z "${DISPLAY}" ]; then
  PACKAGES="gnome-tweaks code chromium-browser ${PACKAGES}"
fi

echo "Attempting to install:  ${PACKAGES}"

# Install docker pre-req's
apt-get update -qq && apt-get install -qqy \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

# Add docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add docker's ubuntu repo
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update -qq && apt-get install -qqy ${PACKAGES}

if [ -z "${SUDO_USER}" ]; then
  echo "Adding ${USER} to the \"docker\" group."
  usermod -aG docker ${USER}
else
  echo "Adding ${SUDO_USER} to the \"docker\" group."
  usermod -aG docker ${SUDO_USER}
fi

curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

docker run --rm hello-world

gem install -q rails bundle
