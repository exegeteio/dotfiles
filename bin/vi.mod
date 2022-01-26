#!/bin/bash
set -e
vi $(git status -s | columnize | cut -d" " -f2 | sort | menu)
