# Omarchy nvim, layered instead of forked

This directory is a personal layer on top of the default Omarchy nvim
setup (the `omarchy-nvim` pacman package, at
`/usr/share/omarchy-nvim/config`), not a copy of it. `init.lua` appends
that package's directory to `'runtimepath'`, so any `require("config.X")`
this repo doesn't define resolves live from the Omarchy package instead.
That means `lazy.lua`, `autocmds.lua`, and `remote_clipboard.lua` aren't
present here at all — Omarchy's own copies keep being used, and pick up
package updates automatically.

Linux-only, and specifically Omarchy-only: it depends on the
`omarchy-nvim` package and Omarchy's theme system, neither of which exist
elsewhere. `linux/install.sh` only symlinks this directory to
`~/.config/nvim` when the `omarchy` command is present. The macOS nvim
config lives separately, at `macos/xdg_config/nvim`.

## What is custom here

- `lua/config/options.lua` and `lua/config/keymaps.lua` each `dofile()`
  Omarchy's own version of the file first, then
  `dofile()` `common/xdg_config/nvim-shared/{options,keymaps}.lua` — the
  actual personal overrides, shared with the macOS config so they aren't
  duplicated between the two.

  `lazy.nvim` resets `'runtimepath'` during its own bootstrap, so by the
  time these files run, the rtp entry `init.lua` added for Omarchy's
  config is already gone, and a plain `require()` from inside a `dofile()`d
  Omarchy file can no longer find anything under it. Omarchy's
  `options.lua` does `require("config.remote_clipboard")` internally, so
  `options.lua` here pre-loads that module into `package.loaded` directly
  (bypassing `require`'s path search) before running Omarchy's file. If a
  future Omarchy update adds another such internal `require()`, it needs
  the same treatment.
- `lazyvim.json` enables one extra beyond the Omarchy default: the
  `editor.snacks_picker` extra. It adds the default LazyVim finder
  keymaps (`<leader><space>`, `<leader>ff`, `<leader>/`, and so on).
- `lua/plugins/*.lua`, other than `theme.lua`, are symlinks to Omarchy's
  own plugin files (`all-themes.lua`, `disable-news-alert.lua`,
  `omarchy-theme-hotreload.lua`, `snacks-animated-scrolling-off.lua`).
  They have to live in this directory as *something* — `lazy.nvim`'s
  `{ import = "plugins" }` only reads the first `lua/plugins` directory
  it finds on the runtimepath, it doesn't merge across several — but as
  symlinks they carry no content of their own and can't drift from
  upstream. Add real plugin files here alongside them for anything
  genuinely custom.
- `lua/plugins/theme.lua` is a symlink to
  `~/.local/state/omarchy/current/theme/neovim.lua`. It must stay an
  absolute symlink. This nvim config is itself reached through a symlink
  (`~/.config/nvim` -> this directory), so a relative symlink here would
  resolve against the wrong directory.

## Personal keymaps

See `common/xdg_config/nvim-shared/keymaps.lua` for the full list and
rationale. A few of them intentionally override LazyVim defaults (for
example: `n`/`N` center the screen here, instead of LazyVim's
search-direction-aware version). Where a personal keymap could collide
with a useful LazyVim default (`<leader>gg` for Lazygit, `<leader>gb` for
Git Blame Line, `<leader>l` for the Lazy UI, `<leader>fc` for Find Config
File), the personal keymap was moved to a free key instead.

## Updating from upstream Omarchy

Omarchy updates `omarchy-nvim` like any other package, and since this
directory only carries the actual delta, most upstream changes need no
action at all — they show up automatically the next time nvim starts. The
things worth checking after an Omarchy update:

```bash
diff -ru /usr/share/omarchy-nvim/config/lua/plugins linux/omarchy/nvim/lua/plugins
```

If Omarchy adds a new `lua/plugins/*.lua` file, symlink it here the same
way as the others (or decide it's not needed). If Omarchy renames or
removes one of the files already symlinked here, update or remove that
symlink.

## First run after linking

Plugins install automatically the first time nvim starts, via
`lazy.nvim`. If the colorscheme looks wrong (falls back to tokyonight),
run `omarchy theme set <current-theme>` once to regenerate
`~/.local/state/omarchy/current/theme/neovim.lua`.
