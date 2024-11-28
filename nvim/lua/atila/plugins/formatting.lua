return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "biome", "prettier" }, -- Add Prettier here
				typescript = { "biome", "prettier" },
				javascriptreact = { "biome", "prettier" },
				typescriptreact = { "biome", "prettier" },
				svelte = { "biome", "prettier" },
				css = { "prettier" }, -- Use Prettier for CSS
				html = { "prettier" }, -- Use Prettier for HTML
				json = { "biome" }, -- Biome handles JSON
				yaml = { "prettier" }, -- Add Prettier if needed
				lua = { "stylua" }, -- Stylua for Lua
				python = { "isort", "black" }, -- Python formatters
			},
			format_after_save = {
				enable = true,
				lsp_fallback = true,
				async = true,
				timeout_ms = 1000,
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
