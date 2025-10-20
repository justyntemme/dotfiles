return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/.config/org/**/*.org",
      org_default_notes_file = "~/.config/org/orgfiles/refile.org",
      mappings = {
        global = {
          -- org_agenda = true,
          org_capture = "gC",
        },
      },
    })
  end,
}
