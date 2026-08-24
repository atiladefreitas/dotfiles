-- ╭──────────────────────────────────────────────────────────────────╮
-- │  colorscheme.lua — gruvbox, a few shades down                    │
-- │                                                                  │
-- │  Loaded first (see plugins/init.lua) so every later highlight    │
-- │  override wins. Everything downstream reads its colors back out  │
-- │  of whatever is set here via plugins/theme.lua — change the      │
-- │  scheme below and telescope, neo-tree, which-key and markdown    │
-- │  follow on their own.                                            │
-- ╰──────────────────────────────────────────────────────────────────╯

vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim",
})

-- Gruvbox's own "hard" background is #1d2021; this goes a little further
-- down and drops its blue cast. One knob — everything else on the page is
-- derived from it.
local PAGE = "#1a1a1a"

require("gruvbox").setup({
	contrast = "hard",
	palette_overrides = {
		dark0_hard = PAGE,
		dark0 = PAGE,
	},
})

vim.cmd.colorscheme("gruvbox")

-- ── Depth between windows ───────────────────────────────────────────
-- Gruvbox paints every window the same color, so a vertical split reads
-- as one wide buffer with a line through it. Give the surfaces a
-- hierarchy instead: the window you're typing in stays at page level,
-- unfocused windows sink, sidebars sink furthest, and floats rise above
-- everything. Derived from the palette, so it survives a scheme change.
local theme = require("atila.plugins.theme")

theme.on_change("surfaces", function(p)
	local hl = function(group, spec)
		vim.api.nvim_set_hl(0, group, spec)
	end

	-- Unfocused windows recede — Neovim applies NormalNC on its own. The
	-- gutter has to stay background-less, though: gruvbox gives it a solid
	-- page-colored bg, which would leave a lit stripe down the side of
	-- every window that just sank.
	hl("NormalNC", { bg = p.bg_inactive, fg = p.fg })
	hl("SignColumn", { bg = "NONE" })
	hl("LineNr", { bg = "NONE", fg = p.fg_dark })
	hl("CursorLineNr", { bg = "NONE", fg = p.yellow, bold = true })
	hl("FoldColumn", { bg = "NONE", fg = p.fg_dark })

	-- The seam itself: dim enough to be trim, bright enough to be an edge.
	hl("WinSeparator", { fg = theme.blend(p.fg_dark, p.bg, 0.55), bg = p.bg_deep })
	hl("VertSplit", { link = "WinSeparator" })

	-- Floats rise. Border in the float's own color so it reads as one
	-- panel rather than a box drawn around it.
	hl("NormalFloat", { bg = p.bg_raised, fg = p.fg })
	hl("FloatBorder", { bg = p.bg_raised, fg = p.bg_raised })
	hl("FloatTitle", { bg = p.bg_raised, fg = p.blue, bold = true })
	hl("Pmenu", { bg = p.bg_raised, fg = p.fg })
	-- The raised surface is already close to CursorLine, so tint the
	-- selection with the accent instead of stepping it up another shade.
	hl("PmenuSel", { bg = theme.blend(p.blue, p.bg_raised, 0.28), fg = p.fg, bold = true })
	hl("PmenuSbar", { bg = p.bg_raised })
	hl("PmenuThumb", { bg = theme.blend(p.fg_dark, p.bg_raised, 0.5) })

	-- Statusline sits with the sidebars, at the bottom of the stack.
	hl("StatusLine", { bg = p.bg_deep, fg = p.fg_dark })
	hl("StatusLineNC", { bg = p.bg_deep, fg = p.fg_dark })
	hl("WinBar", { bg = p.bg, fg = p.fg_dark })
	hl("WinBarNC", { bg = p.bg_inactive, fg = p.fg_dark })
end)
