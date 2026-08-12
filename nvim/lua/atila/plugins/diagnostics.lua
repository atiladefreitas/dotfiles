return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	opts = {
		preset = "powerline", -- default: "modern"
		options = {
			multilines = { enabled = true },
			-- show a diagnostic count on lines the cursor isn't on (needs multilines)
			add_messages = { display_count = true },
		},
	},
	config = function(_, opts)
		require("tiny-inline-diagnostic").setup(opts)
		vim.diagnostic.config({ virtual_text = false }) -- superseded by the above
	end,
}
