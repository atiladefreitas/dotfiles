-- External-change detection, tuned for an agent (Claude Code, opencode…)
-- editing files on disk while they sit open in Neovim.
--
-- Nvim 0.13 drives 'autoread' from OS filewatcher events (|uv_fs_event_t|),
-- so a buffer reloads the moment its file changes. Nvim 0.12 only compares
-- timestamps on FocusGained, after shell commands, or on an explicit
-- :checktime — which is why an edit made from another tmux pane sat unseen
-- until the cursor moved or focus came back.
--
-- Below 0.13 the same thing is built here on libuv: one fs_event per
-- directory that holds a loaded file buffer. The directory, not the file, is
-- watched on purpose: atomic writes (write to a temp file, then rename over
-- the original) replace the inode, and a per-file watch would be left
-- pointing at the old, now-unlinked one.

vim.o.autoread = true

local group = vim.api.nvim_create_augroup("atila_autoreload", { clear = true })

-- Only fire :checktime when Nvim can actually act on it. In Cmdline mode the
-- buffer swap is refused, and inside the cmdwin it errors.
local function can_checktime()
	return vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == ""
end

local function checktime(buf)
	if not can_checktime() then
		return false
	end
	if buf then
		if vim.api.nvim_buf_is_loaded(buf) then
			vim.cmd(("silent! checktime %d"):format(buf))
		end
	else
		vim.cmd("silent! checktime")
	end
	return true
end

-- Cheap sweep on focus/buffer entry. Kept on every version as a safety net:
-- inotify has per-user limits and network filesystems emit no events at all.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = group,
	callback = function()
		checktime()
	end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	group = group,
	callback = function(ev)
		local name = vim.fn.fnamemodify(ev.file, ":~:.")
		vim.notify(("Reloaded %s (changed on disk)"):format(name), vim.log.levels.INFO)
	end,
})

-- 0.13+: 'autoread' is watcher-driven natively; nothing more to do.
if vim.fn.has("nvim-0.13") == 1 then
	return
end

-- ── libuv watcher backport for 0.12 ─────────────────────────────────
local uv = vim.uv

---@class atila.DirWatch
---@field handle uv.uv_fs_event_t
---@field bufs table<integer, string> buffer -> basename of its file in this dir

---@type table<string, atila.DirWatch> directory -> watch
local watches = {}
---@type table<integer, string> buffer -> directory it is registered under
local buf_dir = {}
---@type table<integer, uv.uv_timer_t> buffer -> pending debounce timer
local pending = {}

-- Agents write in bursts (several edits to one file within milliseconds),
-- and one :checktime per burst is plenty.
local DEBOUNCE_MS = 50
-- If an event lands while the cmdline is open, try again shortly instead of
-- dropping it: the change would otherwise wait for the next BufEnter.
local RETRY_MS = 250

local function schedule_checktime(buf)
	local timer = pending[buf]
	if not timer then
		timer = assert(uv.new_timer())
		pending[buf] = timer
	end
	timer:stop()
	timer:start(
		DEBOUNCE_MS,
		0,
		vim.schedule_wrap(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				timer:stop()
				timer:close()
				pending[buf] = nil
				return
			end
			if not checktime(buf) then
				timer:start(RETRY_MS, 0, vim.schedule_wrap(function()
					checktime(buf)
				end))
			end
		end)
	)
end

local function on_dir_event(dir, err, filename)
	if err then
		return
	end
	local w = watches[dir]
	if not w then
		return
	end
	for buf, name in pairs(w.bufs) do
		-- libuv omits the filename on some platforms; treat that as "any".
		if filename == nil or filename == name then
			schedule_checktime(buf)
		end
	end
end

local function unwatch(buf)
	local timer = pending[buf]
	if timer then
		timer:stop()
		timer:close()
		pending[buf] = nil
	end

	local dir = buf_dir[buf]
	if not dir then
		return
	end
	buf_dir[buf] = nil
	local w = watches[dir]
	if not w then
		return
	end
	w.bufs[buf] = nil
	if next(w.bufs) == nil then
		w.handle:stop()
		w.handle:close()
		watches[dir] = nil
	end
end

local function watch(buf)
	if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= "" then
		return
	end
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return
	end
	local dir = vim.fs.dirname(name)
	local base = vim.fs.basename(name)

	if buf_dir[buf] == dir then
		-- Same directory (e.g. a plain :w); just refresh the basename in case
		-- the buffer was renamed within it.
		watches[dir].bufs[buf] = base
		return
	end
	unwatch(buf)

	if (uv.fs_stat(dir) or {}).type ~= "directory" then
		return
	end

	local w = watches[dir]
	if not w then
		local handle = uv.new_fs_event()
		if not handle then
			return
		end
		local _, start_err = handle:start(dir, {}, function(err, filename)
			on_dir_event(dir, err, filename)
		end)
		if start_err then
			handle:close()
			return
		end
		w = { handle = handle, bufs = {} }
		watches[dir] = w
	end
	w.bufs[buf] = base
	buf_dir[buf] = dir
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost", "BufFilePost" }, {
	group = group,
	callback = function(ev)
		watch(ev.buf)
	end,
})

vim.api.nvim_create_autocmd({ "BufUnload", "BufWipeout" }, {
	group = group,
	callback = function(ev)
		unwatch(ev.buf)
	end,
})

-- Buffers that were already loaded when this file was sourced (:restart,
-- re-sourcing the config).
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	watch(buf)
end

vim.api.nvim_create_user_command("AutoreadStatus", function()
	local lines = {}
	for dir, w in pairs(watches) do
		local names = {}
		for _, base in pairs(w.bufs) do
			names[#names + 1] = base
		end
		table.sort(names)
		lines[#lines + 1] = ("%s: %s"):format(vim.fn.fnamemodify(dir, ":~"), table.concat(names, ", "))
	end
	table.sort(lines)
	vim.notify(#lines > 0 and table.concat(lines, "\n") or "no directories watched", vim.log.levels.INFO)
end, { desc = "List directories the autoread watcher is tracking" })
