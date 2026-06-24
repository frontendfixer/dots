local home = os.getenv("HOME")

return {
    home = home,
    scripts = home .. "/.config/hypr/scripts",
    userConfigs = home .. "/.config/hypr/user-configs",
}
