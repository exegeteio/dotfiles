#!/bin/bash

folder="$1"

if [ -z "$folder" ]; then
  cd "${CODE_PATH:-${HOME}/code}"
  folder="${CODE_PATH:-${HOME}/code}/$(ls -1 | menu)"
fi

if [ -z "$folder" ]; then
  echo "No folder selected!"
  exit
fi

if [ ! -d "$folder" ]; then
  echo "Not a directory:  $folder"
  exit
fi

TMUX="" EDITOR="" exec rubymine "${folder:-.}"
