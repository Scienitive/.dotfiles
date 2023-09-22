local opt = vim.opt

opt.relativenumber = true
opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.background = "dark"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8

opt.iskeyword:append("-")
