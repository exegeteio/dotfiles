#!/usr/bin/env bash

tree=$(git worktree list | columnize | first | menu)

git worktree remove "$tree"
