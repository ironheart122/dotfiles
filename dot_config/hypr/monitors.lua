-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Straight 1x setup for low-resolution displays like 1080p or 1440p.
hl.env("GDK_SCALE", "1")

local MONITOR_L = "DP-2" -- LG UltraGear
local MONITOR_R = "DP-1" -- DELL S2721DGF

hl.monitor({ output = MONITOR_L, mode = "2560x1440@165", position = "auto-left", scale = 1 })
hl.monitor({ output = MONITOR_R, mode = "2560x1440@165", position = "auto-right", scale = 1 })
