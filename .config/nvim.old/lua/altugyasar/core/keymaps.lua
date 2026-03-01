vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set({ "n", "v" }, "<leader>y", '"+y')
keymap.set({ "n", "v" }, "<leader>Y", '"+Y')
keymap.set("n", "<leader>p", '"+p')
keymap.set("n", "<leader>P", '"+P')

-- Global config reset
keymap.set("n", "<leader>rl", function()
	for name, _ in pairs(package.loaded) do
		if name:match("^user") or name:match("^plugins") then
			package.loaded[name] = nil
		end
	end
	dofile(vim.fn.stdpath("config") .. "/init.lua")
	vim.notify("🔁 Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload full Neovim config" })

-- Global copy to system clipboard
keymap.set({ "n" }, "<leader>g", 'ggvG"+Y')

-- Global diagnostics to quickfix list
vim.keymap.set("n", "<leader>td", function()
	-- Set errorformat using raw strings (no escape sequence processing)
	vim.opt.errorformat = {
		[[%E||\ %f(%l\,%c):\ error\ %m]], -- Error lines with ||
		[[%W||\ %f(%l\,%c):\ warning\ %m]], -- Warning lines with ||
		[[%-G||%.%#]], -- Ignore other || lines
		[[%f(%l\,%c):\ error\ %m]], -- Fallback without ||
		[[%f(%l\,%c):\ warning\ %m]], -- Fallback warning without ||
	}

	-- Run tsc and capture output
	local output = vim.fn.systemlist("npx tsc --noEmit 2>&1")

	-- Populate quickfix list
	vim.fn.setqflist({}, " ", {
		title = "TypeScript Errors",
		lines = output,
	})

	-- Open quickfix if there are errors
	local qf_list = vim.fn.getqflist()
	if #qf_list > 0 then
		vim.cmd("copen")
	else
		print("✅ No TypeScript errors!")
	end
end, { desc = "Run TypeScript compiler" })

-- Apple Metal Compile
vim.api.nvim_create_user_command("MSL", function()
	local file = vim.fn.expand("%:p")
	if not file:match("%.metal$") then
		vim.notify("Not a .metal file", vim.log.levels.WARN)
		return
	end

	local output = vim.fn.system({
		"xcrun",
		"-sdk",
		"macosx",
		"metal",
		"-c",
		file,
		"-o",
		"/dev/null",
	})

	if vim.v.shell_error == 0 then
		vim.notify("✓ No errors", vim.log.levels.INFO)
	else
		-- Open in quickfix for easy navigation
		vim.fn.setqflist({}, "r", {
			title = "Metal Compiler",
			lines = vim.split(output, "\n"),
			efm = "%f:%l:%c: %t%*[^:]: %m",
		})
		vim.cmd("copen")
	end
end, { desc = "Check Metal shader compilation" })

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

-- Quickfix
keymap.set("n", "<M-n>", ":cnext<CR>", { desc = "Quickfix next" })
keymap.set("n", "<M-p>", ":cprev<CR>", { desc = "Quickfix prev" })

-- SuperMaven
keymap.set("n", "<leader>sm", ":SupermavenToggle<CR>", { noremap = true, desc = "Toggle SuperMaven" })

-- Previous File Navigation
keymap.set("n", "<leader>w", function()
	local prev_file = vim.fn.bufnr("#")
	if prev_file ~= -1 then
		vim.cmd("buffer " .. prev_file)
	end
end, { desc = "Go to previous file" })

keymap.set("n", "<leader>q", function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1, loaded = 1 })
	if #buffers > 2 then
		table.sort(buffers, function(a, b)
			return a.lastused > b.lastused
		end)
		vim.cmd("buffer " .. buffers[3].bufnr)
	end
end, { desc = "Go to second previous file" })
