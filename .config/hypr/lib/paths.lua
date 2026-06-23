local home = os.getenv("HOME")

return {
    home = home,
    scripts = home .. "/.config/hypr/scripts",
    userScripts = home .. "/.config/hypr/UserScripts",
    userConfigs = home .. "/.config/hypr/UserConfigs",
    wallpapers = home .. "/Pictures/wallpapers",
}
