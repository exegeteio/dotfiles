#!/usr/bin/env bash

repo_name="$(basename $(pwd))"
cache_file="/tmp/$repo_name.$(date +%F).trees.cache"
touch "$cache_file"

# Replace the mainr epo with the current branch.
grep -ve "^$repo_name\s" "$cache_file" | tee "$cache_file" > /dev/null
echo "$repo_name - $(g.branch)" >> "$cache_file"

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
