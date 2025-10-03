return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    -- 1. Run the standard setup. This hijacks the built-in scroll keys
    -- and makes them smooth. This is the mechanism we will piggyback on.
    require("neoscroll").setup({})

    -- 2. Create our custom keymaps using an expression.
    -- This calculates the line count and prepends it to the already-working <C-d> command.
    vim.keymap.set("n", "<S-C-d>", function()
      return tostring(math.floor(vim.api.nvim_win_get_height(0) * 0.25)) .. "<C-d>"
    end, { expr = true, desc = "Scroll Down (Quarter Page)" })

    vim.keymap.set("n", "<S-C-u>", function()
      -- The count for <C-u> is also a positive number.
      return tostring(math.floor(vim.api.nvim_win_get_height(0) * 0.25)) .. "<C-u>"
    end, { expr = true, desc = "Scroll Up (Quarter Page)" })
  end,
}
