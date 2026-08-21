-- smart clipboard manager
require("lazyclip").setup({
	window = {
		width = 80,
	},
})

vim.keymap.set("n", "<leader>Cw", ":lua require('lazyclip').show_clipboard()<CR>", { desc = "Open Clipboard Manager" })
