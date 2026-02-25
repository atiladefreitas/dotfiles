-- colorscheme
-- Only the active colorscheme loads eagerly; the rest are lazy (available via :colorscheme)
return {
	{ "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true },

	{
		"folke/tokyonight.nvim",
		-- dir = "~/Documents/tokyonight.nvim/",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = false,
				on_colors = function(colors)
					colors.bg = "#0f1019"
					colors.bg_dark = "#0a0b11"
					colors.bg_dark1 = "#05060a"
					colors.bg_highlight = "#1a1d29"
				end,
				on_highlights = function(highlights, colors) end,
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},

	{
		"alexxGmZ/e-ink.nvim",
		lazy = true,
	},

	{
		"wadackel/vim-dogrun",
		lazy = true,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = {
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true,
				show_end_of_buffer = true,
				term_colors = true,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
				no_italic = false,
				no_bold = false,
				no_underline = false,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = { "bold" },
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				default_integrations = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					neotree = true,
					treesitter = true,
					notify = false,
					telescope = { enabled = true },
					mini = {
						enabled = true,
						indentscope_color = "",
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
