vim.g.mapleader = " "

vim.keymap.set("n", "<a-,>", "@a", { noremap = true, silent = true })

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

vim.keymap.set("n", "<a-[>", "15j", { noremap = true, silent = true })
vim.keymap.set("n", "<a-]>", "15k", { noremap = true, silent = true })

vim.keymap.set("n", "<a-d>", "15j", { noremap = true, silent = true })
vim.keymap.set("n", "<a-w>", "15k", { noremap = true, silent = true })

-- navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- map 'c' to 'ç' in insert mode
vim.api.nvim_set_keymap("i", "´c", "ç", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "'c", "ç", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "ć", "ç", { noremap = true, silent = true })

-- step spell check
vim.api.nvim_set_keymap("n", "<leader>ss", ":set spell!<CR>", { noremap = true, silent = true })

-- insert current time in 24h format
vim.keymap.set("n", "<leader>st", function()
  local current_time = "[ " .. os.date("%H:%M") .. "]  "
  vim.api.nvim_put({ current_time, "" }, "c", true, true)
  vim.api.nvim_command("startinsert")
end, { desc = "paste current time" })

-- Obsidian Today command
vim.keymap.set("n", "<leader>ot", ":ObsidianToday<CR>", { desc = "open today's note", silent = true })

vim.keymap.set("i", "<a-i>", function()
  vim.ui.input({ prompt = " Calculator: " }, function(input)
    local calc = load("return " .. (input or ""))()
    if (calc) then
      vim.api.nvim_feedkeys(tostring(calc) .. "rem", "i", true)
    end
  end)
end)

vim.keymap.set("i", "<a-p>", function()
  vim.ui.input({ prompt = "Tag: " }, function(tag)
    if not tag then return end
    vim.ui.input({ prompt = "Propertie: " }, function(propertie)
      if not propertie then return end
      vim.api.nvim_feedkeys("prose-" .. tag .. ":" .. propertie, "i", true)
    end)
  end)
end)
