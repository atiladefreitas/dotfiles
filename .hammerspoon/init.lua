-- Directional window focus (vim-style) + warp cursor to center
hs.window.animationDuration = 0

-- Cached window list, limited to the current desktop
local wf = hs.window.filter.copy(hs.window.filter.default):setCurrentSpace(true)

local directions = { h = "West", j = "South", k = "North", l = "East" }

for key, dir in pairs(directions) do
	hs.hotkey.bind({ "alt" }, key, function()
		local win = hs.window.focusedWindow()
		if not win then
			return
		end

		-- args: window, frontmost, strict
		local targets = wf["windowsTo" .. dir](wf, win, false, true)
		local target = targets and targets[1]
		if not target then
			return
		end

		target:focus()
		hs.mouse.absolutePosition(target:frame().center)
	end)
end

-- Disable Cmd+H (Hide app)
hs.hotkey.bind({ "cmd" }, "h", function() end)

-- Reload config
hs.hotkey.bind({ "alt", "shift" }, "r", function()
	hs.reload()
end)

hs.alert.show("Hammerspoon config loaded")
