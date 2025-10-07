hs.loadSpoon("ReloadConfiguration")

spoon.ReloadConfiguration:start()

spoon.ReloadConfiguration:bindHotkeys({ reloadConfiguration = { { "cmd", "ctrl", "shift" }, "R" } })

require("hs.window.filter")

local currentSpaceFilter = hs.window.filter.defaultCurrentSpace
hs.hotkey.bind({ "cmd", "shift" }, "9", "Left", function()
	local wf = hs.window.filter
	currentSpaceFilter:focusWindowWest(nil, true, false)
end)
hs.hotkey.bind({ "cmd", "shift" }, "0", "Right", function()
	currentSpaceFilter:focusWindowEast(nil, true, false)
end)

hs.hotkey.bind({ "cmd" }, "9", "Down", function()
	currentSpaceFilter:focusWindowSouth(nil, true, false)
end)
hs.hotkey.bind({ "cmd" }, "0", "Left", function()
	currentSpaceFilter:focusWindowNorth(nil, true, false)
end)
hs.timer.doAfter(2, function()
	-- We just need to get the windows; we don't need to do anything with them.
	-- This single call is enough to warm the cache.
	currentSpaceFilter:getWindows()
	hs.alert.show("Hammerspoon Focus Ready") -- Optional: Shows a confirmation
end)
