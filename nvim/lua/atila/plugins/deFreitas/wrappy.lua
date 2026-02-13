-- soft-wrap toggle that breaks at word boundaries at a specific column
return {
	enabled = true,
	dir = vim.fn.stdpath("config"),
	name = "wrappy",
	config = function()
		-- change this value to your preferred wrap column (80, 100, 120, etc.)
		local default_wrap_column = 80

		-- per-buffer state: stores saved options and the padding window
		local wrappy_state = {}

		local function save_options(winnr, bufnr)
			return {
				wrap = vim.wo[winnr].wrap,
				linebreak = vim.wo[winnr].linebreak,
				breakindent = vim.wo[winnr].breakindent,
				breakindentopt = vim.wo[winnr].breakindentopt,
				showbreak = vim.wo[winnr].showbreak,
				colorcolumn = vim.wo[winnr].colorcolumn,
				number = vim.wo[winnr].number,
				relativenumber = vim.wo[winnr].relativenumber,
				signcolumn = vim.wo[winnr].signcolumn,
				textwidth = vim.bo[bufnr].textwidth,
				formatoptions = vim.bo[bufnr].formatoptions,
			}
		end

		local function restore_options(winnr, bufnr, saved)
			vim.wo[winnr].wrap = saved.wrap
			vim.wo[winnr].linebreak = saved.linebreak
			vim.wo[winnr].breakindent = saved.breakindent
			vim.wo[winnr].breakindentopt = saved.breakindentopt
			vim.wo[winnr].showbreak = saved.showbreak
			vim.wo[winnr].colorcolumn = saved.colorcolumn
			vim.wo[winnr].number = saved.number
			vim.wo[winnr].relativenumber = saved.relativenumber
			vim.wo[winnr].signcolumn = saved.signcolumn
			vim.bo[bufnr].textwidth = saved.textwidth
			vim.bo[bufnr].formatoptions = saved.formatoptions
		end

		-- calculate how many columns gutter elements consume (line numbers, signs, fold)
		local function get_gutter_width(winnr)
			local width = 0
			-- signcolumn
			local sc = vim.wo[winnr].signcolumn
			if sc == "yes" or sc == "yes:1" then
				width = width + 2
			elseif sc == "auto" or sc == "auto:1" then
				width = width + 2
			end
			-- line numbers
			if vim.wo[winnr].number or vim.wo[winnr].relativenumber then
				width = width + vim.wo[winnr].numberwidth
			end
			-- foldcolumn
			local fc = vim.wo[winnr].foldcolumn
			if fc ~= "0" then
				width = width + (tonumber(fc) or 0)
			end
			return width
		end

		local function enable_wrap(bufnr, col)
			local winnr = vim.api.nvim_get_current_win()
			local saved = save_options(winnr, bufnr)

			-- soft-wrap at word boundaries
			vim.opt_local.wrap = true
			vim.opt_local.linebreak = true
			vim.opt_local.breakindent = true
			vim.opt_local.breakindentopt = "shift:2"
			vim.opt_local.showbreak = "↪ "
			vim.opt_local.colorcolumn = tostring(col)

			-- textwidth for manual `gq` reformat; disable auto-wrap
			vim.opt_local.textwidth = col
			vim.opt_local.formatoptions = vim.bo[bufnr].formatoptions:gsub("[tc]", "")

			-- force the window to the target width by opening a padding split
			-- the wrap column must account for gutter width
			local gutter = get_gutter_width(winnr)
			local target_win_width = col + gutter + 1
			local total_width = vim.o.columns
			local padding_width = total_width - target_win_width - 1 -- 1 for separator

			local pad_win = nil
			if padding_width > 0 then
				-- create an empty scratch buffer for the padding window
				local pad_buf = vim.api.nvim_create_buf(false, true)
				vim.bo[pad_buf].buftype = "nofile"
				vim.bo[pad_buf].bufhidden = "wipe"
				vim.bo[pad_buf].swapfile = false

				-- open a vertical split to the right
				vim.cmd("botright vsplit")
				pad_win = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_buf(pad_win, pad_buf)
				vim.api.nvim_win_set_width(pad_win, padding_width)

				-- make the padding window unobtrusive
				vim.wo[pad_win].number = false
				vim.wo[pad_win].relativenumber = false
				vim.wo[pad_win].signcolumn = "no"
				vim.wo[pad_win].colorcolumn = ""
				vim.wo[pad_win].statusline = " "
				vim.wo[pad_win].winfixwidth = true
				vim.wo[pad_win].cursorline = false

				-- switch focus back to the original window
				vim.api.nvim_set_current_win(winnr)
				vim.api.nvim_win_set_width(winnr, target_win_width)
			end

			wrappy_state[bufnr] = {
				saved = saved,
				column = col,
				main_win = winnr,
				pad_win = pad_win,
				active = true,
			}
		end

		local function disable_wrap(bufnr)
			local state = wrappy_state[bufnr]
			if not state then
				return
			end

			-- close the padding window if it still exists
			if state.pad_win and vim.api.nvim_win_is_valid(state.pad_win) then
				vim.api.nvim_win_close(state.pad_win, true)
			end

			-- restore original options
			local winnr = vim.api.nvim_get_current_win()
			restore_options(winnr, bufnr, state.saved)

			wrappy_state[bufnr] = nil
		end

		local function is_active(bufnr)
			return wrappy_state[bufnr] and wrappy_state[bufnr].active
		end

		vim.api.nvim_create_user_command("WrappyToggle", function(opts)
			local bufnr = vim.api.nvim_get_current_buf()
			local col = opts.args ~= "" and tonumber(opts.args) or default_wrap_column

			if is_active(bufnr) then
				disable_wrap(bufnr)
				vim.notify("Wrappy: soft-wrap OFF", vim.log.levels.INFO)
			else
				enable_wrap(bufnr, col)
				vim.notify("Wrappy: soft-wrap ON (col " .. col .. ")", vim.log.levels.INFO)
			end
		end, {
			nargs = "?",
			desc = "Toggle soft-wrap at word boundaries (optional: column width)",
		})

		-- clean up state when a buffer is deleted
		vim.api.nvim_create_autocmd("BufDelete", {
			callback = function(ev)
				local state = wrappy_state[ev.buf]
				if state and state.pad_win and vim.api.nvim_win_is_valid(state.pad_win) then
					vim.api.nvim_win_close(state.pad_win, true)
				end
				wrappy_state[ev.buf] = nil
			end,
		})

		vim.keymap.set("n", "<leader>uw", "<cmd>WrappyToggle<CR>", { desc = "Toggle soft-wrap (Wrappy)" })
	end,
}
