-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.default_prog = { '/usr/bin/zsh' }

-- For example, changing the color scheme:
local my_color_scheme = 'Tokyo Night Moon'

config.color_scheme = my_color_scheme
config.font = wezterm.font("JetBrainsMono NF")
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.audible_bell = "Disabled"
config.check_for_updates = false
config.use_fancy_tab_bar = false

config.keys = {
  { key = 'F11', action = act.ToggleFullScreen },
}

if wezterm.gui then
  local copy_mode = wezterm.gui.default_key_tables().copy_mode

  table.insert(copy_mode, { key = '/', mods = 'NONE', action = act.CopyMode "ClearPattern" })

  config.key_tables = {
    copy_mode = copy_mode
  }
end

-- background layers =)
local scheme = wezterm.get_builtin_color_schemes()[my_color_scheme]
config.background = {
  {
    source = {
      Color = scheme.background
    },
    height = "100%",
    width = "100%"
  },
  {
    source = {
      File = "{{HOME}}/Downloads/2b-canva.png"
    },
    height = "Contain",
    width = "40%",
    repeat_x = "NoRepeat",
    repeat_y = "NoRepeat",
    horizontal_align = "Right",
    opacity = 0.15
  }
}
-- and finally, return the configuration to wezterm
return config

