return {
  "justyntemme/org-sync.nvim",
  -- The event trigger now lives here, in your personal config.
  -- event = "VeryLazy",
  -- event = { "BufReadPost ~/.org/**/*.org", "BufWritePost ~/.org/**/*.org" },
  event = { "BufReadPost ~/.config/org/**/*.org", "BufWritePost ~/.config/org/**/*.org" },
  -- The config function calls the `setup` function from your plugin.
  config = function()
    require("org-sync").setup({
      dir = "~/.config/org/",
    })
  end,
}
