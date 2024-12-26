return {
	-- Tokyo Night Colorscheme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "storm",
				transparent = true,
				on_colors = function(colors) end,
				on_highlights = function(highlights, colors) end,
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},

	-- Kanagawa Colorscheme
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 999,
		config = function()
			require("kanagawa").setup({
				transparent = false,
				theme = "wave",
				colors = {},
				overrides = function(colors)
					return {}
				end,
			})
			-- vim.cmd("colorscheme kanagawa")
		end,
	},

	-- Gruvbox Colorscheme
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 998,
		config = function()
			require("gruvbox").setup({
				contrast = "medium", -- Options: "hard", "medium", "soft"
				transparent_mode = false,
			})
			-- vim.cmd("colorscheme gruvbox")
		end,
	},

	-- Everforest Colorscheme
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 997,
		config = function()
			vim.g.everforest_background = "hard" -- Options: "soft", "medium", "hard"
			vim.g.everforest_transparent_background = 0
			vim.g.everforest_enable_italic = 1
			-- vim.cmd("colorscheme everforest")
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 996,
		config = function()
			-- vim.cmd("colorscheme catppuccin")
		end,
	},
}
