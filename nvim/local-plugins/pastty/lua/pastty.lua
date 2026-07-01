-- pastty: a persistent "paste-along" panel pinned to the center-right.
--
--   * Press the keybind (<leader>pp) to open an empty floating window on the
--     center-right edge and drop the cursor inside it.
--   * Paste your reference content. As soon as content lands, the cursor jumps
--     back to where you were working so you can keep typing with it in view.
--   * Press the keybind again to jump the cursor back into the panel (and again
--     to jump back out). The panel stays put either way.
--   * Press `q` (normal mode) inside the panel to close it and clear its content.

local M = {}

local config = {
	keymap = "<leader>pp",
	width = 50, -- fixed width, in columns
	min_height = 3, -- floor so the empty panel still looks like a window
	max_height = 0.8, -- never exceed this fraction of the editor height
	margin = 2, -- columns between the panel and the right edge
	border = "rounded",
	title = " pastty ",
}

local state = {
	buf = nil,
	win = nil,
	prev_win = nil,
}

local function is_open()
	return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

-- Center-right placement: fixed width, hugged to the right edge, height fit to
-- content (clamped), vertically centered.
local function win_geometry()
	local width = config.width

	local max_height = math.floor(vim.o.lines * config.max_height)
	local content = state.buf and vim.api.nvim_buf_is_valid(state.buf)
			and vim.api.nvim_buf_line_count(state.buf)
		or 0
	local height = math.max(config.min_height, math.min(content, max_height))

	return {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = vim.o.columns - width - config.margin,
		style = "minimal",
		border = config.border,
		title = config.title,
		title_pos = "center",
	}
end

-- Re-fit and re-center the panel to its current content.
local function refit()
	if is_open() then
		vim.api.nvim_win_set_config(state.win, win_geometry())
	end
end

local function focus_back()
	if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
		vim.api.nvim_set_current_win(state.prev_win)
	end
end

local function ensure_buf()
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		return state.buf
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].filetype = "pastty"

	-- `q` closes the panel and clears it.
	vim.keymap.set("n", "q", function()
		M.close()
	end, { buffer = buf, nowait = true, silent = true, desc = "pastty: close and clear" })

	-- When content lands in the panel while it's focused, hop back to work.
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		buffer = buf,
		callback = function()
			refit()
			if is_open() and vim.api.nvim_get_current_win() == state.win then
				vim.schedule(function()
					if vim.fn.mode() ~= "n" then
						vim.cmd("stopinsert")
					end
					focus_back()
				end)
			end
		end,
	})

	state.buf = buf
	return buf
end

local function open()
	state.prev_win = vim.api.nvim_get_current_win()
	local buf = ensure_buf()
	state.win = vim.api.nvim_open_win(buf, true, win_geometry())
	vim.wo[state.win].number = false
	vim.wo[state.win].relativenumber = false
	vim.wo[state.win].wrap = true
	vim.wo[state.win].winfixbuf = true
end

-- Keybind entry point: open, focus-in, or focus-out depending on state.
function M.toggle()
	if not is_open() then
		open()
		return
	end

	if vim.api.nvim_get_current_win() == state.win then
		focus_back()
	else
		state.prev_win = vim.api.nvim_get_current_win()
		vim.api.nvim_set_current_win(state.win)
	end
end

function M.close()
	if is_open() then
		vim.api.nvim_win_close(state.win, true)
	end
	state.win = nil
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		vim.api.nvim_buf_delete(state.buf, { force = true })
	end
	state.buf = nil
	focus_back()
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	-- Keep the panel pinned to the center-right when the editor is resized.
	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup("Pastty", { clear = true }),
		callback = refit,
	})

	vim.keymap.set("n", config.keymap, function()
		M.toggle()
	end, { desc = "pastty: toggle paste-along panel" })
end

return M
