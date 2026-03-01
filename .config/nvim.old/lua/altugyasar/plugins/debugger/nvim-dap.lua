return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",

			-- Virtual text (shows variable values inline)
			"theHamsta/nvim-dap-virtual-text",

			-- Mason integration for installing debug adapters
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},
		keys = {
			-- Basic debugging keymaps
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Continue",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},

			-- Breakpoints
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Conditional Breakpoint",
			},
			{
				"<leader>dl",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "Debug: Log Point",
			},

			-- UI toggle
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Debug: Toggle UI",
			},

			-- Evaluate expression under cursor
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Debug: Evaluate",
				mode = { "n", "v" },
			},

			-- REPL
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Debug: Open REPL",
			},

			-- Run last
			{
				"<leader>d.",
				function()
					require("dap").run_last()
				end,
				desc = "Debug: Run Last",
			},

			-- Terminate
			{
				"<leader>dx",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: Terminate",
			},

			-- Hover (show variable value)
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Debug: Hover",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Mason DAP setup - auto install debug adapters
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				handlers = {},
				ensure_installed = {
					"codelldb", -- For C/C++/Rust on macOS
				},
			})

			-- DAP UI setup
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			-- Virtual text setup (shows variable values inline)
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				display_callback = function(variable, _buf, _stackframe, _node)
					return " " .. variable.name .. " = " .. variable.value
				end,
			})

			-- Auto open/close UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Signs for breakpoints
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
			)

			-- Highlight for stopped line
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
			vim.api.nvim_set_hl(0, "DapBreakpoint", { default = true, fg = "#e51400" })
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { default = true, fg = "#f5c400" })
			vim.api.nvim_set_hl(0, "DapLogPoint", { default = true, fg = "#61afef" })
			vim.api.nvim_set_hl(0, "DapStopped", { default = true, fg = "#98c379" })

			-----------------------------------------------------------
			-- CODELLDB ADAPTER (for C/C++/Rust on macOS)
			-----------------------------------------------------------
			-- Mason installs codelldb to this path
			local mason_path = vim.fn.stdpath("data") .. "/mason"
			local codelldb_path = mason_path .. "/bin/codelldb"

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
				},
			}

			-- C configuration
			dap.configurations.c = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				{
					name = "Launch with arguments",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " ")
					end,
				},
			}

			-- C++ uses same config as C
			dap.configurations.cpp = dap.configurations.c

			-- Rust uses same config
			dap.configurations.rust = dap.configurations.c

			-----------------------------------------------------------
			-- OPTIONAL: Project-specific launch configs
			-----------------------------------------------------------
			-- You can create a .nvim-dap.lua file in your project root:
			--
			-- return {
			--   {
			--     name = "My Game",
			--     type = "codelldb",
			--     request = "launch",
			--     program = "${workspaceFolder}/build/game",
			--     cwd = "${workspaceFolder}",
			--     args = {},
			--   },
			-- }
			--
			-- Then load it with:
			-- :lua require('dap.ext.vscode').load_launchjs('.nvim-dap.lua')
		end,
	},
}
