#!/usr/bin/env bash
DEBIAN_FRONTEND=noninteractive

set -e

apt-get update -qqy
cat linux/apt-packages | xargs apt-get install -qqy --no-install-recommends
rm -rf /var/lib/apt/lists/*
