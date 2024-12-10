return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode
				down = "<C-j>",
				up = "<C-k>",
				-- Move current line in Normal mode
				line_down = "<C-j>",
				line_up = "<C-k>",
			},
			options = {
				reindent_linewise = true,
			},
		})
	end,
}
