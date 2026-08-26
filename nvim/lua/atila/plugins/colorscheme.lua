vim.pack.add({
	"https://github.com/sainnhe/gruvbox-material",
})

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_foreground = "original"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_sign_column_background = "none"

vim.g.gruvbox_material_colors_override = {
	bg_dim = { "#0e1011", "232" },
	bg0 = { "#141617", "234" },
	bg1 = { "#1d2021", "235" },
	bg2 = { "#1d2021", "235" },
	bg3 = { "#282828", "237" },
	bg4 = { "#282828", "237" },
	bg5 = { "#3c3836", "239" },
	bg_statusline1 = { "#1d2021", "235" },
	bg_statusline2 = { "#282828", "235" },
	bg_statusline3 = { "#3c3836", "239" },
	bg_current_word = { "#282828", "236" },
	fg0 = { "#f3e9d1", "223" },
	fg1 = { "#f3e9d1", "223" },
}

if not pcall(vim.cmd.colorscheme, "gruvbox-material") then
	vim.cmd.colorscheme("retrobox")
end

vim.api.nvim_create_user_command("GruvboxFlavor", function(opts)
	vim.g.gruvbox_material_foreground = opts.args
	vim.cmd.colorscheme("gruvbox-material")
	vim.notify("gruvbox-material foreground: " .. opts.args)
end, {
	nargs = 1,
	complete = function()
		return { "material", "mix", "original" }
	end,
	desc = "Switch gruvbox-material foreground flavor",
})
