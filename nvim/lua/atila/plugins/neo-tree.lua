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
				conflict = "!!",
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

vim.api.nvim_create_user_command("ThemeSurfaces", function()
	local p = require("atila.plugins.theme").palette
	local hex = function(group)
		local bg = vim.api.nvim_get_hl(0, { name = group, link = false }).bg
		return bg and ("#%06x"):format(bg) or "-"
	end
	local cursorline, visual = hex("CursorLine"), hex("Visual")
	local sidebar = hex("NeoTreeNormal")
	vim.notify(table.concat({
		"kitty.conf — dim these instead of drawing them opaque:",
		("  transparent_background_colors %s@0.75 %s@0.85 %s@0.85"):format(sidebar, cursorline, visual),
		("  (%s sidebar, %s cursorline, %s selection)"):format(sidebar, cursorline, visual),
	}, "\n"))
end, { desc = "Print the kitty transparent_background_colors line for this palette" })
