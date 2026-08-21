-- nvim-treesitter is kept solely for parser management (:TSInstall, :TSUpdate).
-- Neovim 0.12 handles highlighting, indentation, and queries natively; highlighting is
-- started per-filetype in lua/atila/core/options.lua via vim.treesitter.start().
--
-- WHY THIS SETUP:
-- We track the `main` branch (the rewrite), which is a pure parser/query installer:
-- no `nvim-treesitter.configs`, no highlight/indent modules, no `ensure_installed` option.
-- Parsers and queries install into stdpath("data")/site instead of the plugin directory.
-- The old 0.12 directive shims (set-lang-from-info-string!, downcase!, nth?, ...) are gone
-- because the rewrite no longer registers those broken handlers.
--
-- The "main" version pin and the :TSUpdate build hook live in plugins/init.lua,
-- which is where vim.pack is driven from.

local ts = require("nvim-treesitter")

local ensure_installed = {
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
	"scss",
	"lua",
	"json",
	"markdown",
	"markdown_inline",
	"vim",
	"vimdoc",
	"python",
	"jinja",
	"jinja_inline",
}

-- Replaces `ensure_installed`: install() is a no-op for up-to-date parsers,
-- but filtering first keeps startup from queueing work every launch.
local installed = require("nvim-treesitter.config").get_installed("parsers")
local missing = vim.tbl_filter(function(lang)
	return not vim.tbl_contains(installed, lang)
end, ensure_installed)
if #missing > 0 then
	ts.install(missing)
end

-- Replaces `auto_install = true`: pull a parser the first time a filetype is opened.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("atila_ts_auto_install", { clear = true }),
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang or #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0 then
			return
		end
		if vim.tbl_contains(ts.get_available(), lang) then
			pcall(ts.install, { lang })
		end
	end,
})

-- Autotag (works independently of nvim-treesitter)
require("nvim-ts-autotag").setup({})

-- ── Jinja syntax support (jinja.vim) ────────────────────────────────

-- Auto-detect Jinja syntax inside .html files and set filetype to html.jinja.
-- jinja#AdjustFiletype() scans the first five lines for Jinja constructs and
-- appends ".jinja" to 'filetype' only when it finds one, so plain HTML is left
-- as "html" (see core/filetypes.lua, which pins the base type).
--
-- This hangs off FileType, not BufRead. On BufRead 'filetype' is still unset,
-- and AdjustFiletype's `set filetype+=.jinja` would yield a bare ".jinja";
-- upstream's own README example papers over that with an explicit `set
-- ft=html` first, which would clobber any better detection. By FileType the
-- type is already "html" and we only ever append to it.
--
-- Calling the function is also what loads it: this used to be guarded by
-- `exists("*jinja#AdjustFiletype")`, but exists() does not source autoload
-- scripts, so the guard was never true and the call never happened. The
-- runtime-file check below is the honest way to ask "is jinja.vim installed?".
--
-- Re-entry is safe. A compound 'filetype' fires FileType once per component,
-- so setting "html.jinja" re-triggers this very autocmd, but AdjustFiletype
-- returns early as soon as 'filetype' already matches /jinja/.
if #vim.api.nvim_get_runtime_file("autoload/jinja.vim", false) > 0 then
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("atila_jinja_detect", { clear = true }),
		pattern = "html",
		callback = function()
			vim.fn["jinja#AdjustFiletype"]()
		end,
	})
end

-- Enable vim syntax alongside treesitter for jinja filetypes
-- so that jinja.vim highlighting works with treesitter HTML
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html.jinja", "jinja" },
	callback = function()
		vim.opt_local.syntax = "on"
	end,
})
