return {
  "RRethy/nvim-base16",
  config = function()
    vim.cmd("colorscheme base16-catppuccin")
    vim.cmd([[highlight StatusLineNC guibg=#AAAAAA]])
    vim.cmd([[highlight DiagnosticVirtualTextWarn guibg=#1a212e]])
    vim.cmd([[highlight DiagnosticVirtualTextInfo guibg=#1a212e]])
    vim.cmd([[highlight DiagnosticVirtualTextHint guibg=#1a212e]])
  end,
}
