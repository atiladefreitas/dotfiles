return {
	"b0o/incline.nvim",
	enabled = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "BufReadPre",
	config = function()
		local devicons = require("nvim-web-devicons")

		require("incline").setup({
			window = {
				placement = {
					horizontal = "center",
					vertical = "top",
				},
				padding = 0,
				margin = {
					horizontal = 1,
					vertical = 1,
				},
				zindex = 50,
			},
			hide = {
				only_win = false,
			},
			render = function(props)
				local bufname = vim.api.nvim_buf_get_name(props.buf)
				local filename = vim.fn.fnamemodify(bufname, ":t")
				if filename == "" then
					filename = "[No Name]"
				end

				local ext = vim.fn.fnamemodify(bufname, ":e")
				local icon, icon_color = devicons.get_icon_color(filename, ext, { default = true })

				local modified = vim.bo[props.buf].modified
				local is_active = props.focused

				local bg = is_active and "#1a1d29" or "#11131c"
				local fg = is_active and "#c0caf5" or "#565f89"

				local result = {
					{ " ", guibg = bg },
					{ icon .. " ", guifg = icon_color, guibg = bg },
					{ filename, guifg = fg, guibg = bg, gui = modified and "bold,italic" or "bold" },
				}

				if modified then
					table.insert(result, { "  ", guifg = "#ff9e64", guibg = bg })
				end

				table.insert(result, { " ", guibg = bg })

				return result
			end,
		})
	end,
}
