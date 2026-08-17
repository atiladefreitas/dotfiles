-- geleira — a cold, electric, near-monochrome colorscheme
--
-- design:
--   • code is a brightness ladder of icy blue: functions glow near-white,
--     keywords recede (but bold), comments are faint italic
--   • the ONLY pop color in code is teal (strings)
--   • red/gold appear exclusively as diagnostic signals
--   • strong UI separation: darker sidebars, lighter floats, visible borders

local M = {}

M.palette = {
	-- surfaces (neutral graphite, strong separation)
	bg = "#1a1a1f", -- code area
	bg_dark = "#121216", -- sidebars, statusline
	bg_float = "#22222a", -- floats, pmenu, telescope
	bg_prompt = "#2a2a34", -- telescope prompt
	bg_line = "#212129", -- cursorline
	bg_visual = "#30303f",
	bg_search = "#33406b",
	border = "#4a4a68",

	-- the monochrome ladder (bright → faint, high contrast)
	fg_bright = "#e2e9ff", -- functions, titles
	fg_type = "#c4cff5", -- types
	fg = "#b6c3ee", -- variables, default text
	fg_mid = "#8b99cf", -- operators, preproc
	fg_kw = "#8291c9", -- keywords (bold)
	fg_punct = "#6b77a8", -- punctuation, delimiters
	comment = "#5d6b9e",
	linenr = "#565e80",
	faint = "#33333f", -- whitespace, indent guides

	-- electric accents (UI only, plus constants)
	blue = "#82aaff", -- cursor line nr, directories, info
	cyan = "#86e1fc", -- matches, string escapes
	const = "#89a7ef", -- numbers, booleans, builtins

	-- the pop
	teal = "#4fd6be", -- strings

	-- signals
	red = "#e26a6a",
	gold = "#d9b96a",
	violet = "#b89aef",
}

function M.load()
	local p = M.palette

	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end
	vim.o.termguicolors = true
	vim.g.colors_name = "geleira"

	local hi = function(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	-- ═══ editor ═══
	hi("Normal", { fg = p.fg, bg = p.bg })
	hi("NormalNC", { fg = p.fg, bg = p.bg })
	hi("NormalFloat", { fg = p.fg, bg = p.bg_float })
	hi("FloatBorder", { fg = p.border, bg = p.bg_float })
	hi("FloatTitle", { fg = p.fg_bright, bg = p.bg_float, bold = true })
	hi("WinSeparator", { fg = p.border })
	hi("CursorLine", { bg = p.bg_line })
	hi("CursorColumn", { bg = p.bg_line })
	hi("ColorColumn", { bg = p.bg_line })
	hi("LineNr", { fg = p.linenr })
	hi("CursorLineNr", { fg = p.blue, bold = true })
	hi("SignColumn", { bg = p.bg })
	hi("Visual", { bg = p.bg_visual })
	hi("VisualNOS", { bg = p.bg_visual })
	hi("Search", { fg = p.fg_bright, bg = p.bg_search })
	hi("IncSearch", { fg = p.bg, bg = p.blue, bold = true })
	hi("CurSearch", { link = "IncSearch" })
	hi("MatchParen", { fg = p.cyan, bold = true })
	hi("Cursor", { fg = p.bg, bg = p.fg_bright })
	hi("TermCursor", { fg = p.bg, bg = p.fg_bright })
	hi("NonText", { fg = p.faint })
	hi("Whitespace", { fg = p.faint })
	hi("SpecialKey", { fg = p.faint })
	hi("EndOfBuffer", { fg = p.bg })
	hi("Folded", { fg = p.fg_mid, bg = p.bg_line, italic = true })
	hi("FoldColumn", { fg = p.linenr, bg = p.bg })
	hi("Directory", { fg = p.blue })
	hi("Title", { fg = p.fg_bright, bold = true })
	hi("ErrorMsg", { fg = p.red })
	hi("WarningMsg", { fg = p.gold })
	hi("MoreMsg", { fg = p.teal })
	hi("Question", { fg = p.blue })
	hi("ModeMsg", { fg = p.fg_mid })
	hi("MsgArea", { fg = p.fg })
	hi("QuickFixLine", { bg = p.bg_visual, bold = true })

	-- statusline / tabs (dark band, strong separation)
	hi("StatusLine", { fg = p.fg, bg = p.bg_dark })
	hi("StatusLineNC", { fg = p.fg_kw, bg = p.bg_dark })
	hi("TabLine", { fg = p.fg_mid, bg = p.bg_dark })
	hi("TabLineFill", { bg = p.bg_dark })
	hi("TabLineSel", { fg = p.fg_bright, bg = p.bg, bold = true })
	hi("WinBar", { fg = p.fg_mid, bg = p.bg })
	hi("WinBarNC", { fg = p.fg_kw, bg = p.bg })

	-- popup menu
	hi("Pmenu", { fg = p.fg, bg = p.bg_float })
	hi("PmenuSel", { fg = p.fg_bright, bg = p.bg_visual, bold = true })
	hi("PmenuSbar", { bg = p.bg_float })
	hi("PmenuThumb", { bg = p.border })
	hi("WildMenu", { fg = p.fg_bright, bg = p.bg_visual })

	-- ═══ syntax: the monochrome ladder ═══
	hi("Comment", { fg = p.comment, italic = true })
	hi("String", { fg = p.teal }) -- ★ the pop
	hi("Character", { fg = p.teal })
	hi("Number", { fg = p.const })
	hi("Float", { fg = p.const })
	hi("Boolean", { fg = p.const })
	hi("Constant", { fg = p.const })
	hi("Identifier", { fg = p.fg })
	hi("Function", { fg = p.fg_bright }) -- ★ brightest rung
	hi("Statement", { fg = p.fg_kw, bold = true })
	hi("Keyword", { fg = p.fg_kw, bold = true })
	hi("Conditional", { fg = p.fg_kw, bold = true })
	hi("Repeat", { fg = p.fg_kw, bold = true })
	hi("Label", { fg = p.fg_kw, bold = true })
	hi("Exception", { fg = p.fg_kw, bold = true })
	hi("Operator", { fg = p.fg_mid })
	hi("Type", { fg = p.fg_type })
	hi("StorageClass", { fg = p.fg_kw, bold = true })
	hi("Structure", { fg = p.fg_type })
	hi("Typedef", { fg = p.fg_type })
	hi("PreProc", { fg = p.fg_mid })
	hi("Include", { fg = p.fg_kw, bold = true })
	hi("Define", { fg = p.fg_mid })
	hi("Macro", { fg = p.fg_mid })
	hi("Special", { fg = p.const })
	hi("SpecialChar", { fg = p.cyan })
	hi("SpecialComment", { fg = p.fg_mid, italic = true })
	hi("Delimiter", { fg = p.fg_punct })
	hi("Tag", { fg = p.fg_kw })
	hi("Debug", { fg = p.gold })
	hi("Underlined", { underline = true })
	hi("Error", { fg = p.red })
	hi("Todo", { fg = p.bg, bg = p.teal, bold = true })

	-- ═══ treesitter ═══
	hi("@variable", { fg = p.fg })
	hi("@variable.builtin", { fg = p.const, italic = true })
	hi("@variable.parameter", { fg = p.fg, italic = true }) -- ★ italic params
	hi("@variable.member", { fg = p.fg })
	hi("@property", { fg = p.fg })
	hi("@field", { fg = p.fg })
	hi("@function", { fg = p.fg_bright })
	hi("@function.call", { fg = p.fg_bright })
	hi("@function.builtin", { fg = p.fg_bright })
	hi("@function.method", { fg = p.fg_bright })
	hi("@function.method.call", { fg = p.fg_bright })
	hi("@constructor", { fg = p.fg_type })
	hi("@keyword", { fg = p.fg_kw, bold = true })
	hi("@keyword.function", { fg = p.fg_kw, bold = true })
	hi("@keyword.return", { fg = p.fg_mid, bold = true })
	hi("@keyword.operator", { fg = p.fg_kw, bold = true })
	hi("@keyword.import", { fg = p.fg_kw, bold = true })
	hi("@string", { fg = p.teal })
	hi("@string.escape", { fg = p.cyan })
	hi("@string.regexp", { fg = p.cyan })
	hi("@string.special", { fg = p.cyan })
	hi("@string.special.url", { fg = p.teal, underline = true })
	hi("@character", { fg = p.teal })
	hi("@number", { fg = p.const })
	hi("@boolean", { fg = p.const })
	hi("@constant", { fg = p.const })
	hi("@constant.builtin", { fg = p.const, italic = true })
	hi("@type", { fg = p.fg_type })
	hi("@type.builtin", { fg = p.fg_type })
	hi("@type.definition", { fg = p.fg_type })
	hi("@attribute", { fg = p.fg_mid })
	hi("@operator", { fg = p.fg_mid })
	hi("@punctuation.delimiter", { fg = p.fg_punct })
	hi("@punctuation.bracket", { fg = p.fg_punct })
	hi("@punctuation.special", { fg = p.fg_mid })
	hi("@comment", { fg = p.comment, italic = true })
	hi("@comment.todo", { fg = p.bg, bg = p.teal, bold = true })
	hi("@comment.warning", { fg = p.bg, bg = p.gold, bold = true })
	hi("@comment.error", { fg = p.bg, bg = p.red, bold = true })
	hi("@comment.note", { fg = p.bg, bg = p.blue, bold = true })
	hi("@tag", { fg = p.fg_kw, bold = true })
	hi("@tag.attribute", { fg = p.fg, italic = true })
	hi("@tag.delimiter", { fg = p.fg_punct })
	hi("@label", { fg = p.fg_mid })
	hi("@module", { fg = p.fg_type })

	-- markdown / prose
	hi("@markup.heading", { fg = p.fg_bright, bold = true })
	hi("@markup.heading.1", { fg = p.fg_bright, bold = true })
	hi("@markup.heading.2", { fg = p.blue, bold = true })
	hi("@markup.heading.3", { fg = p.fg_type, bold = true })
	hi("@markup.strong", { bold = true })
	hi("@markup.italic", { italic = true })
	hi("@markup.strikethrough", { strikethrough = true })
	hi("@markup.link", { fg = p.teal, underline = true })
	hi("@markup.link.url", { fg = p.teal, underline = true })
	hi("@markup.link.label", { fg = p.blue })
	hi("@markup.raw", { fg = p.cyan })
	hi("@markup.raw.block", { fg = p.fg_mid })
	hi("@markup.quote", { fg = p.fg_mid, italic = true })
	hi("@markup.list", { fg = p.blue })

	-- lsp semantic tokens follow the same ladder
	hi("@lsp.type.function", { link = "@function" })
	hi("@lsp.type.method", { link = "@function.method" })
	hi("@lsp.type.parameter", { link = "@variable.parameter" })
	hi("@lsp.type.variable", { link = "@variable" })
	hi("@lsp.type.property", { link = "@property" })
	hi("@lsp.type.class", { link = "@type" })
	hi("@lsp.type.type", { link = "@type" })
	hi("@lsp.type.keyword", { link = "@keyword" })
	hi("@lsp.type.namespace", { link = "@module" })

	-- ═══ diagnostics (the only red/gold in the theme) ═══
	hi("DiagnosticError", { fg = p.red })
	hi("DiagnosticWarn", { fg = p.gold })
	hi("DiagnosticInfo", { fg = p.blue })
	hi("DiagnosticHint", { fg = p.fg_mid })
	hi("DiagnosticOk", { fg = p.teal })
	hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
	hi("DiagnosticUnderlineWarn", { undercurl = true, sp = p.gold })
	hi("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
	hi("DiagnosticUnderlineHint", { undercurl = true, sp = p.fg_mid })
	hi("DiagnosticVirtualTextError", { fg = p.red, bg = "#2e2026" })
	hi("DiagnosticVirtualTextWarn", { fg = p.gold, bg = "#2c271f" })
	hi("DiagnosticVirtualTextInfo", { fg = p.blue, bg = "#212637" })
	hi("DiagnosticVirtualTextHint", { fg = p.fg_mid, bg = p.bg_line })
	hi("DiagnosticUnnecessary", { fg = p.comment, undercurl = true, sp = p.fg_mid })
	hi("LspReferenceText", { bg = p.bg_visual })
	hi("LspReferenceRead", { bg = p.bg_visual })
	hi("LspReferenceWrite", { bg = p.bg_visual, underline = true })
	hi("LspInlayHint", { fg = p.comment, bg = p.bg_line, italic = true })
	hi("LspSignatureActiveParameter", { fg = p.cyan, bold = true })

	-- ═══ diff / git ═══
	hi("DiffAdd", { bg = "#1e2d29" })
	hi("DiffChange", { bg = "#20263a" })
	hi("DiffDelete", { bg = "#302026" })
	hi("DiffText", { bg = "#2b3c61" })
	hi("Added", { fg = p.teal })
	hi("Changed", { fg = p.blue })
	hi("Removed", { fg = p.red })
	hi("GitSignsAdd", { fg = p.teal })
	hi("GitSignsChange", { fg = p.blue })
	hi("GitSignsDelete", { fg = p.red })

	-- ═══ telescope (float layer, electric titles) ═══
	hi("TelescopeNormal", { fg = p.fg, bg = p.bg_float })
	hi("TelescopeBorder", { fg = p.border, bg = p.bg_float })
	hi("TelescopePromptNormal", { fg = p.fg_bright, bg = p.bg_prompt })
	hi("TelescopePromptBorder", { fg = p.bg_prompt, bg = p.bg_prompt })
	hi("TelescopePromptTitle", { fg = p.bg, bg = p.blue, bold = true })
	hi("TelescopePromptPrefix", { fg = p.blue, bg = p.bg_prompt })
	hi("TelescopePromptCounter", { fg = p.fg_mid, bg = p.bg_prompt })
	hi("TelescopeResultsTitle", { fg = p.bg_float, bg = p.bg_float })
	hi("TelescopePreviewTitle", { fg = p.bg, bg = p.teal, bold = true })
	hi("TelescopeSelection", { fg = p.fg_bright, bg = p.bg_visual })
	hi("TelescopeSelectionCaret", { fg = p.blue, bg = p.bg_visual })
	hi("TelescopeMatching", { fg = p.cyan, bold = true })

	-- ═══ neo-tree (dark sidebar layer) ═══
	hi("NeoTreeNormal", { fg = p.fg, bg = p.bg_dark })
	hi("NeoTreeNormalNC", { fg = p.fg, bg = p.bg_dark })
	hi("NeoTreeEndOfBuffer", { fg = p.bg_dark, bg = p.bg_dark })
	hi("NeoTreeWinSeparator", { fg = p.border, bg = p.bg_dark })
	hi("NeoTreeCursorLine", { bg = p.bg_line })
	hi("NeoTreeRootName", { fg = p.fg_bright, bold = true })
	hi("NeoTreeDirectoryName", { fg = p.blue })
	hi("NeoTreeDirectoryIcon", { fg = p.blue })
	hi("NeoTreeFileName", { fg = p.fg })
	hi("NeoTreeFileIcon", { fg = p.fg_mid })
	hi("NeoTreeDotfile", { fg = p.fg_kw })
	hi("NeoTreeHiddenByName", { fg = p.fg_kw })
	hi("NeoTreeGitAdded", { fg = p.teal })
	hi("NeoTreeGitModified", { fg = p.blue })
	hi("NeoTreeGitDeleted", { fg = p.red })
	hi("NeoTreeGitUntracked", { fg = p.violet })
	hi("NeoTreeGitIgnored", { fg = p.comment })
	hi("NeoTreeGitConflict", { fg = p.gold, bold = true })
	hi("NeoTreeIndentMarker", { fg = p.faint })
	hi("NeoTreeExpander", { fg = p.fg_mid })
	hi("NeoTreeFloatBorder", { fg = p.border, bg = p.bg_float })
	hi("NeoTreeFloatTitle", { fg = p.bg, bg = p.blue, bold = true })
	hi("NeoTreeTitleBar", { fg = p.bg, bg = p.blue, bold = true })

	-- ═══ snacks ═══
	hi("SnacksIndent", { fg = "#26262f" })
	hi("SnacksIndentScope", { fg = p.border })
	hi("SnacksDashboardHeader", { fg = p.blue })
	hi("SnacksDashboardDesc", { fg = p.fg })
	hi("SnacksDashboardIcon", { fg = p.cyan })
	hi("SnacksDashboardKey", { fg = p.teal, bold = true })
	hi("SnacksDashboardFooter", { fg = p.comment, italic = true })
	hi("SnacksDashboardSpecial", { fg = p.violet })
	hi("SnacksNormal", { fg = p.fg, bg = p.bg_float })
	hi("SnacksPickerBorder", { fg = p.border, bg = p.bg_float })
	hi("SnacksPickerTitle", { fg = p.bg, bg = p.blue, bold = true })
	hi("SnacksPickerMatch", { fg = p.cyan, bold = true })
	hi("SnacksPickerDir", { fg = p.fg_kw })
	hi("SnacksPickerCursorLine", { bg = p.bg_visual })
	hi("SnacksNotifierInfo", { fg = p.fg, bg = p.bg_float })
	hi("SnacksNotifierBorderInfo", { fg = p.border, bg = p.bg_float })
	hi("SnacksNotifierIconInfo", { fg = p.blue })

	-- ═══ completion (cmp / blink) ═══
	hi("CmpItemAbbr", { fg = p.fg })
	hi("CmpItemAbbrMatch", { fg = p.cyan, bold = true })
	hi("CmpItemAbbrMatchFuzzy", { fg = p.cyan })
	hi("CmpItemAbbrDeprecated", { fg = p.comment, strikethrough = true })
	hi("CmpItemKind", { fg = p.fg_mid })
	hi("CmpItemKindFunction", { fg = p.fg_bright })
	hi("CmpItemKindMethod", { fg = p.fg_bright })
	hi("CmpItemKindVariable", { fg = p.fg })
	hi("CmpItemKindKeyword", { fg = p.fg_kw })
	hi("CmpItemKindClass", { fg = p.fg_type })
	hi("CmpItemKindInterface", { fg = p.fg_type })
	hi("CmpItemKindText", { fg = p.teal })
	hi("CmpItemKindSnippet", { fg = p.violet })
	hi("BlinkCmpLabelMatch", { fg = p.cyan, bold = true })
	hi("BlinkCmpMenu", { fg = p.fg, bg = p.bg_float })
	hi("BlinkCmpMenuBorder", { fg = p.border, bg = p.bg_float })
	hi("BlinkCmpMenuSelection", { fg = p.fg_bright, bg = p.bg_visual, bold = true })
	hi("BlinkCmpDoc", { fg = p.fg, bg = p.bg_float })
	hi("BlinkCmpDocBorder", { fg = p.border, bg = p.bg_float })

	-- ═══ misc plugins ═══
	hi("WhichKey", { fg = p.cyan })
	hi("WhichKeyGroup", { fg = p.blue })
	hi("WhichKeyDesc", { fg = p.fg })
	hi("WhichKeySeparator", { fg = p.comment })
	hi("WhichKeyNormal", { bg = p.bg_float })
	hi("LazyH1", { fg = p.bg, bg = p.blue, bold = true })
	hi("LazyButton", { fg = p.fg, bg = p.bg_visual })
	hi("LazyButtonActive", { fg = p.bg, bg = p.teal, bold = true })
	hi("LazySpecial", { fg = p.cyan })
	hi("LazyProgressDone", { fg = p.teal })
	hi("FlashLabel", { fg = p.bg, bg = p.teal, bold = true })
	hi("FlashMatch", { fg = p.fg_bright, bg = p.bg_search })
	hi("IblIndent", { fg = "#26262f" })
	hi("IblScope", { fg = p.border })

	-- ═══ terminal palette ═══
	vim.g.terminal_color_0 = "#24242c"
	vim.g.terminal_color_8 = "#4a4a68"
	vim.g.terminal_color_1 = p.red
	vim.g.terminal_color_9 = "#ef8585"
	vim.g.terminal_color_2 = p.teal
	vim.g.terminal_color_10 = "#6fe8d2"
	vim.g.terminal_color_3 = p.gold
	vim.g.terminal_color_11 = "#e8cd8a"
	vim.g.terminal_color_4 = p.blue
	vim.g.terminal_color_12 = "#9fbdff"
	vim.g.terminal_color_5 = p.violet
	vim.g.terminal_color_13 = "#ccb2f7"
	vim.g.terminal_color_6 = p.cyan
	vim.g.terminal_color_14 = "#a5ecff"
	vim.g.terminal_color_7 = p.fg
	vim.g.terminal_color_15 = p.fg_bright
end

return M
