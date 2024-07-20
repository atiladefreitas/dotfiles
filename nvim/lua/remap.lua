-- Adds mapping to activate the window to the right with 'frvim.keymap.set("n", "<leader>fr", "<C-w>l", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fr", "To the LEFT", {noremap = true, silent = true})

-- Mapping to activate the window to the left with 'fl'
vim.keymap.set("n", "<leader>fl", "To the RIGHT", {noremap = true, silent = true})

-- Calls LazyGit
vim.keymap.set("n", "<leader>G", ":LazyGit<CR>");

-- Moves the cursor 20 lines up with Alt (Option) + Up Arrow
vim.keymap.set("n", "<A-Up>", "20k", {noremap = true, silent = true})

-- Moves the cursor 20 lines down with Alt (Option) + Down Arrow
vim.keymap.set("n", "<A-Down>", "20j", {noremap = true, silent = true})

-- Moves the cursor 15 lines up with Option (Alt) + k
vim.keymap.set("n", "<A-k>", "15k", {noremap = true, silent = true})

-- Moves the cursor 15 lines down with Option (Alt) + j
vim.keymap.set("n", "<A-j>", "15j", {noremap = true, silent = true})

-- Moves the cursor to the next word with Option (Alt) + Right Arrow
vim.keymap.set("n", "<A-Right>", "w", {noremap = true, silent = true})

-- Moves the cursor to the previous word with Option (Alt) + Left Arrow
vim.keymap.set("n", "<A-Left>", "b", {noremap = true, silent = true})

-- Move cursor left with Option + h in insert mode
vim.api.nvim_set_keymap('i', '<A-h>', '<Left>', { noremap = true, silent = true })
-- Move cursor down with Option + j in insert mode
vim.api.nvim_set_keymap('i', '<A-j>', '<Down>', { noremap = true, silent = true })
-- Move cursor up with Option + k in insert mode
vim.api.nvim_set_keymap('i', '<A-k>', '<Up>', { noremap = true, silent = true })
-- Move cursor right with Option + l in insert mode
vim.api.nvim_set_keymap('i', '<A-l>', '<Right>', { noremap = true, silent = true })


-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
