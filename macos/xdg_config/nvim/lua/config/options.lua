-- Options are automatically loaded before lazy.nvim startup.
-- Personal overrides, shared with the Omarchy Linux nvim config.
local dotfiles = os.getenv("DOTFILES_PATH") or vim.fn.expand("~/.config/dotfiles")
dofile(dotfiles .. "/common/xdg_config/nvim-shared/options.lua")
