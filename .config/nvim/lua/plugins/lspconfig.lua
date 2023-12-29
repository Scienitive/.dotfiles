return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        cmd = {
          "clangd",
          "--function-arg-placeholders=0",
        },
      },
    },
  },
}
