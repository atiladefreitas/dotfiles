return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	keys = {
		{ "<leader>e", desc = "Toggle Neotree" },
		{ "<leader><Tab>", desc = "Neotree Buffers" },
		{ "<leader>gg", desc = "Neotree Git Status" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
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
			position = "float",
			popup = {
				size = {
					height = "90%",
					width = "30%",
				},
				position = {
					row = "50%",
					col = "2%",
				},
			},
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
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				never_show = {
					"node_modules",
					".git",
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
		git_status = {
			window = {
				position = "float",
			},
		},
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
	},
	config = function(_, opts)
		-- tokyonight-inspired highlights for neo-tree
		local bg = "#0f1019"
		local bg_dark = "#0a0b11"
		local bg_highlight = "#1a1d29"
		local blue = "#7aa2f7"
		local cyan = "#7dcfff"
		local green = "#9ece6a"
		local red = "#ff5370"
		local purple = "#bb9af7"
		local orange = "#ff9e64"
		local fg = "#c0caf5"
		local fg_dark = "#565f89"

		vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = bg, fg = fg })
		vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = bg, fg = fg })
		vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { bg = bg, fg = bg })
		vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { bg = blue, fg = bg_dark, bold = true })
		vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { bg = blue, fg = bg_dark, bold = true })
		vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = bg_highlight })
		vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = blue })
		vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = blue })
		vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = blue, bold = true, italic = true })
		vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = fg })
		vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = fg_dark })
		vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#2a2d3d" })
		vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = fg_dark })
		vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = green })
		vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = orange })
		vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = red })
		vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = red, bold = true })
		vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = purple })
		vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = fg_dark })
		vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = green })
		vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = orange })
		vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = orange })
		vim.api.nvim_set_hl(0, "NeoTreeTabActive", { bg = bg, fg = blue, bold = true })
		vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { bg = bg_dark, fg = fg_dark })
		vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", { bg = bg, fg = bg })
		vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", { bg = bg_dark, fg = bg_dark })

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
	end,
}
