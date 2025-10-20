return {
  "mrs4ndman/snacks.nvim", -- This name MUST match the original plugin
  opts = function()
    -- This function is called by LazyVim to get the options
    -- It's great practice, especially if you later need to
    -- require() other modules to build your config.
    return {
      ui = {
        select = true,
        input = true,
      },
    }
  end,
}
