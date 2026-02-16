return {
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			render = "background",
			enable_named_colors = true,
			enable_tailwind = true,
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

	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	opts = {
	-- 		options = {
	-- 			mode = "buffers",
	-- 			numbers = function(opts)
	-- 				local letters = { "Q", "W", "E", "A", "S", "D" }
	-- 				return string.format("[%s]", letters[opts.ordinal] or opts.ordinal)
	-- 			end,
	-- 			offsets = {
	-- 				{
	-- 					filetype = "neo-tree",
	-- 					text = "File Explorer",
	-- 					highlight = "Directory",
	-- 					separator = true,
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },

	{
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
			default_component_configs = {
				git_status = {
					symbols = {
						added = "+",
						modified = "~",
						deleted = "-",
						renamed = "→",
						untracked = "",
						ignored = "/",
						unstaged = "✗",
						staged = "✓",
						conflict = "",
					},
				},
			},
			window = {
				position = "float",
				popup = {
					size = {
						height = "98%",
						width = "40%",
					},
					position = "3%",
				},
				mappings = {
					["<Esc>"] = "close_window",
					["h"] = "navigate_up",
					["l"] = "open",
				},
			},
			enable_relative_numbers = true,
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
			require("neo-tree").setup(opts)
			-- Keymaps
			vim.keymap.set(
				"n",
				"<leader>e",
				":Neotree toggle reveal<CR>",
				{ noremap = true, silent = true, desc = "Toggle Neotree" }
			)
			vim.keymap.set(
				"n",
				"<leader><Tab>",
				":Neotree toggle source=buffers reveal<CR>",
				{ noremap = true, silent = true, desc = "Neotree Buffers" }
			)
			vim.keymap.set(
				"n",
				"<leader>gg",
				":Neotree toggle source=git_status<CR>",
				{ noremap = true, silent = true, desc = "Neotree Git Status" }
			)
		end,
	},

	{
		"b0o/incline.nvim",
		enabled = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local devicons = require("nvim-web-devicons")

			require("incline").setup({
				window = {
					placement = {
						horizontal = "right",
						vertical = "top",
					},
				},
				highlight = {
					groups = {
						InclineNormal = { guibg = "#0f1019" },
						InclineNormalNC = { guibg = "#0f1019" },
					},
				},
				hide = {
					only_win = false,
				},
				render = function(props)
					local bufname = vim.api.nvim_buf_get_name(props.buf)
					local filename = vim.fn.fnamemodify(bufname, ":t")
					if filename == "" then
						filename = "[No Name]"
					end

					local ext = vim.fn.fnamemodify(bufname, ":e")
					local icon, icon_color = devicons.get_icon(filename, ext, { default = true })

					local modified = vim.bo[props.buf].modified

					return {
						{ " ", icon, " ", guifg = icon_color },
						{ filename, gui = modified and "bold" or "none" },
						modified and { " [+]", guifg = "#ff9e64" } or "",
						" ",
					}
				end,
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				sections = {
					lualine_c = {
						"filename",
						{
							function()
								return require("nvim-navic").get_location()
							end,
							cond = function()
								return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
							end,
						},
					},
				},
			})
		end,
	},

	{
		"arnamak/stay-centered.nvim",
		config = function()
			require("stay-centered").setup({
				-- The filetype is determined by the vim filetype, not the file extension. In order to get the filetype, open a file and run the command:
				-- :lua print(vim.bo.filetype)
				skip_filetypes = {},
				-- Set to false to disable by default
				enabled = true,
				-- allows scrolling to move the cursor without centering, default recommended
				allow_scroll_move = true,
				-- temporarily disables plugin on left-mouse down, allows natural mouse selection
				-- try disabling if plugin causes lag, function uses vim.on_key
				disable_on_mouse = true,
			})
		end,
	},
	-- {
	--   "sphamba/smear-cursor.nvim",
	--   opts = {
	--     enabled = true,
	--     smear_between_buffers = false,
	--     stiffness = 0.6,
	--     trailing_stiffness = 0.5,
	--     distanc_stop_animation = 0.5
	--   }
	-- }
}
