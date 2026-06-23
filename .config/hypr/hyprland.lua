-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Hyprland 0.55+ Lua config entry point

-- Default configs (may be replaced on upstream JaKooLit update)
require("configs.settings")
require("configs.keybinds")

-- User configs (safe to edit)
require("UserConfigs.startup_apps")
require("UserConfigs.envariables")
require("UserConfigs.monitors")
require("UserConfigs.laptops")
require("UserConfigs.laptop_display")
require("UserConfigs.window_rules")
require("UserConfigs.user_decor_animations")
require("UserConfigs.user_keybinds")
require("UserConfigs.user_settings")
require("UserConfigs.workspace_rules")
