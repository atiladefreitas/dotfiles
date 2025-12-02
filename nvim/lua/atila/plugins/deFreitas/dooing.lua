return {
	-- beautiful to-do item manager
	{
		-- "atiladefreitas/dooing",
		dir = "~/Documents/plugins/dooing",
		config = function()
			require("dooing").setup({
				prioritization = true,
				show_entered_date = true,
				keymaps = {
					show_due_notification = "<leader>tM",
				},
				window = {
					width = 80,
					border = "single", -- Border style: 'single', 'double', 'rounded', 'solid', 'shadow', or custom array
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
