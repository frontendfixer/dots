-- Window and layer rules

local function wr(rule)
  hl.window_rule(rule)
end

-- Position / center
wr({ match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, center = true })
wr({ match = { class = "^([Ww]hatsapp-for-linux)$" }, center = true })
wr({ match = { class = "^([Ff]erdium)$" }, center = true })
wr({ match = { class = "([Tt]hunar)", title = "File Operation Progress" }, center = true })
wr({ match = { class = "([Tt]hunar)", title = "Confirm to replace files" }, center = true })
wr({ match = { title = "^(ROG Control)$" }, center = true })
wr({ match = { title = "^(Keybindings)$" }, center = true })
wr({ match = { title = "^(Picture-in-Picture)$" }, move = { "72%", "7%" } })

-- Idle inhibit for fullscreen
wr({ match = { class = "^(*)$" }, idle_inhibit = "fullscreen" })
wr({ match = { title = "^(*)$" }, idle_inhibit = "fullscreen" })
wr({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- Workspace assignment
wr({ match = { class = "^(kitty|Alacritty)$" }, workspace = "1" })
wr({ match = { class = "^([Tt]hunar)$" }, workspace = "2" })
wr({
  match = { class = "^(firefox|Firefox|Navigator|[Hh]elium|helium-browser)$" },
  workspace =
  "3"
})
wr({ match = { class = "^(VSCodium|Code|dev.zed.Zed|[Cc]ursor)$" }, workspace = "4" })
wr({ match = { class = "^(figma-linux|[Gg]imp-2.10|Inkscape|postman)$" }, workspace = "5" })
wr({ match = { class = "^(vlc|libreoffice|DBeaver)$" }, workspace = "6" })
wr({ match = { class = "^(VirtualBox Manager)$" }, workspace = "8" })
wr({ match = { class = "^(meld|Meld)$" }, workspace = "10" })

-- Float
wr({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, float = true })
wr({ match = { class = "([Zz]oom|onedriver|onedriver-launcher)" }, float = true })
wr({ match = { class = "([Tt]hunar)", title = "File Operation Progress" }, float = true })
wr({ match = { class = "([Tt]hunar)", title = "Confirm to replace files" }, float = true })
wr({ match = { class = "xdg-desktop-portal-gtk" }, float = true })
wr({ match = { class = "org.gnome.Calculator", title = "Calculator" }, float = true })
wr({ match = { class = "(VSCodium|code-oss|dev.zed.Zed|[Cc]ursor)", title = "Add Folder to Workspace" }, float = true })
wr({ match = { class = "^([Rr]ofi)$" }, float = true })
wr({ match = { class = "^(eog|org.gnome.Loupe)$" }, float = true })
wr({ match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, float = true })
wr({ match = { class = "^(nwg-look|qt5ct|qt6ct)$" }, float = true })
wr({ match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true })
wr({ match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" }, float = true })
wr({ match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" }, float = true })
wr({ match = { class = "^([Yy]ad)$" }, float = true })
wr({ match = { class = "^(wihotspot(-gui)?)$" }, float = true })
wr({ match = { class = "^(evince)$" }, float = true })
wr({ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, float = true })
wr({ match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" }, float = true })
wr({ match = { title = "Kvantum Manager" }, float = true })
wr({ match = { class = "^([Ss]team)$", title = "^((?![Ss]team).*| [Ss]team [Ss]ettings)$" }, float = true })
wr({ match = { class = "^([Qq]alculate-gtk)$" }, float = true })
wr({ match = { class = "^([Ff]erdium)$" }, float = true })
wr({ match = { title = "^(Picture-in-Picture)$" }, float = true })
wr({ match = { title = "^(ROG Control)$" }, float = true })
wr({ match = { title = "^(hyprgui)$" }, float = true })
wr({ match = { class = "^([Ff]lameshot|[Dd]menu)$" }, float = true })
wr({ match = { class = "^(copyq)$" }, float = true })
wr({ match = { class = "^([Mm]eld)$" }, float = true })
wr({ match = { class = "^(VirtualBox)$" }, float = true })
wr({ match = { class = "^([Tt]ransmission-gtk|Transmission-gtk)$" }, float = true })
wr({ match = { class = "^(ssh-askpass)$" }, float = true })
wr({ match = { title = "^(pinentry)$" }, float = true })
wr({ match = { class = "^([Zz]enity)$" }, float = true })
wr({ match = { class = "^(Mousepad)$" }, float = true })
wr({ match = { class = "^(Gedit)$" }, float = true })
wr({ match = { class = "^(Xed)$" }, float = true })
wr({ match = { class = "^([Aa]udacious)$" }, float = true })
wr({ match = { class = "^(Lxappearance)$" }, float = true })
wr({ match = { class = "^(GParted)$" }, float = true })
wr({ match = { class = "^(Synaptic)$" }, float = true })
wr({ match = { class = "^(Xfce4-power-manager-settings)$" }, float = true })
wr({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, float = true })
wr({ match = { class = "^(Xfce4-appfinder)$" }, float = true })
wr({ match = { class = "^(Nitrogen)$" }, float = true })
wr({ match = { class = "^(gcolor2|gcolor3)$" }, float = true })
wr({ match = { class = "^(TelegramDesktop)$" }, float = true })
wr({ match = { class = "^(Toolkit)$" }, float = true })
wr({ match = { class = "^(code-url-handler|VSCodium-url-handler)$" }, float = true })
wr({ match = { class = "^(Engrampa|Xarchiver)$" }, float = true })
wr({ match = { class = "^(Galculator|gcolor2|gcolor3|[Yy]ad|[Zz]enity)$" }, center = true })
wr({ match = { class = "^(file-roller|Engrampa|GParted)$" }, center = true })
wr({ match = { title = "^(Picture-in-Picture)$" }, size = { "26%", "15%" } })

-- Opacity
wr({ match = { class = "^([Rr]ofi)$" }, opacity = "0.9 0.6" })
wr({ match = { class = "^(Brave-browser(-beta|-dev)?)$" }, opacity = "0.9 0.7" })
wr({ match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$" }, opacity = "0.9 0.7" })
wr({ match = { class = "^(zen-alpha)$" }, opacity = "0.9 0.7" })
wr({ match = { class = "^([Tt]horium-browser)$" }, opacity = "0.9 0.6" })
wr({ match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(google-chrome(-beta|-dev|-unstable)?)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(chrome-.+-Default)$" }, opacity = "0.94 0.86" })
wr({ match = { class = "^([Tt]hunar|org.gnome.Nautilus)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = "0.8 0.7" })
wr({ match = { class = "^(deluge)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(Alacritty|kitty|kitty-dropterm)$" }, opacity = "0.8 0.7" })
wr({ match = { class = "^(VSCodium|Code|code-oss|VSCode|code-url-handler|dev.zed.Zed|[Cc]ursor)$" }, opacity = "0.9 0.7" })
wr({ match = { class = "^(nwg-look|qt5ct|qt6ct|[Yy]ad)$" }, opacity = "0.9 0.8" })
wr({ match = { title = "Kvantum Manager" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(com.obsproject.Studio)$" }, opacity = "0.9 0.7" })
wr({ match = { class = "^([Aa]udacious)$" }, opacity = "0.9 0.7" })
wr({ match = { class = "^(jetbrains-.+)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^([Dd]iscord|[Vv]esktop)$" }, opacity = "0.94 0.86" })
wr({ match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(im.riot.Riot)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(gnome-disks|evince|wihotspot(-gui)?|org.gnome.baobab)$" }, opacity = "0.94 0.86" })
wr({ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^(app.drey.Warp)$" }, opacity = "0.8 0.7" })
wr({ match = { class = "^(seahorse)$" }, opacity = "0.9 0.8" })
wr({
  match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" },
  opacity =
  "0.82 0.75"
})
wr({ match = { class = "^(xdg-desktop-portal-gtk)$" }, opacity = "0.9 0.8" })
wr({ match = { class = "^([Ww]hatsapp-for-linux)$" }, opacity = "0.9 0.7" })
wr({ match = { class = "^([Ff]erdium)$" }, opacity = "0.9 0.7" })
wr({ match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.75" })

-- Size
wr({ match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" }, size = { "70%", "70%" } })
wr({ match = { class = "^(xdg-desktop-portal-gtk)$" }, size = { "70%", "70%" } })
wr({ match = { title = "Kvantum Manager" }, size = { "60%", "70%" } })
wr({ match = { class = "^(qt6ct)$" }, size = { "60%", "70%" } })
wr({ match = { class = "^(evince|wihotspot(-gui)?)$" }, size = { "70%", "70%" } })
wr({ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, size = { "60%", "70%" } })
wr({ match = { class = "^([Ww]hatsapp-for-linux)$" }, size = { "60%", "70%" } })
wr({ match = { class = "^([Ff]erdium)$" }, size = { "60%", "70%" } })
wr({ match = { title = "^(ROG Control)$" }, size = { "60%", "70%" } })
wr({ match = { title = "^(hyprgui)$" }, size = { "60%", "70%" } })

-- Pin and extras
wr({ match = { title = "^(Picture-in-Picture)$" }, pin = true })
wr({ match = { title = "^(Picture-in-Picture)$" }, keep_aspect_ratio = true })

-- GameMode: toggled at runtime via hyprctl (see GameMode.sh)
local gamemodeOpacity = hl.window_rule({
  name = "gamemode-opacity",
  match = { class = ".*" },
  opacity = "1.0 override 1.0 override 1.0 override",
})
gamemodeOpacity:set_enabled(false)

-- Layer rules (commented in original — enable if needed)
-- hl.layer_rule({ match = { namespace = "^([Rr]ofi)$" }, blur = true })
