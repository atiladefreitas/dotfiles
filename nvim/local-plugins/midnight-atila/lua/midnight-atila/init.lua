-- midnight-atila colorscheme
-- A personal blend of Tokyo Night, Dracula, and Catppuccin
-- Author: Atila de Freitas

local M = {}

---@class MidnightAtilaOptions
---@field transparent boolean  Disable background colors (default: false)
---@field italic_comments boolean  Italicize comments (default: true)
---@field italic_keywords boolean  Italicize keywords (default: true)
---@field terminal_colors boolean  Set ANSI terminal colors (default: true)

---@type MidnightAtilaOptions
M.options = {
  transparent = false,
  italic_comments = true,
  italic_keywords = true,
  terminal_colors = true,
}

---@param opts MidnightAtilaOptions|nil
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

local function set_terminal_colors(c)
  vim.g.terminal_color_0  = c.term.black
  vim.g.terminal_color_1  = c.term.red
  vim.g.terminal_color_2  = c.term.green
  vim.g.terminal_color_3  = c.term.yellow
  vim.g.terminal_color_4  = c.term.blue
  vim.g.terminal_color_5  = c.term.magenta
  vim.g.terminal_color_6  = c.term.cyan
  vim.g.terminal_color_7  = c.term.white
  vim.g.terminal_color_8  = c.term.bright_black
  vim.g.terminal_color_9  = c.term.bright_red
  vim.g.terminal_color_10 = c.term.bright_green
  vim.g.terminal_color_11 = c.term.bright_yellow
  vim.g.terminal_color_12 = c.term.bright_blue
  vim.g.terminal_color_13 = c.term.bright_magenta
  vim.g.terminal_color_14 = c.term.bright_cyan
  vim.g.terminal_color_15 = c.term.bright_white
end

---Apply the colorscheme
function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "midnight-atila"

  local palette = require("midnight-atila.palette")
  local c = palette.colors
  local opts = M.options

  -- Aggregate all highlight groups
  local groups = {}
  local sources = {
    require("midnight-atila.groups.editor").get(c, opts),
    require("midnight-atila.groups.syntax").get(c, opts),
    require("midnight-atila.groups.lsp").get(c, opts),
    require("midnight-atila.groups.plugins").get(c, opts),
  }

  for _, src in ipairs(sources) do
    for name, def in pairs(src) do
      groups[name] = def
    end
  end

  -- Apply highlights
  for name, def in pairs(groups) do
    vim.api.nvim_set_hl(0, name, def)
  end

  -- Terminal ANSI colors
  if opts.terminal_colors then
    set_terminal_colors(c)
  end
end

---Toggle transparency at runtime
function M.toggle_transparent()
  M.options.transparent = not M.options.transparent
  M.load()
  vim.notify(
    "midnight-atila: transparent = " .. tostring(M.options.transparent),
    vim.log.levels.INFO
  )
end

-- User command for transparency toggle
vim.api.nvim_create_user_command("MidnightAtilaToggleTransparent", function()
  M.toggle_transparent()
end, { desc = "Toggle midnight-atila transparency" })

return M
