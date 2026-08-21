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
-- Default mappings disabled; bound under <leader>s below.
require("mini.surround").setup({
	mappings = {
		add = "",
		delete = "",
		find = "",
		find_left = "",
		highlight = "",
		replace = "",
		update_n_lines = "",
	},
})

local map = function(mode, lhs, fn, desc)
	vim.keymap.set(mode, lhs, fn, { silent = true, desc = desc })
end

map({ "n", "x" }, "<leader>sa", function() MiniSurround.add("visual") end, "Add surround")
map("n", "<leader>sd", function() MiniSurround.delete() end, "Delete surround")
map("n", "<leader>sr", function() MiniSurround.replace() end, "Replace surround")
map("n", "<leader>sf", function() MiniSurround.find() end, "Find surround")
map("n", "<leader>sF", function() MiniSurround.find_left() end, "Find surround left")
map("n", "<leader>sh", function() MiniSurround.highlight() end, "Highlight surround")
map("n", "<leader>sn", function() MiniSurround.update_n_lines() end, "Update n lines")
