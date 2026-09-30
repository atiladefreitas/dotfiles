-- Directional window focus (vim-style)
local directions = { h = "West", j = "South", k = "North", l = "East" }

for key, dir in pairs(directions) do
	hs.hotkey.bind({ "alt" }, key, function()
		local win = hs.window.focusedWindow() or hs.window.frontmostWindow()
		if win then
			-- args: candidateWindows, frontmost, strict
			win["focusWindow" .. dir](win, nil, false, true)
		end
	end)
end

-- Disable Cmd+H (Hide app)
hs.hotkey.bind({ "cmd" }, "h", function() end)

-- Reload config
hs.hotkey.bind({ "alt", "shift" }, "r", function()
	hs.reload()
end)

hs.alert.show("Hammerspoon config loaded")
