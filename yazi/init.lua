-- Show image dimensions in the status bar
require("image-size"):setup()

-- full-border: draw a border around the whole UI
require("full-border"):setup({
  type = ui.Border.ROUNDED,
})

-- bookmarks: save/jump to favorite directories
require("bookmarks"):setup({
  last_directory = { enable = false, persist = false },
  persist = "all",
  desc_format = "full",
  file_pick_mode = "hover",
})

-- yatline: configurable header/statusline
local theme = require("yatline"):setup({
  show_background = false,

  header_line = {
    left = {
      section_a = { { type = "line", custom = false, name = "tabs", params = { "left" } } },
      section_b = {},
      section_c = {},
    },
    right = {
      section_a = { { type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } } },
      section_b = { { type = "string", custom = false, name = "date", params = { "%X" } } },
      section_c = {},
    },
  },

  status_line = {
    left = {
      section_a = { { type = "string", custom = false, name = "tab_mode" } },
      section_b = { { type = "string", custom = false, name = "hovered_size" } },
      section_c = {
        { type = "string",   custom = false, name = "hovered_path" },
        { type = "coloreds", custom = false, name = "count" },
      },
    },
    right = {
      section_a = { { type = "string", custom = false, name = "cursor_position" } },
      section_b = { { type = "string", custom = false, name = "cursor_percentage" } },
      section_c = {
        { type = "string",   custom = false, name = "hovered_file_extension", params = { true } },
        { type = "coloreds", custom = false, name = "permissions" },
      },
    },
  },
})
