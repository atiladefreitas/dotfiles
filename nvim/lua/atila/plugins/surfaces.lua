local theme = require("atila.plugins.theme")

if vim.g.atila_transparent == nil then
	vim.g.atila_transparent = true
end

theme.on_change("surfaces", function(p)
	local hl = function(group, spec)
		vim.api.nvim_set_hl(0, group, spec)
	end

	local set_bg = function(group, bg)
		local spec = vim.api.nvim_get_hl(0, { name = group, link = false })
		spec.bg = bg
		vim.api.nvim_set_hl(0, group, spec)
	end

	local transparent = vim.g.atila_transparent

	hl("SignColumn", { bg = "NONE" })
	hl("LineNr", { bg = "NONE", fg = p.fg_dark })
	hl("CursorLineNr", { bg = "NONE", fg = p.yellow, bold = true })
	hl("FoldColumn", { bg = "NONE", fg = p.fg_dark })

	if transparent then
		set_bg("Normal", nil)
		set_bg("NormalNC", nil)
		hl("EndOfBuffer", { bg = "NONE", fg = p.bg_deep })
		hl("NonText", { bg = "NONE", fg = p.fg_dark })
		hl("WinBar", { bg = "NONE", fg = p.fg_dark })
		hl("WinBarNC", { bg = "NONE", fg = p.fg_dark })

		local line = theme.blend(p.cyan, p.bg, 0.26)
		hl("Visual", { bg = p.selection })
		hl("VisualNOS", { bg = p.selection })
		hl("CursorLine", { bg = line })
		hl("CursorColumn", { bg = line })

		hl("WinSeparator", { fg = theme.blend(p.fg_dark, p.bg, 0.85), bg = "NONE" })
	else
		set_bg("Normal", p.bg)
		set_bg("NormalNC", p.bg_inactive)
		hl("EndOfBuffer", { bg = "NONE", fg = p.bg_deep })
		hl("NonText", { bg = "NONE", fg = p.fg_dark })
		hl("WinBar", { bg = p.bg, fg = p.fg_dark })
		hl("WinBarNC", { bg = p.bg_inactive, fg = p.fg_dark })

		hl("WinSeparator", { fg = theme.blend(p.fg_dark, p.bg, 0.55), bg = p.bg_deep })
	end
	hl("VertSplit", { link = "WinSeparator" })

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
	hl("PmenuSel", { bg = theme.blend(p.blue, p.bg_raised, 0.28), fg = p.fg, bold = true })
	hl("PmenuSbar", { bg = theme.surface(p.bg_raised) })
	hl("PmenuThumb", { bg = theme.blend(p.fg_dark, p.bg_raised, 0.5) })

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
