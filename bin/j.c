#!/usr/bin/env bash

link="$(j.link)"
out="[$(j.info)](${link})"
echo "${out}" | pbcopy
echo "Copied to clipboard: ${out}"
command -v open >/dev/null 2>&1 && open "raycast://script-commands/alert?arguments=Copied Markdown!"
