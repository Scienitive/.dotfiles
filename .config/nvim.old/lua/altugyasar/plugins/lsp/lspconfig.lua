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

		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			opts.buffer = bufnr

			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

			opts.desc = "Show LSP info"
			keymap.set("n", "<leader>ls", ":LspInfo<CR>", opts) -- mapping to restart lsp if necessary
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
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

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure typescript server with plugin
		lspconfig["ts_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
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

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				css = { validate = true, lint = {
					unknownAtRules = "ignore",
				} },
				scss = { validate = true, lint = {
					unknownAtRules = "ignore",
				} },
				less = { validate = true, lint = {
					unknownAtRules = "ignore",
				} },
			},
		})

		-- configure emmet language server
		lspconfig["emmet_language_server"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			init_options = {
				showExpandedAbbreviation = "never",
			},
		})

		-- configure python server
		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
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

		lspconfig["bashls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		local clangd_capabilities = vim.tbl_deep_extend("keep", capabilities, {
			offsetEncoding = { "utf-16" },
		})
		lspconfig["clangd"].setup({
			cmd = { "clangd", "--function-arg-placeholders=0" },
			capabilities = clangd_capabilities,
			on_attach = on_attach,
			filetypes = { "c", "cpp" },
		})

		lspconfig["sourcekit"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "xcrun", "sourcekit-lsp" },
			filetypes = { "swift", "objc", "objcpp" },
			root_dir = lspconfig.util.root_pattern("build.zig", ".git", "compile_commands.json", "Package.swift"),
		})

		lspconfig["dockerls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["docker_compose_language_service"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["jsonls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["autotools_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["sqls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["eslint"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			-- Add these critical settings from the default config:
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = true,
					},
				},
				codeActionOnSave = {
					enable = false,
					mode = "all",
				},
				experimental = {
					useFlatConfig = true, -- Set to true if you're using eslint.config.mjs
				},
				format = true,
				nodePath = "",
				onIgnoredFiles = "off",
				problems = {
					shortenToSingleLine = false,
				},
				quiet = false,
				rulesCustomizations = {},
				run = "onType", -- This is KEY - validates as you type
				useESLintClass = false,
				validate = "on", -- This enables validation
				workingDirectory = {
					mode = "auto",
				},
			},
			-- Also add the filetypes explicitly
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				-- Add any other file types you want ESLint to check
			},
		})

		lspconfig["zls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
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

		lspconfig["slangd"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "hlsl", "slang", "shaderslang" },
		})

		lspconfig["gslslls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "glslls", "--stdin" },
			filetypes = { "glsl" },
		})

		lspconfig["wgsl_analyzer"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { vim.fn.stdpath("data") .. "/mason/bin/wgsl-analyzer" },
			root_dir = lspconfig.util.root_pattern(".git", "package.json", "Cargo.toml"),
		})

		lspconfig["kotlin-language-server"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- Java Setup
		local mason_root = vim.fn.stdpath("data") .. "/mason"
		local jdtls_path = mason_root .. "/packages/jdtls"

		local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

		local os_config = "linux"
		if vim.fn.has("mac") == 1 then
			os_config = "mac"
		end
		if vim.fn.has("win32") == 1 then
			os_config = "win"
		end

		if #launcher_jar > 0 then
			lspconfig["jdtls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					launcher_jar,
					"-configuration",
					jdtls_path .. "/config_" .. os_config,
					"-data",
					vim.fn.stdpath("data")
						.. "/site/java/workspace-root/"
						.. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
				},
				root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
			})
		end
	end,
}
