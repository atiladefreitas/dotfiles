-- Repo context line for the dashboard: name, branch, ahead/behind, dirty count.
--
-- `git status` runs off the startup path: the line renders with the repo name
-- right away and fills itself in once the call comes back, which then asks the
-- dashboard to redraw.
local M = {}

local TTL = 5 -- seconds a reading stays fresh
local cache = {} ---@type table<string, { at: number, info: table }>
local pending = {} ---@type table<string, boolean>

local function parse(out)
	local info = { ahead = 0, behind = 0, changed = 0 }
	for line in out:gmatch("[^\n]+") do
		if line:sub(1, 1) == "#" then
			local head = line:match("^# branch%.head (.+)$")
			local oid = line:match("^# branch%.oid (%x+)")
			local ahead, behind = line:match("^# branch%.ab %+(%d+) %-(%d+)$")
			info.branch = head or info.branch
			info.oid = oid or info.oid
			if ahead then
				info.ahead, info.behind = tonumber(ahead), tonumber(behind)
			end
		else
			-- every remaining line is a changed, unmerged or untracked entry
			info.changed = info.changed + 1
		end
	end
	if info.branch == "(detached)" then
		info.branch = info.oid and info.oid:sub(1, 7) or "detached"
	end
	return info
end

local function fetch(root)
	if pending[root] then
		return
	end
	pending[root] = true

	local cmd = { "git", "status", "--porcelain=v2", "--branch" }
	local ok = pcall(vim.system, cmd, { cwd = root, text = true }, function(result)
		vim.schedule(function()
			pending[root] = nil
			if result.code ~= 0 then
				return
			end
			cache[root] = { at = os.time(), info = parse(result.stdout or "") }
			-- the redraw finds a fresh cache, so it will not fetch again
			pcall(function()
				Snacks.dashboard.update()
			end)
		end)
	end)

	if not ok then
		pending[root] = nil
	end
end

local function truncate(text, width)
	if width < 2 or vim.api.nvim_strwidth(text) <= width then
		return text
	end
	local out = text
	while vim.api.nvim_strwidth(out) > width - 1 do
		out = vim.fn.strcharpart(out, 0, vim.fn.strchars(out) - 1)
	end
	return out .. "…"
end

--- Build a snacks.dashboard section describing the repo Neovim was opened in.
--- Renders nothing outside a git repository.
---@param opts? { pane?: number, width?: number }
function M.section(opts)
	opts = opts or {}

	return function(self)
		local width = opts.width or (self and self.opts and self.opts.width) or 60
		local root = vim.fs.root(vim.uv.cwd() or ".", ".git")
		if not root then
			return {}
		end

		local entry = cache[root]
		if not entry or os.time() - entry.at >= TTL then
			fetch(root)
		end
		local info = entry and entry.info or {}

		-- everything after the repo name, so the name can take the rest
		local tail = {}
		if info.branch then
			tail[#tail + 1] = { " · ", hl = "SnacksDashboardDir" }
			tail[#tail + 1] = { info.branch, hl = "SnacksDashboardDesc" }
		end
		if (info.ahead or 0) > 0 then
			tail[#tail + 1] = { " ↑" .. info.ahead, hl = "GitSignsAdd" }
		end
		if (info.behind or 0) > 0 then
			tail[#tail + 1] = { " ↓" .. info.behind, hl = "GitSignsDelete" }
		end
		if (info.changed or 0) > 0 then
			tail[#tail + 1] = { " · ", hl = "SnacksDashboardDir" }
			tail[#tail + 1] = { info.changed .. " changed", hl = "GitSignsChange" }
		end

		local tail_width = 0
		for _, part in ipairs(tail) do
			tail_width = tail_width + vim.api.nvim_strwidth(part[1])
		end

		local text = {
			{ "󰊢  ", hl = "SnacksDashboardIcon" },
			{ truncate(vim.fn.fnamemodify(root, ":t"), width - 3 - tail_width), hl = "SnacksDashboardTitle" },
		}
		vim.list_extend(text, tail)

		return { { pane = opts.pane, padding = 1, text = text } }
	end
end

return M
