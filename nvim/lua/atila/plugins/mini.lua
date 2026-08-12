-- Standalone mini modules only. `mini.nvim` (the full ~40-module collection)
-- was previously pulled in just for mini.move.
return {
	{
		"nvim-mini/mini.cursorword",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("mini.cursorword").setup({
				delay = 100,
			})
			vim.keymap.set(
				"n",
				"<leader>cE",
				function() require("mini.cursorword").toggle() end,
				{ silent = true, desc = "Toggle cursorword highlight" }
			)
		end,
	},

	{
		"nvim-mini/mini.move",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			mappings = {
				-- Move visual selection in Visual mode
				down = "<a-j>",
				up = "<a-k>",
				-- Move current line in Normal mode
				line_down = "<a-j>",
				line_up = "<a-k>",
			},
			options = {
				reindent_linewise = true,
			},
		},
	},

	{
		"nvim-mini/mini.pairs",
		version = false,
		event = "InsertEnter",
		opts = {
			modes = { insert = true, command = false, terminal = false },

			mappings = {
				["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
				["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
				["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

				[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
				["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
				["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

				['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
				["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
				["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
				["*"] = { action = "closeopen", pair = "**", neigh_pattern = "[^\\].", register = { cr = false } },
			},
		},
	},

	{
		"nvim-mini/mini.surround",
		version = false,
		keys = {
			{ "<leader>sa", mode = { "n", "x" }, desc = "Add surround" },
			{ "<leader>sd", desc = "Delete surround" },
			{ "<leader>sr", desc = "Replace surround" },
			{ "<leader>sf", desc = "Find surround" },
			{ "<leader>sF", desc = "Find surround left" },
			{ "<leader>sh", desc = "Highlight surround" },
			{ "<leader>sn", desc = "Update n lines" },
		},
		config = function()
			-- Default mappings disabled; bound under <leader>s below.
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

			local map = function(mode, lhs, fn, desc)
				vim.keymap.set(mode, lhs, fn, { silent = true, desc = desc })
			end

			map({ "n", "x" }, "<leader>sa", function() MiniSurround.add("visual") end, "Add surround")
			map("n", "<leader>sd", function() MiniSurround.delete() end, "Delete surround")
			map("n", "<leader>sr", function() MiniSurround.replace() end, "Replace surround")
			map("n", "<leader>sf", function() MiniSurround.find() end, "Find surround")
			map("n", "<leader>sF", function() MiniSurround.find_left() end, "Find surround left")
			map("n", "<leader>sh", function() MiniSurround.highlight() end, "Highlight surround")
			map("n", "<leader>sn", function() MiniSurround.update_n_lines() end, "Update n lines")
		end,
	},
}
