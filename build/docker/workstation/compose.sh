#!/usr/bin/env bash
# Setup Docker CLI.
mkdir -p $HOME/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64 \
  -o $HOME/.docker/cli-plugins/docker-compose
chmod +x $HOME/.docker/cli-plugins/docker-compose

