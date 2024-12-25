require("atila.core.options")
require("atila.core.keymaps")

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "pt_br", "en_us" }
		-- Set text width to 80 for Markdown files
		vim.bo.textwidth = 80
		-- Enable soft wrapping without inserting new lines
		vim.wo.wrap = true
		-- Indent lines properly when wrapped
		vim.bo.formatoptions = vim.bo.formatoptions .. "t"
	end,
})
