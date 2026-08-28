# Just my dotfiles

## Warning!

This is my personal repo.  You're welcome to use it as an example or jumping off point, but please
do not rely on this being a stable repository for your own personal workflow.

# Install

`install.sh` is the install file. It symlinks `common/dotfiles/` to `~/.` and `common/xdg_config/`
to `~/.config/` (via `dotfiles.sh`), then runs the OS-specific `macos/install.sh` or
`linux/install.sh`.

# Layout

- `common/` — files applied on every OS: dotfile symlink targets (`common/dotfiles/`,
  `common/xdg_config/`) and the base Homebrew bundle (`common/Brewfile`).
- `macos/` — `install.sh` (macOS defaults, Homebrew, Mac App Store installs), `Brewfile`
  (macOS-only casks/brews), `app_store_ids.txt`, and `configs/` (iTerm, Rectangle, JetBrains,
  Terminal.app configs — not symlinked automatically, kept for manual reference).
- `linux/` — `install.sh` targets [Omarchy](https://omarchy.org) (Arch Linux + Hyprland) only,
  and exits if the `omarchy` command is not present. It symlinks the Hyprland and Omarchy shell
  overrides in `linux/omarchy/` into `~/.config/`, installs 1Password and Tailscale via
  `omarchy install service` (skipped if already installed), removes every Chromium extension
  except 1Password (see `linux/omarchy/bash/chromium-prune-extensions.sh` — this closes Chromium
  and cannot be undone), adds and removes some web apps, and drops some preinstalled packages.
  `Brewfile` is Linux-only brews. `apt-packages` is used only by the unrelated `Dockerfile` /
  `linux.sh` plain Ubuntu container (a generic non-GUI sandbox, not an attempt to run Omarchy).

# Homebrew

`brew.sh` installs Homebrew if needed, then installs `common/Brewfile` plus the OS-specific
`macos/Brewfile` or `linux/Brewfile`.

