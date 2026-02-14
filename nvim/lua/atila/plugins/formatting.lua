return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local markdown_folder = vim.fn.expand("~/Documents/notes")
		local excluded_subfolder = vim.fn.expand("~/Documents/notes/articles")

		conform.setup({
			formatters_by_ft = {
				javascript = { "rustywind", "biome", "prettier" },
				typescript = { "rustywind", "biome", "prettier" },
				javascriptreact = { "rustywind", "biome", "prettier" },
				typescriptreact = { "rustywind", "biome", "prettier" },
				svelte = { "rustywind", "prettier" },
				vue = { "rustywind", "prettier" },
				markdown = function()
					local current_file = vim.fn.expand("%:p")
					if current_file:find(excluded_subfolder, 1, true) then
						return {}
					elseif current_file:find(markdown_folder, 1, true) then
						return { "prettier" }
					else
						return {}
					end
				end,
				css = { "prettier" },
				scss = { "prettier" },
				html = { "rustywind", "prettier" },
				json = { "biome", "prettier" },
				jsonc = { "biome", "prettier" },
				yaml = { "prettier" },
				yml = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				}
			end,
			formatters = {
				rustywind = {},
				biome = {
					condition = function(self, ctx)
						-- Only use biome when the project has a biome config
						return vim.fs.find({
							"biome.json",
							"biome.jsonc",
						}, { path = ctx.filename, upward = true })[1] ~= nil
					end,
				},
				prettier = {
					condition = function(self, ctx)
						-- Use prettier as fallback when project has no biome config
						return vim.fs.find({
							"biome.json",
							"biome.jsonc",
						}, { path = ctx.filename, upward = true })[1] == nil
					end,
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}

