-- Layer these personal customizations on top of Omarchy's own nvim config
-- (the omarchy-nvim pacman package, /usr/share/omarchy-nvim/config) instead
-- of forking it. Anything not overridden under lua/config/ or lua/plugins/
-- here (lazy.lua, autocmds.lua, remote_clipboard.lua) is picked up live
-- from the Omarchy package via this runtimepath entry.
vim.opt.rtp:append("/usr/share/omarchy-nvim/config")

require("config.lazy")
