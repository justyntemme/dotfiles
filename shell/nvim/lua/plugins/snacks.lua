return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.ui = opts.ui or {}
    opts.ui.select = true
    opts.ui.input = true
    return opts
  end,
}
