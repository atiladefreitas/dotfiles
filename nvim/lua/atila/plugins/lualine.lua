-- ╭──────────────────────────────────────────────────────────────────╮
-- │  lualine.lua — statusline, in the page's own colors               │
-- │                                                                  │
-- │  lualine's `theme = "auto"` matches on the colorscheme's *name*,  │
-- │  so it loaded its bundled gruvbox theme: stock gruvbox greys      │
-- │  (#3c3836, #504945) against our darkened page, and saturated      │
-- │  blocks brighter than anything else on screen. Derive the theme   │
-- │  from plugins/theme.lua instead, like the rest of the config.     │
-- ╰──────────────────────────────────────────────────────────────────╯

local theme = require("atila.plugins.theme")

-- Statusline sits at the bottom of the surface stack with the sidebars —
-- same `bg_deep` colorscheme.lua paints StatusLine with, so the bar and
-- the gap under a split read as one surface.
---@param p table palette
---@param accent string mode color
local function mode_colors(p, accent)
	return {
		a = { bg = accent, fg = p.on_accent, gui = "bold" },
		-- A tint of the mode color rather than another grey step: b would
		-- otherwise be indistinguishable from c on this dark a page.
		b = { bg = theme.blend(accent, p.bg_deep, 0.16), fg = accent },
		c = { bg = p.bg_deep, fg = p.fg_dark },
	}
end

---@param p table palette
local function build(p)
	local inactive = { bg = p.bg_deep, fg = theme.blend(p.fg_dark, p.bg_deep, 0.6) }
	-- `cyan` for normal, not `blue`: gruvbox has no blue in its syntax
	-- groups, so theme.lua mints one, and a minted accent is the wrong
	-- thing to put on the block that's on screen all day. The roles below
	-- are all colors the scheme actually paints with.
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
			-- No chevrons. Sections are already told apart by their
			-- background, and the same flat surfaces the floats and
			-- sidebars use read better than a row of arrows.
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
			-- Encoding and fileformat are the same for every file this
			-- config ever opens; the filetype icon carries what's left.
			lualine_x = { "diagnostics", "filetype" },
		},
	})
end

-- Rebuilt on :colorscheme — lualine only re-resolves its own theme when it
-- was given a name, and we hand it a table.
theme.on_change("lualine", setup)
