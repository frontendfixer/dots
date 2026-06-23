-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Laptop keybinds and touchpad device

local paths = require("lib.paths")
local mainMod = "SUPER"
local s = paths.scripts
local touchpadDevice = "elan06c7:00-04f3:3193-touchpad"

hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(s .. "/BrightnessKbd.sh --dec"), { repeating = true })
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd(s .. "/BrightnessKbd.sh --inc"), { repeating = true })
hl.bind("XF86Launch1", hl.dsp.exec_cmd("rog-control-center"))
hl.bind("XF86Launch3", hl.dsp.exec_cmd("asusctl led-mode -n"))
hl.bind("XF86Launch4", hl.dsp.exec_cmd("asusctl profile -n"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(s .. "/Brightness.sh --dec"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(s .. "/Brightness.sh --inc"), { repeating = true })
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd(s .. "/TouchPad.sh"))

hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + F6", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + F6", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --in5"))
hl.bind(mainMod .. " + ALT + F6", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --in10"))
hl.bind("ALT + F6", hl.dsp.exec_cmd(s .. "/ScreenShot.sh --active"))

hl.device({
    name = touchpadDevice,
    enabled = true,
})
