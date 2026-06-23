#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/bell.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        eval 'hl.config({ animations = { enabled = false } })';\
        eval 'hl.config({ decoration = { shadow = { enabled = false }, blur = { passes = 0 }, rounding = 0, active_opacity = 1.0, inactive_opacity = 1.0, fullscreen_opacity = 1.0 } })';\
        eval 'hl.config({ general = { gaps_in = 0, gaps_out = 0, border_size = 1 } })'"
    swww kill 
    notify-send -e -u low -i "$notif" "gamemode enabled. All animations off"
    exit
else
	swww-daemon --format xrgb && swww img "$HOME/.config/rofi/.current_wallpaper" &
	sleep 0.1
	${SCRIPTSDIR}/WallustSwww.sh
	sleep 0.5
	hyprctl reload
	${SCRIPTSDIR}/Refresh.sh	 
    notify-send -e -u normal -i "$notif" "gamemode disabled. All animations normal"
    exit
fi
hyprctl reload
