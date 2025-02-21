return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		strategies = {
			chat = {
				adapter = "copilot",
				keymaps = {
					send = {
						modes = { n = "<C-s>", i = "<C-s>" },
					},
				},
				slash_commands = {
					["file"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.file",
						description = "Select a file using Telescope",
						opts = {
							provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
							contains_code = true,
						},
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
			agent = {
				adapter = "copilot",
			},
		},
	},
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle Chat", mode = { "n", "v" } },
		{ "<leader>ac", "<cmd>CodeCompanionActions<CR>", desc = "Open Actions Menu", mode = { "n", "v" } },
	},
	config = function()
		local codecompanion = require("codecompanion")

		codecompanion.setup({
			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ", -- Prompt used for interactive LLM calls
					provider = "default", -- default|telescope|mini_pick
					opts = {
						show_default_actions = true, -- Show the default actions in the action palette?
						show_default_prompt_library = true, -- Show the default prompt library in the action palette?
					},
				},
				chat = {
					window = {
						position = "right",
						width = 0.55,
					},
				},
			},
		})
	end,
}
