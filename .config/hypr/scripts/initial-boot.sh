#!/bin/bash
# One-time first-boot setup for Hyprland dotfiles.
# Safe to delete after the marker file exists.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HYPR_CONFIG="$(dirname "$SCRIPT_DIR")"
MARKER="$HYPR_CONFIG/.initial_startup_done"

kvantum_theme="catppuccin-mocha-blue"
color_scheme="prefer-dark"
gtk_theme="Dracula"
icon_theme="Papirus-Dark"
cursor_theme="Bibata-Modern-Ice"

if [ -f "$MARKER" ]; then
    exit 0
fi

sleep 1

gsettings set org.gnome.desktop.interface color-scheme "$color_scheme" >/dev/null 2>&1 || true
gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" >/dev/null 2>&1 || true
gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" >/dev/null 2>&1 || true
gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" >/dev/null 2>&1 || true
gsettings set org.gnome.desktop.interface cursor-size 24 >/dev/null 2>&1 || true

if command -v kvantummanager >/dev/null; then
    kvantummanager --set "$kvantum_theme" >/dev/null 2>&1 &
fi

touch "$MARKER"
