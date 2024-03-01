local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.color_scheme = "Isotope (dark) (terminal.sexy)"
config.color_scheme = "catppuccin-mocha"
config.colors = {
	background = "black",
}

config.hide_tab_bar_if_only_one_tab = true
-- config.leader = { key = "a", mods = "CTRL", timeout_miliseconds = 1000 }
-- config.keys = {
-- 	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
-- 	{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
-- 	{ key = "|", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
-- 	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
-- 	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
-- 	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
-- 	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
-- 	{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
-- 	{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
-- 	{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
-- 	{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
-- 	{ key = "m", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
-- 	{ key = "s", mods = "LEADER", action = wezterm.action.ShowLauncher },
-- 	{
-- 		key = "n",
-- 		mods = "LEADER",
-- 		action = wezterm.action.PromptInputLine({
-- 			description = wezterm.format({
-- 				{ Attribute = { Intensity = "Bold" } },
-- 				{ Foreground = { AnsiColor = "Fuchsia" } },
-- 				{ Text = "Enter name for new workspace" },
-- 			}),
-- 			action = wezterm.action_callback(function(window, pane, line)
-- 				-- line will be `nil` if they hit escape without entering anything
-- 				-- An empty string if they just hit enter
-- 				-- Or the actual line of text they wrote
-- 				if line then
-- 					window:perform_action(
-- 						wezterm.action.SwitchToWorkspace({
-- 							name = line,
-- 						}),
-- 						pane
-- 					)
-- 				end
-- 			end),
-- 		}),
-- 	},
-- }

return config
