return {
	"echasnovski/mini.jump2d",
	version = false,

	config = function()
		require("mini.jump2d").setup({
			allowed_lines = {
				blank = false, -- Blank line (not sent to spotter even if `true`)
				cursor_before = false, -- Lines before cursor line
				cursor_at = true, -- Cursor line
				cursor_after = false, -- Lines after cursor line
				fold = false, -- Start of fold (not sent to spotter even if `true`)
			},
		})
	end,
}
