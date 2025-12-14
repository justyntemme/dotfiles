-- ~/.config/nvim/lua/plugins/odin.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure 'ols' is listed here.
        -- If you added 'ols' to your PATH, this empty table is enough.
        ols = {},
      },
    },
  },
}
