-- Decoration and Animations Settings
local colors = require("lib.colors")

hl.config({
  decoration = {
    rounding = 8,
    active_opacity = 1,
    inactive_opacity = 0.90,
    fullscreen_opacity = 1.0,
    dim_inactive = true,
    dim_strength = 0.1,
    dim_special = 0.8,
    shadow = {
      enabled = false,
      range = 2,
      render_power = 1,
      color = colors.color12,
      color_inactive = colors.color2,
    },
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
      ignore_opacity = true,
      new_optimizations = true,
      special = true,
    },
  },
})

hl.config({
  animations = {
    enabled = true,
  },
})

-- Ease-out beziers: fast, no overshoot
hl.curve("elegant", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 6, bezier = "elegant" })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "elegant", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, bezier = "elegant", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "elegant", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 8, bezier = "elegant", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 7, bezier = "elegant", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7, bezier = "elegant", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "elegant", style = "slide 15%" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 6, bezier = "elegant", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 6, bezier = "elegant", style = "slide bottom" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "liner" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "elegant" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "liner", style = "loop" })
