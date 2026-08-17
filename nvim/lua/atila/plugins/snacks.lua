-- homepagge
local dashboard = require("atila.dashboard")
local dooing_dash = dashboard.dooing

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			pane_gap = 6,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },

				-- right pane: repo, pending Dooing todos, today's Bloocky blocks, actions
				dashboard.git.section({ pane = 2 }),
				dooing_dash.section({ pane = 2, limit = 6 }),
				dashboard.bloocky.section({ pane = 2, limit = 4 }),
				dashboard.bloocky.week_section({ pane = 2 }),
				{
					pane = 2,
					gap = 1,
					{ icon = "󰄲 ", key = "d", desc = "Todos (Dooing)", action = ":Dooing" },
					{ icon = "󰐕 ", key = "a", desc = "Add Todo", action = dooing_dash.add_todo },
					{ icon = "󰃭 ", key = "b", desc = "Time Blocks (Bloocky)", action = ":BloockyToggle" },
				},
			},
			preset = {
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
					{ icon = "󱎸 ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
				},
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
	},

	keys = {
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>G",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>tt",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
		},
	},

	init = function()
		-- redraw the todo/schedule panes whenever the dashboard is entered
		dashboard.setup()

		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Set timeout settings (from which-key)
				vim.o.timeout = true
				vim.o.timeoutlen = 100

				-- Create toggle mappings (which-key equivalent functionality)
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uW")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
