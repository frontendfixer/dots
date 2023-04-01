#!/bin/sh

case "$1" in
    --popup)
        yad=$(yad --width 280 --posx=-10 --posy=30 --entry --entry-label="<span foreground='black' background='#fd6e7f'><b><big><big><big><big> ⏻ </big></big></big></big></b></span>" --undecorated --title "System Logout" --text "<span foreground='#1dfafa'><b><big><big>Choose action</big></big></b></span>" --text-align=center  --entry-text "🔒 Lock" "💤 Sleep" "⌛ Logout" "🔁 Reboot" "⚡ Shutdown")

        case "$yad" in
            '🔒 Lock')
                betterlockscreen -l dimblur
                ;;
            '⚡ Shutdown')
                systemctl poweroff
                ;;
            '🔁 Reboot')
                systemctl reboot
                ;;
            '💤 Sleep')
                systemctl suspend
                ;;
            '⌛ Logout')
                loginctl kill-user $USER
                ;;
        esac
        ;;
    *)
        echo ""
        ;;
esac
