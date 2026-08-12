return {
	-- beautiful time-blocking manager
	{
		dir = "~/Documents/projects/bloocky.nvim",
		cmd = { "Bloocky", "BloockyToggle", "BloockyAdd" },
		keys = {
			{ "<leader>tb", "<cmd>BloockyToggle<cr>", desc = "Bloocky: toggle calendar" },
		},
		config = function()
			require("bloocky").setup({
				integrations = {
					dooing = {
						enabled = true, -- show dooing todos on their due date
						show_done = false, -- set true to also show completed ones
					},
				},

				window = {
					-- How the calendar is displayed: "float" | "sidebar"
					mode = "float",

					-- Size per view: a fraction of the editor, absolute cells if > 1,
					-- or "full" for everything available. A single value applies to
					-- every view. Floating mode only.
					-- width = "full",
					-- height = "full",

					border = "rounded",

					-- Used when the calendar opens as a sidebar (a regular vertical split)
					sidebar = {
						position = "right", -- "left" | "right"
						width = 46, -- columns (or a fraction of the editor width if <= 1)
						view = "week", -- view the sidebar opens in
					},
				},
			})
		end,
	},
}
