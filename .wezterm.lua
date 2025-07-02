local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'One Light (Gogh)'

-- No ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.scrollback_lines = 50000

config.pane_focus_follows_mouse = true

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 50,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 50,
}
config.colors = {
  background = '#ffffff', -- Pure white background
  visual_bell = '#D7D7FF'
}

-- Otherwise get weird key repeat issues
config.use_ime = false

-- Otherwise menu bar disappears in full screen
config.native_macos_fullscreen_mode = true

config.keys = {
  -- Sends ESC + b and ESC + f sequence, which is used
  -- for telling your shell to jump back/forward.
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bb',
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bf',
  },
  -- Splitting panes
  {
    key = 'S',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'V',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Moving between split panes
  {
    key = 'H',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'L',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'K',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'J',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  -- Claude Code newline
  {
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action.SendString '\\\n'
  },
}

config.enable_tab_bar = false

return config
