-- Lualine theme for midnight-atila
local M = {}

function M.theme()
  local p = require("midnight-atila.palette").colors

  return {
    normal = {
      a = { fg = p.bg, bg = p.blue_bright, gui = "bold" },
      b = { fg = p.blue_bright, bg = p.bg_statusline },
      c = { fg = p.fg_dim, bg = p.bg_statusline },
    },
    insert = {
      a = { fg = p.bg, bg = p.green_bright, gui = "bold" },
      b = { fg = p.green_bright, bg = p.bg_statusline },
      c = { fg = p.fg_dim, bg = p.bg_statusline },
    },
    visual = {
      a = { fg = p.bg, bg = p.purple, gui = "bold" },
      b = { fg = p.purple, bg = p.bg_statusline },
      c = { fg = p.fg_dim, bg = p.bg_statusline },
    },
    replace = {
      a = { fg = p.bg, bg = p.red, gui = "bold" },
      b = { fg = p.red, bg = p.bg_statusline },
      c = { fg = p.fg_dim, bg = p.bg_statusline },
    },
    command = {
      a = { fg = p.bg, bg = p.yellow, gui = "bold" },
      b = { fg = p.yellow, bg = p.bg_statusline },
      c = { fg = p.fg_dim, bg = p.bg_statusline },
    },
    terminal = {
      a = { fg = p.bg, bg = p.cyan, gui = "bold" },
      b = { fg = p.cyan, bg = p.bg_statusline },
      c = { fg = p.fg_dim, bg = p.bg_statusline },
    },
    inactive = {
      a = { fg = p.fg_dark, bg = p.bg_statusline, gui = "bold" },
      b = { fg = p.fg_dark, bg = p.bg_statusline },
      c = { fg = p.fg_dark, bg = p.bg_statusline },
    },
  }
end

return M
