-- Personal keymaps, shared between the Omarchy Linux nvim config
-- (linux/omarchy/nvim) and the plain LazyVim macOS config
-- (macos/xdg_config/nvim). Each of those dofile()s this file after loading
-- its own base config, so this stays platform-independent.
--
-- A few of these intentionally override LazyVim defaults (for example:
-- n/N center the screen here, instead of LazyVim's search-direction-aware
-- version). Where a personal keymap could collide with a useful LazyVim
-- default (<leader>gg for Lazygit, <leader>gb for Git Blame Line, <leader>l
-- for the Lazy UI, <leader>fc for Find Config File), the personal keymap
-- was moved to a free key instead.

local map = vim.keymap.set

-- Alias commands for holding shift too long while hitting w.
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

-- Insert the current git branch name at the cursor.
map("n", "<leader>b", ":execute 'norm i' . system('g.branch')<CR><Esc>kJa", { desc = "Insert Git Branch" })

-- Yank the whole line with Y, to match D and C.
map("n", "Y", "yy")

-- Center the screen after scrolling, searching, or jumping to the end.
-- This replaces LazyVim's search-direction-aware n/N with a simpler, centered version.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "G", "Gzz")

-- Find files. LazyVim also provides this at <leader><space> and <leader>ff.
map("n", "<leader>o", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

-- Find files that are treesitter symbols.
map("n", "<leader>gt", function()
  Snacks.picker.treesitter()
end, { desc = "Goto Treesitter Symbol" })

-- Find files with uncommitted changes (see bin/g.mod in this dotfiles repo).
map("n", "<leader>gm", function()
  Snacks.picker.pick({ finder = "proc", cmd = "g.mod", format = "file", title = "Modified Files" })
end, { desc = "Goto Modified" })

-- Find files changed on this branch (see bin/g.bmod in this dotfiles repo).
-- Capital M, since <leader>gm is taken above and <leader>gb is LazyVim's Git Blame Line.
map("n", "<leader>gM", function()
  Snacks.picker.pick({ finder = "proc", cmd = "g.bmod", format = "file", title = "Branch Modified Files" })
end, { desc = "Goto Branch Modified" })

-- Yank the filename to the system clipboard.
map("n", "<leader>fy", '<cmd>:silent execute ":!echo -n % | pbcopy"<cr>', { desc = "Yank Filename" })
-- Yank the filename with the current line number.
map("n", "<leader>fl", '<cmd>:silent execute ":!echo %:".line(\'.\')." | pbcopy"<cr>', { desc = "Yank Filename:Line" })

-- Reload init.lua.
map("n", "<leader>rr", "<cmd>:so ~/.config/nvim/init.lua<cr>", { desc = "Reload init.lua" })

-- Check for a changed file on disk, and reload it.
map("n", "<leader>rf", "<cmd>:checkt<cr>", { desc = "Check Time / Reload File" })

-- Copy and paste from the system clipboard.
map("n", "<leader>c", '"+y', { desc = "Yank to Clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from Clipboard" })
map("v", "<leader>c", '"+y', { desc = "Yank to Clipboard" })

-- Toggle invisible characters. <leader>l is LazyVim's Lazy plugin manager.
map("n", "<leader>uv", ":set list!<cr>", { desc = "Toggle Invisible Characters" })
