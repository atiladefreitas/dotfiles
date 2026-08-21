-- ── ts-comments.nvim ────────────────────────────────────────────────
if vim.fn.has("nvim-0.10.0") == 1 then
	require("ts-comments").setup({})
end

-- ── flash.nvim ──────────────────────────────────────────────────────
require("flash").setup({})

-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, "-", function() require("flash").jump() end,       { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
-- stylua: ignore end

-- ── noice.nvim ──────────────────────────────────────────────────────
-- nvim-notify omitted on purpose: messages use the `mini` view below,
-- which is noice's fallback when notify isn't installed.
require("noice").setup({
	messages = { view = "mini", view_warn = "mini" },
})

-- ── which-key.nvim ──────────────────────────────────────────────────
-- Was which-key's lazy.nvim `init`: has to run before setup().
vim.o.timeout = true
vim.o.timeoutlen = 100

do
	-- tokyonight-inspired which-key highlights
	local bg = "#0f1019"
	local bg_dark = "#0a0b11"
	local blue = "#7aa2f7"
	local cyan = "#7dcfff"
	local purple = "#bb9af7"
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
end

require("which-key").setup({
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
	--  { "<leader>f", group = "Find", icon = " " },
	--  { "<leader>l", group = "LSP", icon = " " },
	--  { "<leader>g", group = "Git", icon = " " },
	--  { "<leader>x", group = "Diagnostics", icon = " " },
	--  { "<leader>u", group = "Toggle", icon = " " },
	--  { "<leader>c", group = "Code", icon = " " },
	--  { "<leader>a", group = "AI", icon = " " },
	--  { "<leader>t", group = "Terminal", icon = " " },
	-- },
})

-- ── trouble.nvim ────────────────────────────────────────────────────
require("trouble").setup({}) -- for custom options, refer to the configuration section

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- ── sidekick.nvim ───────────────────────────────────────────────────
require("sidekick").setup({
	-- add any options here
	cli = {
		mux = {
			backend = "tmux",
			enabled = true,
			-- open new CLI sessions in a tmux split (pane) instead of a Neovim terminal
			create = "split",
			split = {
				vertical = true, -- vertical split (pane on the side); set false for horizontal
				size = 0.4, -- 40% of the window
			},
		},
	},
})

vim.keymap.set("n", "<tab>", function()
	-- skip sidekick handling inside neo-tree
	if vim.bo.filetype == "neo-tree" then
		return "<Tab>"
	end
	-- if there is a next edit, jump to it, otherwise apply it if any
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>" -- fallback to normal tab
	end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle" })

vim.keymap.set("n", "<leader>aa", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI" })

vim.keymap.set("n", "<leader>as", function()
	require("sidekick.cli").select()
	-- Or to select only installed tools:
	-- require("sidekick.cli").select({ filter = { installed = true } })
end, { desc = "Select CLI" })

vim.keymap.set("n", "<leader>ad", function()
	require("sidekick.cli").close()
end, { desc = "Detach a CLI Session" })

vim.keymap.set({ "x", "n" }, "<leader>at", function()
	require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })

vim.keymap.set("n", "<leader>af", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })

vim.keymap.set("x", "<leader>av", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

vim.keymap.set({ "n", "x" }, "<leader>ap", function()
	require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })

-- Example of a keybinding to open Claude directly
vim.keymap.set("n", "<leader>ac", function()
	require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Toggle Claude" })
