return {
	{
		"atiladefreitas/dooing",
		-- version = "*",
		-- dir = "~/Documents/dooing",
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
