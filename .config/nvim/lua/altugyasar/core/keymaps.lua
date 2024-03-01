vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set({"n", "v"}, "<leader>y", '"+y')
keymap.set({"n", "v"}, "<leader>Y", '"+Y')
keymap.set("n", "<leader>p", '"+p')
keymap.set("n", "<leader>P", '"+P')

keymap.set({"i", "x", "n", "s"}, "<C-s>", "<cmd>w<cr><esc>", {desc = "Save file"})
