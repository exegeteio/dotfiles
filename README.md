# Just my dotfiles

## Warning

This is my personal repository. You can use it as an example. Do not rely on this repository as a
stable base for your own workflow. This repository can change without notice.

# Install

`install.sh` is the install script. The script links `common/dotfiles/` to `~/.`. The script links
`common/xdg_config/` to `~/.config/`. The `dotfiles.sh` script does this linking. After that,
`install.sh` runs the correct script for your OS: `macos/install.sh` or `linux/install.sh`.

# Tool versions

[mise](https://mise.jdx.dev) manages the language runtimes and most of the CLI tools. The file
`common/xdg_config/mise/config.toml` lists the global versions. The `dotfiles.sh` script links
this file to `~/.config/mise/`. To install the listed versions, run `mise install`.

The runtimes track a range. Node follows the LTS line, and Ruby follows the 4.x line. The CLI
tools track the latest release. Run `mise outdated` to see what is behind. Run `mise upgrade` to
move up inside the range.

The `shellrc/00-env` script activates mise in each interactive shell. The same script adds the
mise shims to `PATH`. The shims serve the scripts that do not read the shell config.

The `Brewfile` installs mise on macOS. Omarchy supplies mise on Linux. The `Brewfile` keeps the
tools that mise cannot supply, and the tools that sit too close to the system to move: `git`,
`bash`, and `tmux`.

# Shell config

Bash and zsh load the same files. Each shell reads `shellrc/[0-9]*` in order, so one edit applies
to both shells at the next new shell. No cache file exists.

- `common/dotfiles/bashrc` and `common/dotfiles/zshrc` hold only the settings that one shell
  needs: completion, history, vi mode, and the fzf key bindings.
- `common/dotfiles/inputrc` sets the vi keys for bash. The `bindkey` lines in `zshrc` set the same
  keys for zsh.
- `common/dotfiles/bash_profile` makes a login bash read `bashrc`.
- `shellrc/00-env` sets `$_sh` to `bash` or `zsh`. Other files use it to run `tool init $_sh`.
- `~/.shellrc.local` holds the settings for one machine. It is not in this repository. Each shell
  sources it last.

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
  The script links the Hyprland changes, the Omarchy shell changes, and the screensaver art (the
  Aperture Science logo) in `linux/omarchy/` to `~/.config/`.
  The script installs 1Password and Tailscale with the `omarchy install service` command. The
  script skips this step if the apps are already installed. The script removes every Chromium
  extension except 1Password — see `linux/omarchy/bash/chromium-prune-extensions.sh` for this
  step. Warning: this step closes Chromium, and you cannot undo it. The script adds and removes
  some web apps. The script also removes some preinstalled packages. This setup does not use
  Homebrew — Omarchy uses its own package manager.
