return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MonifTanjim/nui.nvim" },
  config = function()
    return {
      enabled_keys = {
        ["<Up>"] = true, -- Allow <Up> key
        ["<Down>"] = true, -- Allow <Down> key
        ["<Left>"] = true, -- Allow <Left> key
        ["<Right>"] = true, -- Allow <Right> key
      },
    }
  end,
}
