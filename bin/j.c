#!/usr/bin/env bash

link="$(op read $JIRA_DOMAIN)/secure/QuickSearch.jspa?searchString=$(urlencode $(g.branch))"
out="[$(j.info)](${link})"
echo "${out}" | pbcopy
echo "Copied to clipboard: ${out}"
