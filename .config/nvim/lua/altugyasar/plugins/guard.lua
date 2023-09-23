return {
	"nvimdev/guard.nvim",
	dependencies = {
        "nvimdev/guard-collection",
    },
	config = function()
		local guard = require("guard")
		local ft = require("guard.filetype")

		ft('rust'):fmt('rustfmt')

		guard.setup({
			fmt_ons_save = true,
			lsp_as_default_formatter = false,
		})
	end,
}
