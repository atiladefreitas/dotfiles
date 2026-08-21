-- ╭──────────────────────────────────────────────────────────────────╮
-- │  Plugin management — vim.pack (Neovim 0.12+), no lazy.nvim       │
-- │                                                                  │
-- │  vim.pack is a manager, not a loader framework: it clones,       │
-- │  pins and updates, and that is all. There is no event/keys/cmd   │
-- │  deferral, so every plugin here loads eagerly at startup and     │
-- │  each module below is required in dependency order.              │
-- │                                                                  │
-- │  Plugins live in stdpath("data")/site/pack/core/opt/             │
-- │  Revisions are pinned in ~/.config/nvim/nvim-pack-lock.json      │
-- │  (:h vim.pack-lockfile) — commit it to keep machines in sync.    │
-- ╰──────────────────────────────────────────────────────────────────╯

local gh = function(repo)
	return "https://github.com/" .. repo
end

-- ── Built-in plugins we never use ───────────────────────────────────
-- Replaces lazy.nvim's `performance.rtp.disabled_plugins`. Must run before
-- Neovim sources its own plugin/ files, i.e. here in init.lua.
-- ("tohtml" is omitted on purpose: in 0.12 it is "nvim.tohtml" and opt-in.)
for _, builtin in ipairs({
	"gzip",
	"matchit",
	"matchparen",
	"netrwPlugin",
	"tarPlugin",
	"tutor",
	"zipPlugin",
}) do
	vim.g["loaded_" .. builtin] = 1
end

-- ── Build hooks ─────────────────────────────────────────────────────
-- vim.pack's stand-in for lazy.nvim's `build`. Registered before add() so
-- the very first install fires it too.
local build = {
	["telescope-fzf-native.nvim"] = function(path)
		vim.system({ "make" }, { cwd = path }):wait()
	end,
	["nvim-treesitter"] = function()
		-- Needs the plugin's own command, so only after it is loadable.
		vim.schedule(function()
			pcall(vim.cmd, "TSUpdate")
		end)
	end,
}

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("atila_pack_build", { clear = true }),
	callback = function(ev)
		local kind, spec, path = ev.data.kind, ev.data.spec, ev.data.path
		if kind ~= "install" and kind ~= "update" then
			return
		end
		local hook = build[spec.name]
		if hook then
			vim.notify(("Building %s…"):format(spec.name), vim.log.levels.INFO)
			local ok, err = pcall(hook, path)
			if not ok then
				vim.notify(("Build failed for %s: %s"):format(spec.name, err), vim.log.levels.ERROR)
			end
		end
	end,
})

-- ── The plugin list ─────────────────────────────────────────────────
-- Order here is irrelevant (vim.pack installs in parallel and only puts
-- directories on 'runtimepath'); the require() order further down is what
-- actually sequences configuration.
local specs = {
	-- Colorscheme
	gh("folke/tokyonight.nvim"),

	-- Libraries (dependencies of the plugins below)
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("MunifTanjim/nui.nvim"),

	-- Treesitter. `main` is the rewrite: a pure parser/query installer.
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	gh("windwp/nvim-ts-autotag"),
	-- jinja.vim is not here on purpose — see `unmanaged` below.

	-- UI
	gh("folke/snacks.nvim"),
	gh("nvim-lualine/lualine.nvim"),
	gh("b0o/incline.nvim"),
	gh("brenoprata10/nvim-highlight-colors"),
	gh("rachartier/tiny-inline-diagnostic.nvim"),
	gh("serhez/bento.nvim"),
	gh("nvzone/showkeys"),

	-- folke's
	gh("folke/ts-comments.nvim"),
	gh("folke/flash.nvim"),
	gh("folke/noice.nvim"),
	gh("folke/which-key.nvim"),
	gh("folke/trouble.nvim"),
	gh("folke/sidekick.nvim"),
	gh("folke/todo-comments.nvim"),
	gh("folke/lazydev.nvim"),

	-- Telescope. master, not 0.1.x: that branch is frozen at May 2024 and
	-- still calls nvim-treesitter's removed ft_to_lang/is_enabled APIs.
	{ src = gh("nvim-telescope/telescope.nvim"), version = "master" },
	gh("andrew-george/telescope-themes"),
	gh("nvim-telescope/telescope-file-browser.nvim"),
	gh("nvim-telescope/telescope-fzf-native.nvim"),

	-- Explorer
	{ src = gh("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" },

	-- Completion. A release tag gets the pre-built Rust fuzzy matcher.
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1") },
	gh("rafamadriz/friendly-snippets"),

	-- LSP
	gh("neovim/nvim-lspconfig"),
	gh("williamboman/mason.nvim"),
	gh("williamboman/mason-lspconfig.nvim"),
	gh("antosha417/nvim-lsp-file-operations"),
	gh("SmiteshP/nvim-navic"),

	-- Editing
	gh("stevearc/conform.nvim"),
	gh("lewis6991/gitsigns.nvim"),
	gh("nvim-pack/nvim-spectre"),
	gh("arnamak/stay-centered.nvim"),
	gh("alexghergh/nvim-tmux-navigation"),
	gh("NickvanDyke/opencode.nvim"),

	-- mini.nvim, standalone modules only
	gh("nvim-mini/mini.cursorword"),
	gh("nvim-mini/mini.move"),
	gh("nvim-mini/mini.pairs"),
	gh("nvim-mini/mini.surround"),

	-- Markdown
	gh("MeanderingProgrammer/render-markdown.nvim"),
	{ src = gh("epwalsh/obsidian.nvim"), version = vim.version.range("*") },
	gh("3rd/image.nvim"),

	-- Mine
	{ src = gh("atiladefreitas/lazyclip"), version = vim.version.range("*") },
}

-- `load` defaults to false while init.lua is sourcing, which would leave
-- plugin/ and ftdetect/ files unsourced until after this file finishes —
-- so commands and globals the setup code below relies on would be missing.
-- true reproduces lazy.nvim's eager behaviour.
vim.pack.add(specs, { confirm = false, load = true })

-- ── Plugins vim.pack cannot install ─────────────────────────────────
-- vim.pack always runs `git submodule update --init --recursive` after
-- checkout, and it has no opt-out. HiPhish/jinja.vim commits a gitlink at
-- test/bin but names its submodule manifest `.submodules` instead of
-- `.gitmodules`, so that step fails and takes the whole add() down with it.
-- (lazy.nvim never touched submodules, which is why this never surfaced.)
--
-- These get a plain, submodule-free clone into their own package, loaded
-- with :packadd like everything else. Drop an entry back into `specs` if
-- upstream ever fixes its manifest.
local unmanaged = {
	["jinja.vim"] = gh("HiPhish/jinja.vim"),
}

local unmanaged_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "manual", "opt")

for name, src in pairs(unmanaged) do
	local path = vim.fs.joinpath(unmanaged_dir, name)
	if not vim.uv.fs_stat(path) then
		vim.notify(("Installing %s…"):format(name), vim.log.levels.INFO)
		vim.fn.mkdir(unmanaged_dir, "p")
		local out = vim.system({ "git", "clone", "--filter=blob:none", src, path }):wait()
		if out.code ~= 0 then
			vim.notify(("Failed to clone %s:\n%s"):format(name, out.stderr), vim.log.levels.ERROR)
		end
	end
	if vim.uv.fs_stat(path) then
		pcall(vim.cmd.packadd, name)
	end
end

-- Folded into :PackUpdate below so these do not silently rot.
local function update_unmanaged()
	for name, _ in pairs(unmanaged) do
		local path = vim.fs.joinpath(unmanaged_dir, name)
		if vim.uv.fs_stat(path) then
			local out = vim.system({ "git", "pull", "--ff-only" }, { cwd = path }):wait()
			local level = out.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
			vim.notify(("%s: %s"):format(name, vim.trim(out.stdout .. out.stderr)), level)
		end
	end
end

-- ── Plugins developed locally ───────────────────────────────────────
-- Not managed by vim.pack (nothing to clone or update); they just need to
-- be on 'runtimepath'. Missing checkouts are skipped rather than fatal.
local M = {}

M.local_plugins = {
	bloocky = "~/Documents/projects/Dooing/bloocky.nvim",
	booky = "~/Documents/projects/booky.nvim",
	dooing = "~/Documents/projects/Dooing/dooing",
	floaty = vim.fn.stdpath("config") .. "/local-plugins/floaty",
	pastty = vim.fn.stdpath("config") .. "/local-plugins/pastty",
	widgy = vim.fn.stdpath("config") .. "/local-plugins/widgy",
	wrappy = vim.fn.stdpath("config") .. "/local-plugins/wrappy",
}

---@type table<string, boolean> which local plugins are actually on disk
M.local_available = {}

for name, path in pairs(M.local_plugins) do
	local dir = vim.fn.expand(path)
	if vim.uv.fs_stat(dir) then
		M.local_available[name] = true
		vim.opt.runtimepath:prepend(dir)
		local after = dir .. "/after"
		if vim.uv.fs_stat(after) then
			vim.opt.runtimepath:append(after)
		end
		-- vim.pack.add sourced plugin/ for managed plugins; do the same here.
		for _, file in ipairs(vim.fn.glob(dir .. "/plugin/**/*.{vim,lua}", false, true)) do
			pcall(vim.cmd.source, file)
		end
	end
end

-- Inventory for the dashboard's startup line (see util.stats).
local util = require("atila.plugins.util")
util.counts.managed = #specs
util.counts.unmanaged = vim.tbl_count(unmanaged)
util.counts.locals = vim.tbl_count(M.local_available)

-- ── Configuration, in dependency order ──────────────────────────────
-- Each module below performs its own setup() at require time. The order is
-- load-bearing: colorscheme first so later highlight overrides win,
-- blink.cmp before the LSP config that reads its capabilities, mason before
-- lspconfig, and nvim-navic before the statusline that renders it.
local modules = {
	"atila.plugins.colorscheme",
	"atila.plugins.treesitter",
	"atila.plugins.snacks",

	"atila.plugins.lsp.blink-cmp",
	"atila.plugins.lsp.mason",
	"atila.plugins.lsp.native-lsp",

	"atila.plugins.telescope",
	"atila.plugins.neo-tree",

	"atila.plugins.lualine",
	"atila.plugins.incline",
	"atila.plugins.gitsigns",
	"atila.plugins.diagnostics",
	"atila.plugins.colors",

	"atila.plugins.folke",
	"atila.plugins.mini",
	"atila.plugins.formatting",
	"atila.plugins.markdown",
	"atila.plugins.image",

	"atila.plugins.bento",
	"atila.plugins.opencode",
	"atila.plugins.search-replace",
	"atila.plugins.showkeys",
	"atila.plugins.stay-centered",
	"atila.plugins.tmux-nav",

	"atila.plugins.deFreitas.bloocky",
	"atila.plugins.deFreitas.booky",
	"atila.plugins.deFreitas.dooing",
	"atila.plugins.deFreitas.floaty",
	"atila.plugins.deFreitas.lazyclip",
	"atila.plugins.deFreitas.pastty",
	"atila.plugins.deFreitas.widgy",
	"atila.plugins.deFreitas.wrappy",
}

-- One broken module must not take the whole config down with it — that was
-- lazy.nvim's behaviour too, and without it a bad plugin means no editor.
for _, mod in ipairs(modules) do
	local ok, err = pcall(require, mod)
	if not ok then
		vim.schedule(function()
			vim.notify(("Failed to load %s:\n%s"):format(mod, err), vim.log.levels.ERROR)
		end)
	end
end

-- ── Management commands ─────────────────────────────────────────────
-- vim.pack ships no UI, so these stand in for `:Lazy`.

-- Download updates and open a confirmation buffer: `:write` to apply,
-- `:quit` to discard. (:h vim.pack.update)
vim.api.nvim_create_user_command("PackUpdate", function()
	update_unmanaged()
	vim.pack.update()
end, { desc = "vim.pack: fetch updates and review them" })

-- Same review buffer, but without hitting the network: shows what is
-- currently installed against what is pinned.
vim.api.nvim_create_user_command("PackStatus", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "vim.pack: review installed plugins offline" })

-- Delete anything on disk that this config no longer asks for.
vim.api.nvim_create_user_command("PackClean", function()
	local wanted = {}
	for _, spec in ipairs(specs) do
		local src = type(spec) == "string" and spec or spec.src
		wanted[spec.name or src:match("([^/]+)$")] = true
	end

	local orphans = {}
	for _, plug in ipairs(vim.pack.get()) do
		if not wanted[plug.spec.name] then
			table.insert(orphans, plug.spec.name)
		end
	end

	if #orphans == 0 then
		vim.notify("vim.pack: nothing to clean", vim.log.levels.INFO)
		return
	end

	local prompt = ("Delete %d unused plugin(s)?\n  %s"):format(#orphans, table.concat(orphans, "\n  "))
	if vim.fn.confirm(prompt, "&Yes\n&No", 2) == 1 then
		vim.pack.del(orphans, { force = true })
	end
end, { desc = "vim.pack: remove plugins this config no longer lists" })

return M
