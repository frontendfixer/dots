#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Rofi icon power menu (Hyprland) — adi1090x style

ROFI_THEME="$HOME/.config/rofi/rofi-powermenu.rasi"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

uptime="$(uptime -p | sed -e 's/up //g')"

lock='🔒'
suspend='💤'
logout='⌛'
reboot='🔁'
shutdown='⚡'
yes='✅'
no='❌'

rofi_cmd() {
	rofi -dmenu \
		-p "Power" \
		-mesg "Uptime: $uptime" \
		-theme "$ROFI_THEME"
}

confirm_cmd() {
	rofi \
		-theme-str 'window {location: center; anchor: center; width: 320px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5; font: "sans-serif 24";}' \
		-dmenu \
		-p 'Confirm' \
		-mesg 'Are you sure?' \
		-theme "$ROFI_THEME"
}

confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

run_cmd() {
	local action="$1"
	local selected
	selected="$(confirm_exit)"
	[[ "$selected" == "$yes" ]] || exit 0

	case "$action" in
		--shutdown) systemctl poweroff ;;
		--reboot) systemctl reboot ;;
		--suspend) systemctl suspend ;;
		--logout) hyprctl dispatch exit 0 ;;
	esac
}

pkill rofi 2>/dev/null || true

chosen="$(run_rofi)"
case "$chosen" in
	"$lock")
		"$SCRIPTSDIR/LockScreen.sh"
		;;
	"$suspend")
		run_cmd --suspend
		;;
	"$logout")
		run_cmd --logout
		;;
	"$reboot")
		run_cmd --reboot
		;;
	"$shutdown")
		run_cmd --shutdown
		;;
esac
