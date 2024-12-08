return {
	-- "atiladefreitas/tinyunit",
	dir = "~/Documents/plugins/tinyunit",
	event = "VeryLazy",
	config = function()
		require("tinyunit").setup({})
	end,
}
