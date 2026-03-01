return {
	"olimorris/codecompanion.nvim",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = {
		"CodeCompanion",
		"CodeCompanionChat",
		"CodeCompanionActions",
	},
	opts = {
		adapters = {},
		strategies = {
			chat = {
				adapter = "anthropic",
				keymaps = {
					send = {
						modes = { n = "<C-s>", i = "<C-s>" },
					},
				},
				slash_commands = {
					["file"] = {
						callback = "strategies.chat.slash_commands.file",
						description = "Select a file using Telescope",
						opts = {
							provider = "telescope",
							contains_code = true,
						},
					},
				},
			},
			agent = {
				adapter = "anthropic",
			},
		},
	},
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle Chat", mode = { "n", "v" } },
		{ "<leader>ac", "<cmd>CodeCompanionActions<CR>", desc = "Open Actions Menu", mode = { "n", "v" } },
	},
	config = function(_, opts)
		opts.adapters.anthropic = function()
			return require("codecompanion.adapters").extend("anthropic", {
				env = {
					api_key = os.getenv("ANTHROPIC_API_KEY"),
				},
			})
		end
		require("codecompanion").setup(opts)
	end,
}
