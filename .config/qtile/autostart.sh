#!/bin/bash

feh --bg-fill --randomize /usr/share/backgrounds/fantasy/* &
picom -b --config ~/.config/picom/picom.conf &
xscreensaver &
blueman-applet &
nm-applet &

# Polkit agent (Fedora / Debian paths)
polkit_paths=(
    "/usr/libexec/polkit-gnome-authentication-agent-1"
    "/usr/libexec/polkit-mate-authentication-agent-1"
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
)
for agent in "${polkit_paths[@]}"; do
    if [ -x "$agent" ]; then
        "$agent" &
        break
    fi
done

command -v numlockx >/dev/null && numlockx on
command -v clipman >/dev/null && clipman &
command -v clipit >/dev/null && clipit &
dunst &
unclutter -root &
~/.scripts/redshift-on &
