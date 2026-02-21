return {
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
    -- stylua: ignore
    keys = {
      { "-", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			messages = { view = "mini", view_warn = "mini" },
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 100

			-- tokyonight-inspired which-key highlights
			local bg = "#0f1019"
			local bg_dark = "#0a0b11"
			local bg_highlight = "#1a1d29"
			local blue = "#7aa2f7"
			local cyan = "#7dcfff"
			local purple = "#bb9af7"
			local green = "#9ece6a"
			local orange = "#ff9e64"
			local fg = "#c0caf5"
			local fg_dark = "#565f89"

			vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = bg, fg = fg })
			vim.api.nvim_set_hl(0, "WhichKeyBorder", { bg = bg, fg = bg })
			vim.api.nvim_set_hl(0, "WhichKeyTitle", { bg = blue, fg = bg_dark, bold = true })
			vim.api.nvim_set_hl(0, "WhichKey", { fg = cyan, bold = true })
			vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = purple })
			vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = fg })
			vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = fg_dark })
			vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = fg_dark })
		end,
		opts = {
			preset = "modern",
			win = {
				border = "rounded",
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
				wo = {
					winblend = 0,
				},
			},
			layout = {
				spacing = 3,
				align = "center",
			},
			icons = {
				breadcrumb = " ",
				separator = " ",
				group = " ",
				mappings = true,
				rules = {},
				colors = true,
			},
			-- spec = {
			-- 	{ "<leader>f", group = "Find", icon = " " },
			-- 	{ "<leader>l", group = "LSP", icon = " " },
			-- 	{ "<leader>g", group = "Git", icon = " " },
			-- 	{ "<leader>x", group = "Diagnostics", icon = " " },
			-- 	{ "<leader>u", group = "Toggle", icon = " " },
			-- 	{ "<leader>c", group = "Code", icon = " " },
			-- 	{ "<leader>a", group = "AI", icon = " " },
			-- 	{ "<leader>t", group = "Terminal", icon = " " },
			-- },
		},
	},

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{
		"folke/sidekick.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					-- skip sidekick handling inside neo-tree
					if vim.bo.filetype == "neo-tree" then
						return "<Tab>"
					end
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<c-.>",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select()
				end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			-- Example of a keybinding to open Claude directly
			{
				"<leader>ac",
				function()
					require("sidekick.cli").toggle({ name = "claude", focus = true })
				end,
				desc = "Sidekick Toggle Claude",
			},
		},
	},
}
