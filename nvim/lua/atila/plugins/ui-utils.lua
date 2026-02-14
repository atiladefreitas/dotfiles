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
						height = "80%",
						width = "40%",
					},
					position = "50%",
				},
				mappings = {
					["<Esc>"] = "close_window",
				},
			},
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
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({})
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
