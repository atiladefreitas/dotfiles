-- ╭──────────────────────────────────────────────────────────────────╮
-- │  markdown.lua — editorial markdown, tuned for Tokyo Night        │
-- │                                                                  │
-- │  1. palette      shared ink & paper tones                        │
-- │  2. paint()      highlight groups (reapplied on ColorScheme)     │
-- │  3. render-markdown.nvim                                         │
-- │  4. obsidian.nvim                                                │
-- ╰──────────────────────────────────────────────────────────────────╯

-- ── 1. Palette ──────────────────────────────────────────────────────
-- One ink set for everything markdown, so render-markdown, treesitter
-- and obsidian.nvim all read as a single typeset page.
-- The page is pure black (see colorscheme.lua: colors.bg = "#000000"), so a
-- heading band is simply that level's own ink pulled most of the way back
-- to the paper. Move PAGE if the background ever moves.
local PAGE = { 0x00, 0x00, 0x00 }

---Blend an ink toward the page. alpha 1 = full ink, 0 = bare paper.
---@param hex string
---@param alpha number
---@return string
local function tint(hex, alpha)
  local out = {}
  for i, byte in ipairs({ hex:match("^#(%x%x)(%x%x)(%x%x)$") }) do
    out[i] = math.floor(PAGE[i] + (tonumber(byte, 16) - PAGE[i]) * alpha + 0.5)
  end
  return ("#%02x%02x%02x"):format(out[1], out[2], out[3])
end

local p = {
  -- Heading foregrounds (bright vellum → descending accents)
  h1 = "#c0caf5",
  h2 = "#bb9af7",
  h3 = "#7aa2f7",
  h4 = "#7dcfff",
  h5 = "#9ece6a",
  h6 = "#e0af68",

  -- Surfaces
  code_bg = "#0c0e18",
  code_inline_bg = "#1a1b2e",

  -- Type
  body = "#a9b1d6",
  muted = "#565f89",
  rule = "#1f2335",

  -- Accents
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  green = "#9ece6a",
  amber = "#e0af68",
  magenta = "#bb9af7",
  red = "#f7768e",
  quote_text = "#9aa5ce",
  highlight_bg = "#3d2f1f",
}

-- Heading bands: each level tinted with its own hue, strong under a title
-- and gone by H5 — depth is legible before you've read a word.
p.h1_bg = tint(p.h1, 0.16)
p.h2_bg = tint(p.h2, 0.13)
p.h3_bg = tint(p.h3, 0.10)
p.h4_bg = tint(p.h4, 0.07)
p.h5_bg = "NONE"
p.h6_bg = "NONE"

-- ── 2. Highlights ───────────────────────────────────────────────────
-- Everything lives in one function so a colorscheme change can't wash
-- the page out — we simply repaint.
local function paint()
  local hl = function(group, spec)
    vim.api.nvim_set_hl(0, group, spec)
  end

  -- Headings — one source of truth per level, painted onto all three
  -- surfaces that make up a heading: the bar icon (RenderMarkdownHN), the
  -- band (…Bg) and the heading text itself. That last one is treesitter's,
  -- and tokyonight paints it from its own rainbow unless we say otherwise.
  -- (Heading borders take their color from the band, not a Border group.)
  local levels = {
    { fg = p.h1, bg = p.h1_bg },
    { fg = p.h2, bg = p.h2_bg },
    { fg = p.h3, bg = p.h3_bg },
    { fg = p.h4, bg = p.h4_bg },
    { fg = p.h5, bg = p.h5_bg },
    { fg = p.h6, bg = p.h6_bg, italic = true },
  }
  for i, level in ipairs(levels) do
    hl("RenderMarkdownH" .. i, { fg = level.fg, bold = true, italic = level.italic })
    hl("RenderMarkdownH" .. i .. "Bg", { bg = level.bg })
    hl("@markup.heading." .. i .. ".markdown", {
      fg = level.fg,
      bg = level.bg,
      bold = true,
      italic = level.italic,
    })
  end

  -- Code: deep surface, cyan language tag
  hl("RenderMarkdownCode", { bg = p.code_bg })
  hl("RenderMarkdownCodeBorder", { fg = p.rule, bg = p.code_bg })
  hl("RenderMarkdownCodeInline", { bg = p.code_inline_bg, fg = p.cyan })
  hl("RenderMarkdownCodeLanguage", { fg = p.cyan, bg = p.code_bg, italic = true })

  -- Checkboxes
  hl("RenderMarkdownUnchecked", { fg = p.muted })
  hl("RenderMarkdownChecked", { fg = p.green })
  hl("RenderMarkdownTodo", { fg = p.amber })

  -- Callouts
  hl("RenderMarkdownInfo", { fg = p.blue, bold = true })
  hl("RenderMarkdownSuccess", { fg = p.green, bold = true })
  hl("RenderMarkdownHint", { fg = p.magenta, bold = true })
  hl("RenderMarkdownWarn", { fg = p.amber, bold = true })
  hl("RenderMarkdownError", { fg = p.red, bold = true })

  -- Quote: magenta rule, softly muted italic body
  hl("RenderMarkdownQuote", { fg = p.magenta, italic = true })
  hl("@markup.quote.markdown", { fg = p.quote_text, italic = true })

  -- Links
  hl("RenderMarkdownLink", { fg = p.blue, underline = true })
  hl("RenderMarkdownWikiLink", { fg = p.magenta, underline = true })

  -- Tables
  hl("RenderMarkdownTableHead", { fg = p.h2, bold = true })
  hl("RenderMarkdownTableRow", { fg = p.body })
  hl("RenderMarkdownTableFill", { fg = p.rule })

  -- ==Inline highlights== read like a marker pen
  hl("RenderMarkdownInlineHighlight", { bg = p.highlight_bg, fg = p.amber })

  -- Misc
  hl("RenderMarkdownBullet", { fg = p.cyan, bold = true })
  hl("RenderMarkdownDash", { fg = p.muted })
  hl("RenderMarkdownSign", { fg = p.muted })

  -- Treesitter polish: body prose like a magazine
  hl("@markup.strong.markdown_inline", { fg = p.h1, bold = true })
  hl("@markup.italic.markdown_inline", { fg = p.magenta, italic = true })
  hl("@markup.strikethrough.markdown_inline", { fg = p.muted, strikethrough = true })
  hl("@markup.raw.markdown_inline", { fg = p.cyan, bg = p.code_inline_bg })
  hl("@markup.link.label.markdown_inline", { fg = p.blue, italic = true })
  hl("@markup.link.url.markdown_inline", { fg = p.muted, italic = true, underline = true })

  -- The foldcolumn is reading-margin padding, keep it invisible
  hl("FoldColumn", { fg = "NONE", bg = "NONE" })
end

-- ── 3. render-markdown.nvim ───────────────────────────────────────
local render_markdown_opts = {
  render_modes = { "n", "c", "t" },

  -- Anti-conceal reveals the raw source on the cursor line, which is
  -- right for links and inline marks — but by default it takes the
  -- heading band and its edges with it, so the page lurches every time
  -- the cursor crosses a title. Pin those; let the '#' markers reveal
  -- (the icons are marker-width, so nothing shifts sideways).
  anti_conceal = {
    enabled = true,
    ignore = {
      head_background = true,
      head_border = true,
      code_background = true,
      indent = true,
      sign = true,
      virtual_lines = true,
    },
  },
  max_file_size = 10.0,
  debounce = 100,

  -- Editorial heading hierarchy — a depth ruler.
  -- Bar thickness reads as level (█ ▊ ▌ ▍ ▎ ▏), and every icon is
  -- exactly two cells wide, which is what makes "overlay" behave: the
  -- icon is right-aligned inside the '#' field, so the source indent
  -- survives and headings staircase instead of all sitting flush left.
  -- Bands narrow and fade on the way down, then stop entirely at H5.
  heading = {
    enabled = true,
    sign = false,
    position = "overlay",
    icons = { "█ ", "▊ ", "▌ ", "▍ ", "▎ ", "▏ " },
    width = "block",
    left_margin = 0,
    left_pad = 1,
    right_pad = { 4, 4, 3, 2, 2, 2 },
    min_width = { 74, 66, 58, 0, 0, 0 },
    -- Soft one-eighth-block edges, title levels only. They land on the
    -- blank line around the heading, so nothing grows taller.
    border = { true, true, false, false, false, false },
    border_virtual = false,
    border_prefix = false,
    above = "▁",
    below = "▔",
    backgrounds = {
      "RenderMarkdownH1Bg",
      "RenderMarkdownH2Bg",
      "RenderMarkdownH3Bg",
      "RenderMarkdownH4Bg",
      "RenderMarkdownH5Bg",
      "RenderMarkdownH6Bg",
    },
    foregrounds = {
      "RenderMarkdownH1",
      "RenderMarkdownH2",
      "RenderMarkdownH3",
      "RenderMarkdownH4",
      "RenderMarkdownH5",
      "RenderMarkdownH6",
    },
  },

  -- Generous, centered-feeling code blocks
  code = {
    enabled = true,
    sign = false,
    style = "full",
    position = "left",
    language_pad = 2,
    language_name = true,
    language_icon = true,
    disable_background = { "diff" },
    width = "block",
    left_margin = 2,
    left_pad = 3,
    right_pad = 3,
    min_width = 70,
    border = "thick",
    above = "▁",
    below = "▔",
    highlight = "RenderMarkdownCode",
    highlight_inline = "RenderMarkdownCodeInline",
    highlight_language = "RenderMarkdownCodeLanguage",
    inline_pad = 1,
  },

  -- Soft horizontal rule, like a manuscript section break
  dash = {
    enabled = true,
    icon = "─",
    width = 80,
    left_margin = 0,
    highlight = "RenderMarkdownDash",
  },

  -- Refined bullets: filled circle, open circle, arrow, dot
  bullet = {
    enabled = true,
    icons = { "•", "◦", "▸", "·" },
    ordered_icons = function(ctx)
      local value = vim.trim(ctx.value or "")
      local num = tonumber(value:sub(1, #value - 1))
      local value_index = num and num > 1 and num or ctx.index
      return string.format("%d.", value_index)
    end,
    left_pad = 0,
    right_pad = 1,
    highlight = "RenderMarkdownBullet",
  },

  -- Refined checkboxes
  checkbox = {
    enabled = true,
    position = "inline",
    unchecked = {
      icon = "󰄱 ",
      highlight = "RenderMarkdownUnchecked",
      scope_highlight = nil,
    },
    checked = {
      icon = "󰄵 ",
      highlight = "RenderMarkdownChecked",
      scope_highlight = "@markup.strikethrough",
    },
    custom = {
      todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
      forwarded = { raw = "[>]", rendered = " ", highlight = "RenderMarkdownInfo" },
      cancelled = { raw = "[~]", rendered = "󰰱 ", highlight = "RenderMarkdownError" },
      important = { raw = "[!]", rendered = " ", highlight = "DiagnosticError" },
      question = { raw = "[?]", rendered = " ", highlight = "DiagnosticWarn" },
      star = { raw = "[*]", rendered = "󰓎 ", highlight = "DiagnosticHint" },
    },
  },

  -- Magazine-style pull-quote with thick magenta rule
  quote = {
    enabled = true,
    icon = "▎",
    repeat_linebreak = true,
    highlight = "RenderMarkdownQuote",
  },

  -- Refined tables: rounded preset, calmer borders
  pipe_table = {
    enabled = true,
    preset = "round",
    style = "full",
    cell = "padded",
    padding = 1,
    min_width = 0,
    alignment_indicator = "─",
    head = "RenderMarkdownTableHead",
    row = "RenderMarkdownTableRow",
    filler = "RenderMarkdownTableFill",
  },

  -- ==Marker-pen== inline highlights
  inline_highlight = {
    enabled = true,
    highlight = "RenderMarkdownInlineHighlight",
  },

  -- Editorial callouts: rounded labels with breathing room
  callout = {
    note = { raw = "[!NOTE]", rendered = "  Note", highlight = "RenderMarkdownInfo" },
    tip = { raw = "[!TIP]", rendered = "  Tip", highlight = "RenderMarkdownSuccess" },
    important = { raw = "[!IMPORTANT]", rendered = "  Important", highlight = "RenderMarkdownHint" },
    warning = { raw = "[!WARNING]", rendered = "  Warning", highlight = "RenderMarkdownWarn" },
    caution = { raw = "[!CAUTION]", rendered = "  Caution", highlight = "RenderMarkdownError" },
    abstract = { raw = "[!ABSTRACT]", rendered = "  Abstract", highlight = "RenderMarkdownInfo" },
    summary = { raw = "[!SUMMARY]", rendered = "  Summary", highlight = "RenderMarkdownInfo" },
    tldr = { raw = "[!TLDR]", rendered = "  TL;DR", highlight = "RenderMarkdownInfo" },
    info = { raw = "[!INFO]", rendered = "  Info", highlight = "RenderMarkdownInfo" },
    todo = { raw = "[!TODO]", rendered = "  Todo", highlight = "RenderMarkdownInfo" },
    hint = { raw = "[!HINT]", rendered = "  Hint", highlight = "RenderMarkdownSuccess" },
    success = { raw = "[!SUCCESS]", rendered = "  Success", highlight = "RenderMarkdownSuccess" },
    check = { raw = "[!CHECK]", rendered = "  Check", highlight = "RenderMarkdownSuccess" },
    done = { raw = "[!DONE]", rendered = "  Done", highlight = "RenderMarkdownSuccess" },
    question = { raw = "[!QUESTION]", rendered = "  Question", highlight = "RenderMarkdownWarn" },
    help = { raw = "[!HELP]", rendered = "  Help", highlight = "RenderMarkdownWarn" },
    faq = { raw = "[!FAQ]", rendered = "  FAQ", highlight = "RenderMarkdownWarn" },
    attention = { raw = "[!ATTENTION]", rendered = "  Attention", highlight = "RenderMarkdownWarn" },
    failure = { raw = "[!FAILURE]", rendered = "  Failure", highlight = "RenderMarkdownError" },
    fail = { raw = "[!FAIL]", rendered = "  Fail", highlight = "RenderMarkdownError" },
    missing = { raw = "[!MISSING]", rendered = "  Missing", highlight = "RenderMarkdownError" },
    danger = { raw = "[!DANGER]", rendered = "  Danger", highlight = "RenderMarkdownError" },
    error = { raw = "[!ERROR]", rendered = "  Error", highlight = "RenderMarkdownError" },
    bug = { raw = "[!BUG]", rendered = "  Bug", highlight = "RenderMarkdownError" },
    example = { raw = "[!EXAMPLE]", rendered = "  Example", highlight = "RenderMarkdownHint" },
    quote = { raw = "[!QUOTE]", rendered = "  Quote", highlight = "RenderMarkdownQuote" },
    cite = { raw = "[!CITE]", rendered = "  Cite", highlight = "RenderMarkdownQuote" },
  },

  -- Links
  link = {
    enabled = true,
    footnote = {
      superscript = true,
      prefix = "",
      suffix = "",
    },
    image = "󰥶 ",
    email = "󰀓 ",
    hyperlink = "󰌹 ",
    highlight = "RenderMarkdownLink",
    wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
    custom = {
      web = { pattern = "^http", icon = "󰖟 " },
      github = { pattern = "github%.com", icon = " " },
      youtube = { pattern = "youtube%.com", icon = "󰗃 " },
      discord = { pattern = "discord%.com", icon = "󰙯 " },
      reddit = { pattern = "reddit%.com", icon = " " },
      stackoverflow = { pattern = "stackoverflow%.com", icon = " " },
    },
  },

  -- Quiet sign column
  sign = {
    enabled = false,
    highlight = "RenderMarkdownSign",
  },

  -- Indent guide off — cleaner long-form reading
  indent = {
    enabled = false,
    per_level = 2,
    skip_level = 1,
    skip_heading = false,
  },

  -- Window options when rendering
  win_options = {
    conceallevel = { default = vim.o.conceallevel, rendered = 2 },
    concealcursor = { default = vim.o.concealcursor, rendered = "" },
  },

  -- Disable yaml frontmatter rendering so dashes stay visible
  yaml = {
    enabled = false,
  },

  -- Overrides for specific filetypes
  overrides = {
    buftype = {
      nofile = { render_modes = { "n", "c", "t", "i" } },
    },
  },
}

require("render-markdown").setup(render_markdown_opts)

-- Paint now, and repaint whenever the colorscheme changes so the
-- editorial palette survives theme reloads.
paint()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("MarkdownEditorialInk", { clear = true }),
  callback = function()
    paint()
    -- render-markdown caches the icon/border colors it derives from
    -- ours and refreshes them on ColorScheme too — but its autocmd was
    -- registered first, so it would recompute from the old palette.
    pcall(function()
      require("render-markdown.core.colors").reload()
    end)
  end,
})

-- ────────────────────────────────────────────────────────────────
--  Reading-mode ergonomics for markdown buffers
--  Soft wrap at 80 columns, breathing line height
--
--  Neovim has no native "soft wrap at column N" — `linebreak` only
--  wraps at the window edge. Trick: pad the window with foldcolumn
--  so the *effective* text area is 80 columns, then `linebreak`
--  wraps there naturally. We recompute padding on resize.
-- ────────────────────────────────────────────────────────────────
local TARGET_WIDTH = 80

local function apply_reading_padding(win)
  if not win or not vim.api.nvim_win_is_valid(win) then return end
  local buf = vim.api.nvim_win_get_buf(win)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  local ft = vim.bo[buf].filetype
  if ft ~= "markdown" then return end
  -- Skip floating windows and special buffers
  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.relative and cfg.relative ~= "" then return end
  if vim.bo[buf].buftype ~= "" then return end

  local win_width = vim.api.nvim_win_get_width(win)
  local gutter = 6 -- sign column + small breathing room
  local available = win_width - gutter
  local padding = math.max(0, math.floor((available - TARGET_WIDTH) / 2))
  padding = math.min(padding, 9) -- foldcolumn maxes at 9
  local target = tostring(padding)
  -- Only update if changed (avoids re-render storm)
  if vim.wo[win].foldcolumn ~= target then
    vim.wo[win].foldcolumn = target
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "  ↳ "
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = ""
    vim.opt_local.spell = false
    vim.opt_local.cursorline = false
    vim.opt_local.signcolumn = "yes:1"
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 8
    vim.opt_local.textwidth = 0
    vim.opt_local.formatoptions:remove("t")
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.colorcolumn = ""
    -- Defer padding so render-markdown can register the buffer first
    vim.schedule(function()
      apply_reading_padding(vim.api.nvim_get_current_win())
    end)
  end,
})

-- Recompute padding only when actually needed, deferred
vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
  callback = function()
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        apply_reading_padding(win)
      end
    end)
  end,
})

-- ── 4. obsidian.nvim ──────────────────────────────────────────────
require("obsidian").setup({
  workspaces = {
    {
      name = "notes",
      path = "~/Documents/notes-2026",
    },
  },
  notes_subdir = "notes",
  log_level = vim.log.levels.INFO,

  daily_notes = {
    folder = "journal/" .. os.date("%m") .. "-" .. os.date("%b"),
    date_format = "%d-%m-%Y",
    alias_format = "%B %-d, %Y",
    default_tags = { "daily-notes" },
    template = nil,
  },

  completion = {
    nvim_cmp = false,
    min_chars = 2,
  },

  mappings = {
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    ["<leader>ch"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
    ["<cr>"] = {
      action = function()
        return require("obsidian").util.smart_action()
      end,
      opts = { buffer = true, expr = true },
    },
  },

  new_notes_location = "notes_subdir",
  note_id_func = function(title)
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,

  note_path_func = function(spec)
    local is_daily = string.match(spec.title or "", "%d%d%-%d%d%-%d%d%d%d")

    if is_daily then
      local month_names = {
        "01-Jan",
        "02-Feb",
        "03-Mar",
        "04-Apr",
        "05-May",
        "06-Jun",
        "07-Jul",
        "08-Aug",
        "09-Sep",
        "10-Oct",
        "11-Nov",
        "12-Dec",
      }
      local current_month = tonumber(os.date("%m"))
      local month_folder = month_names[current_month]

      local path = spec.dir / "journal" / month_folder / spec.id
      return path:with_suffix(".md")
    end

    -- For non-daily notes, use the default behavior
    local path = spec.dir / tostring(spec.id)
    return path:with_suffix(".md")
  end,

  wiki_link_func = function(opts)
    return require("obsidian.util").wiki_link_id_prefix(opts)
  end,

  markdown_link_func = function(opts)
    return require("obsidian.util").markdown_link(opts)
  end,

  preferred_link_style = "wiki",

  disable_frontmatter = false,

  note_frontmatter_func = function(note)
    if note.title then
      note:add_alias(note.title)
    end

    local out = { id = note.id, aliases = note.aliases, tags = note.tags }

    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end

    return out
  end,

  templates = {
    folder = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    substitutions = {},
  },

  follow_url_func = function(url)
    vim.ui.open(url)
  end,

  follow_img_func = function(img)
    vim.ui.open(img)
  end,

  use_advanced_uri = false,

  open_app_foreground = false,

  picker = {
    name = "telescope.nvim",
    note_mappings = {
      new = "<C-x>",
      insert_link = "<C-l>",
    },
    tag_mappings = {
      tag_note = "<C-x>",
      insert_tag = "<C-l>",
    },
  },

  sort_by = "modified",
  sort_reversed = true,
  search_max_lines = 1000,
  open_notes_in = "current",

  callbacks = {
    post_setup = function(client) end,
    enter_note = function(client, note) end,
    leave_note = function(client, note) end,
    pre_write_note = function(client, note) end,
    post_set_workspace = function(client, workspace) end,
  },
  ui = {
    enable = true,      -- set to false to disable all additional syntax features
    update_debounce = 200, -- update delay after a text change (in milliseconds)
    max_file_length = 5000, -- disable UI features for files with more than this many lines
    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
      [">"] = { char = "", hl_group = "ObsidianRightArrow" },
      ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      ["!"] = { char = "", hl_group = "ObsidianImportant" },
    },
    bullets = { char = "•", hl_group = "ObsidianBullet" },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    block_ids = { hl_group = "ObsidianBlockID" },
    hl_groups = {
      -- Same editorial ink as render-markdown
      ObsidianTodo = { bold = true, fg = p.amber },
      ObsidianDone = { bold = true, fg = p.green },
      ObsidianRightArrow = { bold = true, fg = p.blue },
      ObsidianTilde = { bold = true, fg = p.magenta },
      ObsidianImportant = { bold = true, fg = p.amber },
      ObsidianBullet = { bold = true, fg = p.cyan },
      ObsidianRefText = { underline = true, fg = p.magenta },
      ObsidianExtLinkIcon = { fg = p.magenta },
      ObsidianTag = { italic = true, fg = p.cyan },
      ObsidianBlockID = { italic = true, fg = p.cyan },
      ObsidianHighlightText = { bg = p.highlight_bg, fg = p.amber },
    },
  },
  attachments = {
    img_folder = "assets/imgs", -- This is the default
    img_name_func = function()
      return string.format("%s-", os.time())
    end,
    img_text_func = function(client, path)
      path = client:vault_relative_path(path) or path
      return string.format("![%s](%s)", path.name, path)
    end,
  },
})
