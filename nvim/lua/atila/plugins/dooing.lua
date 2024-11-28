return {
	{
		-- "atiladefreitas/dooing",
		-- version = "v1.6.0-alpha",
		dir = "~/Documents/dooing-prio/dooing",
		config = function()
			require("dooing").setup({
				prioritization = true,
			})
		end,
	},
}
