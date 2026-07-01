return {
	enabled = true,
	dir = vim.fn.stdpath("config") .. "/local-plugins/pastty",
	name = "pastty",
	keys = {
		{ "<leader>pp", desc = "pastty: toggle paste-along panel" },
	},
	config = function()
		require("pastty").setup({
			keymap = "<leader>pp",
		})
	end,
}
