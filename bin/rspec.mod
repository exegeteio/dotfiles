#!/bin/bash
specs=$(git.mod spec/ | cut -d" " -f2 | sort | menu)
[ -z "$spec" ] && exit 1
echo "Running:  $specs"
be rspec $specs
