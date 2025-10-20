return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/.config/org/orgfiles/**/*",
      org_default_notes_file = "~/.config/org/orgfiles/refile.org",
    })
  end,
}
