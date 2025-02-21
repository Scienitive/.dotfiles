return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		local linters = require("lint").linters

		lint.linters_by_ft = {
			lua = { "stylua" },
			css = { "stylelint" },
			sh = { "shellcheck" },
			markdown = { "markdownlint" },
			yaml = { "yamllint" },
			python = { "pylint" },
			gitcommit = {},
			json = {},
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			toml = {},
			text = {},
		}
	end,
}
