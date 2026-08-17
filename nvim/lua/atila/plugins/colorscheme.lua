-- colorscheme
return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 999,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = false,
				on_colors = function(colors)
					colors.bg = "#090a12"
					-- colors.bg_dark = "#0a0b11"
					-- colors.bg_dark1 = "#05060a"
					-- colors.bg_highlight = "#1a1d29"
				end,
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},
}
