local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.cursorline = true
opt.termguicolors = true
opt.pumheight = 10

opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.spelllang = { "en" }

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.wrap = false

opt.list = false
opt.clipboard = ""
opt.scrolloff = 8

vim.g.autoFormat = true
