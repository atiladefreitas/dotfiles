vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.encoding = "utf-8" -- set encoding

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2      -- 2 spaces for indent width
opt.expandtab = true    -- expand tab to spaces
opt.autoindent = true   -- copy indent from current line when starting new one
opt.smartindent = true  -- smart indentation

opt.wrap = true         -- enable soft wrap (visual only, no actual line breaks)
opt.textwidth = 0       -- disable auto hard-wrap (don't insert actual line breaks)
opt.linebreak = true    -- wrap at word boundaries, not mid-word
opt.colorcolumn = "120" -- show visual indicator at 120 characters
opt.columns = 120       -- set window width to 120 columns

opt.conceallevel = 1

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

opt.linespace = 4

-- Native treesitter folding (Neovim 0.11+), replaces nvim-ufo.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- treesitter foldexpr yields no folds when a buffer has no parser, so fall back
-- to indent folding there (ufo did this via provider_selector = {treesitter, indent}).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("atila_fold_fallback", { clear = true }),
  callback = function(ev)
    local ok, parser = pcall(vim.treesitter.get_parser, ev.buf, nil, { error = false })
    if not ok or not parser then
      vim.opt_local.foldmethod = "indent"
    end
  end,
})

-- Fold column: show fold state markers on the left (matches midnight-atila theme)
opt.foldcolumn = "1"
opt.foldlevel = 99      -- start with all folds open
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars:append({
  eob = " ",          -- no ~ past the last line: windows read as blocks
  fold = " ",
  foldopen = "▾",     -- open fold marker
  foldclose = "▸",    -- closed fold marker
  foldsep = "│",
})

-- turn on termguicolors for the colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- Native treesitter highlighting for all supported filetypes (Neovim 0.12+)
-- Markdown, Lua, Help, and Query are handled by the runtime ftplugins already.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript", "typescript", "typescriptreact", "javascriptreact",
    "html", "css", "scss", "json", "jsonc", "yaml",
    "python", "vim", "vimdoc", "tsx",
    "jinja", "jinja2",
  },
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- No mkview/loadview fold persistence: view files bake in foldmethod/foldexpr,
-- which silently overrode the treesitter foldexpr set above. Folds are derived
-- from the parser on every open instead.
