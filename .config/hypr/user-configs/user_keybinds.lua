-- Qtile-parity keybinds (override defaults from configs/keybinds.lua)

local paths = require("lib.paths")
local mainMod = "SUPER"
local s = paths.scripts
local launchPrefix = "" -- if you are using UWSM, make this ("uwsm app -- ")

local function bind(key, action, opts)
    hl.unbind(key)
    hl.bind(key, action, opts)
end

-- Overrides: unbind default from configs/keybinds.lua, then bind user action
local overrides = {
    { key = mainMod .. " + E",             action = hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER) },
    { key = mainMod .. " + B",             action = hl.dsp.exec_cmd(launchPrefix .. BROWSER) },
    { key = mainMod .. " + SHIFT + B",     action = hl.dsp.exec_cmd(launchPrefix .. ALT_BROWSER) },
    { key = mainMod .. " + SHIFT + G",     action = hl.dsp.exec_cmd("flameshot gui") },
    { key = mainMod .. " + P",             action = hl.dsp.exec_cmd("pkill rofi || rofi -modi drun -show drun -config ~/.config/rofi/themes/col_singlerow.rasi") },
    { key = mainMod .. " + CTRL + Return", action = hl.dsp.exec_cmd("pypr toggle term") },
    { key = mainMod .. " + SHIFT + S",     action = hl.dsp.layout("togglesplit") },
    { key = mainMod .. " + SHIFT + left",  action = hl.dsp.window.move({ direction = "left" }) },
    { key = mainMod .. " + SHIFT + right", action = hl.dsp.window.move({ direction = "right" }) },
    { key = mainMod .. " + SHIFT + up",    action = hl.dsp.window.move({ direction = "up" }) },
    { key = mainMod .. " + SHIFT + down",  action = hl.dsp.window.move({ direction = "down" }) },
    { key = mainMod .. " + CTRL + left",   action = hl.dsp.window.resize({ x = -10, y = 0, relative = true }),                                                   opts = { repeating = true } },
    { key = mainMod .. " + CTRL + right",  action = hl.dsp.window.resize({ x = 10, y = 0, relative = true }),                                                    opts = { repeating = true } },
    { key = mainMod .. " + CTRL + up",     action = hl.dsp.window.resize({ x = 0, y = -10, relative = true }),                                                   opts = { repeating = true } },
    { key = mainMod .. " + CTRL + down",   action = hl.dsp.window.resize({ x = 0, y = 10, relative = true }),                                                    opts = { repeating = true } },
}

for _, entry in ipairs(overrides) do
    bind(entry.key, entry.action, entry.opts)
end

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(launchPrefix .. CODE_EDITOR))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))

hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"))
hl.bind(mainMod .. " + SHIFT + Return",
    hl.dsp.exec_cmd("dmenu_run -nb '#1a1e1e' -sf '#212128' -sb '#f24054' -nf '#00e5ff' -p 'Run: '"))

hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(s .. "/LockScreen.sh"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(s .. "/Wlogout.sh"))

hl.bind(mainMod .. " + space", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Insert",
    hl.dsp.exec_cmd("sh -c 'mkdir -p ~/Pictures && flameshot full -p ~/Pictures/$(date +%Y-%m-%d-%T-scr.png)'"))

hl.bind("CTRL + SHIFT + space",
    hl.dsp.exec_cmd("rofi -modi 'run,drun,emoji:~/.scripts/rofiemoji.sh' -show emoji"))

hl.bind(mainMod .. " + CTRL + SHIFT + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }),
    { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }),
    { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }),
    { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }),
    { repeating = true })

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || true && ags -t 'overview'"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr zoom"))
