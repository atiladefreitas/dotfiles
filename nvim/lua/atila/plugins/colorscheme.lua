-- colorscheme
return {
	{ "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },

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

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("notify").setup({
				background_colour = "#000000",
			})
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- disables setting the background color.
				show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
				term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
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
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
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
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
