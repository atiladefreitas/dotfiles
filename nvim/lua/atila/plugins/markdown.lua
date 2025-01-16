return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		bullet = {
			-- Turn on / off list bullet rendering
			enabled = true,
			-- Additional modes to render list bullets
			render_modes = false,
			-- Replaces '-'|'+'|'*' of 'list_item'
			-- How deeply nested the list is determines the 'level', how far down at that level determines the 'index'
			-- If a function is provided both of these values are passed in using 1 based indexing
			-- If a list is provided we index into it using a cycle based on the level
			-- If the value at that level is also a list we further index into it using a clamp based on the index
			-- If the item is a 'checkbox' a conceal is used to hide the bullet instead
			icons = { "● ", "○ ", "◆ ", "◇ " },
			-- Replaces 'n.'|'n)' of 'list_item'
			-- How deeply nested the list is determines the 'level', how far down at that level determines the 'index'
			-- If a function is provided both of these values are passed in using 1 based indexing
			-- If a list is provided we index into it using a cycle based on the level
			-- If the value at that level is also a list we further index into it using a clamp based on the index
			ordered_icons = function(level, index, value)
				value = vim.trim(value)
				local value_index = tonumber(value:sub(1, #value - 1))
				return string.format("%d.", value_index > 1 and value_index or index)
			end,
			-- Padding to add to the left of bullet point
			left_pad = 0,
			-- Padding to add to the right of bullet point
			right_pad = 0,
			-- Highlight for the bullet icon
			highlight = "RenderMarkdownBullet",
		},
	},
}
