return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "biome", "estlint_d" }, -- Use Biome for JavaScript
				typescript = { "biome", "estlint_d" }, -- Use Biome for TypeScript
				javascriptreact = { "biome", "estlint_d" }, -- Use Biome for JSX
				typescriptreact = { "biome", "estlint_d" }, -- Use Biome for TSX
				svelte = { "biome" }, -- Use Biome for Svelte
				css = { "biome" }, -- Use Biome for CSS
				html = { "biome" }, -- Use Biome for HTML
				json = { "biome" }, -- Use Biome for JSON
				yaml = { "biome" }, -- Use Biome for YAML
				graphql = { "biome" }, -- Use Biome for GraphQL
				liquid = { "biome" }, -- Use Biome for Liquid
				lua = { "stylua" }, -- Use Stylua for Lua
				python = { "isort", "black" }, -- Use Isort and Black for Python
				-- Additional filetypes can be added here
			},
			format_after_save = {
				enable = true, -- Enable format on save
				lsp_fallback = true, -- Use LSP as fallback formatter
				async = true, -- Format asynchronously
				timeout_ms = 1000, -- Timeout for formatting
			},
		})

		-- Custom keybindings for formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = true,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		-- Add additional keymaps or configurations as needed
	end,
}
