return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_items = {
				visible = true,
			},
		},
	},
	config = function(_, opts)
		vim.keymap.set("n", "<leader>o", ":Neotree filesystem reveal left<CR>", {})
		buffers = { follow_current_file = { enabled = true } }
		require("neo-tree").setup(opts)

		-- Keymaps
		vim.keymap.set(
			"n",
			"<leader>e",
			":Neotree toggle<CR>",
			{ noremap = true, silent = true, desc = "Toggle Neotree" }
		)
		-- vim.keymap.set(
		-- 	"n",
		-- 	"<leader>o",
		-- 	":Neotree focus<CR>",
		-- 	{ noremap = true, silent = true, desc = "Focus Neotree" }
		-- )
	end,
}
