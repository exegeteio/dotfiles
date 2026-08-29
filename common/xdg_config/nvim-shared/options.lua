-- Personal nvim option overrides, shared between the Omarchy Linux nvim
-- config (linux/omarchy/nvim) and the plain LazyVim macOS config
-- (macos/xdg_config/nvim). Each of those dofile()s this file after loading
-- its own base config, so this stays platform-independent.

-- Show relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Characters to show when list mode is on.
-- Toggle list mode with <leader>uv.
vim.opt.list = false
vim.opt.listchars = { space = "*", trail = "*", nbsp = "*", extends = ">", precedes = "<", tab = "|>" }
