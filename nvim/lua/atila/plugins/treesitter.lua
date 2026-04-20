return {
	-- nvim-treesitter is kept solely for parser management (:TSInstall, :TSUpdate).
	-- Neovim 0.12 handles highlighting, indentation, and queries natively.
	--
	-- WHY THIS SETUP:
	-- nvim-treesitter's query_predicates.lua registers custom directives (set-lang-from-info-string!,
	-- set-lang-from-mimetype!, downcase!) that are incompatible with Neovim 0.12's query API where
	-- match[capture_id] returns TSNode[] instead of a single TSNode. This causes:
	--   "attempt to call method 'range' (a nil value)"
	-- We preload a shim that replaces the broken directives with 0.12-compatible versions, and
	-- delete nvim-treesitter's query files so the built-in runtime queries (which don't use
	-- these custom directives) take precedence.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		priority = 900,
		init = function()
			-- Preload a shim module BEFORE nvim-treesitter loads.
			-- When nvim-treesitter does `require "nvim-treesitter.query_predicates"`,
			-- it will register broken directive handlers. We fix them right after.
		end,
		config = function()
			-- Load nvim-treesitter for parser management
			require("nvim-treesitter.configs").setup({
				highlight = { enable = false }, -- native Neovim 0.12
				indent = { enable = false }, -- native Neovim 0.12
				ensure_installed = {
					"javascript", "typescript", "tsx",
					"html", "css", "scss",
					"lua", "json", "markdown", "markdown_inline",
					"vim", "vimdoc", "python",
					"jinja", "jinja_inline",
				},
				modules = {},
				sync_install = false,
				ignore_install = {},
				auto_install = true,
			})

			-- FIX: Override the broken custom directives registered by nvim-treesitter's
			-- query_predicates.lua. In Neovim 0.12, match[capture_id] returns TSNode[] (a list)
			-- instead of a single TSNode. The original handlers pass the list directly to
			-- vim.treesitter.get_node_text() which calls node:range() on the list and crashes.
			local query = require("vim.treesitter.query")

			query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local capture_id = pred[2]
				local nodes = match[capture_id]
				if not nodes then
					return
				end
				-- Handle both old (single node) and new (list of nodes) API
				local node = type(nodes) == "table" and nodes[1] or nodes
				if not node then
					return
				end
				local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
				if not ok or not text then
					return
				end
				local injection_alias = text:lower()
				-- Try filetype match first, then use the alias directly
				local lang = vim.filetype.match({ filename = "a." .. injection_alias })
				metadata["injection.language"] = lang or injection_alias
			end, { force = true })

			query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
				local capture_id = pred[2]
				local nodes = match[capture_id]
				if not nodes then
					return
				end
				local node = type(nodes) == "table" and nodes[1] or nodes
				if not node then
					return
				end
				local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
				if not ok or not text then
					return
				end
				local html_script_type_languages = {
					["importmap"] = "json",
					["module"] = "javascript",
					["application/ecmascript"] = "javascript",
					["text/ecmascript"] = "javascript",
				}
				local configured = html_script_type_languages[text]
				if configured then
					metadata["injection.language"] = configured
				else
					local parts = vim.split(text, "/", {})
					metadata["injection.language"] = parts[#parts]
				end
			end, { force = true })

			query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
				local id = pred[2]
				local nodes = match[id]
				if not nodes then
					return
				end
				local node = type(nodes) == "table" and nodes[1] or nodes
				if not node then
					return
				end
				local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr, { metadata = metadata[id] })
				if not ok then
					return
				end
				text = text or ""
				if not metadata[id] then
					metadata[id] = {}
				end
				metadata[id].text = string.lower(text)
			end, { force = true })

			-- Also fix the custom predicates (nth?, is?, kind-eq?) used in indent/highlight queries
			local function unwrap_node(nodes)
				if not nodes then
					return nil
				end
				return type(nodes) == "table" and nodes[1] or nodes
			end

			query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
				local node = unwrap_node(match[pred[2]])
				local n = tonumber(pred[3])
				if node and node:parent() and node:parent():named_child_count() > n then
					return node:parent():named_child(n) == node
				end
				return false
			end, { force = true })

			query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
				local node = unwrap_node(match[pred[2]])
				local types = { unpack(pred, 3) }
				if not node then
					return true
				end
				return vim.tbl_contains(types, node:type())
			end, { force = true })
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
