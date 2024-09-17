#!/usr/bin/env bash

repo_dir="$(git worktree list | head -n 1 | first )"
repo_name="$(basename $repo_dir)"
cache_file="/tmp/$repo_name.trees.cache"
touch "$cache_file"

# Replace the main repo every time.
[ -f "$cache_file" ] || echo "$repo_name - $(cd $repo_dir && g.branch)" >> "$cache_file"

trees=$(git worktree list | first)
for dir in $trees; do
  bname=$(basename $dir)
  desc=$(grep -e "^$bname\s" "$cache_file")
  if [ -z "$desc" ]; then
    title=$(cd $dir && j.title)
    if [ "$title" == "null" ]; then
      desc="$bname - $(cd $dir && g.branch) - Not found"
      echo "$desc" >> "$cache_file"
    else
      desc="$bname - $title"
      echo "$desc" >> "$cache_file"
    fi
  fi
  echo "$desc"
done
