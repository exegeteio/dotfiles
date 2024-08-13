#!/usr/bin/env bash

branch=$1

if [ -z "${branch}" ]; then
  branch=$(w.t | menu | columnize | first)
fi

git worktree remove "$branch"
echo "Removed ${branch}"
