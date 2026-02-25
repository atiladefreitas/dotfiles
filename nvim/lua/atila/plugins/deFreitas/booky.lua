return {
	"atiladefreitas/booky.nvim",
	-- dir = "~/Documents/plugins/booky",
	cmd = "Booky",
	keys = {
		{ "<leader>bo", "<cmd>Booky open<CR>", desc = "Open bookmark" },
		{ "<leader>ba", "<cmd>Booky add<CR>", desc = "Add bookmark" },
	},
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
