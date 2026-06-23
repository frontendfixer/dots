#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly

notif="$HOME/.config/swaync/images/bell.png"

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl eval 'hl.config({ general = { layout = "dwindle" } })'
	hyprctl eval 'hl.bind("SUPER + O", hl.dsp.layout("togglesplit"))'
  notify-send -e -u low -i "$notif" "Dwindle Layout"
	;;
"dwindle")
	hyprctl eval 'hl.config({ general = { layout = "master" } })'
	hyprctl eval 'hl.unbind("SUPER + O")'
  notify-send -e -u low -i "$notif" "Master Layout"
	;;
*) ;;

esac
