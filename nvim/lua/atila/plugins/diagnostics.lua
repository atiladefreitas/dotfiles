require("tiny-inline-diagnostic").setup({
	preset = "powerline", -- default: "modern"
	options = {
		multilines = { enabled = true },
		-- show a diagnostic count on lines the cursor isn't on (needs multilines)
		add_messages = { display_count = true },
	},
})
vim.diagnostic.config({ virtual_text = false }) -- superseded by the above
