-- Home screen
return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local status_ok, alpha = pcall(require, "alpha")
		if not status_ok then
			vim.notify("Failed to load alpha", vim.log.levels.ERROR)
			return
		end

		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"   __ _   _ _             _        _____         _ _            ",
			"  /_/| |_(_) | __ _    __| | ___  |  ___| __ ___(_) |_ __ _ ___ ",
			"  /_\\| __| | |/ _` |  / _` |/ _ \\ | |_ | '__/ _ \\ | __/ _` / __|",
			" / _ \\ |_| | | (_| | | (_| |  __/ |  _|| | |  __/ | || (_| \\__ \\",
			"/_/ \\_\\__|_|_|\\__,_|  \\__,_|\\___| |_|  |_|  \\___|_|\\__\\__,_|___/",
			"",
			"",
			"      Tudo por Jesus, tudo por Maria, tudo à vossa imitação,      ",
			"   ó Patriarca São José! Este será meu lema na vida e na morte.    ",
			"",
			"",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
			dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
