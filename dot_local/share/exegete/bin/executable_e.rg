#!/usr/bin/env bash
# Pick out the search term.
needle="$1"
# Shift the term off the input array.
shift 1
# Do the do!
$EDITOR $(rg --vimgrep "$needle" "$@" | sort | menu | $EDITOR_ARGS)
