return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"vtsls",
				"biome",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"marksman",
				"jinja_lsp",
			},
			automatic_installation = true,
			-- Disable automatic_enable since we call vim.lsp.enable() ourselves in native-lsp.lua.
			-- Without this, mason-lspconfig auto-enables ALL installed servers (including biome),
			-- causing duplicate diagnostics and completions.
			automatic_enable = false,
		},
	},
}
