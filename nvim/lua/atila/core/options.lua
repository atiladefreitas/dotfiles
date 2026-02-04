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

-- turn on termguicolors for tokyonight colorscheme to work
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

-- fold persistence
opt.viewoptions = "folds,cursor"
opt.sessionoptions:append("folds")

-- auto save and restore folds
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! loadview")
    end
  end,
})
