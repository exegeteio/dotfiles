-- Keymaps are automatically loaded on the VeryLazy event.
-- Personal keymaps, shared with the Omarchy Linux nvim config.
-- See common/xdg_config/nvim-shared/keymaps.lua for the full list and rationale.
local dotfiles = os.getenv("DOTFILES_PATH") or vim.fn.expand("~/.config/dotfiles")
dofile(dotfiles .. "/common/xdg_config/nvim-shared/keymaps.lua")
