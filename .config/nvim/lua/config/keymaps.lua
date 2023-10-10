-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set({ "n", "v" }, "<leader>y", '"+y')
keymap.set({ "n", "v" }, "<leader>Y", '"+Y')
keymap.set("n", "<leader>p", '"+p')
keymap.set("n", "<leader>P", '"+P')

keymap.set("n", "<leader>md", ":MarkdownPreviewToggle<CR>")
