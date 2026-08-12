return {
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
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		priority = 900,
		config = function()
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
		end,
	},

	-- Autotag (works independently of nvim-treesitter)
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},

	-- Jinja syntax support
	{
		"HiPhish/jinja.vim",
		init = function()
			-- Auto-detect Jinja syntax inside .html files and set filetype to html.jinja
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = "*.html",
				callback = function()
					if vim.fn.exists("*jinja#AdjustFiletype") == 1 then
						vim.fn["jinja#AdjustFiletype"]()
					end
				end,
			})

			-- Enable vim syntax alongside treesitter for jinja filetypes
			-- so that jinja.vim highlighting works with treesitter HTML
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "html.jinja", "jinja" },
				callback = function()
					vim.opt_local.syntax = "on"
				end,
			})
		end,
	},
}
