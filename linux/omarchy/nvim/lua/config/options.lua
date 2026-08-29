-- Options are automatically loaded before lazy.nvim startup.
--
-- lazy.nvim resets 'runtimepath' during its own bootstrap, so by the time
-- this file runs, the rtp entry init.lua added for Omarchy's config is
-- gone and plain require() can no longer find anything under it. Omarchy's
-- own options.lua does `require("config.remote_clipboard")` internally, so
-- pre-load that module into Lua's cache directly (bypassing require's path
-- search entirely) before running Omarchy's options.
package.loaded["config.remote_clipboard"] = dofile("/usr/share/omarchy-nvim/config/lua/config/remote_clipboard.lua")

-- Load Omarchy's own options (relativenumber default, autoformat, the
-- remote-clipboard setup above), then layer personal overrides on top.
dofile("/usr/share/omarchy-nvim/config/lua/config/options.lua")

local dotfiles = os.getenv("DOTFILES_PATH") or vim.fn.expand("~/.config/dotfiles")
dofile(dotfiles .. "/common/xdg_config/nvim-shared/options.lua")
