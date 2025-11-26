local wezterm = require 'wezterm'

local colors_dark = {
  foreground = "#B0B0B0",
  background = "#232136",
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
}

local colors_light = {
  foreground = "#202020",
  background = "#faf4ed",
  cursor_bg = "#202020",
  cursor_border = "#202020",
  cursor_fg = "#FFFFFF",
  selection_fg = "#000000",
  selection_bg = "#C0C0C0",

  ansi = {
    "#F0F0F0",
    "#C0585B",
    "#4F8F5D",
    "#B2A178",
    "#4D79B5",
    "#B67DA8",
    "#4C918D",
    "#202020",
  },
  brights = {
    "#A0A0A0", "#D0686B", "#5F9F6D", "#C2B188",
    "#5D89C5", "#C68DB8", "#5CA19D", "#505050",
  },
}

local function get_color_scheme()
  local gtk_theme = os.getenv("GTK_THEME")

  if gtk_theme and gtk_theme:lower():find("dark") then
    return colors_dark
  else
    return colors_light
  end
end

return {
  font = wezterm.font("Victor Mono NF"),
  font_size = 18.0,
  harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' },

  colors = get_color_scheme(),

  window_padding = {
    left = 20,
    right = 20,
    top = 10,
    bottom = 10,
  },

  window_decorations = "RESIZE",

  enable_tab_bar = false,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
}
