return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		-- Existing key mappings
		{
			"<leader>-",
			function()
				require("yazi").yazi()
			end,
			desc = "Open the file manager",
		},
		{
			"<leader>cw",
			function()
				require("yazi").yazi(nil, vim.fn.getcwd())
			end,
			desc = "Open the file manager in nvim's working directory",
		},
		{
			"<c-up>",
			function()
				-- NOTE: requires a version of yazi that includes
				-- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
				require("yazi").toggle()
			end,
			desc = "Resume the last yazi session",
		},
		-- New key mapping for opening Yazi in the current file buffer's directory
		{
			"<leader>yf",
			function()
				local file_dir = vim.fn.expand("%:p:h")
				if file_dir ~= "" then
					require("yazi").yazi(nil, file_dir)
				else
					print("No file in current buffer")
				end
			end,
			desc = "Open the file manager in the current file buffer's directory",
		},
	},
	---@type YaziConfig
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,

		yazi_floating_window_border = "rounded",

		-- enable these if you are using the latest version of yazi
		-- use_ya_for_events_reading = true,
		-- use_yazi_client_id_flag = true,

		keymaps = {
			show_help = "<f1>",
		},
	},
}
