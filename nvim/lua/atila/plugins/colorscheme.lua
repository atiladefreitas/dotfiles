-- colorscheme
return {
	{ "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },
	-- Tokyo Night Colorscheme
	{
		"folke/tokyonight.nvim",
		-- dir = "~/Documents/tokyonight.nvim/",
		lazy = false,
		priority = 900,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = true,
				on_colors = function(colors)
					colors.bg = "#0f1019"
					colors.bg_dark = "#0a0b11"
					colors.bg_dark1 = "#05060a"
					colors.bg_highlight = "#1a1d29"
					-- colors.fg = "#e0e6ff"
					-- colors.fg_dark = "#c4ccf0"
					-- colors.comment = "#6b7394"
					-- colors.blue = "#82b1ff"
					-- colors.cyan = "#89dceb"
					-- colors.green = "#a6e3a1"
					-- colors.orange = "#fab387"
					-- colors.purple = "#b4befe"
					-- colors.red = "#f38ba8"
					-- colors.yellow = "#f9e2af"
					-- colors.magenta = "#cba6f7"
				end,
				on_highlights = function(highlights, colors) end,
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},
	{
		"alexxGmZ/e-ink.nvim",
		priority = 994,
		config = function()
			-- choose light mode or dark mode
			-- vim.opt.background = "dark"
			-- vim.opt.background = "light"
			--
			-- or do
			-- :set background=dark
			-- :set background=light
		end,
	},
	{
		"wadackel/vim-dogrun",
		priority = 992,
		config = function() end,
	},
}
