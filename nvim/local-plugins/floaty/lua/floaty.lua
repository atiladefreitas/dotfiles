-- floaty: edit a visual selection in a floating window that syncs back
-- to the originating buffer.
--
--   * Select lines in visual mode and trigger `open()` (mapped to <leader>fe).
--   * A floating, syntax-highlighted scratch window opens with just those lines.
--   * `:w` inside the float writes the lines back into the source buffer
--     (in-memory only — the source file stays dirty until you save it).
--   * `q` in normal mode syncs any pending changes and closes the float.

local M = {}

local config = {
	keymap = "<leader>fe",
	max_width = 0.8, -- never exceed this fraction of the editor width
	max_height = 0.8, -- never exceed this fraction of the editor height
	min_width = 20, -- floor so tiny selections still look like a window
	padding = 4, -- extra columns of breathing room around the content
	border = "rounded",
}

-- Push the float's contents back into the source buffer. The source range is
-- adjusted afterwards so repeated saves (which may change the line count) keep
-- targeting the right region.
local function sync_back(state)
	if not (vim.api.nvim_buf_is_valid(state.float_buf) and vim.api.nvim_buf_is_valid(state.src_buf)) then
		return
	end

	local lines = vim.api.nvim_buf_get_lines(state.float_buf, 0, -1, false)
	vim.api.nvim_buf_set_lines(state.src_buf, state.start_line - 1, state.end_line, false, lines)

	state.end_line = state.start_line - 1 + #lines
	vim.bo[state.float_buf].modified = false
end

local function close(state)
	if state.synced_on_close ~= false and vim.bo[state.float_buf].modified then
		sync_back(state)
	end
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end
end

-- Resolve the current visual selection's line range. Works while still in
-- visual mode: `v` is the selection anchor, `.` is the cursor.
local function visual_range()
	local anchor = vim.fn.line("v")
	local cursor = vim.fn.line(".")
	if anchor > cursor then
		anchor, cursor = cursor, anchor
	end
	return anchor, cursor
end

function M.open()
	local src_buf = vim.api.nvim_get_current_buf()
	local start_line, end_line = visual_range()

	-- Leave visual mode so the highlight doesn't linger.
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

	local lines = vim.api.nvim_buf_get_lines(src_buf, start_line - 1, end_line, false)
	local filetype = vim.bo[src_buf].filetype
	local src_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(src_buf), ":t")
	if src_name == "" then
		src_name = "[No Name]"
	end

	local float_buf = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
	vim.bo[float_buf].filetype = filetype
	vim.bo[float_buf].buftype = "acwrite" -- intercept :w via BufWriteCmd
	vim.bo[float_buf].bufhidden = "wipe"
	vim.bo[float_buf].modified = false
	vim.api.nvim_buf_set_name(float_buf, ("floaty://%s [%d-%d]"):format(src_name, start_line, end_line))

	-- Size the window to the content, clamped to a max fraction of the editor.
	local max_width = math.floor(vim.o.columns * config.max_width)
	local max_height = math.floor(vim.o.lines * config.max_height)

	local longest = 0
	for _, line in ipairs(lines) do
		longest = math.max(longest, vim.fn.strdisplaywidth(line))
	end

	local width = math.max(config.min_width, math.min(longest + config.padding, max_width))
	local height = math.max(1, math.min(#lines, max_height))

	local win = vim.api.nvim_open_win(float_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = config.border,
		title = (" %s  %d-%d "):format(src_name, start_line, end_line),
		title_pos = "center",
	})
	vim.wo[win].number = true
	vim.wo[win].relativenumber = true
	vim.wo[win].wrap = false

	local state = {
		src_buf = src_buf,
		float_buf = float_buf,
		win = win,
		start_line = start_line,
		end_line = end_line,
		synced_on_close = true,
	}

	local group = vim.api.nvim_create_augroup("Floaty_" .. float_buf, { clear = true })

	-- `:w` inside the float syncs back instead of touching disk.
	vim.api.nvim_create_autocmd("BufWriteCmd", {
		group = group,
		buffer = float_buf,
		callback = function()
			sync_back(state)
		end,
	})

	-- If the source buffer goes away, the float can't sync anywhere.
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		buffer = float_buf,
		callback = function()
			state.synced_on_close = false
		end,
	})

	-- `q` in normal mode: sync (if dirty) and close.
	vim.keymap.set("n", "q", function()
		close(state)
	end, { buffer = float_buf, nowait = true, silent = true, desc = "Floaty: sync and close" })
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	vim.keymap.set("v", config.keymap, function()
		M.open()
	end, { desc = "Floaty: edit selection in floating window" })
end

return M
