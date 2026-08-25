-- ╭──────────────────────────────────────────────────────────────────╮
-- │  colorscheme.lua — which scheme, and nothing else                │
-- │                                                                  │
-- │  This file only picks a scheme. Nothing else in the config reads │
-- │  anything out of it, so editing or breaking it can change how    │
-- │  Neovim looks but cannot leave it half-painted: window depth     │
-- │  lives in plugins/surfaces.lua, and telescope, neo-tree,         │
-- │  which-key and markdown all derive their colors from whatever    │
-- │  scheme ends up loaded (plugins/theme.lua). Swap the scheme      │
-- │  below and they follow on their own.                             │
-- ╰──────────────────────────────────────────────────────────────────╯

vim.pack.add({
	"https://github.com/sainnhe/gruvbox-material",
})

-- "original" over "material": with a transparent page the text sits on the
-- wallpaper rather than on a known background, and material's softened ink
-- is the first thing to go. Original is the brightest of the three (fg
-- #ebdbb2 against material's #d4be98) and happens to match the gruvbox
-- colors kitty is already using, so terminal and editor agree.
-- Swap live with :GruvboxFlavor material|mix|original.
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_foreground = "original"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_sign_column_background = "none"

-- One notch below "hard", which bottoms out at #1d2021. Every entry is the
-- next rung down gruvbox-material's own ladder, so the scheme stays in
-- proportion instead of just having its page knocked out from under it.
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
}

-- On a fresh clone the plugin isn't on disk yet, and a typo in the block
-- above shouldn't mean no colors at all — either way, fall back to a
-- built-in scheme rather than leaving the default one half-overridden.
if not pcall(vim.cmd.colorscheme, "gruvbox-material") then
	vim.cmd.colorscheme("retrobox")
end

-- Contrast over a wallpaper is only really judgeable against that
-- wallpaper, so make the three foregrounds a keystroke apart rather than
-- an edit-and-restart apart.
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
