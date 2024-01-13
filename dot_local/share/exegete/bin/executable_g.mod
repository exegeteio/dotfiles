#!/usr/bin/env bash
git ss -s "$@" | columnize | cut -d" " -f2
