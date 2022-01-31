#!/bin/bash
set -e
files=$(git.mod | cut -d" " -f2 | sort | menu)
[ -z "$files" ] && exit 1
$EDITOR $files
