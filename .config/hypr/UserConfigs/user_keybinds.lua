-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Qtile-parity keybinds (override defaults from configs/keybinds.lua)

local paths = require("lib.paths")
local mainMod = "SUPER"
local s = paths.scripts
local us = paths.userScripts

local function override(key, action, opts)
    hl.unbind(key)
    hl.bind(key, action, opts)
end

-- Unbind default keys this file replaces (prevents double-fire on conflicts)
for _, key in ipairs({
    mainMod .. " + E",
    mainMod .. " + B",
    mainMod .. " + SHIFT + B",
    mainMod .. " + SHIFT + G",
    mainMod .. " + P",
    mainMod .. " + CTRL + Return",
    mainMod .. " + SHIFT + S",
    mainMod .. " + SHIFT + left",
    mainMod .. " + SHIFT + right",
    mainMod .. " + SHIFT + up",
    mainMod .. " + SHIFT + down",
    mainMod .. " + CTRL + left",
    mainMod .. " + CTRL + right",
    mainMod .. " + CTRL + up",
    mainMod .. " + CTRL + down",
}) do
    hl.unbind(key)
end

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
override(mainMod .. " + E", hl.dsp.exec_cmd("pcmanfm"))
override(mainMod .. " + B", hl.dsp.exec_cmd("google-chrome"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"))
override(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("galculator"))
override(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd(s .. "/GameMode.sh"))

hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"))
override(mainMod .. " + P", hl.dsp.exec_cmd("pkill rofi || rofi -modi drun -show drun -config ~/.config/rofi/col_singlerow.rasi"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("dmenu_run -nb '#1a1e1e' -sf '#212128' -sb '#f24054' -nf '#00e5ff' -p 'Run: '"))
hl.bind("CTRL + SHIFT + space", hl.dsp.exec_cmd(s .. "/RofiEmoji.sh"))

hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(s .. "/LockScreen.sh"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(s .. "/Wlogout.sh"))

hl.bind(mainMod .. " + space", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd(s .. "/ChangeLayout.sh"))
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
override(mainMod .. " + SHIFT + S", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Insert", hl.dsp.exec_cmd("sh -c 'mkdir -p ~/Pictures && flameshot full -p ~/Pictures/$(date +%Y-%m-%d-%T-scr.png)'"))

hl.bind(mainMod .. " + CTRL + SHIFT + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

override(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
override(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
override(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
override(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

override(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
override(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
override(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
override(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || true && ags -t 'overview'"))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(us .. "/RofiCalc.sh"))
override(mainMod .. " + CTRL + Return", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr zoom"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(us .. "/ZshChangeTheme.sh"))
hl.bind("ALT_L + SHIFT_L", hl.dsp.exec_cmd(s .. "/SwitchKeyboardLayout.sh"), { non_consuming = true })
