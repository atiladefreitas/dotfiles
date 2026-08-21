-- Dependencies that lazy.nvim used to set up implicitly through the
-- `dependencies` list on the nvim-lspconfig spec.

require("lsp-file-operations").setup()

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("nvim-navic").setup({
	lsp = { auto_attach = true },
	highlight = true,
	separator = " > ",
	depth_limit = 5,
})

-- ── nvim-lspconfig ──────────────────────────────────────────────────
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
		-- nowait: Neovim 0.12 ships six default LSP mappings under the `gr`
		-- prefix (grn gra grr gri grt grx). Without it, bare `gr` sits waiting
		-- out 'timeoutlen' to see whether one of those is coming.
		keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", vim.tbl_extend("force", opts, { nowait = true }))
		keymap("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- Toggle inlay hints with <leader>ih
		if client and client.server_capabilities.inlayHintProvider then
			keymap("n", "<leader>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
			end, { noremap = true, silent = true, buffer = bufnr, desc = "Toggle inlay hints" })
		end
	end,
})

-- JS/TS/React (lightweight and fast)
vim.lsp.config("vtsls", {
	capabilities = capabilities,
	-- Fix vtsls duplicate diagnostics: it sends two identical sets with
	-- different sources ("ts" and "typescript") in separate calls. Drop "typescript".
	handlers = {
		["textDocument/publishDiagnostics"] = function(err, result, ctx)
			if result and result.diagnostics then
				result.diagnostics = vim.tbl_filter(function(d)
					return d.source ~= "typescript"
				end, result.diagnostics)
			end
			vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
		end,
	},
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

-- Jinja2 (via jinja-lsp) -- diagnostics disabled to avoid false "undefined variable" errors
--
-- init_options constrains jinja-lsp's startup indexing to fix high CPU. Without it,
-- jinja-lsp defaults to templates="./" + backend={"."} and recursively tree-sitter-parses
-- every template-extension file (html/jinja/j2) under the process cwd -- including the
-- thousands of .html files inside node_modules. We scope it to a conventional "templates"
-- dir (indexed only when present) and disable backend (.py/.rs) scanning entirely.
-- The walk root is the cwd, not root_dir, so this -- not root_dir -- is the only lever.
vim.lsp.config("jinja_lsp", {
	capabilities = capabilities,
	filetypes = { "html", "jinja", "jinja2" },
	init_options = {
		templates = "templates",
		backend = {},
	},
	handlers = {
		["textDocument/publishDiagnostics"] = function() end,
	},
})

local servers = {
	"vtsls",
	"html",
	"cssls",
	"tailwindcss",
	"lua_ls",
	"marksman",
	"jinja_lsp",
}

-- An .html file containing Jinja constructs ends up with 'filetype' set to the
-- compound "html.jinja" (see plugins/treesitter.lua). vim.lsp matches a server
-- against `vim.tbl_contains(config.filetypes, vim.bo.filetype)` -- an exact
-- string compare, with no splitting on the dot the way FileType autocmds do.
-- So every server that serves "html" has to opt into the compound name too, or
-- it silently stops attaching to exactly the templates we care most about.
-- Derived rather than hardcoded so a server gaining/losing "html" upstream
-- (tailwindcss ships ~50 filetypes) stays correct on its own.
for _, name in ipairs(servers) do
	local fts = vim.lsp.config[name].filetypes
	if fts and vim.tbl_contains(fts, "html") and not vim.tbl_contains(fts, "html.jinja") then
		vim.lsp.config(name, { filetypes = vim.list_extend(vim.deepcopy(fts), { "html.jinja" }) })
	end
end

vim.lsp.enable(servers)
