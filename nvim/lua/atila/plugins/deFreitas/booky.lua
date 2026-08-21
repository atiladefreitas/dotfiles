-- bookmark manager
if not require("atila.plugins.util").has("booky") then
	return
end

require("booky").setup({})

vim.keymap.set("n", "<leader>ba", "<cmd>BookyToggle<cr>", { desc = "Booky: toggle bookmark for this file" })
vim.keymap.set("n", "<leader>bl", "<cmd>BookyAddLine<cr>", { desc = "Booky: bookmark this line" })
vim.keymap.set("n", "<leader>bb", "<cmd>BookyList<cr>", { desc = "Booky: project bookmarks" })
vim.keymap.set("n", "<leader>bg", "<cmd>BookyGlobal<cr>", { desc = "Booky: global bookmarks" })
