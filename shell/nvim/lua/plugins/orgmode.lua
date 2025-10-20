return {
  "nvim-orgmode/orgmode",
  dependencies = {
    "danilshvalov/org-modern.nvim",
  },
  event = "VeryLazy",
  config = function()
    local Menu = require("org-modern.menu")

    require("orgmode").setup({
      org_agenda_files = "~/.config/org/**/*.org",
      org_default_notes_file = "~/.config/org/orgfiles/refile.org",
      ui = {
        menu = {
          handler = function(data)
            Menu:new({
              window = {
                margin = { 1, 0, 1, 0 },
                padding = { 0, 1, 0, 1 },
                title_pos = "center",
                border = "single",
                zindex = 1000,
              },
              icons = {
                separator = "➜",
              },
            }):open(data)
          end,
        },
      },
      mappings = {
        global = {
          -- org_agenda = true,
          --org_capture = "gc",
        },
      },
    })
  end,
}
