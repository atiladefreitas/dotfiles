-- homepagge
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "hub status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
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
		notifier = { enabled = false },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		lazygit = {
			enabled = true,
			---@class snacks.lazygit.Config: snacks.terminal.Opts
			---@field args? string[]
			---@field theme? snacks.lazygit.Theme
			{
				-- automatically configure lazygit to use the current colorscheme
				-- and integrate edit with the current neovim instance
				configure = true,
				-- extra configuration for lazygit that will be merged with the default
				-- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
				-- you need to double quote it: `"\"test\""`
				config = {
					os = { editPreset = "nvim-remote" },
					gui = {
						-- set to an empty string "" to disable icons
						nerdFontsVersion = "3",
					},
				},
				theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
				-- Theme for lazygit
				theme = {
					[241] = { fg = "Special" },
					activeBorderColor = { fg = "MatchParen", bold = true },
					cherryPickedCommitBgColor = { fg = "Identifier" },
					cherryPickedCommitFgColor = { fg = "Function" },
					defaultFgColor = { fg = "Normal" },
					inactiveBorderColor = { fg = "FloatBorder" },
					optionsTextColor = { fg = "Function" },
					searchingActiveBorderColor = { fg = "MatchParen", bold = true },
					selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
					unstagedChangesColor = { fg = "DiagnosticError" },
				},
				win = {
					style = "lazygit",
				},
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
		-- Trouble-equivalent diagnostics keymaps
		{
			"<leader>xw",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Workspace Diagnostics",
		},
		{
			"<leader>xd",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Document Diagnostics",
		},
		{
			"<leader>xq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>xl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},
	},

	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Set timeout settings (from which-key)
				vim.o.timeout = true
				vim.o.timeoutlen = 500

				-- Create toggle mappings (which-key equivalent functionality)
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
