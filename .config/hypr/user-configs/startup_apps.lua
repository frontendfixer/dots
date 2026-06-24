-- Commands & Apps to be executed at launch

local paths = require("lib.paths")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("swaync")
    hl.exec_cmd("ags")

    hl.exec_cmd("bash -c 'command -v numlockx >/dev/null && numlockx on'")
    hl.exec_cmd(
    "bash -c 'command -v gammastep >/dev/null && gammastep -O 4800 || command -v wlsunset >/dev/null && wlsunset -T 4800 || true'")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    hl.exec_cmd("hypridle")
    hl.exec_cmd("pypr")
end)
