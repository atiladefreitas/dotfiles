return {
	-- Tokyo Night Colorscheme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "moon",
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
				transparent = true,
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
				transparent_mode = true,
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

	{
		"navarasu/onedark.nvim",
		name = "onedark",
		priority = 995,
		config = function()
			-- Lua
			require("onedark").setup({
				-- Main options --
				style = "darker", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
				transparent = false, -- Show/hide background
				term_colors = true, -- Change terminal color as per the selected theme style
				ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
				cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

				-- toggle theme style ---
				toggle_style_key = "<leader>od", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
				toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

				-- Change code style ---
				-- Options are italic, bold, underline, none
				-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
				code_style = {
					comments = "italic",
					keywords = "none",
					functions = "none",
					strings = "none",
					variables = "none",
				},

				-- Lualine options --
				lualine = {
					transparent = false, -- lualine center bar transparency
				},

				-- Custom Highlights --
				colors = {}, -- Override default colors
				highlights = {}, -- Override highlight groups

				-- Plugins Config --
				diagnostics = {
					darker = true, -- darker colors for diagnostic
					undercurl = true, -- use undercurl instead of underline for diagnostics
					background = true, -- use background color for virtual text
				},
			})
		end,
	},
}
