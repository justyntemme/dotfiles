hs.loadSpoon("ReloadConfiguration")

spoon.ReloadConfiguration:start()

spoon.ReloadConfiguration:bindHotkeys({ reloadConfiguration = { { "cmd", "ctrl", "shift" }, "R" } })

require("hs.window.filter")

local currentSpaceFilter = hs.window.filter.defaultCurrentSpace
hs.hotkey.bind({ "cmd", "shift" }, "[", "Left", function()
	currentSpaceFilter:focusWindowWest(nil, true, false)
end)
hs.hotkey.bind({ "cmd", "shift" }, "]", "Right", function()
	currentSpaceFilter:focusWindowEast(nil, true, false)
end)

hs.hotkey.bind({ "cmd" }, "[", "Down", function()
	currentSpaceFilter:focusWindowSouth(nil, true, false)
end)
hs.hotkey.bind({ "cmd" }, "]", "Left", function()
	currentSpaceFilter:focusWindowNorth(nil, true, false)
end)
hs.timer.doAfter(2, function()
	-- We just need to get the windows; we don't need to do anything with them.
	-- This single call is enough to warm the cache.
	currentSpaceFilter:getWindows()
	hs.alert.show("Hammerspoon Focus Ready") -- Optional: Shows a confirmation
end)
