return {
	"echasnovski/mini.comment",
	version = false,
	config = function()
		require("mini.comment").setup({
			mappings = {
				comment = "<leader>/", -- Normal and Visual mode toggle
				comment_line = "<leader>/", -- Line toggle
				textobject = "", -- Disable textobject mapping
			},
		})
	end,
}
