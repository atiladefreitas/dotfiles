-- Today's Bloocky time blocks as a snacks.dashboard section.
--
-- Bloocky's own state/utils do the work here (recurrence rules live in
-- `blocks_for_date`), so the dashboard never has to reimplement them.
local M = {}

local function bloocky()
	local ok_state, state = pcall(require, "bloocky.state")
	local ok_utils, utils = pcall(require, "bloocky.utils")
	local ok_hl, highlights = pcall(require, "bloocky.highlights")
	local ok_cfg, config = pcall(require, "bloocky.config")
	if not (ok_state and ok_utils and ok_hl and ok_cfg) then
		return nil
	end
	-- Bloocky's groups only exist once its window has opened
	pcall(highlights.setup)
	return { state = state, utils = utils, highlights = highlights, options = config.options }
end

-- Blocks of the current day that have not ended yet, oldest first.
-- The tables are copies: the ones Bloocky hands out are the live state.
local function upcoming()
	local api = bloocky()
	if not api then
		return nil
	end

	-- always re-read, so blocks added in another Neovim show up here
	pcall(api.state.load_blocks)
	local ok, blocks = pcall(api.state.blocks_for_date, api.utils.today())
	if not ok or type(blocks) ~= "table" then
		return nil
	end

	local now = os.date("*t")
	local now_min = now.hour * 60 + now.min
	local out, total = {}, #blocks

	for _, block in ipairs(blocks) do
		local start_min = block.start_min or 0
		local duration = block.duration_min or 0
		local ends = start_min + duration
		if ends > now_min then
			out[#out + 1] = {
				title = (tostring(block.title or ""):gsub("\n", " ")),
				start_min = start_min,
				duration = duration,
				remaining = ends - now_min,
				running = start_min <= now_min,
				recurring = block.recurrence ~= nil and block.recurrence ~= vim.NIL,
				hl = api.highlights.block_group(block),
			}
		end
	end

	return out, total, api.utils
end

--- Build a snacks.dashboard section with the time blocks still ahead today.
---@param opts? { pane?: number, limit?: number, width?: number, title?: string }
function M.section(opts)
	opts = opts or {}
	local limit = opts.limit or 4

	return function(self)
		local width = opts.width or (self and self.opts and self.opts.width) or 60
		local blocks, total, utils = upcoming()
		if not blocks then
			return {}
		end

		local items = {}
		local summary = #blocks > 0 and (#blocks .. " left") or ""
		local summary_width = summary == "" and 0 or vim.api.nvim_strwidth(summary) + 1
		items[#items + 1] = {
			pane = opts.pane,
			padding = 1,
			text = {
				{ "󰃭  ", hl = "BloockyHeader" },
				{ opts.title or "Today", hl = "BloockyHeader", width = width - 3 - summary_width },
				{ summary == "" and "" or (" " .. summary), hl = "BloockyMore" },
			},
		}

		if #blocks == 0 then
			local text = total > 0 and "   Day's blocks are done" or "   Nothing scheduled today"
			items[#items + 1] = { pane = opts.pane, padding = 1, text = { { text, hl = "BloockyMore" } } }
			return items
		end

		for index, block in ipairs(blocks) do
			if index > limit then
				break
			end

			-- the block under way counts down instead of showing its length
			local label = block.running and (utils.format_duration(block.remaining) .. " left")
				or utils.format_duration(block.duration)
			if block.recurring then
				label = "󰑖 " .. label
			end
			local label_width = vim.api.nvim_strwidth(label) + 1

			local time = utils.format_hhmm(block.start_min) .. "  "
			local prefix_width = 1 + vim.api.nvim_strwidth(time)
			local title_width = width - prefix_width - label_width
			local title = utils.truncate(block.title, title_width)

			items[#items + 1] = {
				pane = opts.pane,
				text = {
					{ "▎", hl = block.hl },
					{ time, hl = block.running and "BloockyToday" or "BloockyTime" },
					{ title, hl = "Normal", width = title_width },
					{ " " .. label, hl = block.running and "BloockyToday" or "BloockyMore" },
				},
			}
		end

		if #blocks > limit then
			items[#items + 1] = {
				pane = opts.pane,
				text = { { ("   +%d more"):format(#blocks - limit), hl = "BloockyMore" } },
			}
		end

		items[#items].padding = 1

		return items
	end
end

local BARS = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }

-- Booked minutes per day of the current week, plus the week's total
local function week_load(api, full_day)
	local today = api.utils.today()
	local today_str = api.utils.date_to_str(today)
	local first = api.utils.week_start_of(today, api.options.week_start)
	local days, total = {}, 0

	for offset = 0, 6 do
		local date = api.utils.add_days(first, offset)
		local ok, blocks = pcall(api.state.blocks_for_date, date)
		local minutes = 0
		for _, block in ipairs(ok and blocks or {}) do
			minutes = minutes + (block.duration_min or 0)
		end
		total = total + minutes

		local date_str = api.utils.date_to_str(date)
		days[#days + 1] = {
			label = api.utils.WDAYS_SHORT[api.utils.wday(date)]:sub(1, 1),
			bar = minutes == 0 and "·" or BARS[math.min(8, math.ceil(minutes / full_day * 8))],
			today = date_str == today_str,
			past = date_str < today_str,
		}
	end

	return days, total
end

--- Build a snacks.dashboard section with a bar per day of the current week,
--- scaled against a full day of blocks. Renders nothing on an empty week.
---@param opts? { pane?: number, width?: number, full_day_hours?: number }
function M.week_section(opts)
	opts = opts or {}
	local full_day = (opts.full_day_hours or 8) * 60

	return function(self)
		local width = opts.width or (self and self.opts and self.opts.width) or 60
		local api = bloocky()
		if not api then
			return {}
		end

		pcall(api.state.load_blocks)
		local days, total = week_load(api, full_day)
		if total == 0 then
			return {}
		end

		local text, strip_width = { { "   " } }, 3
		for index, day in ipairs(days) do
			local hl = day.today and "BloockyToday" or (day.past and "BloockyGrid" or nil)
			text[#text + 1] = { day.label, hl = hl or "BloockyTime" }
			text[#text + 1] = { " " }
			text[#text + 1] = { day.bar, hl = hl or (day.bar == "·" and "BloockyGrid" or "Normal") }
			strip_width = strip_width + 3
			if index < #days then
				text[#text + 1] = { "  " }
				strip_width = strip_width + 2
			end
		end

		local label = api.utils.format_duration(total) .. " this week"
		local pad = width - strip_width - vim.api.nvim_strwidth(label) - 1
		if pad > 0 then
			text[#text + 1] = { (" "):rep(pad + 1) }
			text[#text + 1] = { label, hl = "BloockyMore" }
		end

		return { { pane = opts.pane, padding = 1, text = text } }
	end
end

return M
