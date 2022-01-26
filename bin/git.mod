#!/bin/bash
git status -s "$@" | columnize | cut -d" " -f2
