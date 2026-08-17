-- Dooing todos as a snacks.dashboard section.
--
-- The todo files are read straight from disk instead of `dooing.state`, since
-- that state holds a single list at a time (global or project) and gets swapped
-- around while the dashboard is being drawn.
local M = {}

local function read_todos(path)
	if not path or vim.fn.filereadable(path) == 0 then
		return {}
	end
	local ok, decoded = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
	end)
	if not ok or type(decoded) ~= "table" then
		return {}
	end
	return decoded
end

local function dooing_options()
	local ok, config = pcall(require, "dooing.config")
	if ok and type(config.options) == "table" then
		return config.options
	end
	return {}
end

-- Project todos first (when inside a git repo), then the global list
local function sources()
	local options = dooing_options()
	local per_project = options.per_project or {}
	local list = {}

	if per_project.enabled ~= false then
		local root = vim.fs.root(vim.uv.cwd() or ".", ".git")
		if root then
			table.insert(list, {
				scope = vim.fn.fnamemodify(root, ":t"),
				path = root .. "/" .. (per_project.default_filename or "dooing.json"),
			})
		end
	end

	table.insert(list, {
		scope = "global",
		path = options.save_path or (vim.fn.stdpath("data") .. "/dooing_todos.json"),
	})

	return list
end

local function priority_weights()
	local weights = {}
	for _, priority in ipairs(dooing_options().priorities or {}) do
		weights[priority.name] = priority.weight or 0
	end
	return weights
end

-- 0 = overdue, 1 = due today, 2 = upcoming, 3 = no due date
local function bucket_of(days)
	if days == nil then
		return 3
	elseif days < 0 then
		return 0
	elseif days == 0 then
		return 1
	end
	return 2
end

local function collect()
	local weights = priority_weights()
	local now = os.date("*t")
	local today = os.time({ year = now.year, month = now.month, day = now.day, hour = 0, min = 0, sec = 0 })
	local todos = {}

	for _, source in ipairs(sources()) do
		for _, todo in ipairs(read_todos(source.path)) do
			if type(todo) == "table" and todo.text and not todo.done then
				local score = 0
				for _, name in ipairs(todo.priorities or {}) do
					score = score + (weights[name] or 0)
				end

				local days = todo.due_at and math.floor((todo.due_at - today) / 86400) or nil
				table.insert(todos, {
					text = (todo.text:gsub("\n", " ")),
					scope = source.scope,
					in_progress = todo.in_progress == true,
					priorities = todo.priorities,
					score = score,
					days = days,
					bucket = bucket_of(days),
					created_at = todo.created_at or 0,
				})
			end
		end
	end

	table.sort(todos, function(a, b)
		if a.bucket ~= b.bucket then
			return a.bucket < b.bucket
		elseif a.in_progress ~= b.in_progress then
			return a.in_progress
		elseif a.score ~= b.score then
			return a.score > b.score
		elseif (a.days or 0) ~= (b.days or 0) then
			return (a.days or 0) < (b.days or 0)
		end
		return a.created_at < b.created_at
	end)

	return todos
end

local function due_label(days)
	if days == nil then
		return nil, nil
	elseif days < -1 then
		return math.abs(days) .. "d late", "DooingOverdue"
	elseif days == -1 then
		return "yesterday", "DooingOverdue"
	elseif days == 0 then
		return "today", "DooingDueToday"
	elseif days == 1 then
		return "tomorrow", "DooingDueSoon"
	elseif days < 7 then
		return "in " .. days .. "d", "DooingDueSoon"
	end
	return "in " .. math.floor(days / 7) .. "w", "DooingMeta"
end

-- Dooing only defines its highlight groups when its window opens, so make sure
-- they exist before the dashboard borrows them.
local function ensure_highlights()
	local ok, highlights = pcall(require, "dooing.ui.highlights")
	if ok and type(highlights.setup_highlights) == "function" then
		pcall(highlights.setup_highlights)
		return highlights
	end
	return nil
end

-- Same priority-group color Dooing paints the status icon with
local function priority_highlight(highlights, priorities)
	if highlights and type(highlights.get_priority_highlight) == "function" then
		local ok, group = pcall(highlights.get_priority_highlight, priorities)
		if ok and group then
			return group
		end
	end
	return "DooingPending"
end

-- Split a todo into plain/tag segments, the way the modern Dooing UI does
local function tag_segments(text)
	local segments, cursor = {}, 1
	while true do
		local tag_start, tag_end = text:find("#[%w_%-]+", cursor)
		if not tag_start then
			break
		end
		if tag_start > cursor then
			segments[#segments + 1] = { text = text:sub(cursor, tag_start - 1) }
		end
		segments[#segments + 1] = { text = text:sub(tag_start, tag_end), is_tag = true }
		cursor = tag_end + 1
	end
	if cursor <= #text then
		segments[#segments + 1] = { text = text:sub(cursor) }
	end
	return segments
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

local function summary_of(todos)
	local overdue, today = 0, 0
	for _, todo in ipairs(todos) do
		if todo.bucket == 0 then
			overdue = overdue + 1
		elseif todo.bucket == 1 then
			today = today + 1
		end
	end

	if overdue > 0 then
		return overdue .. " late", "DooingOverdue"
	elseif today > 0 then
		return today .. " today", "DooingDueToday"
	elseif #todos > 0 then
		return #todos .. " open", "DooingSectionCount"
	end
	return "", nil
end

--- Build a snacks.dashboard section listing the pending Dooing todos.
---@param opts? { pane?: number, limit?: number, width?: number, title?: string }
function M.section(opts)
	opts = opts or {}
	local limit = opts.limit or 8

	return function(self)
		local width = opts.width or (self and self.opts and self.opts.width) or 60
		local highlights = ensure_highlights()
		local todos = collect()
		local items = {}

		local summary, summary_hl = summary_of(todos)
		local summary_width = summary == "" and 0 or vim.api.nvim_strwidth(summary) + 1
		local title = opts.title or "Todos"
		items[#items + 1] = {
			pane = opts.pane,
			padding = 1,
			text = {
				{ "󰄲  ", hl = "DooingSectionTitle" },
				{ title, hl = "DooingSectionTitle", width = width - 3 - summary_width },
				{ summary == "" and "" or (" " .. summary), hl = summary_hl },
			},
		}

		if #todos == 0 then
			items[#items + 1] = {
				pane = opts.pane,
				padding = 1,
				text = { { "   Nothing pending — enjoy the day", hl = "DooingMeta" } },
			}
			return items
		end

		local icons = (dooing_options().formatting or {})
		for index, todo in ipairs(todos) do
			if index > limit then
				break
			end

			local label, label_hl = due_label(todo.days)
			local label_width = label and vim.api.nvim_strwidth(label) + 1 or 0

			-- priority bar + status icon, both in the priority color Dooing uses
			local status = todo.in_progress and "in_progress" or "pending"
			local icon = (icons[status] or {}).icon or (todo.in_progress and "◐" or "○")
			local icon_hl = priority_highlight(highlights, todo.priorities)
			local text_width = width - (2 + vim.api.nvim_strwidth(icon)) - label_width
			local text = {
				{ "▎", hl = icon_hl },
				{ icon .. " ", hl = icon_hl },
			}

			local todo_text = truncate(todo.text, text_width)
			for _, segment in ipairs(tag_segments(todo_text)) do
				text[#text + 1] = { segment.text, hl = segment.is_tag and "DooingTag" or "DooingText" }
			end
			local pad = text_width - vim.api.nvim_strwidth(todo_text)
			if pad > 0 then
				text[#text + 1] = { (" "):rep(pad) }
			end

			if label then
				text[#text + 1] = { " " .. label, hl = label_hl }
			end

			items[#items + 1] = { pane = opts.pane, text = text }
		end

		if #todos > limit then
			items[#items + 1] = {
				pane = opts.pane,
				text = { { ("   +%d more"):format(#todos - limit), hl = "DooingMeta" } },
			}
		end

		-- trailing blank line, so whatever follows in the pane keeps its distance
		items[#items].padding = 1

		return items
	end
end

--- Prompt for a todo and hand it to `:Dooing add`, then redraw the dashboard.
function M.add_todo()
	vim.ui.input({ prompt = "New todo: " }, function(text)
		if not text or vim.trim(text) == "" then
			return
		end
		local args = vim.split(vim.trim(text), "%s+", { trimempty = true })
		table.insert(args, 1, "add")
		vim.cmd({ cmd = "Dooing", args = args })
		pcall(function()
			Snacks.dashboard.update()
		end)
	end)
end

return M
