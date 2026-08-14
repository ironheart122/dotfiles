-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Straight 1x setup for low-resolution displays like 1080p or 1440p.
hl.env("GDK_SCALE", "1")

local MONITOR_L = "DP-2" -- LG UltraGear
local MONITOR_R = "DP-1" -- DELL S2721DGF

hl.monitor({ output = MONITOR_L, mode = "2560x1440@165", position = "auto-left", scale = 1 })
hl.monitor({ output = MONITOR_R, mode = "2560x1440@165", position = "auto-right", scale = 1 })

for _, workspace in ipairs({ 8, 9, 10, 11, 12, 13, 14 }) do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = MONITOR_L,
    persistent = true,
    default = workspace == 8,
  })
end

for _, workspace in ipairs({ 1, 2, 3, 4, 5, 6, 7 }) do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = MONITOR_R,
    persistent = true,
    default = workspace == 1,
  })
end
