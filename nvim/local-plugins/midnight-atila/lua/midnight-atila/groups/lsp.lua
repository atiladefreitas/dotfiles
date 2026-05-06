-- LSP / Diagnostics highlight groups
local M = {}

function M.get(c, _opts)
  return {
    -- Diagnostic colors
    DiagnosticError            = { fg = c.error, bold = true },
    DiagnosticWarn             = { fg = c.warning, bold = true },
    DiagnosticInfo             = { fg = c.info },
    DiagnosticHint             = { fg = c.hint },
    DiagnosticOk               = { fg = c.ok },

    -- Virtual text (subtler bg)
    DiagnosticVirtualTextError = { fg = c.error, bg = c.diff_delete, bold = true },
    DiagnosticVirtualTextWarn  = { fg = c.warning, bg = c.bg_highlight },
    DiagnosticVirtualTextInfo  = { fg = c.info, bg = c.bg_highlight },
    DiagnosticVirtualTextHint  = { fg = c.hint, bg = c.bg_highlight },
    DiagnosticVirtualTextOk    = { fg = c.ok, bg = c.bg_highlight },

    -- Underline
    DiagnosticUnderlineError   = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn    = { sp = c.warning, undercurl = true },
    DiagnosticUnderlineInfo    = { sp = c.info, undercurl = true },
    DiagnosticUnderlineHint    = { sp = c.hint, undercurl = true },
    DiagnosticUnderlineOk      = { sp = c.ok, undercurl = true },

    -- Floats / signs
    DiagnosticFloatingError    = { fg = c.error },
    DiagnosticFloatingWarn     = { fg = c.warning },
    DiagnosticFloatingInfo     = { fg = c.info },
    DiagnosticFloatingHint     = { fg = c.hint },

    DiagnosticSignError        = { fg = c.error },
    DiagnosticSignWarn         = { fg = c.warning },
    DiagnosticSignInfo         = { fg = c.info },
    DiagnosticSignHint         = { fg = c.hint },

    -- LSP references / inlay
    LspReferenceText           = { bg = c.bg_highlight, bold = true },
    LspReferenceRead           = { bg = c.bg_highlight },
    LspReferenceWrite          = { bg = c.bg_visual },
    LspInlayHint               = { fg = c.muted, bg = c.bg_dark, italic = true },
    LspCodeLens                = { fg = c.fg_dark, italic = true },
    LspSignatureActiveParameter = { fg = c.yellow_bright, bold = true, underline = true },

    -- LSP semantic tokens (modern)
    ["@lsp.type.namespace"]    = { fg = c.yellow },
    ["@lsp.type.type"]         = { fg = c.yellow },
    ["@lsp.type.class"]        = { fg = c.yellow, bold = true },
    ["@lsp.type.interface"]    = { fg = c.yellow },
    ["@lsp.type.struct"]       = { fg = c.yellow },
    ["@lsp.type.enum"]         = { fg = c.yellow },
    ["@lsp.type.enumMember"]   = { fg = c.purple_bright },
    ["@lsp.type.parameter"]    = { fg = c.fg_dim, italic = true },
    ["@lsp.type.variable"]     = { fg = c.fg },
    ["@lsp.type.property"]     = { fg = c.cyan_bright },
    ["@lsp.type.function"]     = { fg = c.blue },
    ["@lsp.type.method"]       = { fg = c.blue },
    ["@lsp.type.macro"]        = { fg = c.cyan },
    ["@lsp.type.decorator"]    = { fg = c.cyan },
    ["@lsp.type.keyword"]      = { fg = c.purple },
    ["@lsp.type.string"]       = { fg = c.green },
    ["@lsp.type.number"]       = { fg = c.purple_bright },
    ["@lsp.type.comment"]      = { fg = c.comment, italic = true },
    ["@lsp.typemod.variable.readonly"] = { fg = c.purple_bright },
    ["@lsp.typemod.variable.global"]   = { fg = c.purple_bright, bold = true },
    ["@lsp.typemod.function.defaultLibrary"] = { fg = c.blue, italic = true },
    ["@lsp.typemod.method.defaultLibrary"]   = { fg = c.blue, italic = true },
  }
end

return M
