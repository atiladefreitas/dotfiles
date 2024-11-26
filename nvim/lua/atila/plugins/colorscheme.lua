return {
	"folke/tokyonight.nvim",
	lazy = false, -- Load immediately
	priority = 1000, -- Ensure it loads first
	config = function()
		require("tokyonight").setup({
			style = "night",
			transparent = false,
			on_colors = function(colors) end, -- Define this as an empty function
			on_highlights = function(highlights, colors) end, -- Define this as an empty function
		})
		vim.cmd("colorscheme tokyonight")
	end,
}
