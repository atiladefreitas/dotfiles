return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- Setup nvim-ts-autotag
		require("nvim-ts-autotag").setup()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")
		-- configure treesitter
		treesitter.setup({
			-- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"scss",
				"lua",
				"json",
				"markdown",
				"markdown_inline",
				"vimdoc",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			-- Add the missing fields
			modules = {},
			sync_install = false,
			ignore_install = {},
			auto_install = true,
		})
	end,
}
