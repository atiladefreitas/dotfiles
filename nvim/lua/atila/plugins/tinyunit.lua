return {
	-- "atiladefreitas/tinyunit",
	dir = "~/Documents/plugins/tinyunit",
	event = "VeryLazy",
	config = function()
		require("tinyunit").setup({
			-- Core settings
			max_history = 100, -- Maximum number of items to keep in history
			items_per_page = 9, -- Number of items to show per page
			min_chars = 5, -- Minimum characters required to store item

			-- Window appearance
			window = {
				relative = "editor",
				width = 70, -- Width of the floating window
				height = 12, -- Height of the floating window
				border = "rounded", -- Border style
			},

			-- Internal keymaps for the lazyclip window
			keymaps = {
				close_window = "q", -- Close the clipboard window
				prev_page = "h", -- Go to previous page
				next_page = "l", -- Go to next page
				paste_selected = "", -- Paste the selected item
				move_up = "k", -- Move selection up
				move_down = "j", -- Move selection down
				delete_item = "d", -- Delete selected item
			},
		})
	end,
}
