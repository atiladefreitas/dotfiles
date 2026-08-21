local M = {}

--- Whether a Lua module is reachable on 'runtimepath'.
---
--- Locally-developed plugins are plain checkouts under ~/Documents/projects,
--- not something vim.pack installs, so they are simply absent on a machine
--- that has not cloned them. Their config modules use this to bail out
--- quietly instead of raising at startup. Unlike `pcall(require, ...)` it
--- does not swallow errors thrown by a module that *is* present.
---@param mod string
---@return boolean
function M.has(mod)
	local path = mod:gsub("%.", "/")
	return #vim.api.nvim_get_runtime_file("lua/" .. path .. ".lua", false) > 0
		or #vim.api.nvim_get_runtime_file("lua/" .. path .. "/init.lua", false) > 0
end

--- How many plugins are on 'runtimepath', by how they got there.
--- Filled in by plugins/init.lua; read by the dashboard.
M.counts = { managed = 0, unmanaged = 0, locals = 0 }

--- Stand-in for `require("lazy.stats").stats()`, which the snacks dashboard's
--- built-in "startup" section calls and which obviously no longer exists.
--- Frozen on first call so a dashboard redraw does not keep inflating the
--- number. Everything is eager now, so loaded == count by construction.
---@return { count: integer, loaded: integer, ms: number }
function M.stats()
	if not M._stats then
		local count = M.counts.managed + M.counts.unmanaged + M.counts.locals
		M._stats = {
			count = count,
			loaded = count,
			-- hrtime is nanoseconds; round to one decimal place of a millisecond
			ms = math.floor((vim.uv.hrtime() - (vim.g.atila_start or vim.uv.hrtime())) / 1e5 + 0.5) / 10,
		}
	end
	return M._stats
end

return M
