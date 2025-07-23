-- smart clipboard manager
return {
	-- "atiladefreitas/lazyclip",
	dir = "~/Documents/lazyclip",
	event = "VeryLazy",
	version = "*",
	config = function()
		require("lazyclip").setup({
			window = {
				width = 80,
			},
		})
	end,
	keys = {
		{ "<leader>Cw", ":lua require('lazyclip').show_clipboard()<CR>", desc = "Open Clipboard Manager" },
	},
}
