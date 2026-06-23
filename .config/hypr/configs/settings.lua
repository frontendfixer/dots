-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Default Settings. avoid changing this file as during update, this will be replaced

local paths = require("lib.paths")

hl.on("hyprland.start", function()
    hl.exec_cmd(paths.scripts .. "/initial-boot.sh")
end)
