require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"vtsls",
		"html",
		"cssls",
		"tailwindcss",
		"lua_ls",
		"marksman",
		"jinja_lsp",
	},
	automatic_installation = true,
	-- Disable automatic_enable since we call vim.lsp.enable() ourselves in native-lsp.lua.
	-- Without this, mason-lspconfig auto-enables every installed server, including ones
	-- we deliberately leave dormant — which duplicates diagnostics and completions.
	automatic_enable = false,
})

-- ── Formatters (conform.nvim's tools) ───────────────────────────────
-- `ensure_installed` above only understands lspconfig server names, so
-- conform's formatters cannot ride along there. Driving mason-registry
-- directly is all mason-tool-installer.nvim does, without the extra plugin.
--
-- Mason prepends its bin/ to Neovim's PATH, so conform finds these with no
-- further wiring — and they take precedence over any system-wide copies.
local ensure_tools = {
	"prettier", -- js/ts/css/html/yaml/markdown
	"rustywind", -- tailwind class sorting
	"stylua", -- lua
	"black", -- python
	"isort", -- python imports
}

-- Deferred until after the UI is up. The check itself is cheap (a handful of
-- fs_stat calls; mason-lspconfig has already pulled mason-registry in anyway),
-- but when something *is* missing this hits the network to refresh the registry
-- and then downloads — none of which should sit in front of the first frame.
local function ensure_formatters()
	local registry = require("mason-registry")

	-- Resolving a package is a local lookup, so the steady state (everything
	-- already installed) costs a handful of fs_stat calls and no network.
	local missing = {}
	for _, name in ipairs(ensure_tools) do
		local ok, pkg = pcall(registry.get_package, name)
		if not ok then
			vim.notify(("mason: no package named %q"):format(name), vim.log.levels.WARN)
		elseif not pkg:is_installed() then
			missing[#missing + 1] = pkg
		end
	end

	if #missing == 0 then
		return
	end

	-- Only now is it worth refreshing, so a stale local registry can still
	-- resolve current versions.
	registry.refresh(function()
		for _, pkg in ipairs(missing) do
			vim.schedule(function()
				vim.notify(("mason: installing %s…"):format(pkg.name), vim.log.levels.INFO)
			end)
			pkg:install(nil, function(success, err)
				vim.schedule(function()
					if success then
						vim.notify(("mason: installed %s"):format(pkg.name), vim.log.levels.INFO)
					else
						-- A failed or interrupted install leaves a dangling symlink in
						-- mason/bin, and every retry then dies with "is already linked".
						-- Deleting that link is the fix; see :MasonLog for the real error.
						vim.notify(
							("mason: failed to install %s\n%s"):format(pkg.name, tostring(err)),
							vim.log.levels.ERROR
						)
					end
				end)
			end)
		end
	end)
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("atila_mason_tools", { clear = true }),
	once = true,
	callback = function()
		vim.defer_fn(ensure_formatters, 500)
	end,
})
