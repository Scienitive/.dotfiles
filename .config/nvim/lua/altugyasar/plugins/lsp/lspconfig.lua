return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.filetype.add({
			extension = {
				slang = "slang",
				shaderslang = "slang",
				vs = "glsl",
				fs = "glsl",
				vert = "glsl",
				frag = "glsl",
				glsl = "glsl",
				m = "objc",
				metal = "metal",
				wgsl = "wgsl",
			},
		})

		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.HINT] = signs.Hint,
					[vim.diagnostic.severity.INFO] = signs.Info,
				},
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
			callback = function(event)
				local opts = { noremap = true, silent = true, buffer = event.buf }
				local keymap = vim.keymap

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				opts.desc = "Show LSP info"
				keymap.set("n", "<leader>ls", ":LspInfo<CR>", opts)
			end,
		})

		-- LSP Servers

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("html", {})

		vim.lsp.config("ts_ls", {
			init_options = {
				preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
					importModuleSpecifierPreference = "non-relative",
				},
			},
		})

		vim.lsp.config("cssls", {
			settings = {
				css = { validate = true, lint = { unknownAtRules = "ignore" } },
				scss = { validate = true, lint = { unknownAtRules = "ignore" } },
				less = { validate = true, lint = { unknownAtRules = "ignore" } },
			},
		})

		vim.lsp.config("emmet_language_server", {
			init_options = {
				showExpandedAbbreviation = "never",
			},
		})

		vim.lsp.config("pyright", {})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		vim.lsp.config("bashls", {})

		vim.lsp.config("clangd", {
			cmd = { "clangd", "--function-arg-placeholders=0" },
			capabilities = vim.tbl_deep_extend("keep", capabilities, {
				offsetEncoding = { "utf-16" },
			}),
			filetypes = { "c", "cpp" },
		})

		vim.lsp.config("sourcekit", {
			cmd = { "xcrun", "sourcekit-lsp" },
			filetypes = { "swift", "objc", "objcpp" },
			root_dir = function(fname)
				return vim.fs.root(fname, { "build.zig", ".git", "compile_commands.json", "Package.swift" })
			end,
		})

		vim.lsp.config("dockerls", {})
		vim.lsp.config("docker_compose_language_service", {})
		vim.lsp.config("gopls", {})
		vim.lsp.config("jsonls", {})
		vim.lsp.config("autotools_ls", {})
		vim.lsp.config("sqls", {})
		vim.lsp.config("tailwindcss", {})

		vim.lsp.config("eslint", {
			settings = {
				codeAction = {
					disableRuleComment = { enable = true, location = "separateLine" },
					showDocumentation = { enable = true },
				},
				codeActionOnSave = { enable = false, mode = "all" },
				experimental = { useFlatConfig = true },
				format = true,
				nodePath = "",
				onIgnoredFiles = "off",
				problems = { shortenToSingleLine = false },
				quiet = false,
				rulesCustomizations = {},
				run = "onType",
				useESLintClass = false,
				validate = "on",
				workingDirectory = { mode = "auto" },
			},
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
		})

		vim.lsp.config("zls", {
			settings = {
				zls = {
					enable_semantic_tokens = true,
					enable_inlay_hints = true,
					enable_autofix = true,
					enable_snippets = false,
					warn_style = true,
					highlight_global_var_declarations = true,
				},
			},
		})

		vim.lsp.config("slangd", {
			filetypes = { "hlsl", "slang", "shaderslang" },
		})

		vim.lsp.config("glslls", {
			cmd = { "glslls", "--stdin" },
			filetypes = { "glsl" },
		})

		vim.lsp.config("wgsl_analyzer", {
			cmd = { vim.fn.stdpath("data") .. "/mason/bin/wgsl-analyzer" },
			root_dir = function(fname)
				return vim.fs.root(fname, { ".git", "package.json", "Cargo.toml" })
			end,
		})

		-- Note: the server name uses underscores, not hyphens
		vim.lsp.config("kotlin_language_server", {})

		-- Enable all configured servers
		-- (mason-lspconfig handles enabling mason-installed servers automatically,
		-- but manually configured ones need vim.lsp.enable if not handled by mason)
		vim.lsp.enable({
			"sourcekit",
			"glslls",
			"wgsl_analyzer",
			"slangd",
			"kotlin_language_server",
		})
	end,
}
