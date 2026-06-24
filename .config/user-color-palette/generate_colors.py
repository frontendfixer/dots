#!/usr/bin/env python3
"""Generate WM color files from ~/.config/user-color-palette/colors.py"""

from __future__ import annotations

import importlib.util
import os
from pathlib import Path

PALETTE_DIR = Path(__file__).resolve().parent
CONFIG = PALETTE_DIR.parent
HOME = Path(os.environ.get("HOME", os.path.expanduser("~")))

spec = importlib.util.spec_from_file_location("palette", PALETTE_DIR / "colors.py")
palette = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(palette)

colors = palette.colors
backgroundColor = palette.backgroundColor
foregroundColor = palette.foregroundColor
workspaceColor = palette.workspaceColor
foregroundColorTwo = palette.foregroundColorTwo


def strip_hash(value: str) -> str:
    return value.lstrip("#").upper()


def hex_rgb(value: str) -> str:
    return f"rgb({strip_hash(value)})"


def hex_css(value: str) -> str:
    return f"#{strip_hash(value)}"


# Theme -> 16-color mapping (see COLORS.md)
MAPPED = {
    "background": backgroundColor,
    "foreground": foregroundColorTwo,
    "color0": colors[0][0],
    "color1": colors[0][1],
    "color2": colors[5][0],
    "color3": colors[4][0],
    "color4": colors[3][0],
    "color5": colors[8][0],
    "color6": colors[6][0],
    "color7": colors[2][0],
    "color8": colors[1][0],
    "color9": colors[9][0],
    "color10": colors[10][0],
    "color11": colors[6][0],
    "color12": colors[3][0],
    "color13": workspaceColor,
    "color14": colors[7][0],
    "color15": colors[2][1],
}

ORDER = [
    "background",
    "foreground",
    *[f"color{i}" for i in range(16)],
]

HEADER_LUA = (
    "-- Auto-generated from user-color-palette/colors.py — do not edit\n"
    "-- Run: ~/.config/user-color-palette/sync-colors.sh\n"
    "-- Hyprland Lua configs: require(\"lib.colors\")\n\n"
    "return {\n"
)
HEADER_CONF = (
    "# Auto-generated from user-color-palette/colors.py — do not edit\n"
    "# Run: ~/.config/user-color-palette/sync-colors.sh\n"
)
HEADER_CSS = (
    "/* Auto-generated from user-color-palette/colors.py — do not edit */\n"
    "/* Run: ~/.config/user-color-palette/sync-colors.sh */\n"
)
HEADER_ROFI = (
    "/* Auto-generated from user-color-palette/colors.py — do not edit */\n"
    "/* Run: ~/.config/user-color-palette/sync-colors.sh */\n"
)


def write_hypr_lua(path: Path) -> None:
    lines = [HEADER_LUA]
    for key in ORDER:
        lines.append(f'    {key} = "{hex_rgb(MAPPED[key])}",')
    lines.append("}\n")
    path.write_text("\n".join(lines))


def write_hypr_conf(path: Path) -> None:
    lines = [HEADER_CONF]
    for key in ORDER:
        lines.append(f"${key} = {hex_rgb(MAPPED[key])}")
    path.write_text("\n".join(lines) + "\n")


def write_hypr_css(path: Path) -> None:
    lines = [HEADER_CSS, ""]
    for key in ORDER:
        lines.append(f"@define-color {key} {hex_css(MAPPED[key])};")
    lines.extend(
        [
            "",
            "/* semantic aliases */",
            "@define-color accent @color12;",
            "@define-color highlight @color13;",
            "@define-color urgent @color11;",
            "@define-color surface @color0;",
            "@define-color surface-alt @color1;",
            "@define-color muted @color8;",
            "",
        ]
    )
    path.write_text("\n".join(lines))


def write_rofi_rasi(path: Path) -> None:
    bg = hex_css(MAPPED["background"])
    fg = hex_css(MAPPED["foreground"])
    c = {i: hex_css(MAPPED[f"color{i}"]) for i in range(16)}

    lines = [
        HEADER_ROFI,
        "",
        "* {",
        f"    background: {bg};",
        f"    foreground: {fg};",
        f"    background-color: {bg};",
        f"    border-color: {c[12]};",
        "",
        f"    active-background: {c[12]};",
        f"    active-foreground: {fg};",
        f"    normal-background: {bg};",
        f"    normal-foreground: {fg};",
        f"    urgent-background: {c[13]};",
        f"    urgent-foreground: {fg};",
        "",
        f"    alternate-active-background: {c[11]};",
        f"    alternate-active-foreground: {fg};",
        f"    alternate-normal-background: {bg};",
        f"    alternate-normal-foreground: {fg};",
        f"    alternate-urgent-background: {bg};",
        f"    alternate-urgent-foreground: {fg};",
        "",
        f"    selected-active-background: {c[12]};",
        f"    selected-active-foreground: {bg};",
        f"    selected-normal-background: {c[12]};",
        f"    selected-normal-foreground: {bg};",
        f"    selected-urgent-background: {c[11]};",
        f"    selected-urgent-foreground: {bg};",
        "",
    ]
    for i in range(16):
        lines.append(f"    color{i}: {c[i]};")
    lines.extend(["}", ""])
    path.write_text("\n".join(lines))


def write_awesome_lua(path: Path) -> None:
    header = (
        "-- Auto-generated from user-color-palette/colors.py — do not edit\n"
        "-- Run: ~/.config/user-color-palette/sync-colors.sh\n\n"
    )
    text = f"""{header}local colors = {{
\tbg = "{hex_css(colors[0][1])}",
\tfg = "{hex_css(colors[2][0])}",
\tdark = "{hex_css(backgroundColor)}",
\tgray = "{hex_css(colors[1][0])}",
\tcyan = "{hex_css(colors[4][0])}",
\tgreen = "{hex_css(colors[5][0])}",
\torange = "{hex_css(colors[6][0])}",
\tpink = "{hex_css(colors[7][0])}",
\tpurple = "{hex_css(colors[8][0])}",
\tred = "{hex_css(colors[9][0])}",
\tyellow = "{hex_css(colors[10][0])}",
}}

colors.primary = colors.cyan

return colors
"""
    path.write_text(text)


def write_polybar_ini(path: Path) -> None:
    bg_alt = colors[0][1]
    text = f"""{HEADER_CONF}
[colors]
background = {hex_css(bg_alt)}
background-trans = {hex_css(bg_alt)}1a
background-alt = {hex_css(colors[1][0])}
foreground = {hex_css(colors[2][0])}
foreground-alt = {hex_css(colors[2][1])}
primary = {hex_css(colors[3][0])}
secondary = {hex_css(colors[9][0])}
alert = {hex_css(colors[9][0])}
disabled = {hex_css(colors[1][0])}
dark = {hex_css(backgroundColor)}
red = {hex_css(colors[9][0])}
green = {hex_css(colors[5][0])}
yellow = {hex_css(colors[10][0])}
blue = {hex_css(colors[3][0])}
cyan = {hex_css(colors[4][0])}
tela = {hex_css(colors[6][0])}
orange = {hex_css(colors[6][0])}
pink = {hex_css(colors[7][0])}
purple = {hex_css(colors[8][0])}
"""
    path.write_text(text)


def main() -> None:
    hypr_lib = CONFIG / "hypr" / "lib"

    outputs = {
        hypr_lib / "colors.lua": write_hypr_lua,
        hypr_lib / "colors.conf": write_hypr_conf,
        CONFIG / "waybar" / "colors.css": write_hypr_css,
        CONFIG / "wlogout" / "colors.css": write_hypr_css,
        CONFIG / "rofi" / "colors-rofi.rasi": write_rofi_rasi,
        CONFIG / "awesome" / "themes" / "colors.lua": write_awesome_lua,
        CONFIG / "polybar" / "colors.ini": write_polybar_ini,
    }

    for path, writer in outputs.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        writer(path)

    stale = [
        hypr_lib / "colors.conf",
        hypr_lib / "colors.css",
        hypr_lib / "colors-rofi.rasi",
    ]
    for path in stale:
        if path.exists():
            path.unlink()

    print("Generated from user-color-palette/colors.py:")
    for path in outputs:
        print(f"  {path}")
    for path in stale:
        print(f"  removed stale {path}")


if __name__ == "__main__":
    main()
