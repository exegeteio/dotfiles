-- Keymaps are automatically loaded on the VeryLazy event.
-- Load Omarchy's own keymaps first, then layer personal keymaps on top.
-- See common/xdg_config/nvim-shared/keymaps.lua for the full list and rationale.
dofile("/usr/share/omarchy-nvim/config/lua/config/keymaps.lua")

local dotfiles = os.getenv("DOTFILES_PATH") or vim.fn.expand("~/.config/dotfiles")
dofile(dotfiles .. "/common/xdg_config/nvim-shared/keymaps.lua")
