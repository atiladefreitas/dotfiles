local M = {}

local function to_hex(n)
	return n and ("#%06x"):format(n) or nil
end

local function to_rgb(hex)
	local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
	if not r then
		return 0, 0, 0
	end
	return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

function M.blend(fg, bg, alpha)
	local fr, fg_, fb = to_rgb(fg)
	local br, bg_, bb = to_rgb(bg)
	local mix = function(a, b)
		return math.floor(math.min(255, math.max(0, b + (a - b) * alpha)) + 0.5)
	end
	return ("#%02x%02x%02x"):format(mix(fr, br), mix(fg_, bg_), mix(fb, bb))
end

function M.shade(hex, amount)
	return M.blend(amount < 0 and "#000000" or "#ffffff", hex, math.abs(amount))
end

function M.luminance(hex)
	local r, g, b = to_rgb(hex)
	return (0.299 * r + 0.587 * g + 0.114 * b) / 255
end

local function hue_sat(hex)
	local r, g, b = to_rgb(hex)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local delta = max - min
	if delta < 1e-6 then
		return 0, 0
	end
	local h
	if max == r then
		h = ((g - b) / delta) % 6
	elseif max == g then
		h = (b - r) / delta + 2
	else
		h = (r - g) / delta + 4
	end
	local light = (max + min) / 2
	return h * 60, delta / (1 - math.abs(2 * light - 1)), light, delta
end

local function hsl_to_hex(h, s, l)
	local c = (1 - math.abs(2 * l - 1)) * s
	local x = c * (1 - math.abs((h / 60) % 2 - 1))
	local m = l - c / 2
	local r, g, b
	if h < 60 then r, g, b = c, x, 0
	elseif h < 120 then r, g, b = x, c, 0
	elseif h < 180 then r, g, b = 0, c, x
	elseif h < 240 then r, g, b = 0, x, c
	elseif h < 300 then r, g, b = x, 0, c
	else r, g, b = c, 0, x end
	local byte = function(v)
		return math.floor(math.min(255, math.max(0, (v + m) * 255)) + 0.5)
	end
	return ("#%02x%02x%02x"):format(byte(r), byte(g), byte(b))
end

local function hue_gap(a, b)
	local d = math.abs(a - b) % 360
	return d > 180 and 360 - d or d
end

local function hl(name)
	local ok, group = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	return ok and group or {}
end

local SCHEME_OWNED = {
	"Normal",
	"NormalFloat",
	"Pmenu",
	"CursorLine",
	"Visual",
	"Comment",
	"NonText",
	"LineNr",
	"FloatBorder",
	"WinSeparator",
}

M.scheme = {}

function M.capture()
	M.scheme = {}
	for _, group in ipairs(SCHEME_OWNED) do
		local spec = hl(group)
		if spec.fg or spec.bg then
			M.scheme[group] = spec
		end
	end
end

local function scheme_hl(name)
	return M.scheme[name] or hl(name)
end

local function readable(color, bg)
	local a, b = M.luminance(color) + 0.05, M.luminance(bg) + 0.05
	return (math.max(a, b) / math.min(a, b)) >= 1.5
end

local function pick(candidates, bg, fallback)
	for _, candidate in ipairs(candidates) do
		local value = to_hex(scheme_hl(candidate[1])[candidate[2]])
		if value and (candidate[2] == "bg" or readable(value, bg)) then
			return value
		end
	end
	return fallback
end

function M.build()
	if vim.tbl_isempty(M.scheme) then
		M.capture()
	end
	local normal = scheme_hl("Normal")
	local bg = to_hex(normal.bg) or (vim.o.background == "dark" and "#000000" or "#ffffff")
	local fg = to_hex(normal.fg) or (vim.o.background == "dark" and "#c0caf5" or "#333333")
	local dark = M.luminance(bg) < 0.5

	local recede = dark and -0.30 or 0.35
	local emerge = dark and 0.10 or -0.06

	local p = {
		bg = bg,
		fg = fg,
		dark = dark,

		bg_dark = M.shade(bg, recede),
		bg_inactive = M.shade(bg, recede),
		bg_deep = M.shade(bg, recede * 1.5),
		bg_raised = M.shade(bg, emerge),

		bg_float = pick({ { "NormalFloat", "bg" }, { "Pmenu", "bg" } }, bg, bg),
		bg_highlight = pick({ { "CursorLine", "bg" }, { "Visual", "bg" } }, bg, M.shade(bg, emerge)),
		bg_visual = pick({ { "Visual", "bg" } }, bg, M.shade(bg, emerge * 1.6)),

		fg_dark = pick({ { "Comment", "fg" }, { "NonText", "fg" }, { "LineNr", "fg" } }, bg, M.blend(fg, bg, 0.45)),
		border = pick({ { "FloatBorder", "fg" }, { "WinSeparator", "fg" }, { "LineNr", "fg" } }, bg, M.blend(fg, bg, 0.3)),
	}

	local pool = {}
	local seen = {}
	for _, group in ipairs({
		"Function", "String", "Keyword", "Statement", "Type", "Constant", "Number",
		"Special", "Identifier", "PreProc", "Operator", "Directory", "Title",
		"DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint",
		"@constructor", "@variable.member", "@string.escape", "@keyword", "@type", "@function",
	}) do
		local color = to_hex(scheme_hl(group).fg)
		if color and not seen[color] and readable(color, bg) then
			local h, s, l, chroma = hue_sat(color)
			if s >= 0.15 and chroma >= 0.08 then
				seen[color] = true
				pool[#pool + 1] = { color = color, hue = h, sat = s, light = l }
			end
		end
	end

	local roles = {
		{ "red", 0, "#f7768e" },
		{ "orange", 20, "#ff9e64" },
		{ "yellow", 45, "#e0af68" },
		{ "green", 120, "#9ece6a" },
		{ "cyan", 185, "#7dcfff" },
		{ "blue", 220, "#7aa2f7" },
		{ "purple", 285, "#bb9af7" },
	}

	local pairs_by_gap = {}
	for _, role in ipairs(roles) do
		for _, candidate in ipairs(pool) do
			pairs_by_gap[#pairs_by_gap + 1] = {
				role = role[1],
				color = candidate.color,
				gap = hue_gap(role[2], candidate.hue),
			}
		end
	end
	table.sort(pairs_by_gap, function(a, b)
		return a.gap < b.gap
	end)

	local MAX_GAP = 60

	local taken = {}
	for _, match in ipairs(pairs_by_gap) do
		if match.gap <= MAX_GAP and not p[match.role] and not taken[match.color] then
			p[match.role] = match.color
			taken[match.color] = true
		end
	end

	local sat_total, light_total = 0, 0
	for _, candidate in ipairs(pool) do
		sat_total = sat_total + candidate.sat
		light_total = light_total + candidate.light
	end
	for _, role in ipairs(roles) do
		if not p[role[1]] then
			p[role[1]] = #pool > 0 and hsl_to_hex(role[2], sat_total / #pool, light_total / #pool)
				or role[3]
		end
	end

	p.magenta = p.purple
	p.amber = p.yellow

	p.git_add = pick({ { "GitSignsAdd", "fg" }, { "diffAdded", "fg" } }, bg, p.green)
	p.git_change = pick({ { "GitSignsChange", "fg" }, { "diffChanged", "fg" } }, bg, p.yellow)
	p.git_delete = pick({ { "GitSignsDelete", "fg" }, { "diffRemoved", "fg" } }, bg, p.red)

	p.selection = vim.g.atila_transparent and M.blend(p.cyan, bg, 0.45) or p.bg_highlight

	p.directory = pick({ { "Directory", "fg" }, { "@module", "fg" } }, bg, p.cyan)

	p.on_accent = dark and p.bg_dark or M.shade(bg, -0.85)

	p.stroke = M.blend(fg, p.fg_dark, 0.35)

	return p
end

M.capture()
M.palette = M.build()

M.palette_scheme = vim.g.colors_name

function M.surface(color)
	return vim.g.atila_transparent and "NONE" or color
end

local painters = {}

function M.on_change(name, fn)
	painters[name] = fn
	if M.palette_scheme ~= vim.g.colors_name then
		M.palette_scheme = vim.g.colors_name
		M.palette = M.build()
	end
	local ok, err = pcall(fn, M.palette)
	if not ok then
		vim.schedule(function()
			vim.notify(("theme: %s failed to paint:\n%s"):format(name, err), vim.log.levels.ERROR)
		end)
	end
end

function M.repaint()
	M.palette = M.build()
	M.palette_scheme = vim.g.colors_name
	for name, fn in pairs(painters) do
		local ok, err = pcall(fn, M.palette)
		if not ok then
			vim.schedule(function()
				vim.notify(("theme: %s failed to paint:\n%s"):format(name, err), vim.log.levels.ERROR)
			end)
		end
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("atila_theme", { clear = true }),
	callback = function()
		M.capture()
		vim.schedule(M.repaint)
	end,
})

vim.api.nvim_create_user_command("ThemeRepaint", M.repaint, {
	desc = "Re-derive the palette from the active colorscheme and repaint",
})

return M
