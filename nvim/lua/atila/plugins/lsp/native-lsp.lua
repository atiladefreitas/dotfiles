return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"SmiteshP/nvim-navic",
			opts = {
				lsp = { auto_attach = true },
				highlight = true,
				separator = " > ",
				depth_limit = 5,
			},
		},
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Global keymaps via LspAttach autocmd
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufnr = args.buf
				local opts = { noremap = true, silent = true, buffer = bufnr }
				local keymap = vim.keymap.set

				keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
				keymap("n", "K", vim.lsp.buf.hover, opts)
				keymap("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
				keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
				keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
				keymap("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)

				-- Toggle inlay hints with <leader>ih
				if client and client.server_capabilities.inlayHintProvider then
					keymap("n", "<leader>ih", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
					end, { noremap = true, silent = true, buffer = bufnr, desc = "Toggle inlay hints" })
				end

				-- Biome: disable completion to avoid duplicates with vtsls
				if client and client.name == "biome" then
					client.server_capabilities.completionProvider = nil
				end
			end,
		})

		-- JS/TS/React (lightweight and fast)
		vim.lsp.config("vtsls", {
			capabilities = capabilities,
			settings = {
				vtsls = {
					enableMoveToFileCodeAction = true,
					autoUseWorkspaceTsdk = true,
					experimental = {
						completion = {
							enableServerSideFuzzyMatch = true,
						},
					},
				},
				typescript = {
					updateImportsOnFileMove = { enabled = "always" },
					suggest = {
						completeFunctionCalls = true,
					},
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = false },
					},
				},
			},
		})

		-- Biome (Linter only -- formatting handled by conform.nvim)
		vim.lsp.config("biome", {
			capabilities = capabilities,
		})

		-- HTML
		vim.lsp.config("html", {
			capabilities = capabilities,
		})

		-- CSS
		vim.lsp.config("cssls", {
			capabilities = capabilities,
		})

		-- Tailwind CSS
		vim.lsp.config("tailwindcss", {
			capabilities = capabilities,
			settings = {
				tailwindCSS = {
					lint = {
						suggestCanonicalClasses = "ignore",
					},
				},
			},
		})

		-- Lua
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		-- Markdown (via marksman)
		vim.lsp.config("marksman", {
			capabilities = capabilities,
		})

		-- Enable all configured servers
		vim.lsp.enable({
			"vtsls",
			"biome",
			"html",
			"cssls",
			"tailwindcss",
			"lua_ls",
			"marksman",
		})
	end,
}
