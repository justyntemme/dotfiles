hs.loadSpoon("ReloadConfiguration")

spoon.ReloadConfiguration:start()

spoon.ReloadConfiguration:bindHotkeys({ reloadConfiguration = { { "cmd", "ctrl", "shift" }, "R" } })

require("hs.window.filter")
-- Move Focus window up/down left/right & cycle for focus window
hs.hotkey.bind({ "cmd", "shift" }, "9", "Left", function()
	local wf = hs.window.filter
	-- Always use false, false as the last two params, frontmost (dont ignore windows with other windows in front), strict
	-- TODO improve window speed by giving it some windows
	local ws = wf.new({ override = { visible = true, fullscreen = false, allowScreens = "-1,0", currentSpace = true } })
	hs.window.filter.defaultCurrentSpace:focusWindowWest(nil, true, false)
	--works	hs.window.filter.focusWest(nil, true, false)
	--hs.window.focusWindowWest(nil,self:getWindows(),)
end)
hs.hotkey.bind({ "cmd", "shift" }, "0", "Right", function()
	-- hs.window.filter.focusEast(nil, true, false)

	-- local ws = wf.new({ "TextEdit", "Sublime Text", "BBEdit" })
	-- :setRegions(hs.screen.primaryScreen():fromUnitRect("0.5,0/1,1"))
	hs.window.filter.defaultCurrentSpace:focusWindowEast(nil, true, false)
end)

hs.hotkey.bind({ "cmd" }, "9", "Down", function()
	hs.window.filter.defaultCurrentSpace:focusWindowSouth(nil, true, false)
	-- hs.window.focusSouth(nil, true, false)
end)
hs.hotkey.bind({ "cmd" }, "0", "Left", function()
	hs.window.filter.defaultCurrentSpace:focusWindowNorth(nil, true, false)
	-- hs.window.focusNorth(nil, true, false)
end)

-- TODO: cycle ability
-- hs.hotkey.bind({ "cmd", "shift" }, "f", "Left", function()
-- 	hs.window.filter.defaultCurrentSpace:focusWindowWest(nil, true, false)
-- 	-- hs.window.focusWindowWest(nil, true, false)
-- end)
--
-- hs.alert.show("Config loaded")
