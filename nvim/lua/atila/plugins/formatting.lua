-- formatter and linter
return {
	"stevearc/conform.nvim",
	event = { "bufreadpre", "bufnewfile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "biome", "prettier" },
				typescript = { "biome", "prettier" },
				markdown = {
					"prettier",
					"markdownlint-cli2",
				},
				javascriptreact = { "biome", "prettier" },
				typescriptreact = { "biome", "prettier" },
				svelte = { "biome", "prettier" },
				css = { "prettier" }, -- use prettier for css
				html = { "prettier" }, -- use prettier for html
				json = { "biome" }, -- biome handles json
				yaml = { "prettier" }, -- add prettier if needed
				lua = { "stylua" }, -- stylua for lua
				python = { "isort", "black" }, -- python formatters
			},
			format_after_save = {
				enable = true,
				lsp_fallback = true,
				async = true,
				timeout_ms = 1000,
			},
		})

		-- custom keybindings for formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = true,
				timeout_ms = 1000,
			})
		end, { desc = "format file or range (in visual mode)" })

		-- add additional keymaps or configurations as needed
	end,
}
