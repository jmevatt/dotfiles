-- ── WezTerm config ────────────────────────────────────────────────────────────
-- Mirrors the kitty package: Catppuccin Mocha, JetBrainsMono Nerd Font,
-- ctrl+t / ctrl+w / ctrl+shift+←→ tab keys.

local wezterm = require('wezterm')
local act = wezterm.action
local config = wezterm.config_builder()

-- ── Behavior ──────────────────────────────────────────────────────────────────
config.audible_bell = 'Disabled'
config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }
config.window_close_confirmation = 'NeverPrompt'
config.hide_mouse_cursor_when_typing = true
config.scrollback_lines = 10000
config.check_for_updates = false
config.enable_wayland = true

-- ── Window ────────────────────────────────────────────────────────────────────
config.initial_cols = 80
config.initial_rows = 24
config.window_padding = { left = 10, right = 10, top = 6, bottom = 6 }
config.window_decorations = 'TITLE | RESIZE'
config.adjust_window_size_when_changing_font_size = false
config.window_background_opacity = 0.92
config.text_background_opacity = 1.0

-- ── Font ─────────────────────────────────────────────────────────────────────
config.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font',
  'Noto Color Emoji',
  'Noto Sans CJK JP',
})
config.font_size = 11.5
config.warn_about_missing_glyphs = false

-- ── Colors (Catppuccin Mocha) ─────────────────────────────────────────────────
config.color_scheme = 'Catppuccin Mocha'

-- ── Tabs ─────────────────────────────────────────────────────────────────────
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false

config.disable_default_key_bindings = false
config.keys = {
  -- Tab management (mirrors kitty)
  { key = 't', mods = 'CTRL',       action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w', mods = 'CTRL',       action = act.CloseCurrentTab({ confirm = false }) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

  -- Copy/paste (Wayland-friendly)
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },

  -- Font size
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}

-- ── Shell ─────────────────────────────────────────────────────────────────────
config.default_prog = { '/usr/bin/zsh', '-l' }

return config
