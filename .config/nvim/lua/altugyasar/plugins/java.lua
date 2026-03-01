return {
	"mfussenegger/nvim-jdtls",
	ft = "java", -- only loads when you open a java file
	config = function()
		local jdtls = require("jdtls")
		local mason_root = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

		-- Download lombok.jar from projectlombok.org and put it here:
		local lombok_path = vim.fn.stdpath("data") .. "/lombok.jar"

		local launcher_jar = vim.fn.glob(mason_root .. "/plugins/org.eclipse.equinox.launcher_*.jar")
		local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

		local java_bin = "/Users/altugyasar/.sdkman/candidates/java/current/bin/java"

		local config = {
			cmd = {
				java_bin,
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
				-- This is the key Lombok line:
				"-javaagent:" .. lombok_path,
				"-jar",
				launcher_jar,
				"-configuration",
				mason_root .. "/config_mac",
				"-data",
				workspace,
			},

			root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

			settings = {
				java = {
					eclipse = { downloadSources = true },
					configuration = { updateBuildConfiguration = "interactive" },
					maven = { downloadSources = true },
					implementationsCodeLens = { enabled = true },
					referencesCodeLens = { enabled = true },
					inlayHints = { parameterNames = { enabled = "all" } },
					signatureHelp = { enabled = true },
					completion = {
						favoriteStaticMembers = {
							"org.junit.jupiter.api.Assertions.*",
							"org.mockito.Mockito.*",
						},
					},
				},
			},

			init_options = {
				bundles = {}, -- add debug bundles here if you want DAP later
			},
		}

		-- nvim-jdtls specific keymaps (on top of your normal LSP ones)
		config.on_attach = function(_, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set(
				"n",
				"<leader>jo",
				jdtls.organize_imports,
				vim.tbl_extend("force", opts, { desc = "Organize imports" })
			)
			vim.keymap.set(
				"n",
				"<leader>jev",
				jdtls.extract_variable,
				vim.tbl_extend("force", opts, { desc = "Extract variable" })
			)
			vim.keymap.set(
				"n",
				"<leader>jem",
				jdtls.extract_method,
				vim.tbl_extend("force", opts, { desc = "Extract method" })
			)
			vim.keymap.set(
				"n",
				"<leader>jec",
				jdtls.extract_constant,
				vim.tbl_extend("force", opts, { desc = "Extract constant" })
			)
			vim.keymap.set(
				"n",
				"<leader>jt",
				jdtls.test_nearest_method,
				vim.tbl_extend("force", opts, { desc = "Test nearest method" })
			)
			vim.keymap.set("n", "<leader>jT", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Test class" }))
		end

		-- Start jdtls when entering a java buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				jdtls.start_or_attach(config)
			end,
		})
	end,
}
