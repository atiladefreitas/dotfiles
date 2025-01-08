return {
	-- beautiful to-do item manager
	{
		-- "atiladefreitas/dooing",
		-- version = "*",
		dir = "~/Documents/plugins/dooing",
		config = function()
			require("dooing").setup({
				prioritization = true,
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
