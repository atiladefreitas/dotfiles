return {
	-- beautiful to-do item manager
	{
		"atiladefreitas/dooing",
		version = "*",
		config = function()
			require("dooing").setup({
				prioritization = true,
				show_entered_date = true,
				window = {
					width = 80,
				},
				calendar = {
					icon = "",
				},
			})
		end,
	},
}
