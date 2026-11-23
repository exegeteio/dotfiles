#!/usr/bin/env bash

git worktree list | first | xargs basename
