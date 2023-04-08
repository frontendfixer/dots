#!/bin/sh

#betterlockscreen -w blur &
$HOME/.fehbg &
picom -b --config ~/.config/picom/picom.conf &
#pavucontrol &
blueman-applet &
nm-applet &
#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
#### for fedora
/usr/libexec/polkit-gnome-authentication-agent-1 &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
numlockx on &
clipit &
dunst &
