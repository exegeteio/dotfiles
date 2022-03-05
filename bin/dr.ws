#!/usr/bin/env bash
# docker volume create workstation
# -v "workstation:$HOME" \

dr --name "workstation" \
  --hostname "workstation" \
  --privileged \
  -v "$HOME:/workspace" \
  -v "$HOME/.ssh:$HOME/.ssh" \
  -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
  -v /var/run/docker.sock.raw:/var/run/docker.sock \
  -e "SSH_AUTH_SOCK=$SSH_AUTH_SOCK" \
  -e "PORT=$PORT" \
  -p "$PORT:$PORT" \
  "workstation"
