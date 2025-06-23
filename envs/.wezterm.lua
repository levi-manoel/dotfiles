local wezterm = require 'wezterm'

return {
  -- Font
  font = wezterm.font("Victor Mono NF"),
  font_size = 18.0,

  -- Colors
  color_scheme = "Custom Ghostty Style",
  colors = {
    foreground = "#B0B0B0",
    background = "#000000",
    cursor_bg = "#E0E0E0",
    cursor_border = "#E0E0E0",
    cursor_fg = "#000000",
    selection_fg = "#FFFFFF",
    selection_bg = "#444444",

    ansi = {
      "#1C1C2B", "#E0787B", "#89C997", "#E2D1A8",
      "#7DA9E5", "#E6ADD8", "#7CC1BD", "#C5C9D9",
    },
    brights = {
      "#5A5E76", "#E0787B", "#89C997", "#E2D1A8",
      "#7DA9E5", "#E6ADD8", "#7CC1BD", "#B8BCD6",
    },
  },

  -- Padding
  window_padding = {
    left = 20,
    right = 20,
    top = 10,
    bottom = 10,
  },

  -- Disable GTK title bar (if using Wayland or GTK-based DE)
  window_decorations = "RESIZE",

  -- Optional: other tweaks
  enable_tab_bar = false,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
}

