#!/usr/bin/env bash
set -e
files=$(g.mod | cut -d" " -f2 | sort | menu)
[ -z "$files" ] && echo "No files" && exit 1
$EDITOR $files
