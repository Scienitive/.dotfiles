require("altugyasar.core.options")
require("altugyasar.core.keymaps")
require("altugyasar.plugin-manager")
require("altugyasar.plugins.harpoon")
require("altugyasar.plugins.lsp")
require("altugyasar.plugins.treesitter")
require("altugyasar.plugins.nvimtree")
require("altugyasar.plugins.lualine")
vim.cmd "colorscheme catppuccin-mocha" -- oxocarbon also good
vim.cmd "hi NvimTreeNormal guibg=NONE ctermbg=NONE" --remove background color on tree
