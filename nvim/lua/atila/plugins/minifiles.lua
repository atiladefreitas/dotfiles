return {
	"echasnovski/mini.files",
	version = false,
	config = function()
		require("mini.files").setup({
			windows = {
				preview = true,
				width_preview = 40,
			},
		})

		vim.api.nvim_set_keymap(
			"n",
			"<leader>mf",
			":lua require('mini.files').open()<CR>",
			{ noremap = true, silent = true, desc = "Open mini.files" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"<leader>md",
			":lua require('mini.files').open(vim.fn.expand('%:p:h'))<CR>",
			{ noremap = true, silent = true, desc = "Open mini.files in file directory" }
		)
	end,
}
