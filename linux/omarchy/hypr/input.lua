-- Put only your personal input changes in this file. A setting below that
-- is not a comment replaces the matching Omarchy default.

-- Keyboard layout and options.
-- For more information, go to https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- Make Caps Lock act as a second Control key. Press both Shift keys
    -- together to toggle the real Caps Lock function.
    kb_options = "caps:ctrl_modifier,shift:both_capslock_cancel",
  },
})

-- hl.config({
--   input = {
--     -- Example: use more than one keyboard layout. Press Left Alt + Right
--     -- Alt to switch between layouts.
--     kb_layout = "us,dk,eu",
--     kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",
--
--     -- Example: set a specific keyboard variant. Use "intl" for an
--     -- international keyboard.
--     kb_variant = "intl",
--
--     -- Example: change the keyboard repeat speed.
--     repeat_rate = 40,
--     repeat_delay = 250,
--
--     -- Example: turn on Num Lock at startup.
--     numlock_by_default = true,
--
--     -- Example: increase the mouse and trackpad sensitivity. The default
--     -- value is 0.
--     sensitivity = 0.35,
--
--     -- Example: turn off mouse acceleration. The default setting is
--     -- adaptive.
--     accel_profile = "flat",
--
--     touchpad = {
--       -- Example: reverse the scroll direction.
--       natural_scroll = true,
--
--       -- Example: use a two-finger tap for a right-click. This replaces
--       -- the tap in the lower-right corner.
--       clickfinger_behavior = true,
--
--       -- Example: set the scroll speed.
--       scroll_factor = 0.4,
--
--       -- Example: turn on the touchpad during typing.
--       disable_while_typing = false,
--
--       -- Example: click and drag with three fingers.
--       drag_3fg = 1,
--     },
--   },
-- })

-- Examples: set the touchpad scroll speed for specific apps.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Example: turn on touchpad gestures for workspace changes.
-- For more information, go to https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Examples: turn on touchpad gestures for focus changes. These gestures are
-- useful in the scrolling layout.
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
