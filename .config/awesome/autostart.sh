#!/bin/sh
#
#  █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
# ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
# ███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
# ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
# ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
# ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
#

feh --bg-fill --randomize /usr/share/backgrounds/fantacy/* &
picom &
blueman-applet &
nm-applet &
"/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1",
#### for fedora
#/usr/libexec/polkit-gnome-authentication-agent-1 &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
numlockx on &
clipit &
dunst &
unclutter -root &
