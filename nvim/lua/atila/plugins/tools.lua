return {
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({})
			vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
			vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
			vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
			vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})
		end,
	},
	{
		"sindrets/diffview.nvim",
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				-- Choose a preset style for diagnostic appearance
				-- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
				preset = "powerline",

				-- Make diagnostic background transparent
				transparent_bg = false,

				-- Make cursorline background transparent for diagnostics
				transparent_cursorline = true,

				-- Customize highlight groups for colors
				-- Use Neovim highlight group names or hex colors like "#RRGGBB"
				hi = {
					error = "DiagnosticError", -- Highlight for error diagnostics
					warn = "DiagnosticWarn", -- Highlight for warning diagnostics
					info = "DiagnosticInfo", -- Highlight for info diagnostics
					hint = "DiagnosticHint", -- Highlight for hint diagnostics
					arrow = "NonText", -- Highlight for the arrow pointing to diagnostic
					background = "CursorLine", -- Background highlight for diagnostics
					mixing_color = "Normal", -- Color to blend background with (or "None")
				},

				-- List of filetypes to disable the plugin for
				disabled_ft = {},

				options = {
					-- Display the source of diagnostics (e.g., "lua_ls", "pyright")
					show_source = {
						enabled = false, -- Enable showing source names
						if_many = false, -- Only show source if multiple sources exist for the same diagnostic
					},

					-- Use icons from vim.diagnostic.config instead of preset icons
					use_icons_from_diagnostic = false,

					-- Color the arrow to match the severity of the first diagnostic
					set_arrow_to_diag_color = false,

					-- Throttle update frequency in milliseconds to improve performance
					-- Higher values reduce CPU usage but may feel less responsive
					-- Set to 0 for immediate updates (may cause lag on slow systems)
					throttle = 20,

					-- Minimum number of characters before wrapping long messages
					softwrap = 30,

					-- Control how diagnostic messages are displayed
					-- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
					--       If you want them to always be displayed, you can also set multilines.always_show = true.
					add_messages = {
						messages = true, -- Show full diagnostic messages
						display_count = true, -- Show diagnostic count instead of messages when cursor not on line
						use_max_severity = false, -- When counting, only show the most severe diagnostic
						show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
					},

					-- Settings for multiline diagnostics
					multilines = {
						enabled = true, -- Enable support for multiline diagnostic messages
						always_show = false, -- Always show messages on all lines of multiline diagnostics
						trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
						tabstop = 4, -- Number of spaces per tab when expanding tabs
						severity = nil, -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
					},

					-- Show all diagnostics on the current cursor line, not just those under the cursor
					show_all_diags_on_cursorline = false,

					-- Display related diagnostics from LSP relatedInformation
					show_related = {
						enabled = true, -- Enable displaying related diagnostics
						max_count = 3, -- Maximum number of related diagnostics to show per diagnostic
					},

					-- Enable diagnostics display in insert mode
					-- May cause visual artifacts; consider setting throttle to 0 if enabled
					enable_on_insert = false,

					-- Enable diagnostics display in select mode (e.g., during auto-completion)
					enable_on_select = false,

					-- Handle messages that exceed the window width
					overflow = {
						mode = "wrap", -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
						padding = 0, -- Extra characters to trigger wrapping earlier
					},

					-- Break long messages into separate lines
					break_line = {
						enabled = false, -- Enable automatic line breaking
						after = 30, -- Number of characters before inserting a line break
					},

					-- Custom function to format diagnostic messages
					-- Receives diagnostic object, returns formatted string
					-- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
					format = nil,

					-- Virtual text display priority
					-- Higher values appear above other plugins (e.g., GitBlame)
					virt_texts = {
						priority = 2048,
					},

					-- Filter diagnostics by severity levels
					-- Remove severities you don't want to display
					severity = {
						vim.diagnostic.severity.ERROR,
						vim.diagnostic.severity.WARN,
						vim.diagnostic.severity.INFO,
						vim.diagnostic.severity.HINT,
					},

					-- Events that trigger attaching diagnostics to buffers
					-- Default is {"LspAttach"}; change only if plugin doesn't work with your LSP setup
					overwrite_events = nil,

					-- Automatically disable diagnostics when opening diagnostic float windows
					override_open_float = false,
				},
			})
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "0"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set("n", "zR", require("ufo").openAllFolds, {})
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, {})
			vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
			vim.keymap.set("n", "zK", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, {})

			require("ufo").setup({
				close_fold_kinds_for_ft = {
					default = { "imports", "comment" },
					json = { "array" },
					c = { "comment", "region" },
				},
				open_fold_hl_timeout = 0,
				fold_virt_text_handler = function(_, lnum, end_lnum, _, _)
					local _start = lnum - 1
					local _end = end_lnum - 1
					local start_text = vim.api.nvim_buf_get_text(0, _start, 0, _start, -1, {})[1]
					local final_text = vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
					return start_text .. " ⋯ " .. final_text .. (" 󰁂 %d "):format(end_lnum - lnum)
				end,
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			-- Setup nvim-ts-autotag
			require("nvim-ts-autotag").setup()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")
			-- configure treesitter
			treesitter.setup({
				-- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				-- ensure these language parsers are installed
				ensure_installed = {
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
					"vimdoc",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				-- Add the missing fields
				modules = {},
				sync_install = false,
				ignore_install = {},
				auto_install = true,
			})
		end,
	},
	{

		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
		keys = {
			{ "<leader><CR>", desc = "Resume previous search" },
			{ "<leader>f'", desc = "Marks" },
			{ "<leader>fb", desc = "Buffers" },
			{ "<leader>fc", desc = "Word at cursor" },
			{ "<leader>fC", desc = "Commands" },
			{ "<leader>ff", desc = "Find files" },
			{ "<leader>fF", desc = "Find files (include hidden)" },
			{ "<leader>fh", desc = "Help Tags" },
			{ "<leader>fk", desc = "Keymaps" },
			{ "<leader>fm", desc = "Man Pages" },
			{ "<leader>fn", desc = "Notifications" },
			{ "<leader>fo", desc = "Old Files" },
			{ "<leader>fr", desc = "Registers" },
			{ "<leader>ft", desc = "Colorschemes" },
			{ "<leader>fw", desc = "Live Grep" },
			{ "<space>fB", desc = "File Browser" },
			{ "<leader>fW", desc = "Live Grep (include hidden)" },
			{ "<leader>ls", desc = "LSP Symbols" },
			{ "<leader>lG", desc = "LSP Workspace Symbols" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"andrew-george/telescope-themes",
			"nvim-telescope/telescope-file-browser.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local transform_mod = require("telescope.actions.mt").transform_mod

			telescope.load_extension("themes")

			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"%.md",
					},
					path_display = { "smart" },
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					sorting_strategy = "descending",

					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- move to prev result
							["<C-j>"] = actions.move_selection_next, -- move to next result
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-s>"] = actions.select_vertical,
						},
					},
				},
				pickers = {
					find_files = {
						file_sorter = require("telescope.sorters").get_fuzzy_file,
					},
				},
				extensions = {
					file_browser = {
						path = "%:p:h",
						cwd = vim.loop.cwd(),
						cwd_to_path = false,
						grouped = false,
						files = true,
						add_dirs = true,
						depth = 1,
						auto_depth = false,
						select_buffer = false,
						hidden = { file_browser = false, folder_browser = false },
						respect_gitignore = vim.fn.executable("fd") == 1,
						no_ignore = false,
						follow_symlinks = false,
						browse_files = require("telescope._extensions.file_browser.finders").browse_files,
						browse_folders = require("telescope._extensions.file_browser.finders").browse_folders,
						hide_parent_dir = false,
						collapse_dirs = false,
						prompt_path = false,
						quiet = false,
						dir_icon = "",
						dir_icon_hl = "Default",
						display_stat = { date = false, size = true, mode = false },
						hijack_netrw = false,
						use_fd = true,
						git_status = true,
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")

			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set("n", "<leader><CR>", "<cmd>Telescope resume<cr>", { desc = "Resume previous search" })
			keymap.set("n", "<leader>f'", "<cmd>Telescope marks<cr>", { desc = "Marks" })
			keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
			keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Word at cursor" })
			keymap.set("n", "<leader>fC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
			keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
			keymap.set(
				"n",
				"<leader>fF",
				"<cmd>Telescope find_files hidden=true<cr>",
				{ desc = "Find files (include hidden files)" }
			)
			keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
			keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
			keymap.set("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
			keymap.set("n", "<leader>fn", "<cmd>Telescope notifications<cr>", { desc = "Notifications" })
			keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Old Files" })
			keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
			keymap.set("n", "<leader>ft", "<cmd>Telescope colorscheme<cr>", { desc = "Colorschemes" })
			keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
			keymap.set("n", "<space>fB", ":Telescope file_browser<CR>")
			keymap.set(
				"n",
				"<leader>fW",
				"<cmd>Telescope live_grep hidden=true<cr>",
				{ desc = "Live Grep (include hidden files)" }
			)
			keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "LSP Symbols" })
			keymap.set(
				"n",
				"<leader>lG",
				"<cmd>Telescope lsp_workspace_symbols<cr>",
				{ desc = "LSP Workspace Symbols" }
			)
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		keys = {
			{ "<leader>Sr", desc = "Open Spectre" },
			{ "<leader>Sw", desc = "Search current word", mode = { "n", "v" } },
			{ "<leader>Sp", desc = "Search in current file" },
		},
		config = function()
			require("spectre").setup({
				-- Add any desired configuration options here
			})

			-- Keymaps for nvim-spectre
			vim.api.nvim_set_keymap(
				"n",
				"<leader>Sr",
				":lua require('spectre').open()<CR>",
				{ noremap = true, silent = true, desc = "Open Spectre" }
			)

			vim.api.nvim_set_keymap(
				"n",
				"<leader>Sw",
				":lua require('spectre').open_visual({select_word=true})<CR>",
				{ noremap = true, silent = true, desc = "Search current word" }
			)

			vim.api.nvim_set_keymap(
				"v",
				"<leader>Sw",
				":lua require('spectre').open_visual()<CR>",
				{ noremap = true, silent = true, desc = "Search visually selected" }
			)

			vim.api.nvim_set_keymap(
				"n",
				"<leader>Sp",
				":lua require('spectre').open_file_search()<CR>",
				{ noremap = true, silent = true, desc = "Search in current file" }
			)
		end,
	},
}
