return {
  -- Let snacks own all UI/notification handling; disable noice
  {
    "folke/noice.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    opts = {
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
    },
  },
}
