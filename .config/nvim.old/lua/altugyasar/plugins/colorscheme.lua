function LineNumberColors()
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='yellow', bold=true })
    vim.api.nvim_set_hl(0, 'LineNr', { fg='yellow', bold=true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='yellow', bold=true })
end

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme "catppuccin"
		LineNumberColors()
	end,
}
