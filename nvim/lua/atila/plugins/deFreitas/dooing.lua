return {
	-- beautiful to-do item manager
	{
		-- "atiladefreitas/dooing",
		dir = "~/Documents/projects/Dooing/dooing",
		lazy = false,
		cmd = "Dooing",
		keys = {
			{ "<leader>td", "<cmd>Dooing<CR>", desc = "Open Dooing" },
		},
		config = function()
			require("dooing").setup({
				ui = {
					style = "modern", -- "classic" | "modern"
				},
				timestamp = {
					enabled = true, -- Show relative timestamps (this is what `show_entered_date` meant)
				},
				sync = { server = { enabled = true } },
				keymaps = {
					show_due_notification = "<leader>tM",
					share_todos = "<leader>S", -- pick any free key
				},
				window = {
					-- `width`/`height` are deprecated; they now live under `dimensions`,
					-- which may also be a function for a size that adapts to the editor
					dimensions = {
						width = 80,
						height = 25,
					},
					border = "single", -- Border style: 'single', 'double', 'rounded', 'solid', or custom array
				},
				per_project = {
					enabled = true, -- Enable per-project todos
					default_filename = "dooing.json", -- Default filename for project todos
					auto_gitignore = true, -- Auto-add to .gitignore (true/false/"prompt")
					on_missing = "prompt", -- What to do when file missing ("prompt"/"auto_create")
					auto_open_project_todos = true,
				},
				calendar = {
					icon = "",
				},
			})
		end,
	},
}
