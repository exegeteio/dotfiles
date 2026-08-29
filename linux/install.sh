#!/usr/bin/env bash
# Apply personal Omarchy (Arch Linux + Hyprland) customizations.
# This script is Omarchy-specific. It does not support other Linux distros.
set -euo pipefail

if ! command -v omarchy >/dev/null 2>&1; then
  echo "The omarchy command is not present. This script only supports Omarchy Linux. Skipping." >&2
  exit 0
fi

dotfiles="${DOTFILES_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles}"

# Symlink a file. First back up any real file already at the destination.
link_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak.$(date +%s)"
    echo "Backed up existing $dest"
  fi
  ln -sfn "$src" "$dest"
}

echo "Linking Hyprland customizations..."
link_file "$dotfiles/linux/omarchy/hypr/input.lua" ~/.config/hypr/input.lua
link_file "$dotfiles/linux/omarchy/hypr/looknfeel.lua" ~/.config/hypr/looknfeel.lua
link_file "$dotfiles/linux/omarchy/hypr/bindings.lua" ~/.config/hypr/bindings.lua

echo "Linking nvim config..."
link_file "$dotfiles/linux/omarchy/nvim" ~/.config/nvim

if command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1; then
  echo "Hyprland config reloaded."
else
  echo "Hyprland is not running. The changes will take effect at the next login."
fi

# dotfiles.sh, which runs before this script, already links
# xdg_config/starship.toml to ~/.config/starship.toml. No extra step is
# needed here to keep the Starship prompt config current.

if omarchy pkg present 1password 1password-cli >/dev/null 2>&1; then
  echo "1Password is already installed. Skipping this step."
else
  echo "Installing 1Password (desktop app and browser extension). This step needs sudo, then opens the app for sign-in."
  omarchy install service 1password
fi

echo "Removing every Chromium extension except 1Password. This step closes Chromium if it is running."
bash "$dotfiles/linux/omarchy/bash/chromium-prune-extensions.sh"

if omarchy pkg present tailscale >/dev/null 2>&1; then
  echo "Tailscale is already installed. Skipping this step."
else
  echo "Installing Tailscale. This step needs sudo. If you are not signed in, it opens a browser for sign-in."
  omarchy install service tailscale
fi

echo "Adding the Proton Mail web app..."
omarchy webapp install "Proton Mail" "https://mail.proton.me" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/proton-mail.png"

echo "Removing unwanted preinstalled web apps..."
UNWANTED_WEBAPPS=(
  "Basecamp"
  "Google Contacts"
  "Google Maps"
  "Google Messages"
  "Google Photos"
  "WhatsApp"
  "X"
  "YouTube"
)
for webapp in "${UNWANTED_WEBAPPS[@]}"; do
  omarchy webapp remove "$webapp"
done

echo "Removing unwanted preinstalled packages..."
omarchy pkg drop \
  cliamp \
  kdenlive \
  libreoffice-fresh \
  localsend \
  moonlight-qt \
  obs-studio \
  obsidian \
  pinta \
  xournalpp

echo "Linking the Omarchy shell customizations (9-workspace indicator)..."
link_file "$dotfiles/linux/omarchy/shell/shell.json" ~/.config/omarchy/shell.json
link_file "$dotfiles/linux/omarchy/shell/plugins/exegete.workspaces" ~/.config/omarchy/plugins/exegete.workspaces
omarchy restart shell >/dev/null 2>&1 || true

echo "Done."
