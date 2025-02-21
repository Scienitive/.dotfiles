return {
	"stevearc/conform.nvim",
	config = function()
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})

		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true }, -- Add TypeScript
				javascriptreact = { "prettierd", "prettier", stop_after_first = true }, -- Add JSX (JavaScript)
				typescriptreact = { "prettierd", "prettier", stop_after_first = true }, -- Add TSX
				html = { "prettierd", "prettier", stop_after_first = true }, -- Add HTML
				css = { "prettierd", "prettier", stop_after_first = true }, -- Add CSS
				json = { "prettierd", "prettier", stop_after_first = true }, -- Add JSON
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
