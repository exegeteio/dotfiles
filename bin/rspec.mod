#!/bin/bash
specs=$(git status -s spec/ | columnize | cut -d" " -f2 | sort | menu)
echo "Running:  $specs"
be rspec $specs
