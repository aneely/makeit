-- work_test.lua
-- Unit test for work.lua. Run with: lua tests/work_test.lua (from config repo root)
-- Mocks the hs API so the profile runs without Hammerspoon.

local executed = {}

hs = {
  application = {
    launchOrFocus = function(name) end,
    find          = function(name) return nil end,
  },
  urlevent = {
    openURL = function(url) end,
  },
  osascript = {
    applescript = function(s) end,
  },
  execute = function(cmd) table.insert(executed, cmd) end,
  timer = {
    waitUntil = function(condition, callback) callback() end,
  },
  screen = {
    primaryScreen = function()
      return {
        setMode = function(self, w, h, scale) end,
        frame   = function(self) return { x = 0, y = 0, w = 2560, h = 1440 } end,
      }
    end,
  },
  window = {
    find = function(name) return nil end,
  },
}

dofile("work.lua")

assert(#executed > 0, "expected hs.execute to be called at least once")
assert(executed[1] == "open ~", "expected hs.execute(\"open ~\"), got: " .. tostring(executed[1]))

print("OK")
