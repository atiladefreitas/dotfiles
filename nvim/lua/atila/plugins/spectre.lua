return {
	"nvim-pack/nvim-spectre",
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
}
