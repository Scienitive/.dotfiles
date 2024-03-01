return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		local catppuccin = require("catppuccin")

		catppuccin.setup({
			color_overrides = {
				all = {
					base = "#000000",
				},
			},
		})

		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
