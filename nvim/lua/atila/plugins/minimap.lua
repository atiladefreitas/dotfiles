return {
	"Isrothy/neominimap.nvim",
	version = "v3.*.*",
	enabled = true,
	lazy = false, -- NOTE: NO NEED to Lazy load
	keys = {
		-- Global Minimap Controls
		{ "<leader>nm", "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap" },
		--
		-- -- Buffer-Specific Minimap Controls
		{ "<leader>nbt", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
	},
	init = function()
		vim.g.neominimap = {
			auto_enable = false,

			layout = "float",

			winhighlight = table.concat({
				"Normal:NeominimapBackground",
				"CursorLine:NeominimapCursorLine",
				"CursorLineNr:NeominimapCursorLineNr",
				"CursorLineSign:NeominimapCursorLineSign",
				"CursorLineFold:NeominimapCursorLineFold",
			}, ","),
		}
	end,
}
