-- midnight-atila palette
-- A balance between Tokyo Night, Dracula, and Catppuccin
-- High-contrast, near-black, Dracula-saturated, blue-accented
local M = {}

M.colors = {
	-- Backgrounds (very deep near-black with subtle blue undertone)
	bg = "#090a12", -- main editor background (very deep near-black)
	bg_dark = "#05060b", -- darker (sidebars, NeoTree, tabline)
	bg_darker = "#020306", -- darkest (statusline edges, deep wells)
	bg_highlight = "#141622", -- cursorline (subtle lift from bg)
	bg_visual = "#2a2854", -- visual selection (vibrant purple-blue)
	bg_search = "#3d59a1", -- search match background
	bg_float = "#0d0e17", -- floating window bg (slightly above bg)
	bg_popup = "#10111b", -- popup menu bg
	bg_statusline = "#06070d", -- statusline bg
	bg_tabline = "#05060b", -- tabline / bufferline bg

	-- Foregrounds (lifted for more pop)
	fg = "#ffffff", -- main text (pure white)
	fg_dim = "#bac2e0", -- secondary text (lifted)
	fg_dark = "#8a92b8", -- dimmer text (lifted)
	fg_gutter = "#454963", -- line numbers (inactive, slightly more visible)
	fg_gutter_active = "#d0d6ff", -- active line number

	-- Comments / non-essential (more readable but still subtle)
	comment = "#6c7393", -- muted gray, italic
	muted = "#5a5e7e",

	-- Borders / separators
	border = "#33364a",
	border_focus = "#9bb8ff",

	-- Core syntax accents (brighter + more saturated for high pop on deep bg)
	blue = "#9bb8ff", -- functions, links, accent (was #7aa2f7)
	blue_bright = "#a8c5ff", -- bright blue (accents, focus)
	blue_deep = "#4d6bc4", -- deep blue (helper)
	cyan = "#7a93e8", -- medium-deep blue (operators, punctuation, special)
	cyan_bright = "#95acf0", -- brighter medium-deep blue (properties, fields)
	teal = "#2dd4bf",

	purple = "#cdb0ff", -- keywords (was #bb9af7)
	purple_bright = "#d8b4ff", -- numbers/constants (was #c39bff)
	magenta = "#ff8ed4", -- pink/magenta (was #ff79c6)
	pink = "#ffc8e6", -- soft pink (was #f5c2e7)

	green = "#b9e077", -- strings (was #9ece6a, more vivid)
	green_bright = "#7affa0", -- bright green (was #50fa7b)
	sage = "#bdebb0", -- catppuccin green (lifted)

	yellow = "#f5c378", -- types/classes (was #e0af68, brighter gold)
	yellow_bright = "#ffff8e", -- bright yellow (was #f1fa8c)
	gold = "#ffd97a",

	orange = "#ffb380", -- numbers alt / md (was #ff9e64)
	peach = "#ffc7a3", -- catppuccin peach (lifted)

	red = "#ff8da3", -- errors / delete (was #f7768e)
	red_bright = "#ff6b6b", -- bright error (was #ff5555)
	maroon = "#f0b3bd", -- catppuccin maroon (lifted)

	-- Diagnostics
	error = "#ff5555",
	warning = "#e0af68",
	info = "#7dcfff",
	hint = "#1abc9c",
	ok = "#9ece6a",

	-- Diff
	diff_add = "#1f3a2d",
	diff_change = "#1c2c4a",
	diff_delete = "#3a1f23",
	diff_text = "#264f78",

	-- Git
	git_add = "#9ece6a",
	git_change = "#7aa2f7",
	git_delete = "#f7768e",

	-- Markdown rainbow headings (H1-H6) - vivid pop
	md_h1 = "#ff6b6b", -- red
	md_h2 = "#ffb380", -- orange
	md_h3 = "#ffff8e", -- yellow
	md_h4 = "#b9e077", -- green
	md_h5 = "#9bb8ff", -- blue
	md_h6 = "#cdb0ff", -- purple

	-- Terminal ANSI (16 colors) - aligned with brighter palette
	term = {
		black = "#090a12",
		red = "#ff8da3",
		green = "#b9e077",
		yellow = "#f5c378",
		blue = "#9bb8ff",
		magenta = "#cdb0ff",
		cyan = "#7a93e8",
		white = "#bac2e0",
		bright_black = "#6c7393",
		bright_red = "#ff6b6b",
		bright_green = "#7affa0",
		bright_yellow = "#ffff8e",
		bright_blue = "#a8c5ff",
		bright_magenta = "#ff8ed4",
		bright_cyan = "#95acf0",
		bright_white = "#ffffff",
	},

	none = "NONE",
}

return M
