return {
	"echasnovski/mini.surround",
	version = false,
	config = function()
		require("mini.surround").setup({
			mappings = {
				add = "", -- Adicionar surround
				delete = "", -- Remover surround
				find = "", -- Encontrar surround
				find_left = "", -- Encontrar surround à esquerda
				highlight = "", -- Realçar surround
				replace = "", -- Substituir surround
				update_n_lines = "", -- Atualizar n linhas
			},
		})

		local map = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		map("n", "<leader>sa", ":lua MiniSurround.add('visual')<CR>", opts)
		map("x", "<leader>sa", ":lua MiniSurround.add('visual')<CR>", opts)
		map("n", "<leader>sd", ":lua MiniSurround.delete()<CR>", opts)
		map("n", "<leader>sr", ":lua MiniSurround.replace()<CR>", opts)
		map("n", "<leader>sf", ":lua MiniSurround.find()<CR>", opts)
		map("n", "<leader>sF", ":lua MiniSurround.find_left()<CR>", opts)
		map("n", "<leader>sh", ":lua MiniSurround.highlight()<CR>", opts)
		map("n", "<leader>sn", ":lua MiniSurround.update_n_lines()<CR>", opts)
	end,
}
