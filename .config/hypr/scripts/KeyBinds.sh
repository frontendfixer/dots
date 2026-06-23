#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Searchable enabled keybinds using rofi

pkill yad || true

KEYBINDS_CONF="$HOME/.config/hypr/configs/keybinds.lua"
USER_KEYBINDS_CONF="$HOME/.config/hypr/UserConfigs/user_keybinds.lua"
LAPTOP_CONF="$HOME/.config/hypr/UserConfigs/laptops.lua"

KEYBINDS=$(cat "$KEYBINDS_CONF" "$USER_KEYBINDS_CONF" | grep -E '^hl\.bind\(')

if [[ -f "$LAPTOP_CONF" ]]; then
    LAPTOP_BINDS=$(grep -E '^hl\.bind\(' "$LAPTOP_CONF")
    KEYBINDS+=$'\n'"$LAPTOP_BINDS"
fi

if [[ -z "$KEYBINDS" ]]; then
    echo "No keybinds found."
    exit 1
fi

echo "$KEYBINDS" | rofi -dmenu -i -p "Keybinds" -config ~/.config/rofi/config-keybinds.rasi
