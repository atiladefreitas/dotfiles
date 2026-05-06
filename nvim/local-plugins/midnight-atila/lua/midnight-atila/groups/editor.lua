-- Editor / UI highlight groups
local M = {}

function M.get(c, opts)
	local bg = opts.transparent and c.none or c.bg
	local bg_dark = opts.transparent and c.none or c.bg_dark
	local bg_statusline = opts.transparent and c.none or c.bg_statusline
	local bg_float = opts.transparent and c.none or c.bg_float

	return {
		-- Base UI
		Normal = { fg = c.fg, bg = bg },
		NormalNC = { fg = c.fg, bg = bg },
		NormalFloat = { fg = c.fg, bg = bg_float },
		FloatBorder = { fg = c.border_focus, bg = bg_float },
		FloatTitle = { fg = c.blue_bright, bg = bg_float, bold = true },

		-- Cursor / cursorline
		Cursor = { fg = c.bg, bg = c.fg },
		CursorLine = { bg = c.bg_highlight },
		CursorColumn = { bg = c.bg_highlight },
		ColorColumn = { bg = c.bg_dark },

		-- Line numbers
		LineNr = { fg = c.fg_gutter, bg = bg },
		CursorLineNr = { fg = c.blue_bright, bg = c.bg_highlight, bold = true },
		SignColumn = { fg = c.fg_gutter, bg = bg },

		-- Selection / search
		Visual = { bg = c.bg_visual },
		VisualNOS = { bg = c.bg_visual },
		Search = { fg = c.fg, bg = c.bg_search, bold = true },
		IncSearch = { fg = c.bg, bg = c.yellow, bold = true },
		CurSearch = { fg = c.bg, bg = c.yellow_bright, bold = true },
		Substitute = { fg = c.bg, bg = c.red, bold = true },
		MatchParen = { fg = c.yellow_bright, bold = true, underline = true },

		-- Splits / windows
		WinSeparator = { fg = c.border, bg = bg },
		VertSplit = { fg = c.border, bg = bg },

		-- Statusline
		StatusLine = { fg = c.fg_dim, bg = bg_statusline },
		StatusLineNC = { fg = c.fg_dark, bg = bg_statusline },

		-- Tabline
		TabLine = { fg = c.fg_dark, bg = c.bg_tabline },
		TabLineFill = { bg = c.bg_tabline },
		TabLineSel = { fg = c.blue_bright, bg = c.bg, bold = true },

		-- Pmenu (completion)
		Pmenu = { fg = c.fg, bg = c.bg_popup },
		PmenuSel = { fg = c.blue_bright, bg = c.bg_highlight, bold = true },
		PmenuSbar = { bg = c.bg_dark },
		PmenuThumb = { bg = c.fg_gutter },
		PmenuKind = { fg = c.purple, bg = c.bg_popup },
		PmenuKindSel = { fg = c.purple, bg = c.bg_highlight, bold = true },
		PmenuExtra = { fg = c.fg_dark, bg = c.bg_popup },
		PmenuExtraSel = { fg = c.fg_dim, bg = c.bg_highlight },

		-- Folds (bold colored background bar with purple accent)
		Folded = { fg = c.purple_bright, bg = c.bg_visual, bold = true, italic = true },
		FoldColumn = { fg = c.purple, bg = bg, bold = true },
		CursorLineFold = { fg = c.purple_bright, bg = c.bg_highlight, bold = true },

		-- Diff
		DiffAdd = { bg = c.diff_add },
		DiffChange = { bg = c.diff_change },
		DiffDelete = { bg = c.diff_delete },
		DiffText = { bg = c.diff_text, bold = true },

		-- Spell
		SpellBad = { sp = c.error, undercurl = true },
		SpellCap = { sp = c.warning, undercurl = true },
		SpellLocal = { sp = c.info, undercurl = true },
		SpellRare = { sp = c.hint, undercurl = true },

		-- Messages
		ErrorMsg = { fg = c.error, bold = true },
		WarningMsg = { fg = c.warning, bold = true },
		MoreMsg = { fg = c.green, bold = true },
		Question = { fg = c.blue, bold = true },
		ModeMsg = { fg = c.fg_dim, bold = true },
		MsgArea = { fg = c.fg_dim },
		NonText = { fg = c.fg_gutter },
		SpecialKey = { fg = c.fg_gutter },
		Whitespace = { fg = c.fg_gutter },
		EndOfBuffer = { fg = c.bg_dark },
		Conceal = { fg = c.fg_dim },
		Directory = { fg = c.blue_bright, bold = true },
		Title = { fg = c.blue_bright, bold = true },

		-- Quickfix
		qfLineNr = { fg = c.fg_gutter },
		qfFileName = { fg = c.blue },

		-- Floats
		WinBar = { fg = c.fg_dim, bg = bg },
		WinBarNC = { fg = c.fg_dark, bg = bg },

		-- Yank highlight
		Snippet = { fg = c.green_bright },
	}
end

return M
