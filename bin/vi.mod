#!/bin/bash
set -e
vi $(git status -s | strip | cut -d" " -f2 | sort | menu)