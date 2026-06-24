# Rofi configs

## Layout

```
rofi/
  config.rasi              → main launcher (SUPER+D)
  shared-fonts.rasi        → fonts (edit here)
  colors-rofi.rasi         → palette (generated in this directory by sync-colors.sh)
  themes/
    palette.rasi           → shorthand: @bg @fg @se @ac @al @muted @highlight
    default.rasi           → general drun/run
    col_singlerow.rasi     → compact grid launcher (SUPER+P)
    panel.rasi             → top-left panel style
    emoji-selector.rasi    → emoji picker (rofimoji)
    rofi-powermenu.rasi    → power menu grid
```

## Colors

All themes pull from `~/.config/user-color-palette/colors.py` via:

1. Edit `~/.config/user-color-palette/colors.py` (set `colorscheme = fantacy` or another theme)
2. Run `~/.config/user-color-palette/sync-colors.sh`
3. Reopen rofi

Themes using `palette.rasi` map:

| Alias | Palette |
|-------|---------|
| `@bg` | background |
| `@fg` | foreground |
| `@se` | color1 (surface) |
| `@ac` | color11 (accent) |
| `@highlight` | color13 |
| `@muted` | color8 |
| `@al` | transparent |

`rofi-powermenu.rasi` uses the full rofi color set (`@active-background`, `@selected-normal-background`, etc.).

## Fonts

Edit `shared-fonts.rasi` for the default font. Per-theme overrides:

| Theme | Font |
|-------|------|
| default / col_singlerow | JetBrainsMono Nerd Font 11 |
| panel | JetBrainsMono Nerd Font 10 |
| emoji-selector | JetBrainsMono Nerd Font 16 (config), 12 (entry) |
| rofi-powermenu | JetBrainsMono Nerd Font 28 (labels) |

## Usage

```bash
rofi -show drun                          # uses config.rasi
rofi -config ~/.config/rofi/themes/col_singlerow.rasi -show drun
rofi -dmenu -theme ~/.config/rofi/themes/emoji-selector.rasi
rofi -show drun -theme ~/.config/rofi/themes/rofi-powermenu.rasi
```
