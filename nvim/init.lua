-- Stamped before anything else so the dashboard can report load time.
-- Replaces lazy.nvim's `lazy.stats`; see lua/atila/plugins/util.lua.
vim.g.atila_start = vim.uv.hrtime()

require("atila.core")
require("atila.plugins")
