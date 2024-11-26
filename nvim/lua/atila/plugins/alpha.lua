-- Home screen
return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
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
		dashboard.section.buttons.val = {}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
