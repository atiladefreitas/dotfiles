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
		default_component_configs = {
			git_status = {
				symbols = {
					added = "+",
					modified = "~",
					deleted = "-",
					renamed = "→",
					untracked = "",
					ignored = "/",
					unstaged = "✗",
					staged = "✓",
					conflict = "",
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
				position = "2%",
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
}
