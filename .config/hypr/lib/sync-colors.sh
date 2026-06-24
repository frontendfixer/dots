#!/usr/bin/env bash
# Regenerate derived palette files from lib/colors.lua
set -euo pipefail

LIB="${HOME}/.config/hypr/lib"
ROFI_COLORS="${HOME}/.config/rofi/colors-rofi.rasi"

lua <<'LUA'
local home = os.getenv("HOME")
local lib = home .. "/.config/hypr/lib/"
local colors = dofile(lib .. "colors.lua")

local order = {
    "background", "foreground",
    "color0", "color1", "color2", "color3", "color4", "color5",
    "color6", "color7", "color8", "color9", "color10", "color11",
    "color12", "color13", "color14", "color15",
}

local function rgb_hex(value)
    local hex = value:match("^rgb%((%x+)%)$")
    if not hex then
        error("invalid rgb(): " .. value)
    end
    return "#" .. hex
end

local function rgb_triplet(value)
    local hex = value:match("^rgb%((%x+)%)$")
    if not hex or #hex ~= 6 then
        error("invalid rgb(): " .. value)
    end
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local header = "-- Auto-generated from colors.lua — do not edit\n"

-- hyprlock / hyprlang
local conf = { header:gsub("^%-%-", "#") }
table.insert(conf, "# Run: ~/.config/hypr/lib/sync-colors.sh")
for _, key in ipairs(order) do
    local raw = colors[key]:match("^rgb%((%x+)%)$")
    table.insert(conf, string.format("$%s = rgb(%s)", key, raw))
end
local f = io.open(lib .. "colors.conf", "w")
f:write(table.concat(conf, "\n") .. "\n")
f:close()

-- GTK CSS (waybar, wlogout, ags)
local css = {
    "/* Auto-generated from colors.lua — do not edit */",
    "/* Run: ~/.config/hypr/lib/sync-colors.sh */",
    "",
}
for _, key in ipairs(order) do
    table.insert(css, string.format("@define-color %s %s;", key, rgb_hex(colors[key])))
end
table.insert(css, "")
table.insert(css, "/* semantic aliases */")
table.insert(css, "@define-color accent @color12;")
table.insert(css, "@define-color highlight @color13;")
table.insert(css, "@define-color urgent @color11;")
table.insert(css, "@define-color surface @color0;")
table.insert(css, "@define-color surface-alt @color1;")
table.insert(css, "@define-color muted @color8;")
f = io.open(lib .. "colors.css", "w")
f:write(table.concat(css, "\n") .. "\n")
f:close()

-- rofi
local bg = rgb_hex(colors.background)
local fg = rgb_hex(colors.foreground)
local c = {}
for i = 0, 15 do
    c[i] = rgb_hex(colors["color" .. i])
end

local r, g, b = rgb_triplet(colors.background)
local rofi = {
    "/* Auto-generated from colors.lua — do not edit */",
    "/* Run: ~/.config/hypr/lib/sync-colors.sh */",
    "",
    "* {",
    string.format("    background: %s;", bg),
    string.format("    foreground: %s;", fg),
    string.format("    background-color: %s;", bg),
    string.format("    border-color: %s;", c[12]),
    "",
    string.format("    active-background: %s;", c[12]),
    string.format("    active-foreground: %s;", fg),
    string.format("    normal-background: %s;", bg),
    string.format("    normal-foreground: %s;", fg),
    string.format("    urgent-background: %s;", c[13]),
    string.format("    urgent-foreground: %s;", fg),
    "",
    string.format("    alternate-active-background: %s;", c[11]),
    string.format("    alternate-active-foreground: %s;", fg),
    string.format("    alternate-normal-background: %s;", bg),
    string.format("    alternate-normal-foreground: %s;", fg),
    string.format("    alternate-urgent-background: %s;", bg),
    string.format("    alternate-urgent-foreground: %s;", fg),
    "",
    string.format("    selected-active-background: %s;", c[12]),
    string.format("    selected-active-foreground: %s;", bg),
    string.format("    selected-normal-background: %s;", c[12]),
    string.format("    selected-normal-foreground: %s;", bg),
    string.format("    selected-urgent-background: %s;", c[11]),
    string.format("    selected-urgent-foreground: %s;", bg),
    "",
}
for i = 0, 15 do
    table.insert(rofi, string.format("    color%d: %s;", i, c[i]))
end
table.insert(rofi, "}")
table.insert(rofi, "")

local rofi_text = table.concat(rofi, "\n")
f = io.open(lib .. "colors-rofi.rasi", "w")
f:write(rofi_text)
f:close()

local rofi_compat = home .. "/.config/rofi/colors-rofi.rasi"
local rofi_dir = home .. "/.config/rofi"
os.execute("mkdir -p '" .. rofi_dir:gsub("'", "'\\''") .. "'")
f = io.open(rofi_compat, "w")
if f then
    f:write(rofi_text)
    f:close()
end

print("Generated:")
print("  " .. lib .. "colors.conf")
print("  " .. lib .. "colors.css")
print("  " .. lib .. "colors-rofi.rasi")
if f then
    print("  " .. rofi_compat)
end
LUA
