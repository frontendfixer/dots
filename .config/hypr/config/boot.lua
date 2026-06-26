-- First-run setup hook (runs initial-boot.sh once)

local paths = require("lib.paths")

hl.on("hyprland.start", function()
    hl.exec_cmd(paths.scripts .. "/initial-boot.sh")
end)
