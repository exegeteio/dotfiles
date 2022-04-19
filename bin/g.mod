#!/usr/bin/env bash
git status -s "$@" | columnize | cut -d" " -f2
