-- Luacheck configuration for Neovim config
globals = {
  "vim",
}

-- Ignore unused self arguments (common in Neovim configs)
self = false

-- Set maximum line length
max_line_length = 120

-- Ignore some common warnings in Neovim configs
ignore = {
  "212", -- Unused argument (common with event handlers)
  "213", -- Unused loop variable
}