-- ╭──────────────────────────────────────────────────────────────────╮
-- │  theme.lua — one palette, derived from whatever scheme is loaded │
-- │                                                                  │
-- │  Several plugins here are styled by hand (telescope, neo-tree,   │
-- │  which-key, render-markdown…). Hard-coding hexes for those meant │
-- │  they kept wearing the old scheme's colors after :colorscheme.   │
-- │  Instead we read the semantic highlight groups the active scheme │
-- │  already defines — Normal, Comment, Function, String, keywords,  │
-- │  diagnostics — and hand those out as a palette.                  │
-- │                                                                  │
-- │  Usage:                                                          │
-- │      local theme = require("atila.plugins.theme")                │
-- │      theme.on_change("telescope", function(p) … end)             │
-- │                                                                  │
-- │  The callback runs immediately and again on every ColorScheme.   │
-- ╰──────────────────────────────────────────────────────────────────╯

local M = {}

-- ── Color helpers ───────────────────────────────────────────────────

---@param n integer|nil 24-bit color as returned by nvim_get_hl
---@return string|nil
local function to_hex(n)
	return n and ("#%06x"):format(n) or nil
end

---@param hex string
---@return integer, integer, integer
local function to_rgb(hex)
	local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
	if not r then
		return 0, 0, 0
	end
	return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

---Mix `fg` into `bg`. alpha 1 = pure fg, 0 = pure bg.
---@param fg string
---@param bg string
---@param alpha number
---@return string
function M.blend(fg, bg, alpha)
	local fr, fg_, fb = to_rgb(fg)
	local br, bg_, bb = to_rgb(bg)
	local mix = function(a, b)
		return math.floor(math.min(255, math.max(0, b + (a - b) * alpha)) + 0.5)
	end
	return ("#%02x%02x%02x"):format(mix(fr, br), mix(fg_, bg_), mix(fb, bb))
end

---Push a color toward black (negative amount) or white (positive).
---@param hex string
---@param amount number -1..1
---@return string
function M.shade(hex, amount)
	return M.blend(amount < 0 and "#000000" or "#ffffff", hex, math.abs(amount))
end

---Perceived brightness, 0..1. Used to decide which way "darker" goes.
---@param hex string
---@return number
function M.luminance(hex)
	local r, g, b = to_rgb(hex)
	return (0.299 * r + 0.587 * g + 0.114 * b) / 255
end

---Hue in degrees (0 = red, 120 = green, 240 = blue) and saturation 0..1.
---@param hex string
---@return number, number
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

---Rebuild a color from hue/saturation/lightness. Lets us mint an accent a
---scheme simply does not have, in that scheme's own key.
---@param h number degrees
---@param s number 0..1
---@param l number 0..1
---@return string
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

---Shortest distance between two hues on the color wheel, 0..180.
---@param a number
---@param b number
---@return number
local function hue_gap(a, b)
	local d = math.abs(a - b) % 360
	return d > 180 and 360 - d or d
end

-- ── Reading the active scheme ───────────────────────────────────────

---@param name string
---@return table
local function hl(name)
	local ok, group = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	return ok and group or {}
end

---Enough separation from the page to be readable on it. Guards against
---schemes that paint a group in reverse video (gruvbox's ErrorMsg is
---`fg = background`), which would otherwise hand us an invisible accent.
---@param color string
---@param bg string
---@return boolean
local function readable(color, bg)
	local a, b = M.luminance(color) + 0.05, M.luminance(bg) + 0.05
	return (math.max(a, b) / math.min(a, b)) >= 1.5
end

---First attribute the active scheme defines that is actually readable on
---the page.
---@param candidates table list of { "GroupName", "fg"|"bg" }
---@param bg string
---@param fallback string
---@return string
local function pick(candidates, bg, fallback)
	for _, candidate in ipairs(candidates) do
		local value = to_hex(hl(candidate[1])[candidate[2]])
		if value and (candidate[2] == "bg" or readable(value, bg)) then
			return value
		end
	end
	return fallback
end

-- ── The palette ─────────────────────────────────────────────────────

---Derive a palette from the colorscheme that is loaded right now.
---@return table
function M.build()
	local bg = to_hex(hl("Normal").bg) or (vim.o.background == "dark" and "#000000" or "#ffffff")
	local fg = to_hex(hl("Normal").fg) or (vim.o.background == "dark" and "#c0caf5" or "#333333")
	local dark = M.luminance(bg) < 0.5

	-- Surfaces. "dark"/"highlight" are relative to the page, so on a light
	-- scheme they move the other way and the same configs still read right.
	local recede = dark and -0.30 or 0.35
	local emerge = dark and 0.10 or -0.06

	local p = {
		bg = bg,
		fg = fg,
		dark = dark,

		-- Depth. Three surfaces below the page and one above it, so a split
		-- edge is legible without a border: the window you are typing in is
		-- `bg`, the ones you are not recede, and sidebars recede furthest.
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

	-- Accents, matched by hue rather than by group name. Naming a group per
	-- role does not survive a change of scheme: tokyonight's Constant is
	-- orange while gruvbox's is pink, and gruvbox paints Function the same
	-- green as String. So instead we collect every accent the scheme puts on
	-- screen and hand each role the one closest to the hue it is named for.
	local pool = {}
	local seen = {}
	for _, group in ipairs({
		"Function", "String", "Keyword", "Statement", "Type", "Constant", "Number",
		"Special", "Identifier", "PreProc", "Operator", "Directory", "Title",
		"DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint",
		"@constructor", "@variable.member", "@string.escape", "@keyword", "@type", "@function",
	}) do
		local color = to_hex(hl(group).fg)
		if color and not seen[color] and readable(color, bg) then
			local h, s, l, chroma = hue_sat(color)
			-- Greys carry no hue, so they would land anywhere on the wheel.
			-- Both gates matter: saturation alone lets near-white through,
			-- chroma alone lets warm greys like gruvbox's #928374 through.
			if s >= 0.15 and chroma >= 0.08 then
				seen[color] = true
				pool[#pool + 1] = { color = color, hue = h, sat = s, light = l }
			end
		end
	end

	-- Canonical hue per role, plus the fallback if the scheme is too grey
	-- to fill the slot at all.
	local roles = {
		{ "red", 0, "#f7768e" },
		{ "orange", 20, "#ff9e64" },
		{ "yellow", 45, "#e0af68" },
		{ "green", 120, "#9ece6a" },
		{ "cyan", 185, "#7dcfff" },
		{ "blue", 220, "#7aa2f7" },
		{ "purple", 285, "#bb9af7" },
	}

	-- Greedy global match: closest role/color pair wins first, so a scheme's
	-- one unmistakable red is spent on `red` and not on `orange`.
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

	-- Past a quarter-turn on the wheel the "closest" color is no longer the
	-- named hue in any useful sense, so we stop rather than call gruvbox's
	-- lime green a blue.
	local MAX_GAP = 60

	local taken = {}
	for _, match in ipairs(pairs_by_gap) do
		if match.gap <= MAX_GAP and not p[match.role] and not taken[match.color] then
			p[match.role] = match.color
			taken[match.color] = true
		end
	end

	-- A hue the scheme never uses (gruvbox has no blue in its syntax groups)
	-- gets minted at the scheme's own saturation and lightness, so it still
	-- belongs on the page. Only a scheme with no color at all falls through
	-- to the fixed hex.
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

	-- Aliases the older configs were written against.
	p.magenta = p.purple
	p.amber = p.yellow

	-- Git. Added/Changed/Removed ship with Neovim built-in defaults that a
	-- scheme is free to ignore, so reading them would quietly hand back a
	-- color from no scheme at all. Ask what actually restyles them, then
	-- fall back to the accents we just derived.
	p.git_add = pick({ { "GitSignsAdd", "fg" }, { "diffAdded", "fg" } }, bg, p.green)
	p.git_change = pick({ { "GitSignsChange", "fg" }, { "diffChanged", "fg" } }, bg, p.yellow)
	p.git_delete = pick({ { "GitSignsDelete", "fg" }, { "diffRemoved", "fg" } }, bg, p.red)

	-- Text that sits on an accent-colored title bar.
	p.on_accent = dark and p.bg_dark or M.shade(bg, -0.85)

	return p
end

---The palette for the scheme currently loaded. Rebuilt on ColorScheme.
M.palette = M.build()

-- ── Repaint plumbing ────────────────────────────────────────────────

local painters = {}

---Register a repaint function. Runs now, and after every scheme change.
---@param name string unique key, so reloading a module replaces its painter
---@param fn fun(palette: table)
function M.on_change(name, fn)
	painters[name] = fn
	local ok, err = pcall(fn, M.palette)
	if not ok then
		vim.schedule(function()
			vim.notify(("theme: %s failed to paint:\n%s"):format(name, err), vim.log.levels.ERROR)
		end)
	end
end

---Rebuild the palette and repaint everything. Also exposed as :ThemeRepaint
---for when a plugin loads late and clobbers our groups.
function M.repaint()
	M.palette = M.build()
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
		-- Deferred: some schemes finish defining groups after the event
		-- fires, and we want the last word anyway.
		vim.schedule(M.repaint)
	end,
})

vim.api.nvim_create_user_command("ThemeRepaint", M.repaint, {
	desc = "Re-derive the palette from the active colorscheme and repaint",
})

return M
