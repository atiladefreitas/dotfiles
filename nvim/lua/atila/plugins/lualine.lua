local theme = require("atila.plugins.theme")

---@param p table palette
---@param accent string mode color
local function mode_colors(p, accent)
	if vim.g.atila_transparent then
		return {
			a = { bg = "NONE", fg = accent, gui = "bold" },
			b = { bg = "NONE", fg = accent },
			c = { bg = "NONE", fg = theme.blend(p.fg, p.fg_dark, 0.6) },
		}
	end
	return {
		a = { bg = accent, fg = p.on_accent, gui = "bold" },
		b = { bg = theme.blend(accent, p.bg_deep, 0.16), fg = accent },
		c = { bg = p.bg_deep, fg = p.fg_dark },
	}
end

---@param p table palette
local function build(p)
	-- Dimmed, but only against the page — blending toward bg_deep would put
	-- it a step further down than anything actually behind it, and over a
	-- wallpaper there is nothing behind it at all.
	local inactive = vim.g.atila_transparent
			and { bg = "NONE", fg = theme.blend(p.fg, p.fg_dark, 0.3) }
		or { bg = p.bg_deep, fg = theme.blend(p.fg_dark, p.bg_deep, 0.6) }
	return {
		normal = mode_colors(p, p.cyan),
		insert = mode_colors(p, p.green),
		visual = mode_colors(p, p.purple),
		replace = mode_colors(p, p.red),
		command = mode_colors(p, p.yellow),
		terminal = mode_colors(p, p.orange),
		inactive = { a = inactive, b = inactive, c = inactive },
	}
end

local function setup(p)
	require("lualine").setup({
		options = {
			theme = build(p),
			globalstatus = false,
			section_separators = "",
			component_separators = { left = "│", right = "│" },
		},
		sections = {
			lualine_c = {
				"filename",
				{
					function()
						return require("nvim-navic").get_location()
					end,
					cond = function()
						return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
					end,
				},
			},
			lualine_x = { "diagnostics", "filetype" },
		},
	})
end

theme.on_change("lualine", setup)
