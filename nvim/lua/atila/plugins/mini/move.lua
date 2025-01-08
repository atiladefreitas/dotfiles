return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode
				down = "<a-j>",
				up = "<a-k>",
				-- Move current line in Normal mode
				line_down = "<a-j>",
				line_up = "<a-k>",
			},
			options = {
				reindent_linewise = true,
			},
		})
	end,
}
