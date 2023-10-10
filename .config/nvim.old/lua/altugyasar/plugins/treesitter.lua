return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"javascript",
				"typescript",
				"c_sharp",
				"comment",
				"cpp",
				"css",
				"dockerfile",
				"dot",
				"gitignore",
				"git_config",
				"git_rebase",
				"html",
				"ini",
				"java",
				"json",
				"make",
				"markdown",
				"php",
				"python",
				"rust",
				"sql",
				"go",
				"svelte",
				"astro",
				"yaml",
				"bash"
			},

			sync_install = false,
			auto_install = true,

			highlight = {
				enable = true
			},

			indent = { enable = true }
		})
	end,
}
