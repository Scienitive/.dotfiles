local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	opts.buffer = bufnr

	opts.desc = "Show LSP References"
	keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

	opts.desc = "Go to Declaration"
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Show LSP Definitions"
	keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

	opts.desc = "Show LSP Implementations"
	keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

	opts.desc = "Show LSP Type Definitions"
	keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

	opts.desc = "Show Available Code Actions"
	keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)

	opts.desc = "Smart Rename"
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	opts.desc = "Show Line Diagnostics"
	keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

	opts.desc = "Go to Previous Diagnostic"
	keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

	opts.desc = "Go to Next Diagnostic"
	keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	opts.desc = "Show Documentation"
	keymap.set("n", "K", vim.lsp.buf.hover, opts)

	opts.desc = "Restart LSP"
	keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local default_setup = function(server)
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

mason_lspconfig.setup({
	ensure_installed = {
		"tsserver",
		"html",
		"cssls",
		"lua_ls",
		"emmet_ls",
		"bashls",
		"clangd",
		"dockerls",
		"docker_compose_language_service",
		"marksman",
		"pyright",
		"rust_analyzer",
		"sqlls",
	},

	automatic_installation = true,

	handlers = {
		default_setup,
		lua_ls = function()
			require('lspconfig').lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = { -- custom settings for lua
					Lua = {
						-- make the language server recognize "vim" global
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							-- make language server aware of runtime files
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})
		end,
	}
})
