return {
	"Bekaboo/dropbar.nvim",
	name = "dropbar",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("dropbar").setup()
	end,

	vim.api.nvim_set_keymap(
		"n",
		"<leader>u",
		':lua require("dropbar.api").pick(vim.v.count ~= 0 and vim.v.count)<CR>',
		{ noremap = true, silent = true }
	),
}
