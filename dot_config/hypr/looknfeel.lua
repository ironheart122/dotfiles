-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    -- Tighter than Omarchy's 5/10.
    gaps_in = 4,
    gaps_out = 4,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    -- Sharp corners. The old looknfeel.conf asked for 5; quattro's default is 0
    -- and that's the look we're keeping, so this is pinned rather than inherited.
    -- Note this reaches past windows: the Quickshell bar reads decoration:rounding
    -- back via `hyprctl getoption` and uses it for notifications, panels, menus,
    -- and the lock screen (Style.cornerRadius), so this one value sets corners
    -- desktop-wide.
    rounding = 0,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
