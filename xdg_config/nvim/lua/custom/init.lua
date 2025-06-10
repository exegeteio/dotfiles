-- Relative line numbers:
vim.wo.relativenumber = true

-- Enable nerd font.
vim.g.have_nerd_font = true

-- Highlight all search results.
vim.o.hlsearch = true

-- Alias commands for holding shift too long while hitting w.
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

-- Setup list options.
vim.opt.list = false
vim.o.listchars = "space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:|>"

require("custom.keymaps")
require("custom.plugins.init")

-- Return to previous place in the buffer:
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec2('silent! normal! g`"zz', { output = false })
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
