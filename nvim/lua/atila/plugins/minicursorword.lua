return {
	"echasnovski/mini.cursorword",
	version = false,
	config = function()
		require("mini.cursorword").setup({
			delay = 100,
		})

		vim.api.nvim_set_keymap(
			"n",
			"<leader>ce",
			":lua require('mini.cursorword').toggle()<CR>",
			{ noremap = true, silent = true, desc = "Toggle cursorword highlight" }
		)
	end,
}
