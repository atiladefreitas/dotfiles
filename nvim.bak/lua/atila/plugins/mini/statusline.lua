return {
	"echasnovski/mini.statusline",
	version = "*",
	config = function()
		require("mini.statusline").setup({
			content = {
				-- Content for active window
				active = nil,
				-- Content for inactive window(s)
				inactive = nil,
			},

			-- Whether to use icons by default
			use_icons = true,

			-- Whether to set Vim's settings for statusline (make it always shown)
			set_vim_settings = true,
		})
	end,
}
