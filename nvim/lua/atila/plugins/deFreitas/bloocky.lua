return {
	-- beautiful time-blocking manager
	{
		dir = "~/Documents/projects/bloocky.nvim",
		cmd = { "Bloocky", "BloockyToggle", "BloockyAdd" },
		keys = {
			{ "<leader>tb", "<cmd>BloockyToggle<cr>", desc = "Bloocky: toggle calendar" },
		},
		config = function()
			require("bloocky").setup({})
		end,
	},
}
