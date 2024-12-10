return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		-- MiniSurround setup
		require("mini.surround").setup({
			mappings = {
				add = "",
				delete = "",
				find = "",
				find_left = "",
				highlight = "",
				replace = "",
				update_n_lines = "",
			},
		})

		-- MiniMove setup
		require("mini.move").setup({
			mappings = {
				down = "<C-j>",
				up = "<C-k>",
				line_down = "<C-j>",
				line_up = "<C-k>",
			},
			options = {
				reindent_linewise = true,
			},
		})

		-- MiniFiles setup
		require("mini.files").setup({
			windows = {
				preview = true,
				width_preview = 40,
			},
		})

		-- MiniCursorWord setup
		require("mini.cursorword").setup({
			delay = 100,
		})

		-- MiniComment setup
		require("mini.comment").setup({
			mappings = {
				comment = "<leader>/", -- Normal and Visual mode toggle
				comment_line = "<leader>/", -- Line toggle
				textobject = "", -- Disable textobject mapping
			},
		})
	end,
	keys = {
		-- Keymaps for MiniSurround
		{ "<leader>sa", ":lua MiniSurround.add('visual')<CR>", mode = { "n", "x" } },
		{ "<leader>sd", ":lua MiniSurround.delete()<CR>", mode = "n" },
		{ "<leader>sr", ":lua MiniSurround.replace()<CR>", mode = "n" },
		{ "<leader>sf", ":lua MiniSurround.find()<CR>", mode = "n" },
		{ "<leader>sF", ":lua MiniSurround.find_left()<CR>", mode = "n" },
		{ "<leader>sh", ":lua MiniSurround.highlight()<CR>", mode = "n" },
		{ "<leader>sn", ":lua MiniSurround.update_n_lines()<CR>", mode = "n" },

		-- Keymaps for MiniFiles
		{ "<leader>mf", ":lua require('mini.files').open()<CR>", desc = "Open mini.files", mode = "n" },
		{
			"<leader>md",
			":lua require('mini.files').open(vim.fn.expand('%:p:h'))<CR>",
			desc = "Open mini.files in file directory",
			mode = "n",
		},

		-- Keymaps for MiniCursorWord
		{
			"<leader>cE",
			":lua require('mini.cursorword').toggle()<CR>",
			desc = "Toggle cursorword highlight",
			mode = "n",
		},

		-- Keymaps for MiniComment
		{ "<leader>/", ":lua MiniComment.toggle_lines()<CR>", desc = "Toggle comment", mode = { "n", "x" } },
	},
}
