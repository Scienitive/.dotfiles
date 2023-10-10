return {
  "xiyaowong/transparent.nvim",
  config = function()
    local transparent = require("transparent")

    transparent.setup({
      groups = {
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLineNr",
        "EndOfBuffer",
      },
      extra_groups = {
        "NvimTreeNormal",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
      },
    })
  end,
}
