vim.g.mapleader = " "

vim.keymap.set("n", "<a-,>", "@a", { noremap = true, silent = true })

-- moves the cursor 20 lines up with alt (option) + up arrow
vim.keymap.set("n", "<a-up>", "20k", { noremap = true, silent = true })

-- moves the cursor 20 lines down with alt (option) + down arrow
vim.keymap.set("n", "<a-down>", "20j", { noremap = true, silent = true })

-- moves the cursor 15 lines up with option (alt) + k
vim.keymap.set("n", "<a-k>", "15k", { noremap = true, silent = true })

-- moves the cursor 15 lines down with option (alt) + j
vim.keymap.set("n", "<a-j>", "15j", { noremap = true, silent = true })

-- moves the cursor to the next word with option (alt) + right arrow
vim.keymap.set("n", "<a-right>", "w", { noremap = true, silent = true })

-- moves the cursor to the previous word with option (alt) + left arrow
vim.keymap.set("n", "<a-left>", "b", { noremap = true, silent = true })

-- move cursor left with option + h in insert mode
vim.api.nvim_set_keymap("i", "<a-h>", "<left>", { noremap = true, silent = true })
-- move cursor down with option + j in insert mode
vim.api.nvim_set_keymap("i", "<a-j>", "<down>", { noremap = true, silent = true })
-- move cursor up with option + k in insert mode
vim.api.nvim_set_keymap("i", "<a-k>", "<up>", { noremap = true, silent = true })
-- move cursor right with option + l in insert mode
vim.api.nvim_set_keymap("i", "<a-l>", "<right>", { noremap = true, silent = true })

-- key mappings for saving a file and closing a buffer
vim.keymap.set("n", "<leader>w", ":w<cr>", { desc = "save file" })
vim.keymap.set("n", "<leader>q", ":q<cr>", { desc = "close file" })
vim.keymap.set("n", "<leader>cc", ":bd<cr>", { desc = "close buffer" })

-- vim.api.nvim_set_keymap("n", "<leader>/", "gcc", { desc = "comment line" })

-- navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<cr>")
vim.keymap.set("n", "<c-j>", ":wincmd j<cr>")
vim.keymap.set("n", "<c-h>", ":wincmd h<cr>")
vim.keymap.set("n", "<c-l>", ":wincmd l<cr>")

vim.api.nvim_set_keymap("n", "<leader>mP", ":PeekOpen<CR>", { noremap = true, silent = true })

-- map 'c' to 'ç' in insert mode
vim.api.nvim_set_keymap("i", "´c", "ç", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "'c", "ç", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "ć", "ç", { noremap = true, silent = true })
