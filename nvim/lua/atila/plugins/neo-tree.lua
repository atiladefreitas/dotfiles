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
		-- The one panel that keeps a background when everything else goes
		-- transparent: a file tree is a fixed shelf beside the page, and
		-- reading it against a moving wallpaper is the part that actually
		-- hurts. Deliberately NOT routed through theme.surface().
		--
		-- Terminal cells with an explicit background are drawn opaque, so
		-- this is a solid slab by default. To get it dimmed rather than
		-- solid, kitty can single out this exact color — see the note at
		-- the bottom of this file.
		NeoTreeNormal = { bg = p.bg_deep, fg = p.fg },
		NeoTreeNormalNC = { bg = p.bg_deep, fg = p.fg },
		NeoTreeEndOfBuffer = { bg = p.bg_deep, fg = p.bg_deep },
		NeoTreeWinSeparator = { bg = p.bg_deep, fg = p.bg_deep },
		NeoTreeFloatBorder = { bg = p.bg_deep, fg = p.bg_deep },
		NeoTreeFloatTitle = { bg = p.blue, fg = p.on_accent, bold = true },
		NeoTreeTitleBar = { bg = p.blue, fg = p.on_accent, bold = true },
		NeoTreeCursorLine = { bg = p.bg_highlight },
		-- `directory`, not `blue`: gruvbox has no blue among its syntax
		-- groups, so theme.lua mints one, and a minted accent has no
		-- business on the thing the tree is mostly made of. This follows
		-- the scheme's own Directory group instead.
		NeoTreeDirectoryName = { fg = p.directory },
		NeoTreeDirectoryIcon = { fg = p.directory },
		NeoTreeRootName = { fg = p.directory, bold = true, italic = true },
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
		NeoTreeTabActive = { bg = p.bg_deep, fg = p.directory, bold = true },
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

-- ── Dimming the sidebar instead of blacking it out ──────────────────
-- kitty renders a cell opaque as soon as its background differs from the
-- default one, which is why the tree above comes out as a solid slab while
-- the rest of the editor shows the wallpaper. kitty >= 0.35 can exempt
-- specific colors (`transparent_background_colors`, up to 7, each with its
-- own opacity), so the sidebar can be a dim panel rather than a black one.
--
-- In kitty.conf, alongside `background_opacity`:
--
--     transparent_background_colors #0b0c0d@0.75
--
-- That color is `bg_deep` for the current scheme and page — it moves if
-- either changes. :ThemeSurfaces prints the line to paste.
vim.api.nvim_create_user_command("ThemeSurfaces", function()
	local p = require("atila.plugins.theme").palette
	vim.notify(table.concat({
		"kitty.conf — dim these instead of drawing them opaque:",
		("  transparent_background_colors %s@0.75 %s@0.85"):format(p.bg_deep, p.bg_highlight),
		("  (%s = sidebar, %s = cursorline)"):format(p.bg_deep, p.bg_highlight),
	}, "\n"))
end, { desc = "Print the kitty transparent_background_colors line for this palette" })
