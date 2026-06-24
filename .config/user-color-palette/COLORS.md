# Central color palette

Edit **one file**: `~/.config/user-color-palette/colors.py`

Pick a theme by changing the selector near the bottom:

```python
colorscheme = fantacy   # or doomOne, dracula, nord, gruvbox, mbfs, everforest
```

Then run:

```bash
~/.config/user-color-palette/sync-colors.sh
```

Reload apps that use the palette (Hyprland reload, restart waybar/wlogout/ags/polybar, reopen rofi, restart Qtile/Awesome).

## Available themes

| Variable | Theme |
|----------|-------|
| `fantacy` | Royal dark (default) |
| `doomOne` | Doom One |
| `dracula` | Dracula |
| `everforest` | Everforest |
| `nord` | Nord |
| `gruvbox` | Gruvbox |
| `mbfs` | MBFS |

## Generated files (do not edit by hand)

Each file is written to the config directory that consumes it:

| File | Used by |
|------|---------|
| `hypr/lib/colors.lua` | Hyprland Lua configs (`require("lib.colors")`) |
| `hypr/lib/colors.conf` | `hyprlock.conf` |
| `waybar/colors.css` | `waybar/style.css` |
| `wlogout/colors.css` | `wlogout/style.css` |
| `rofi/colors-rofi.rasi` | rofi themes |
| `awesome/themes/colors.lua` | Awesome WM |
| `polybar/colors.ini` | Polybar (`include-file` in `config.ini`) |

Qtile imports the same palette via `~/.config/qtile/colors.py` (shim to this file).

## Theme → 16-color mapping

| Output key | Source from `colors.py` |
|------------|-------------------------|
| `background` | `backgroundColor` |
| `foreground` | `foregroundColorTwo` |
| `color0` | `colors[0][0]` |
| `color1` | `colors[0][1]` |
| `color2` | `colors[5][0]` (green) |
| `color3` | `colors[4][0]` (cyan) |
| `color4` | `colors[3][0]` (blue) |
| `color5` | `colors[8][0]` (purple) |
| `color6` | `colors[6][0]` (orange) |
| `color7` | `colors[2][0]` (text) |
| `color8` | `colors[1][0]` (muted) |
| `color9` | `colors[9][0]` (red) |
| `color10` | `colors[10][0]` (yellow) |
| `color11` | `colors[6][0]` (urgent) |
| `color12` | `colors[3][0]` (accent) |
| `color13` | `workspaceColor` (highlight) |
| `color14` | `colors[7][0]` (pink) |
| `color15` | `colors[2][1]` (bright text) |

## Semantic CSS aliases

Defined in `waybar/colors.css` and `wlogout/colors.css`:

- `@accent` → color12
- `@highlight` → color13
- `@urgent` → color11
- `@surface` / `@surface-alt` → color0 / color1
- `@muted` → color8

## Path resolution

The script derives the config root from its own location (`PALETTE_DIR.parent`), so it works when run from:

- `~/.config/user-color-palette/sync-colors.sh` (deployed dotfiles)
- a git checkout at `.../dots/.config/user-color-palette/sync-colors.sh`
