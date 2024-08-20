return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" }, -- useful snippets
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		config = function()
			local ls = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			ls.config.set_config({
				update_events = { "TextChanged", "TextChangedI" },
				enable_autosnippets = true,
			})

			-- Keymaps
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })

			vim.keymap.set("i", "<C-l>", function()
				if ls.choice_active() then
					ls.change_chioce(1)
				end
			end, { silent = true })

			-- Custom Snippets
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node
			local extras = require("luasnip.extras")
			local rep = extras.rep
			local fmt = require("luasnip.extras.fmt").fmt
			local c = ls.choice_node
			local f = ls.function_node
			local d = ls.dynamic_node
			local sn = ls.snippet_node

			-- Add custom snippets using ls.add_snippets()
			ls.add_snippets("typescriptreact", {
				s("us", {
					t("const ["),
					i(1, "state"),
					t(","),
					t(" set"),
					f(function(args)
						return args[1][1]:gsub("^%l", string.upper)
					end, { 1 }),
					t("] "),
					t("= useState<"),
					i(2, "type"),
					t(">"),
					t("("),
					i(3, "initial"),
					t(");"),
				}),
			})
		end,
	},
}
