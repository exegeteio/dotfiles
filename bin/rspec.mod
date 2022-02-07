#!/usr/bin/env bash
specs=$(git.mod "spec/**/*_spec.rb" | sort | menu)
[ -z "$specs" ] && echo "No specs selected!  $specs" && exit 1
echo "Running:  $specs"
be rspec $specs
