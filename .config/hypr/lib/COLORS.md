# Central color palette

Edit **one file**: `~/.config/hypr/lib/colors.lua`

Then run:

```bash
~/.config/hypr/lib/sync-colors.sh
```

Reload apps that use the palette (Hyprland reload, restart waybar/wlogout/ags, reopen rofi).

## Generated files (do not edit by hand)

| File | Used by |
|------|---------|
| `colors.conf` | `hyprlock.conf` (`source = ...`) |
| `colors.css` | waybar, wlogout, AGS (`@import`) |
| `colors-rofi.rasi` | rofi themes (`@theme`) |

A copy of `colors-rofi.rasi` is also written to `~/.config/rofi/colors-rofi.rasi` so older theme paths keep working.

## Direct consumers

| App | How it loads colors |
|-----|---------------------|
| Hyprland | `require("lib.colors")` in Lua configs |
| hyprlock | `source = $HOME/.config/hypr/lib/colors.conf` |
| waybar | `@import "../hypr/lib/colors.css"` in `style.css` |
| wlogout | `@import "../hypr/lib/colors.css"` in `style.css` |
| AGS | `@import '../../../.config/hypr/lib/colors.css'` |
| rofi | `@theme "~/.config/hypr/lib/colors-rofi.rasi"` in themes |

## Semantic CSS aliases

Defined in `colors.css` for styling:

- `@accent` → color12
- `@highlight` → color13
- `@urgent` → color11
- `@surface` / `@surface-alt` → color0 / color1
- `@muted` → color8
