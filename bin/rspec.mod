#!/usr/bin/env bash
specs=$(g.mod "spec/**/*_spec.rb" | sort | menu)
[ -z "$specs" ] && echo "[rspec.mod] No specs selected!  $specs" && exit 1
echo "[rspec.mod] Running:  $specs"
be rspec $specs
