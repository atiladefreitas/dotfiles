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

-- manual reload buffer
vim.keymap.set("n", "<c-r>", ":e<cr>", { desc = "reload buffer" })

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

-- highlight groups for floating inputs
vim.api.nvim_set_hl(0, "FloatCalcBorder", { fg = "#7aa2f7" })
vim.api.nvim_set_hl(0, "FloatCalcTitle", { fg = "#7aa2f7", bold = true })
vim.api.nvim_set_hl(0, "FloatProseBorder", { fg = "#ff9e64" })
vim.api.nvim_set_hl(0, "FloatProseTitle", { fg = "#ff9e64", bold = true })

-- floating input at cursor position
local function float_input(opts, on_submit)
	local parent_buf = vim.api.nvim_get_current_buf()
	local parent_win = vim.api.nvim_get_current_win()
	local cursor = vim.api.nvim_win_get_cursor(parent_win)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "win",
		win = parent_win,
		width = opts.width,
		height = 1,
		row = 1,
		col = 0,
		bufpos = { cursor[1] - 1, cursor[2] },
		style = "minimal",
		border = "single",
		title = " " .. opts.icon .. " " .. opts.title .. " ",
		title_pos = "center",
	})

	vim.wo[win].winhighlight = "FloatBorder:" .. opts.border_hl .. ",FloatTitle:" .. opts.title_hl

	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.cmd("startinsert!")

	vim.diagnostic.disable(buf)

	local function close()
		pcall(vim.api.nvim_win_close, win, true)
	end

	vim.keymap.set({ "i", "n" }, "<Esc>", close, { buffer = buf })
	vim.keymap.set("n", "q", close, { buffer = buf })

	vim.keymap.set("i", "<CR>", function()
		local input = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
		close()
		if input and input ~= "" then
			on_submit(input, parent_buf, parent_win, cursor)
		end
	end, { buffer = buf })
end

vim.keymap.set("i", "<a-i>", function()
	float_input({
		title = "Calculator",
		icon = " ",
		width = 40,
		border_hl = "FloatCalcBorder",
		title_hl = "FloatCalcTitle",
	}, function(input, _, _, cursor)
		local ok, result = pcall(function()
			return load("return " .. input)()
		end)

		if ok and result ~= nil then
			local text = tostring(result)
			vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { text })
			vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #text })
		end
	end)
end)

vim.keymap.set("i", "<a-p>", function()
	float_input({
		title = "Tag",
		icon = "󰓹 ",
		width = 30,
		border_hl = "FloatProseBorder",
		title_hl = "FloatProseTitle",
	}, function(tag, _, _, cursor)
		local prefix = "prose-" .. tag .. ":"
		vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { prefix })
		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #prefix })

		vim.schedule(function()
			require("blink.cmp").show()
		end)
	end)
end)

vim.keymap.set("n", "<a-e>", ":Widgy<CR>", { desc = "create widgy widget" })

-- Obsidian Today command
vim.keymap.set("n", "<leader>oT", ":ObsidianToday<CR>", { desc = "open today's note", silent = true })

-- Bufferline navigation keymaps
-- vim.keymap.set("n", "<tab>q", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "go to buffer 1" })
-- vim.keymap.set("n", "<tab>w", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "go to buffer 2" })
-- vim.keymap.set("n", "<tab>e", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "go to buffer 3" })
-- vim.keymap.set("n", "<tab>a", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "go to buffer 4" })
-- vim.keymap.set("n", "<tab>s", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "go to buffer 5" })
-- vim.keymap.set("n", "<tab>d", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "go to buffer 6" })

-- vim.keymap.set("n", "<a-q>", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "go to buffer 1" })
-- vim.keymap.set("n", "<a-w>", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "go to buffer 2" })
-- vim.keymap.set("n", "<a-e>", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "go to buffer 3" })
-- vim.keymap.set("n", "<a-a>", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "go to buffer 4" })
-- vim.keymap.set("n", "<a-s>", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "go to buffer 5" })
-- vim.keymap.set("n", "<a-d>", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "go to buffer 6" })

-- Toggle diagnostics (linting)
vim.keymap.set("n", "<leader>tF", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	if vim.diagnostic.is_enabled() then
		vim.notify("Diagnostics enabled")
	else
		vim.notify("Diagnostics disabled")
	end
end, { desc = "Toggle diagnostics" })

-- Toggle format on save
vim.keymap.set("n", "<leader>tf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	if vim.g.disable_autoformat then
		vim.notify("Format on save disabled")
	else
		vim.notify("Format on save enabled")
	end
end, { desc = "Toggle format on save" })
