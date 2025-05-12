#!/usr/bin/env bash

link="$(j.link)"
out="[$(j.info)](${link})"
echo "${out}" | pbcopy
echo "Copied to clipboard: ${out}"
[[ -x "$(which open)" ]] && open "raycast://script-commands/alert?arguments=Copied Markdown!"
