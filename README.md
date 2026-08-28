# Just my dotfiles

## Warning!

This is my personal repo.  You're welcome to use it as an example or jumping off point, but please
do not rely on this being a stable repository for your own personal workflow.

# Install

`install.sh` is the install file, and will create symlinks to all of my configuration files, as well
as build some go scripts, and install some of the software required to make everything work.

# Homebrew

`brew.sh` will attempt a local (user-specific) install of Homebrew in `~/.brew` and install brews
and casks from the `brewfiles/` directory.  One for the core utilities and one for each platform
I install on.

# Linux (Omarchy)

`install/Linux.sh` targets [Omarchy](https://omarchy.org) (Arch Linux + Hyprland) only, and exits
if the `omarchy` command is not present. It symlinks the Hyprland and Omarchy shell overrides in
`omarchy/` into `~/.config/`, installs 1Password and Tailscale via `omarchy install service`
(skipped if already installed), removes every Chromium extension except 1Password (see
`omarchy/bash/chromium-prune-extensions.sh` — this closes Chromium and cannot be undone), adds and
removes some web apps, and drops some preinstalled packages. Run it via `install.sh`, or directly
once dotfiles are linked.

The `Dockerfile` / `linux.sh` / `linux/apt-packages` files are unrelated: a plain Ubuntu container
used as a generic non-GUI sandbox, not an attempt to run Omarchy.

