#!/bin/bash
# Remove every Chromium extension except 1Password. This script removes two
# kinds of extensions. The first kind is a force-installed (policy)
# extension under /usr/share/chromium/extensions/. The second kind is an
# extension you installed by hand in a profile.
#
# Warning: this script makes changes you cannot undo. The script first
# closes all open Chromium windows and tabs. An edit to the Preferences
# files while Chromium is open can damage the profile. The script then
# deletes the extension data and settings for every extension except
# 1Password.
set -euo pipefail

keep_id="aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password extension ID
chromium_dir="$HOME/.config/chromium"

if pgrep -x chromium >/dev/null 2>&1; then
  echo "Closing Chromium to safely prune its extensions..."
  pkill -x chromium || true
  for _ in $(seq 1 20); do
    pgrep -x chromium >/dev/null 2>&1 || break
    sleep 0.5
  done
fi

if [ -d /usr/share/chromium/extensions ]; then
  for policy_file in /usr/share/chromium/extensions/*.json; do
    [ -e "$policy_file" ] || continue
    id="$(basename "$policy_file" .json)"
    if [ "$id" != "$keep_id" ]; then
      sudo rm -f "$policy_file"
      echo "Removed force-installed extension policy: $id"
    fi
  done
fi

if [ -d "$chromium_dir" ]; then
  for profile_dir in "$chromium_dir"/Default "$chromium_dir"/Profile*; do
    [ -d "$profile_dir" ] || continue

    if [ -d "$profile_dir/Extensions" ]; then
      for ext_dir in "$profile_dir/Extensions"/*/; do
        [ -d "$ext_dir" ] || continue
        id="$(basename "$ext_dir")"
        if [ "$id" != "$keep_id" ]; then
          rm -rf "$ext_dir"
          echo "Removed extension data for $id from $(basename "$profile_dir")"
        fi
      done
    fi

    for prefs_file in "$profile_dir/Preferences" "$profile_dir/Secure Preferences"; do
      [ -f "$prefs_file" ] || continue
      tmp="$(mktemp)"
      jq --arg keep "$keep_id" '
        if .extensions.settings then
          .extensions.settings |= with_entries(select(.key == $keep))
        else
          .
        end
      ' "$prefs_file" >"$tmp" && mv "$tmp" "$prefs_file"
    done
  done
fi
