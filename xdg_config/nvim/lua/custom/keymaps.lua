-- Insert current branchname,
vim.keymap.set("n", "<leader>b", ":execute 'norm i' . system('g.branch')<CR><Esc>kJa")

-- vim mode for capital Y
vim.keymap.set("n", "Y", "yy")

-- Center the screen after scrolling, finding next, etc.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "G", "Gzz")

-- List files.
vim.keymap.set("n", "<leader>o", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })

-- Grep for the word under the cursor.
vim.keymap.set("n", "<leader>gg", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })

-- Search for symbols.
vim.keymap.set("n", "<leader>gt", require("telescope.builtin").treesitter, { desc = "[G]oto [T]reesitter" })

-- Run g.mod (files modified and not committed in git) and open the files.
vim.keymap.set("n", "<leader>gm", function(_)
  require("telescope.builtin").find_files({
    find_command = { "g.mod" },
  })
end, { desc = "[G]oto [M]odified" })

-- Run g.bmod (files modified and committed in this git branch) and open the files.
vim.keymap.set("n", "<leader>gb", function(_)
  require("telescope.builtin").find_files({
    find_command = { "g.bmod" },
  })
end, { desc = "[G]oto [B]ranch Modified" })

-- Copy filename to clipboard.
vim.keymap.set("n", "<leader>fc", '<cmd>:silent execute ":!echo -n % | pbcopy"<cr>')
-- Filename with line number.
vim.keymap.set("n", "<leader>fl", '<cmd>:silent execute ":!echo %:".line(\'.\')." | pbcopy"<cr>')

-- Reload init.lua.
vim.keymap.set("n", "<leader>rr", "<cmd>:so ~/.config/nvim/init.lua<cr>")

-- Check time and/or reload current file.
vim.keymap.set("n", "<leader>rf", "<cmd>:checkt<cr>")

-- Copy/paste from clipboard.
vim.keymap.set("n", "<leader>c", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>c", '"+y')

-- Format the current buffer.
vim.keymap.set({ "n", "v" }, "<leader>ff", function()
  vim.lsp.buf.format({ async = true })
end, {})

-- Toggle the invisible characters.
vim.keymap.set("n", "<leader>l", ":set list!<cr>")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
