hs.loadSpoon("ReloadConfiguration")

spoon.ReloadConfiguration:start()

spoon.ReloadConfiguration:bindHotkeys({ reloadConfiguration = { { "cmd", "ctrl", "shift" }, "R" } })
-- Hot reloading of config on save >> Now a spoon
-- function reloadConfig(files)
--   doReload = false
--   for _,file in pairs(files) do
--       if file:sub(-4) == ".lua" then
--           doReload = true
--       end
--   end
--   if doReload then
--       hs.reload()
--   end
-- end
-- myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
-- hs.alert.show("Config loaded")

-- Old method of manual reloading >> kept for documentation purposes

-- hs.hotkey.bind({"cmd", "shift"}, "R", function()
--     hs.reload()
--   end)
-- hs.alert.show("Config loaded")

