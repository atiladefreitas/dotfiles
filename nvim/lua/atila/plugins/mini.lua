-- Standalone mini modules only. `mini.nvim` (the full ~40-module collection)
-- was previously pulled in just for mini.move.

-- ── mini.cursorword ─────────────────────────────────────────────────
require("mini.cursorword").setup({
	delay = 100,
})
vim.keymap.set(
	"n",
	"<leader>cE",
	function() require("mini.cursorword").toggle() end,
	{ silent = true, desc = "Toggle cursorword highlight" }
)

-- ── mini.move ───────────────────────────────────────────────────────
require("mini.move").setup({
	mappings = {
		-- Move visual selection in Visual mode
		down = "<a-j>",
		up = "<a-k>",
		-- Move current line in Normal mode
		line_down = "<a-j>",
		line_up = "<a-k>",
	},
	options = {
		reindent_linewise = true,
	},
})

-- ── mini.pairs ──────────────────────────────────────────────────────
require("mini.pairs").setup({
	modes = { insert = true, command = false, terminal = false },

	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

		[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

		['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
		["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
		["*"] = { action = "closeopen", pair = "**", neigh_pattern = "[^\\].", register = { cr = false } },
	},
})

-- ── mini.surround ───────────────────────────────────────────────────
-- Plugin builds its own mappings (operator-pending in Normal, `:<C-u>` in
-- Visual so '< '> marks are fresh). Calling MiniSurround.add("visual") from a
-- Lua keymap runs before Visual mode exits -> stale marks -> "out of range".
require("mini.surround").setup({
    mappings = {
        add = "<leader>sa",
        delete = "<leader>sd",
        replace = "<leader>sr",
        find = "<leader>sf",
        find_left = "<leader>sF",
        highlight = "<leader>sh",
        update_n_lines = "<leader>sn",
        suffix_last = "l",
        suffix_next = "n",
    },
})
