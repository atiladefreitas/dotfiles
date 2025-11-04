return {
	"atiladefreitas/booky.nvim",
	-- dir = "~/Documents/plugins/booky",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-neo-tree/neo-tree.nvim", -- optional
	},
	config = function()
		require("booky").setup({
			-- your custom config here (optional)
		})
	end,
}
