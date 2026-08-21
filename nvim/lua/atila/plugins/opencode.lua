local tmux_cmd = "opencode --port"
local tmux_pane_id = nil
-- local pane_bg = "#090a12"

-- local function set_pane_bg(pane_id)
-- 	vim.fn.system("tmux select-pane -t " .. pane_id .. " -P 'bg=" .. pane_bg .. "'")
-- end

vim.g.opencode_opts = {
	server = {
		start = function()
			local result =
				vim.fn.system("tmux split-window -h -l 35% -P -F '#{pane_id}' " .. vim.fn.shellescape(tmux_cmd))
			tmux_pane_id = vim.trim(result)
			-- set_pane_bg(tmux_pane_id)
		end,
		stop = function()
			if tmux_pane_id then
				vim.fn.system("tmux kill-pane -t " .. tmux_pane_id)
				tmux_pane_id = nil
			end
		end,
		toggle = function()
			if tmux_pane_id then
				-- Check if the pane still exists
				local check = vim.fn.system("tmux has-session -t " .. tmux_pane_id .. " 2>/dev/null; echo $?")
				if vim.trim(check) ~= "0" then
					tmux_pane_id = nil
				end
			end

			if tmux_pane_id then
				vim.fn.system("tmux kill-pane -t " .. tmux_pane_id)
				tmux_pane_id = nil
			else
				local result =
					vim.fn.system("tmux split-window -h -l 35% -P -F '#{pane_id}' " .. vim.fn.shellescape(tmux_cmd))
				tmux_pane_id = vim.trim(result)
				-- set_pane_bg(tmux_pane_id)
			end
		end,
	},
}

-- Required for `vim.g.opencode_opts.events.reload`.
vim.o.autoread = true

-- ── Keymaps ─────────────────────────────────────────────────────────
vim.keymap.set({ "n", "x" }, "<leader>oa", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask about this" })

vim.keymap.set({ "n", "x" }, "<leader>os", function()
	require("opencode").select()
end, { desc = "Select prompt" })

vim.keymap.set({ "n", "x" }, "<leader>o+", function()
	require("opencode").prompt("@this")
end, { desc = "Add this" })

vim.keymap.set("n", "<leader>ot", function()
	require("opencode").toggle()
end, { desc = "Toggle embedded" })

vim.keymap.set("n", "<leader>oc", function()
	require("opencode").command()
end, { desc = "Select command" })

vim.keymap.set("n", "<leader>on", function()
	require("opencode").command("session.new")
end, { desc = "New session" })

vim.keymap.set("n", "<leader>oi", function()
	require("opencode").command("session.interrupt")
end, { desc = "Interrupt session" })

vim.keymap.set("n", "<leader>oA", function()
	require("opencode").command("agent.cycle")
end, { desc = "Cycle selected agent" })

vim.keymap.set("n", "<S-C-u>", function()
	require("opencode").command("session.half.page.up")
end, { desc = "Messages half page up" })

vim.keymap.set("n", "<S-C-d>", function()
	require("opencode").command("session.half.page.down")
end, { desc = "Messages half page down" })
