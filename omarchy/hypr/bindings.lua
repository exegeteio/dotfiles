-- Put only your personal keybinding changes in this file. Add new bindings
-- here. Unbind a default binding before you replace it.

-- To see the current bindings and their descriptions, run this command:
--   omarchy menu keybindings --print

-- To turn off all Omarchy default bindings, add this line to
-- ~/.config/hypr/hyprland.lua. Add the line before
-- require("default.hypr.omarchy"). Then add only the bindings you want
-- below.
--   omarchy_default_bindings = false

-- To turn off all preinstalled app and webapp bindings, add this line:
--   omarchy_preinstalled_bindings = false

-- Example: add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Example: change an existing binding. First unbind the key. Then bind the
-- key to the new action. This example changes SUPER+SPACE from the
-- launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Example: turn off a default binding. Do not replace it.
-- hl.unbind("SUPER + SHIFT + B")

-- Bind CTRL + RETURN to Tmux. Before this change, this key combination had
-- no global binding. SUPER + ALT + RETURN also opens Tmux.
o.bind("CTRL + RETURN", "Tmux", { omarchy = "terminal-tmux" })

-- Bind SUPER + CTRL + RETURN to the regular terminal. Before this change,
-- this key combination opened Herdr, then Tmux. SUPER + RETURN also opens
-- the regular terminal.
hl.unbind("SUPER + CTRL + RETURN")
o.bind("SUPER + CTRL + RETURN", "Terminal", { omarchy = "terminal" })

-- Bind SUPER + CTRL + A to Claude Code. Claude Code is the default agent.
-- Before this change, this key combination opened the Audio panel.
hl.unbind("SUPER + CTRL + A")
o.bind("SUPER + CTRL + A", "Claude Code", "omarchy-agent")

-- Use CTRL + number to switch workspaces. Before this change, the key
-- combination was SUPER + number.
-- Warning: Hyprland reads this key combination before any app can read it.
-- This blocks the Ctrl+1-9 shortcut in every app. Two examples are browser
-- tab switching and editor tab or pane switching.
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + " .. key)
  o.bind("CTRL + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
end

-- Examples for the Logitech MX Keys keyboard:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
