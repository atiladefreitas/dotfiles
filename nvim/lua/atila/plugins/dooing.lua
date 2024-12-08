return {
	{
		-- "atiladefreitas/dooing",
		-- version = "*",
		dir = "~/Documents/plugins/dooing",
		config = function()
			require("dooing").setup({
				prioritization = true,
				calendar = {
					icon = "",
				},
			})
		end,
	},
}
