require("base")

--- Old vim!
vim.cmd("source ~/.vim/autoload/plug.vim")
vim.cmd("source ~/.vimrc")

-- Customize!
vim.o.termguicolors = true

-- Remaps
vim.g.mapleader = ";"
vim.keymap.set("n", "<leader>rr", ":so ~/.config/nvim/init.lua<CR>")

-- Telescope
local tscope = require("telescope.builtin")
vim.keymap.set("n", "<leader>o", tscope.find_files, {})
vim.keymap.set("n", "<leader>O", tscope.git_files, {})
vim.keymap.set("n", "<leader>g", function()
	tscope.grep_string({ search = vim.fn.input("Grep > ") })
end)
