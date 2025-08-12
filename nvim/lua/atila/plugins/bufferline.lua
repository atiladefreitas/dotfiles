-- Tabs
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			mode = "buffers",
			numbers = function(opts)
				local letters = { "Q", "W", "E", "A", "S", "D" }
				return string.format("[%s]", letters[opts.ordinal] or opts.ordinal)
			end,
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					highlight = "Directory",
					separator = true,
				},
			},
		},
	},
}
