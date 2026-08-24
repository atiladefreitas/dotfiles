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

-- manual reload neovim
vim.keymap.set("n", "<leader>rs", ":restart<CR>", { desc = "restart neovim" })

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

-- highlight groups for floating inputs, in the active scheme's accents
require("atila.plugins.theme").on_change("float-inputs", function(p)
	vim.api.nvim_set_hl(0, "FloatCalcBorder", { fg = p.blue })
	vim.api.nvim_set_hl(0, "FloatCalcTitle", { fg = p.blue, bold = true })
	vim.api.nvim_set_hl(0, "FloatProseBorder", { fg = p.orange })
	vim.api.nvim_set_hl(0, "FloatProseTitle", { fg = p.orange, bold = true })
end)

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

	vim.diagnostic.enable(false, { bufnr = buf })

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
			local text = tostring(result) .. "rem"
			vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { text })
			vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #text })
		end
	end)
end)

-- prose-supported tags from Tailwind Typography
local prose_tags = {
	{ tag = "headings", desc = "all h1–h6" },
	{ tag = "h1", desc = "heading 1" },
	{ tag = "h2", desc = "heading 2" },
	{ tag = "h3", desc = "heading 3" },
	{ tag = "h4", desc = "heading 4" },
	{ tag = "h5", desc = "heading 5" },
	{ tag = "h6", desc = "heading 6" },
	{ tag = "p", desc = "paragraph" },
	{ tag = "lead", desc = "lead paragraph" },
	{ tag = "a", desc = "link" },
	{ tag = "strong", desc = "bold" },
	{ tag = "em", desc = "italic" },
	{ tag = "small", desc = "small text" },
	{ tag = "kbd", desc = "keyboard" },
	{ tag = "code", desc = "inline code" },
	{ tag = "pre", desc = "code block" },
	{ tag = "blockquote", desc = "blockquote" },
	{ tag = "ol", desc = "ordered list" },
	{ tag = "ul", desc = "unordered list" },
	{ tag = "li", desc = "list item" },
	{ tag = "table", desc = "table" },
	{ tag = "thead", desc = "table head" },
	{ tag = "tbody", desc = "table body" },
	{ tag = "tr", desc = "table row" },
	{ tag = "th", desc = "table header cell" },
	{ tag = "td", desc = "table cell" },
	{ tag = "img", desc = "image" },
	{ tag = "video", desc = "video" },
	{ tag = "figure", desc = "figure" },
	{ tag = "figcaption", desc = "figure caption" },
	{ tag = "hr", desc = "horizontal rule" },
}

local function float_select(opts, items, on_submit)
	local parent_win = vim.api.nvim_get_current_win()
	local cursor = vim.api.nvim_win_get_cursor(parent_win)

	local max_tag = 0
	for _, item in ipairs(items) do
		if #item.tag > max_tag then
			max_tag = #item.tag
		end
	end

	local function fmt(item)
		local pad = string.rep(" ", max_tag - #item.tag)
		return "  " .. item.tag .. pad .. "  " .. item.desc
	end

	local width = opts.width
	local result_height = math.min(#items, 12)

	local input_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[input_buf].buftype = "nofile"
	vim.bo[input_buf].bufhidden = "wipe"
	vim.b[input_buf].disable_blink_cmp = true

	local result_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[result_buf].buftype = "nofile"
	vim.bo[result_buf].bufhidden = "wipe"

	local result_win = vim.api.nvim_open_win(result_buf, false, {
		relative = "win",
		win = parent_win,
		width = width,
		height = result_height,
		row = 4,
		col = 0,
		bufpos = { cursor[1] - 1, cursor[2] },
		style = "minimal",
		border = "single",
		focusable = false,
	})

	local input_win = vim.api.nvim_open_win(input_buf, true, {
		relative = "win",
		win = parent_win,
		width = width,
		height = 1,
		row = 1,
		col = 0,
		bufpos = { cursor[1] - 1, cursor[2] },
		style = "minimal",
		border = "single",
		title = " " .. opts.icon .. " " .. opts.title .. " ",
		title_pos = "center",
	})

	vim.wo[input_win].winhighlight = "FloatBorder:" .. opts.border_hl .. ",FloatTitle:" .. opts.title_hl
	vim.wo[result_win].winhighlight = "FloatBorder:" .. opts.border_hl .. ",CursorLine:Visual"
	vim.wo[result_win].cursorline = true
	vim.wo[result_win].cursorlineopt = "line"

	vim.diagnostic.enable(false, { bufnr = input_buf })
	vim.diagnostic.enable(false, { bufnr = result_buf })

	local filtered = {}

	local function refresh()
		local query = (vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)[1] or ""):lower()
		filtered = {}
		for _, item in ipairs(items) do
			if query == "" or item.tag:lower():find(query, 1, true) then
				table.insert(filtered, item)
			end
		end
		local lines = {}
		for _, item in ipairs(filtered) do
			table.insert(lines, fmt(item))
		end
		if #lines == 0 then
			lines = { "  no matches" }
		end
		vim.bo[result_buf].modifiable = true
		vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, lines)
		vim.bo[result_buf].modifiable = false
		if #filtered > 0 and vim.api.nvim_win_is_valid(result_win) then
			vim.api.nvim_win_set_cursor(result_win, { 1, 0 })
		end
	end

	refresh()
	vim.schedule(function()
		if vim.api.nvim_win_is_valid(input_win) then
			vim.api.nvim_set_current_win(input_win)
			vim.cmd("startinsert!")
		end
	end)

	local closed = false
	local function close()
		if closed then
			return
		end
		closed = true
		pcall(vim.api.nvim_win_close, input_win, true)
		pcall(vim.api.nvim_win_close, result_win, true)
	end

	local function move(delta)
		if #filtered == 0 or not vim.api.nvim_win_is_valid(result_win) then
			return
		end
		local row = vim.api.nvim_win_get_cursor(result_win)[1] + delta
		if row < 1 then
			row = #filtered
		elseif row > #filtered then
			row = 1
		end
		vim.api.nvim_win_set_cursor(result_win, { row, 0 })
	end

	local function select_current()
		if #filtered == 0 then
			close()
			return
		end
		local row = vim.api.nvim_win_get_cursor(result_win)[1]
		local item = filtered[row]
		close()
		if item then
			on_submit(item.tag, cursor)
		end
	end

	vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
		buffer = input_buf,
		callback = refresh,
	})
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = input_buf,
		once = true,
		callback = close,
	})

	local map_opts = { buffer = input_buf, nowait = true }
	vim.keymap.set({ "i", "n" }, "<Esc>", close, map_opts)
	vim.keymap.set({ "i", "n" }, "<CR>", select_current, map_opts)
	vim.keymap.set({ "i", "n" }, "<Tab>", select_current, map_opts)
	vim.keymap.set("i", "<C-n>", function()
		move(1)
	end, map_opts)
	vim.keymap.set("i", "<C-p>", function()
		move(-1)
	end, map_opts)
	vim.keymap.set("i", "<C-j>", function()
		move(1)
	end, map_opts)
	vim.keymap.set("i", "<C-k>", function()
		move(-1)
	end, map_opts)
	vim.keymap.set("i", "<Down>", function()
		move(1)
	end, map_opts)
	vim.keymap.set("i", "<Up>", function()
		move(-1)
	end, map_opts)
end

vim.keymap.set("i", "<a-p>", function()
	float_select(
		{
			title = "Prose Tag",
			icon = "󰓹 ",
			width = 36,
			border_hl = "FloatProseBorder",
			title_hl = "FloatProseTitle",
		},
		prose_tags,
		function(tag, cursor)
			local prefix = "prose-" .. tag .. ":"
			vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { prefix })
			vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #prefix })
			if vim.api.nvim_win_get_cursor(0)[2] >= #vim.api.nvim_get_current_line() then
				vim.cmd("startinsert!")
			else
				vim.cmd("startinsert")
			end

			vim.schedule(function()
				require("blink.cmp").show()
			end)
		end
	)
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

-- Toggle prettier line wrapping (120 <-> effectively off)
vim.keymap.set("n", "<leader>tw", function()
	if (vim.g.prettier_print_width or 120) == 120 then
		vim.g.prettier_print_width = 9999
		vim.notify("Prettier line wrapping disabled")
	else
		vim.g.prettier_print_width = 120
		vim.notify("Prettier line wrapping enabled (120)")
	end
end, { desc = "Toggle prettier line wrapping" })
