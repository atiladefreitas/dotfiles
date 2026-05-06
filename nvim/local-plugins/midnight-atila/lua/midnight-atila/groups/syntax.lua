-- Classic vim syntax + Treesitter highlights
local M = {}

function M.get(c, opts)
  local italic_comment = opts.italic_comments and { italic = true } or {}
  local italic_keyword = opts.italic_keywords and { italic = true } or {}

  local groups = {
    -- ============== Classic syntax (vim) ==============
    Comment       = vim.tbl_extend("force", { fg = c.comment }, italic_comment),

    Constant      = { fg = c.purple_bright },
    String        = { fg = c.green },
    Character     = { fg = c.green },
    Number        = { fg = c.purple_bright },
    Float         = { fg = c.purple_bright },
    Boolean       = { fg = c.purple_bright, bold = true },

    Identifier    = { fg = c.fg },
    Function      = { fg = c.blue },

    Statement     = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    Conditional   = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    Repeat        = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    Label         = { fg = c.purple },
    Operator      = { fg = c.magenta },
    Keyword       = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    Exception     = { fg = c.red, bold = true },

    PreProc       = { fg = c.cyan },
    Include       = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    Define        = { fg = c.purple },
    Macro         = { fg = c.purple },
    PreCondit     = { fg = c.cyan },

    Type          = { fg = c.yellow },
    StorageClass  = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    Structure     = { fg = c.yellow },
    Typedef       = { fg = c.yellow },

    Special       = { fg = c.cyan },
    SpecialChar   = { fg = c.orange },
    Tag           = { fg = c.blue },
    Delimiter     = { fg = c.fg_dim },
    SpecialComment = vim.tbl_extend("force", { fg = c.blue }, italic_comment),
    Debug         = { fg = c.red },

    Underlined    = { underline = true },
    Bold          = { bold = true },
    Italic        = { italic = true },

    Error         = { fg = c.error, bold = true },
    Todo          = { fg = c.yellow_bright, bg = c.bg_highlight, bold = true },

    -- ============== Treesitter ==============
    ["@variable"]              = { fg = c.fg },
    ["@variable.builtin"]      = { fg = c.red, italic = true },
    ["@variable.parameter"]    = { fg = c.fg_dim, italic = true },
    ["@variable.member"]       = { fg = c.cyan_bright },

    ["@constant"]              = { fg = c.purple_bright },
    ["@constant.builtin"]      = { fg = c.purple_bright, bold = true },
    ["@constant.macro"]        = { fg = c.purple },

    ["@module"]                = { fg = c.yellow },
    ["@label"]                 = { fg = c.purple },

    ["@string"]                = { fg = c.green },
    ["@string.escape"]         = { fg = c.cyan },
    ["@string.regexp"]         = { fg = c.orange },
    ["@string.special"]        = { fg = c.orange },
    ["@string.documentation"]  = vim.tbl_extend("force", { fg = c.green_bright }, italic_comment),

    ["@character"]             = { fg = c.green },
    ["@character.special"]     = { fg = c.orange },

    ["@boolean"]               = { fg = c.purple_bright, bold = true },
    ["@number"]                = { fg = c.purple_bright },
    ["@number.float"]          = { fg = c.purple_bright },

    ["@type"]                  = { fg = c.yellow },
    ["@type.builtin"]          = { fg = c.yellow, italic = true },
    ["@type.definition"]       = { fg = c.yellow, bold = true },
    ["@type.qualifier"]        = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),

    ["@attribute"]             = { fg = c.cyan },
    ["@property"]              = { fg = c.cyan_bright },
    ["@field"]                 = { fg = c.cyan_bright },

    ["@function"]              = { fg = c.blue },
    ["@function.builtin"]      = { fg = c.blue, italic = true },
    ["@function.call"]         = { fg = c.blue },
    ["@function.macro"]        = { fg = c.cyan },
    ["@function.method"]       = { fg = c.blue },
    ["@function.method.call"]  = { fg = c.blue },

    ["@constructor"]           = { fg = c.yellow },
    ["@operator"]              = { fg = c.magenta },

    ["@keyword"]               = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.coroutine"]     = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.function"]      = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.operator"]      = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.import"]        = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.type"]          = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.modifier"]      = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.repeat"]        = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.return"]        = vim.tbl_extend("force", { fg = c.purple, bold = true }, italic_keyword),
    ["@keyword.debug"]         = { fg = c.red, bold = true },
    ["@keyword.exception"]     = { fg = c.red, bold = true },
    ["@keyword.conditional"]   = vim.tbl_extend("force", { fg = c.purple }, italic_keyword),
    ["@keyword.directive"]     = { fg = c.cyan },

    ["@punctuation.delimiter"] = { fg = c.fg_dim },
    ["@punctuation.bracket"]   = { fg = c.fg_dim },
    ["@punctuation.special"]   = { fg = c.fg_dim },

    ["@comment"]               = vim.tbl_extend("force", { fg = c.comment }, italic_comment),
    ["@comment.documentation"] = vim.tbl_extend("force", { fg = c.fg_dark }, italic_comment),
    ["@comment.error"]         = { fg = c.error, bold = true },
    ["@comment.warning"]       = { fg = c.warning, bold = true },
    ["@comment.todo"]          = { fg = c.yellow_bright, bold = true },
    ["@comment.note"]          = { fg = c.info, bold = true },

    ["@tag"]                   = { fg = c.blue },
    ["@tag.attribute"]         = { fg = c.yellow, italic = true },
    ["@tag.delimiter"]         = { fg = c.cyan },

    -- Markdown rainbow headings
    ["@markup.heading"]        = { fg = c.md_h1, bold = true },
    ["@markup.heading.1.markdown"] = { fg = c.md_h1, bold = true },
    ["@markup.heading.2.markdown"] = { fg = c.md_h2, bold = true },
    ["@markup.heading.3.markdown"] = { fg = c.md_h3, bold = true },
    ["@markup.heading.4.markdown"] = { fg = c.md_h4, bold = true },
    ["@markup.heading.5.markdown"] = { fg = c.md_h5, bold = true },
    ["@markup.heading.6.markdown"] = { fg = c.md_h6, bold = true },
    ["@markup.heading.1.marker.markdown"] = { fg = c.md_h1, bold = true },
    ["@markup.heading.2.marker.markdown"] = { fg = c.md_h2, bold = true },
    ["@markup.heading.3.marker.markdown"] = { fg = c.md_h3, bold = true },
    ["@markup.heading.4.marker.markdown"] = { fg = c.md_h4, bold = true },
    ["@markup.heading.5.marker.markdown"] = { fg = c.md_h5, bold = true },
    ["@markup.heading.6.marker.markdown"] = { fg = c.md_h6, bold = true },

    ["@markup.strong"]         = { fg = c.fg, bold = true },
    ["@markup.italic"]         = { fg = c.purple, italic = true },
    ["@markup.strikethrough"]  = { fg = c.fg_dark, strikethrough = true },
    ["@markup.underline"]      = { underline = true },
    ["@markup.quote"]          = { fg = c.fg_dim, italic = true },
    ["@markup.math"]           = { fg = c.cyan },
    ["@markup.link"]           = { fg = c.cyan, underline = true },
    ["@markup.link.label"]     = { fg = c.blue_bright },
    ["@markup.link.url"]       = { fg = c.cyan, underline = true, italic = true },
    ["@markup.raw"]            = { fg = c.green, bg = c.bg_highlight },
    ["@markup.raw.block"]      = { fg = c.fg, bg = c.bg_dark },
    ["@markup.list"]           = { fg = c.purple },
    ["@markup.list.checked"]   = { fg = c.green_bright },
    ["@markup.list.unchecked"] = { fg = c.fg_dim },

    -- Diff in code (treesitter)
    ["@diff.plus"]             = { fg = c.git_add, bg = c.diff_add },
    ["@diff.minus"]            = { fg = c.git_delete, bg = c.diff_delete },
    ["@diff.delta"]            = { fg = c.git_change, bg = c.diff_change },
  }

  return groups
end

return M
