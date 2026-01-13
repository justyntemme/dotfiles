return {
  "mistweaverco/kulala.nvim",
  keys = {
    { "<leader>Rs", desc = "Send request" },
    { "<leader>Ra", desc = "Send all requests" },
    { "<leader>Rb", desc = "Open scratchpad" },
  },
  ft = { "http", "rest" },
  opts = function(_, opts)
    opts.global_keymaps = true
    opts.global_keymaps_prefix = "<leader>R"
    opts.kulala_keymaps_prefix = ""
    opts.ui = opts.ui or {}
    opts.ui.max_response_size = 100005536
    return opts
  end,
}
