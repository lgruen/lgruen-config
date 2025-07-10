local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'One Light (Gogh)'

-- No ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.scrollback_lines = 50000

-- Doesn't work reliably: https://github.com/wezterm/wezterm/issues/4484
-- config.pane_focus_follows_mouse = true

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

config.mouse_bindings = {
    -- Disable the default click behavior
    {
      event = { Up = { streak = 1, button = "Left"} },
      mods = "NONE",
      action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
    },
    -- Cmd-click will open the link under the mouse cursor
		-- Note that in nvim with "set mouse=a", need to also hold Shift to bypass
		-- mouse reporting capture, i.e. Shift-Cmd+click.
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CMD",
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
    -- Disable the Cmd-click down event to stop programs from seeing it when a URL is clicked
    {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "CMD",
      action = wezterm.action.Nop,
    },
}

-- https://www.perplexity.ai/search/in-nvim-in-a-wezterm-terminal-GIcJGWS2RIexh6YudKWgzA

config.enable_tab_bar = false

return config
