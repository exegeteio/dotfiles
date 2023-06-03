#!/usr/bin/env bash

# Do work to chown everything as we get started.
if [ "$1" != 'root' ]; then
  if [ -f "$SSH_AUTH_SOCK" ]; then
    sudo chown "$(whoami)" "$SSH_AUTH_SOCK"
  fi
fi

exec "$@"
