#!/bin/bash
# Key hints — matches config/keybinds_user.lua + config/keybinds.lua

BACKEND=wayland

if pgrep -x "rofi" > /dev/null; then
    pkill rofi
fi

x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

width=$((x_mon * hypr_scale / 100))
height=$((y_mon * hypr_scale / 100))

max_width=1200
max_height=1000
percentage_width=70
percentage_height=70

dynamic_width=$((width * percentage_width / 100))
dynamic_height=$((height * percentage_height / 100))

dynamic_width=$(($dynamic_width > $max_width ? $max_width : $dynamic_width))
dynamic_height=$(($dynamic_height > $max_height ? $max_height : $dynamic_height))

GDK_BACKEND=$BACKEND yad --width=$dynamic_width --height=$dynamic_height \
    --center \
    --title="Keybindings" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "close this app" "" \
"" "Applications" "" \
"SUPER Return" "Terminal" "kitty" \
"SUPER Ctrl Return" "Dropdown terminal" "pypr toggle term" \
"SUPER C" "Code editor" "zeditor" \
"SUPER Shift C" "Calculator" "galculator" \
"SUPER E" "File manager" "dolphin" \
"SUPER B" "Browser" "helium-browser" \
"SUPER Shift B" "Alt browser" "firefox" \
"SUPER P" "App launcher" "rofi col_singlerow" \
"SUPER D" "App launcher (full)" "rofi main config" \
"SUPER Shift Return" "dmenu" "dmenu_run" \
"Ctrl Shift Space" "Emoji picker" "rofi emoji" \
"" "System / power" "" \
"SUPER Shift L" "Lock screen" "hyprlock" \
"Ctrl Alt L" "Lock screen" "hyprlock" \
"SUPER Shift E" "Power menu" "wlogout" \
"Ctrl Alt P" "Power menu" "wlogout" \
"Ctrl Alt Delete" "Exit Hyprland" "hyprctl dispatch exit" \
"SUPER H" "Key hints" "this dialog" \
"" "Windows / layout" "" \
"SUPER Q" "Close window" "" \
"SUPER Shift Q" "Kill active process" "" \
"SUPER F" "Fullscreen" "" \
"SUPER Shift F" "Toggle float" "" \
"SUPER Shift Space" "Toggle float" "" \
"SUPER Space" "Cycle windows" "" \
"SUPER Shift S" "Toggle split" "" \
"SUPER Insert" "Screenshot (full)" "flameshot" \
"SUPER Shift G" "Screenshot (region)" "flameshot gui" \
"SUPER A" "Desktop overview" "ags" \
"SUPER Z" "Desktop zoom" "pypr zoom" \
"SUPER Shift N" "Notifications" "swaync" \
"SUPER arrows" "Focus direction" "" \
"SUPER Shift arrows" "Move window" "" \
"SUPER Ctrl arrows" "Resize window" "" \
"SUPER Ctrl Shift arrows" "Resize floating window" "" \
"SUPER 1-0" "Switch workspace" "" \
"SUPER Shift 1-0" "Move window to workspace" "" \
"" "Media keys" "" \
"XF86AudioRaise/Lower" "Volume" "wpctl" \
"XF86AudioMute" "Mute" "wpctl" \
"XF86AudioMicMute" "Mic mute" "wpctl" \
"XF86MonBrightnessUp/Down" "Brightness" "brightnessctl" \
"XF86AudioPlay/Pause" "Media play-pause" "playerctl" \
"XF86AudioNext/Prev" "Media next/prev" "playerctl"
