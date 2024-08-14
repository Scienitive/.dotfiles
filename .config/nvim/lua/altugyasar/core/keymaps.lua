vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set({ "n", "v" }, "<leader>y", '"+y')
keymap.set({ "n", "v" }, "<leader>Y", '"+Y')
keymap.set("n", "<leader>p", '"+p')
keymap.set("n", "<leader>P", '"+P')

keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Debugging
-- keymap.set("n", "<leader>d1", ":lua require'dap'.continue()<CR>")
-- keymap.set("n", "<leader>d2", ":lua require'dap'.step_over()<CR>")
-- keymap.set("n", "<leader>d3", ":lua require'dap'.step_into()<CR>")
-- keymap.set("n", "<leader>d4", ":lua require'dap'.step_out()<CR>")
-- keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
-- keymap.set("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>")
-- keymap.set("n", "<leader>dp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log Point Message: '))<CR>")
-- keymap.set("n", "<leader>ds", ":lua require'dap'.repl.open()<CR>")

-- Auto format
keymap.set("n", "<leader>af", ":lua vim.g.autoFormat = not vim.g.autoFormat<CR>", { desc = "Auto format toggle" })

-- oil.nvim
keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Inlay Hint
keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
