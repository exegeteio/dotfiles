#!/usr/bin/env bash

cache_file=/tmp/$(basename $(git worktree list | grep main | first)).$(date +%F).trees.cache
touch "$cache_file"
trees=$(git worktree list | first)

for dir in $trees; do
  bname=$(basename $dir)
  desc=$(grep -e "^$bname\s" "$cache_file")
  if [ -z "$desc" ]; then
    title=$(cd $dir && j.title)
    if [ "$title" == "null" ]; then
      desc="$bname - Not found"
      echo "$desc" >> "$cache_file"
    else
      desc="$bname - $title"
      echo "$desc" >> "$cache_file"
    fi
  fi
  echo "$desc"
done
