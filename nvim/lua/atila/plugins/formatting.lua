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
				rustywind = {
					condition = function(self, ctx)
						return vim.fn.executable("rustywind") == 1
					end,
					prepend_args = { "--write-multi-line", "120" },
				},
				biome = {
					-- Use biome if available (don't require config file)
					condition = function(self, ctx)
						-- Check if biome is available in PATH
						return vim.fn.executable("biome") == 1
					end,
				},
				prettier = {
					condition = function(self, ctx)
						-- Use prettier if biome is not available or if prettier config exists
						local has_prettier_config = vim.fs.find({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yml",
							".prettierrc.yaml",
							".prettierrc.json5",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.toml",
							"prettier.config.js",
							"prettier.config.cjs",
						}, { path = ctx.filename, upward = true })[1]

						return has_prettier_config or vim.fn.executable("biome") ~= 1
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

