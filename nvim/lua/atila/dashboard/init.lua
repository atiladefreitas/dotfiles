-- Dashboard sections + the autocmds that keep them current.
local M = {
	dooing = require("atila.dashboard.dooing"),
	bloocky = require("atila.dashboard.bloocky"),
	git = require("atila.dashboard.git"),
}

-- Dooing and Bloocky write their JSON with plain io.open, so no BufWritePost
-- ever fires for them. Redrawing whenever the dashboard is entered covers the
-- real case anyway: close the todo window, land back here, see the new list.
function M.setup()
	local group = vim.api.nvim_create_augroup("atila_dashboard", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
		group = group,
		callback = function(ev)
			if not (ev.buf and vim.api.nvim_buf_is_valid(ev.buf)) then
				return
			end
			if vim.bo[ev.buf].filetype == "snacks_dashboard" then
				pcall(function()
					Snacks.dashboard.update()
				end)
			end
		end,
	})
end

return M
