-- ╭──────────────────────────────────────────────────────────────────╮
-- │  surfaces.lua — depth between windows                            │
-- │                                                                  │
-- │  Most schemes paint every window the same color, so a vertical    │
-- │  split reads as one wide buffer with a line through it. This      │
-- │  gives the surfaces a hierarchy instead:                          │
-- │                                                                  │
-- │      bg_raised    floats, completion menu, which-key             │
-- │      bg           the window you are typing in                    │
-- │      bg_inactive  the windows you are not                         │
-- │      bg_deep      sidebars, statusline                            │
-- │                                                                  │
-- │  With transparency on, the file buffers drop out of that stack    │
-- │  entirely and show the terminal through; every panel keeps its    │
-- │  surface, and the split seam does the separating. :Transparency   │
-- │  toggles it.                                                     │
-- │                                                                  │
-- │  Every color is derived from the loaded scheme (plugins/theme),   │
-- │  so this file knows nothing about which scheme that is and keeps  │
-- │  working if colorscheme.lua changes or breaks.                    │
-- ╰──────────────────────────────────────────────────────────────────╯

local theme = require("atila.plugins.theme")

-- Deliberately not gruvbox-material's own `transparent_background`: that
-- clears Normal before the palette is read, leaving nothing to derive the
-- panel surfaces from. Transparency is a presentation step, applied here
-- once the scheme's colors are already in hand.
if vim.g.atila_transparent == nil then
	vim.g.atila_transparent = true
end

theme.on_change("surfaces", function(p)
	local hl = function(group, spec)
		vim.api.nvim_set_hl(0, group, spec)
	end

	-- Change only the background, keeping everything else the scheme put on
	-- the group. nvim_set_hl replaces a group wholesale, so writing
	-- `{ bg = ... , fg = p.fg }` would hand Normal the palette's copy of its
	-- own foreground — and the next build() reads that copy straight back.
	-- One stale palette would then be baked in for the rest of the session.
	local set_bg = function(group, bg)
		local spec = vim.api.nvim_get_hl(0, { name = group, link = false })
		spec.bg = bg
		vim.api.nvim_set_hl(0, group, spec)
	end

	local transparent = vim.g.atila_transparent

	-- The gutter always stays background-less: a scheme that gives it a
	-- solid page-colored bg would leave a lit stripe down the side of every
	-- window that is not at page level.
	hl("SignColumn", { bg = "NONE" })
	hl("LineNr", { bg = "NONE", fg = p.fg_dark })
	hl("CursorLineNr", { bg = "NONE", fg = p.yellow, bold = true })
	hl("FoldColumn", { bg = "NONE", fg = p.fg_dark })

	if transparent then
		-- File buffers show the terminal through, focused or not. Anything
		-- that would otherwise paint a page-colored rectangle over the
		-- wallpaper — the area past the last line, the winbar — clears too.
		set_bg("Normal", nil)
		set_bg("NormalNC", nil)
		hl("EndOfBuffer", { bg = "NONE", fg = p.bg_deep })
		hl("NonText", { bg = "NONE", fg = p.fg_dark })
		hl("WinBar", { bg = "NONE", fg = p.fg_dark })
		hl("WinBarNC", { bg = "NONE", fg = p.fg_dark })

		-- With both windows transparent the seam is the only thing left
		-- separating them, so it carries the edge on its own: no bar of
		-- color behind it, and brighter than it needs to be when it has a
		-- change of surface to help.
		hl("WinSeparator", { fg = theme.blend(p.fg_dark, p.bg, 0.85), bg = "NONE" })
	else
		-- Unfocused windows recede — Neovim applies NormalNC on its own.
		set_bg("Normal", p.bg)
		set_bg("NormalNC", p.bg_inactive)
		hl("EndOfBuffer", { bg = "NONE", fg = p.bg_deep })
		hl("NonText", { bg = "NONE", fg = p.fg_dark })
		hl("WinBar", { bg = p.bg, fg = p.fg_dark })
		hl("WinBarNC", { bg = p.bg_inactive, fg = p.fg_dark })

		-- Dim enough to be trim, bright enough to be an edge.
		hl("WinSeparator", { fg = theme.blend(p.fg_dark, p.bg, 0.55), bg = p.bg_deep })
	end
	hl("VertSplit", { link = "WinSeparator" })

	-- Floats. Opaque, they rise above the page and the border hides in the
	-- panel's own color so the whole thing reads as one shape. Transparent,
	-- there is no shape — so the border becomes the only thing describing
	-- where the float ends, and has to actually be visible.
	hl("NormalFloat", { bg = theme.surface(p.bg_raised), fg = p.fg })
	hl("FloatBorder", {
		bg = theme.surface(p.bg_raised),
		fg = transparent and p.stroke or p.bg_raised,
	})
	hl("FloatTitle", {
		bg = theme.surface(p.bg_raised),
		fg = transparent and p.cyan or p.blue,
		bold = true,
	})
	hl("Pmenu", { bg = theme.surface(p.bg_raised), fg = p.fg })
	-- The selection keeps a real background either way: it is the one thing
	-- in a menu that has to be findable at a glance, and a transparent
	-- highlight highlights nothing.
	hl("PmenuSel", { bg = theme.blend(p.blue, p.bg_raised, 0.28), fg = p.fg, bold = true })
	hl("PmenuSbar", { bg = theme.surface(p.bg_raised) })
	hl("PmenuThumb", { bg = theme.blend(p.fg_dark, p.bg_raised, 0.5) })

	-- Statusline. lualine paints its own lualine_* groups over the whole
	-- bar, so these only show where it doesn't reach — but they have to
	-- agree with it, or the ends of the bar stay solid while the middle
	-- goes clear.
	-- Same brightened ink lualine.lua uses when there's no bar to sit on,
	-- so the ends of the statusline match the middle.
	local bar = transparent and { fg = theme.blend(p.fg, p.fg_dark, 0.6) }
		or { fg = p.fg_dark, bg = p.bg_deep }
	hl("StatusLine", bar)
	hl("StatusLineNC", bar)
end)

vim.api.nvim_create_user_command("Transparency", function()
	vim.g.atila_transparent = not vim.g.atila_transparent
	theme.repaint()
	vim.notify("Transparency " .. (vim.g.atila_transparent and "on" or "off"))
end, { desc = "Toggle the transparent editing area" })
