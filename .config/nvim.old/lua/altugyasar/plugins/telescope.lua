return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.3',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = "make" },
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					}
				}
			}
		})

		telescope.load_extension("fzf")
	end,
}
