# Just my dotfiles

## Warning

This is my personal repository. You can use it as an example. Do not rely on this repository as a
stable base for your own workflow. This repository can change without notice.

# Install

`install.sh` is the install script. The script links `common/dotfiles/` to `~/.`. The script links
`common/xdg_config/` to `~/.config/`. The `dotfiles.sh` script does this linking. After that,
`install.sh` runs the correct script for your OS: `macos/install.sh` or `linux/install.sh`.

# Layout

- `common/` — Files in this directory apply to every OS. The directory has the dotfile link
  targets (`common/dotfiles/`, `common/xdg_config/`).
- `macos/` — This directory has the macOS setup. `install.sh` sets macOS defaults, installs
  Homebrew, and installs apps from the Mac App Store. `Brewfile` lists every brew and cask this
  Mac needs. `app_store_ids.txt` lists Mac App Store app IDs. `configs/` holds reference configs
  for iTerm, Rectangle, JetBrains apps, and Terminal.app. No script links these configs
  automatically. Copy them by hand when you need them.
- `linux/` — This directory has the Linux setup for [Omarchy](https://omarchy.org) (Arch Linux
  and Hyprland) only. `install.sh` skips its work if the `omarchy` command is not on the system.
  The script links the Hyprland and Omarchy shell changes in `linux/omarchy/` to `~/.config/`.
  The script installs 1Password and Tailscale with the `omarchy install service` command. The
  script skips this step if the apps are already installed. The script removes every Chromium
  extension except 1Password — see `linux/omarchy/bash/chromium-prune-extensions.sh` for this
  step. Warning: this step closes Chromium, and you cannot undo it. The script adds and removes
  some web apps. The script also removes some preinstalled packages. This setup does not use
  Homebrew — Omarchy uses its own package manager. `apt-packages` is unrelated to Omarchy — the
  `Dockerfile` and `linux.sh` scripts use it to build a plain Ubuntu container. This container is
  a generic, non-GUI sandbox. It does not run Omarchy, and it does not use Homebrew either.

# Homebrew

Homebrew setup applies to macOS only. `brew.sh` installs Homebrew if the Mac does not have it.
Then the script installs every brew and cask in `macos/Brewfile`.
