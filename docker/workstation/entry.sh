#!/usr/bin/env bash

# Do work to chown everything as we get started.
if [ "$1" != 'root' ]; then
  sudo chown $(whoami) $SSH_AUTH_SOCK
fi

exec "$@"
