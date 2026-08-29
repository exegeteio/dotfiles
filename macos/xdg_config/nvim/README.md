# nvim, plain LazyVim + personal customizations

A standard [LazyVim](https://github.com/LazyVim/LazyVim) starter, with no
Omarchy dependency. macOS has no `omarchy-nvim` package to layer onto, so
this is a normal fork of the LazyVim starter template instead.

`lua/config/options.lua` and `lua/config/keymaps.lua` each `dofile()`
`common/xdg_config/nvim-shared/{options,keymaps}.lua` — the actual
personal customizations, shared with the Omarchy Linux nvim config at
`linux/omarchy/nvim` so they aren't duplicated between the two.

`lua/plugins/example.lua` is a placeholder (`lazy.nvim`'s
`{ import = "plugins" }` errors if the directory has no files at all).
Add real plugin specs alongside it, or replace it.
