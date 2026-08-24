-- Tracks the v3.x branch (see the version pin in plugins/init.lua).
local opts = {
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	enable_relative_numbers = true,
	sort_case_insensitive = true,
	source_selector = {
		winbar = true,
		statusline = false,
		content_layout = "center",
		tabs_layout = "equal",
		separator = "",
		highlight_tab = "NeoTreeTabInactive",
		highlight_tab_active = "NeoTreeTabActive",
		highlight_background = "NeoTreeTabInactive",
		highlight_separator = "NeoTreeTabSeparatorInactive",
		highlight_separator_active = "NeoTreeTabSeparatorActive",
		sources = {
			{ source = "filesystem", display_name = " Files" },
			{ source = "buffers", display_name = " Buffers" },
			{ source = "git_status", display_name = " Git" },
		},
	},
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		modified = {
			symbol = "",
			highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = false,
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
		git_status = {
			symbols = {
				added = "+",
				modified = "~",
				deleted = "-",
				renamed = "→",
				untracked = "",
				ignored = "/",
				unstaged = "x",
				staged = "✓",
				conflict = "",
			},
		},
		diagnostics = {
			symbols = {
				hint = "",
				info = "",
				warn = "",
				error = "",
			},
			highlights = {
				hint = "DiagnosticSignHint",
				info = "DiagnosticSignInfo",
				warn = "DiagnosticSignWarn",
				error = "DiagnosticSignError",
			},
		},
	},
	window = {
		position = "left",
		width = 55,
		mappings = {
			["<Esc>"] = "close_window",
			["h"] = "navigate_up",
			["l"] = "open",
			["s"] = "open_split",
			["v"] = "open_vsplit",
			["<Tab>"] = "next_source",
			["<S-Tab>"] = "prev_source",
		},
	},
	filesystem = {
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
		group_empty_dirs = true,
		-- Keep node_modules browsable in the tree, but out of "/" fuzzy search results.
		find_args = {
			fd = {
				"--exclude",
				"node_modules",
			},
		},
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			never_show = {
				-- "node_modules",
				-- ".git",
				".DS_Store",
				"thumbs.db",
			},
		},
	},
	buffers = {
		follow_current_file = { enabled = true },
		group_empty_dirs = true,
		show_unloaded = true,
	},
	git_status = {},
	event_handlers = {
		{
			event = "file_open_requested",
			handler = function()
				require("neo-tree.command").execute({ action = "close" })
			end,
		},
		{
			event = "neo_tree_window_after_open",
			handler = function(args)
				vim.wo[args.winid].number = true
				vim.wo[args.winid].relativenumber = true
			end,
		},
	},
}

-- Neo-tree's own groups, derived from the active colorscheme and
-- repainted whenever it changes (see plugins/theme.lua).
require("atila.plugins.theme").on_change("neo-tree", function(p)
	local groups = {
		-- The sidebar is the deepest surface on screen, so the tree reads as
		-- a shelf beside the page rather than another window of it.
		NeoTreeNormal = { bg = p.bg_deep, fg = p.fg },
		NeoTreeNormalNC = { bg = p.bg_deep, fg = p.fg },
		NeoTreeEndOfBuffer = { bg = p.bg_deep, fg = p.bg_deep },
		NeoTreeWinSeparator = { bg = p.bg_deep, fg = p.bg_deep },
		NeoTreeFloatBorder = { bg = p.bg_deep, fg = p.bg_deep },
		NeoTreeFloatTitle = { bg = p.blue, fg = p.on_accent, bold = true },
		NeoTreeTitleBar = { bg = p.blue, fg = p.on_accent, bold = true },
		NeoTreeCursorLine = { bg = p.bg_highlight },
		NeoTreeDirectoryName = { fg = p.blue },
		NeoTreeDirectoryIcon = { fg = p.blue },
		NeoTreeRootName = { fg = p.blue, bold = true, italic = true },
		NeoTreeFileName = { fg = p.fg },
		NeoTreeFileIcon = { fg = p.fg_dark },
		NeoTreeIndentMarker = { fg = require("atila.plugins.theme").blend(p.fg_dark, p.bg, 0.5) },
		NeoTreeExpander = { fg = p.fg_dark },
		NeoTreeGitAdded = { fg = p.git_add },
		NeoTreeGitModified = { fg = p.git_change },
		NeoTreeGitDeleted = { fg = p.git_delete },
		NeoTreeGitConflict = { fg = p.red, bold = true },
		NeoTreeGitUntracked = { fg = p.purple },
		NeoTreeGitIgnored = { fg = p.fg_dark },
		NeoTreeGitStaged = { fg = p.git_add },
		NeoTreeGitUnstaged = { fg = p.git_change },
		NeoTreeModified = { fg = p.git_change },
		NeoTreeTabActive = { bg = p.bg_deep, fg = p.blue, bold = true },
		NeoTreeTabInactive = { bg = p.bg_deep, fg = p.fg_dark },
		NeoTreeTabSeparatorActive = { bg = p.bg_deep, fg = p.bg_deep },
		NeoTreeTabSeparatorInactive = { bg = p.bg_deep, fg = p.bg_deep },
	}
	for group, spec in pairs(groups) do
		vim.api.nvim_set_hl(0, group, spec)
	end
end)

require("neo-tree").setup(opts)

-- keymaps
vim.keymap.set(
	"n",
	"<leader>e",
	":Neotree toggle reveal<CR>",
	{ noremap = true, silent = true, desc = "Toggle Neotree" }
)
vim.keymap.set(
	"n",
	"<leader><Tab>",
	":Neotree focus source=buffers reveal<CR>",
	{ noremap = true, silent = true, desc = "Neotree Buffers" }
)
vim.keymap.set(
	"n",
	"<leader>gg",
	":Neotree toggle source=git_status<CR>",
	{ noremap = true, silent = true, desc = "Neotree Git Status" }
)
