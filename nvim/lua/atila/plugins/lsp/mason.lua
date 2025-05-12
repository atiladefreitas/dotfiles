return {
	{
		"williamboman/mason.nvim",
		version = "^1.0.0",
		config = true, -- Mason setup directly here
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "^1.0.0",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"html",
					"tailwindcss",
					"lua_ls",
					"emmet_ls",
					"biome",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		version = "^1.0.0",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"eslint_d",
				},
			})
		end,
	},
}
