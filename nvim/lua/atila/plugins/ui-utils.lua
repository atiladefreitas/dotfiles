return {
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			user_default_options = {
				mode = "background",
				tailwind = true,
			},
		},
	},

	{
		"nvzone/showkeys",
		cmd = "ShowkeysToggle",
		opts = {
			timeout = 2,
			maxkeys = 10,
			-- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
			position = "top-center",
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				mode = "buffers",
				numbers = function(opts)
					local letters = { "Q", "W", "E", "A", "S", "D" }
					return string.format("[%s]", letters[opts.ordinal] or opts.ordinal)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						highlight = "Directory",
						separator = true,
					},
				},
			},
		},
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		keys = {
			{ "<leader>e", desc = "Toggle Neotree" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			close_if_last_window = true,
			filesystem = {
				follow_current_file = true,
				filtered_items = {
					visible = true,
				},
			},
			event_handlers = {
				{
					event = "file_open_requested",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			-- Keymaps
			vim.keymap.set(
				"n",
				"<leader>e",
				":Neotree toggle<CR>",
				{ noremap = true, silent = true, desc = "Toggle Neotree" }
			)
		end,
	},

	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		ft = {
			"html",
			"css",
			"scss",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"vue",
			"svelte",
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		---@type TailwindTools.Option
		opts = {
			server = {
				override = false, -- setup the server from the plugin if true
				settings = {}, -- shortcut for `settings.tailwindCSS`
				on_attach = function(client, bufnr) end, -- callback triggered when the server attaches to a buffer
			},
			document_color = {
				enabled = true, -- can be toggled by commands
				kind = "background", -- "inline" | "foreground" | "background"
				inline_symbol = "󰝤 ", -- only used in inline mode
				debounce = 200, -- in milliseconds, only applied in insert mode
			},
			conceal = {
				enabled = false, -- can be toggled by commands
				min_length = nil, -- only conceal classes exceeding the provided length
				symbol = "󱏿", -- only a single character is allowed
				highlight = { -- extmark highlight options, see :h 'highlight'
					fg = "#38BDF8",
				},
			},
			cmp = {
				highlight = "foreground", -- color preview style, "foreground" | "background"
			},
			telescope = {
				utilities = {
					callback = function(name, class) end, -- callback used when selecting an utility class in telescope
				},
			},
			-- see the extension section to learn more
			extension = {
				queries = {}, -- a list of filetypes having custom `class` queries
				patterns = { -- a map of filetypes to Lua pattern lists
					-- example:
					-- rust = { "class=[\"']([^\"']+)[\"']" },
					-- javascript = { "clsx%(([^)]+)%)" },
				},
			},
		}, -- your configuration
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({})
		end,
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
}
