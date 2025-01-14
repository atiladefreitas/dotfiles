return {
	-- "atiladefreitas/tinyunit",
	dir = "~/Documents/plugins/tinyunit",
	event = "VeryLazy",
	config = function()
		require("tinyunit").setup({

			window = {
				width = 100,
				height = 15,
			},
		})
	end,
}
