return {
	"atiladefreitas/tinyunit",
	-- dir = "~/Documents/tinyunit",
	event = "VeryLazy",
	config = function()
		require("tinyunit").setup({})
	end,
}
