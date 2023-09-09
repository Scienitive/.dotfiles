local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	'ThePrimeagen/harpoon',
	{
  		'VonHeikemen/lsp-zero.nvim',
  		branch = 'v2.x',
  		dependencies = {
    		-- LSP Support
    		{'neovim/nvim-lspconfig'},             -- Required
    		{'williamboman/mason.nvim'},           -- Optional
    		{'williamboman/mason-lspconfig.nvim'}, -- Optional

    		-- Autocompletion
    		{'hrsh7th/nvim-cmp'},     -- Required
    		{'hrsh7th/cmp-nvim-lsp'}, -- Required
	   		{'L3MON4D3/LuaSnip'},     -- Required
  		}
	},
	"nyoom-engineering/oxocarbon.nvim",
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000
	},
	{
    	'goolord/alpha-nvim',
    	dependencies = { 'nvim-tree/nvim-web-devicons' },
    	config = function ()
        	require'alpha'.setup(require'alpha.themes.startify'.config)
    	end
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			'nvim-tree/nvim-web-devicons'
		}
	},
	'xiyaowong/transparent.nvim',
	'christoomey/vim-tmux-navigator',
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
	},
	'ThePrimeagen/vim-be-good'
}

local opts = {}

require("lazy").setup(plugins, opts)
