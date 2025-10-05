return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = function()
    return {
      disable_mouse = false,
      -- enabled_keys = {
      --   ["<Up>"] = true, -- Allow <Up> key
      --   ["<Down>"] = true, -- Allow <Down> key
      --   ["<Left>"] = true, -- Allow <Left> key
      --   ["<Right>"] = true, -- Allow <Right> key
      -- },
    }
  end,
}
