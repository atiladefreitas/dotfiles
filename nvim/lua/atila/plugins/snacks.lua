-- homepagge
local dashboard = require("atila.dashboard")
local dooing_dash = dashboard.dooing
local pack = require("atila.plugins.util")

-- Stands in for `{ section = "startup" }`, whose implementation calls
-- `require("lazy.stats")` unconditionally and so errors without lazy.nvim.
-- Same layout, numbers sourced from vim.pack instead.
local function startup_section()
	local stats = pack.stats()
	return {
		align = "center",
		text = {
			{ "⚡ Neovim loaded ", hl = "footer" },
			{ tostring(stats.loaded) .. "/" .. tostring(stats.count), hl = "special" },
			{ " plugins in ", hl = "footer" },
			{ stats.ms .. "ms", hl = "special" },
		},
	}
end

-- redraw the todo/schedule panes whenever the dashboard is entered
-- (was snacks' lazy.nvim `init`)
dashboard.setup()

require("snacks").setup({
	bigfile = { enabled = true },
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			-- pending Dooing todos, today's Bloocky blocks, actions
			dooing_dash.section({ limit = 6 }),
			dashboard.bloocky.section({ limit = 4 }),
			dashboard.bloocky.week_section(),
			{
				gap = 1,
				{ icon = "󰄲 ", key = "d", desc = "Todos (Dooing)", action = ":Dooing" },
				{ icon = "󰐕 ", key = "a", desc = "Add Todo", action = dooing_dash.add_todo },
				{ icon = "󰃭 ", key = "b", desc = "Time Blocks (Bloocky)", action = ":BloockyToggle" },
			},

			startup_section,
		},
		preset = {
			header = [[

███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

  Tudo por Jesus, tudo por Maria, tudo à vossa imitação,
ó Patriarca São José! Este será meu lema na vida e na morte.
]],
		},
	},
	indent = { enabled = true },
	input = { enabled = true },
	-- Required by opencode.nvim's `select()`; it used to arrive through that
	-- plugin's lazy.nvim `dependencies` entry.
	picker = { enabled = true },
	-- noice's `notify` view resolves backend = { "snacks", "notify" }, so this
	-- serves the notification popups that nvim-notify used to render.
	notifier = { enabled = true },
	quickfile = { enabled = true },
	statuscolumn = { enabled = true },
	lazygit = {
		enabled = true,
		-- use ~/.config/lazygit/config.yml as-is instead of a generated theme
		configure = false,
		win = {
			style = "lazygit",
		},
	},
	words = { enabled = true },
	git = { enabled = true },
	dim = {
		enabled = false,
	},
	zen = {
		enabled = true,
	},
})

-- Dashboard shortcuts that no longer have a visible entry in the sections, so
-- snacks does not map them itself. Hooked to snacks' own "Opened" event rather
-- than FileType: the dashboard sets its filetype under `eventignore = all`, and
-- it maps `q` to `:bd` in init, which this has to run after to override.
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("atila_dashboard_keys", { clear = true }),
	pattern = "SnacksDashboardOpened",
	callback = function(ev)
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, nowait = true, desc = desc })
		end
		map("r", "<cmd>Telescope oldfiles<cr>", "Recent Files")
		map("q", "<cmd>qa<cr>", "Quit")
	end,
})

-- ── Keymaps ─────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>z", function()
	Snacks.zen()
end, { desc = "Toggle Zen Mode" })
vim.keymap.set("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>gB", function()
	Snacks.gitbrowse()
end, { desc = "Git Browse" })
vim.keymap.set("n", "<leader>gb", function()
	Snacks.git.blame_line()
end, { desc = "Git Blame Line" })
vim.keymap.set("n", "<leader>gf", function()
	Snacks.lazygit.log_file()
end, { desc = "Lazygit Current File History" })
vim.keymap.set("n", "<leader>G", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", function()
	Snacks.lazygit.log()
end, { desc = "Lazygit Log (cwd)" })
vim.keymap.set("n", "<leader>tt", function()
	Snacks.terminal()
end, { desc = "Toggle Terminal" })

-- ── Toggles ─────────────────────────────────────────────────────────
-- These ran on lazy.nvim's `User VeryLazy` event, which no longer exists.
-- They only register mappings, so running them straight after setup() is
-- equivalent — and happens sooner.
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uW")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
	.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
	:map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")
