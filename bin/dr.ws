#!/bin/bash
dr --name "workstation" \
  --hostname "workstation" \
  --privileged \
  -v "$HOME:$HOME" \
  -v "$HOME/.ssh:/workstation/.ssh" \
  -v "$HOME/code:/workstation/code" \
  -v "$HOME:/workstation/host" \
  -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
  -v /var/run/docker.sock.raw:/var/run/docker.sock \
  -e "SSH_AUTH_SOCK=$SSH_AUTH_SOCK" \
  -e "PORT=$PORT" \
  -p "$PORT:$PORT" \
  "workstation"
