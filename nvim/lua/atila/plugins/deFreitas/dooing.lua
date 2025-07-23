return {
  -- beautiful to-do item manager
  {
    -- "atiladefreitas/dooing",
    dir = "~/Documents/dooing",
    config = function()
      require("dooing").setup({
        prioritization = true,
        show_entered_date = true,
        window = {
          width = 80,
        },
    per_project = {
        enabled = true,                        -- Enable per-project todos
        default_filename = "dooing.json",      -- Default filename for project todos
        auto_gitignore = true,                -- Auto-add to .gitignore (true/false/"prompt")
        on_missing = "prompt",                 -- What to do when file missing ("prompt"/"auto_create")
    },
        calendar = {
          icon = "",
        },
      })
    end,
  },
}
