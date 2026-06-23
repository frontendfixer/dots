-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Default Keybinds

local paths = require("lib.paths")
local mainMod = "SUPER"
local s = paths.scripts
local us = paths.userScripts

hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("hyprctl dispatch exit 0"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(s .. "/KillActiveProcess.sh"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allfloat"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(s .. "/LockScreen.sh"))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(s .. "/Wlogout.sh"))

hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(s .. "/KeyHints.sh"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(s .. "/Refresh.sh"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(s .. "/RofiEmoji.sh"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(s .. "/RofiSearch.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(s .. "/ChangeBlur.sh"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(s .. "/GameMode.sh"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(s .. "/ChangeLayout.sh"))
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd(s .. "/ClipManager.sh"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(us .. "/QuickEdit.sh"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(us .. "/RofiBeats.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(us .. "/WallpaperSelect.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(us .. "/WallpaperEffects.sh"))
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd(us .. "/WallpaperRandom.sh"))
hl.bind(mainMod .. " + ALT + O", hl.dsp.exec_cmd("hyprctl setprop active opaque toggle"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(s .. "/KeyBinds.sh"))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(s .. "/WaybarStyles.sh"))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(s .. "/WaybarLayout.sh"))

hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + CTRL + D", hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + I", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch splitratio 0.3"))

hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + CTRL + tab", hl.dsp.group.next({ forward = false }))

hl.bind("ALT + tab", hl.dsp.window.cycle_next())
hl.bind("ALT + tab", hl.dsp.window.bring_to_top())

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(s .. "/Volume.sh --inc"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(s .. "/Volume.sh --dec"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(s .. "/Volume.sh --toggle-mic"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(s .. "/Volume.sh --toggle"), { locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind("XF86Rfkill", hl.dsp.exec_cmd(s .. "/AirplaneMode.sh"), { locked = true })

hl.bind("XF86AudioPause", hl.dsp.exec_cmd(s .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(s .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(s .. "/MediaCtrl.sh --nxt"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(s .. "/MediaCtrl.sh --prv"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(s .. "/MediaCtrl.sh --stop"), { locked = true })

hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + Print", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --in5"))
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --in10"))
hl.bind("ALT + Print", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --active"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --swappy"))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special())

for i = 1, 10 do
    local code = "code:" .. (9 + i)
    hl.bind(mainMod .. " + " .. code, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. code, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. code, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }))
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
