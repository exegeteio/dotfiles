#!/usr/bin/env bash
specs=$(git.mod spec/ | cut -d" " -f2 | sort | menu)
[ -z "$specs" ] && echo "No specs selected!  $specs" && exit 1
echo "Running:  $specs"
be rspec $specs
