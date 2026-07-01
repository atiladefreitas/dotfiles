return {
	enabled = true,
	dir = vim.fn.stdpath("config") .. "/local-plugins/floaty",
	name = "floaty",
	keys = {
		{ "<leader>fe", mode = "v", desc = "Floaty: edit selection in floating window" },
	},
	config = function()
		require("floaty").setup({
			keymap = "<leader>fe",
		})
	end,
}
