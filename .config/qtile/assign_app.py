from libqtile import hook


@hook.subscribe.client_new
def assign_app_group(client):
    d = {}
    #########################################################
    ################ assign apps to groups ##################
    #########################################################
    d["1"] = ["kitty", "Alacritty"]
    d["2"] = ["thunar", "pcmanfm"]  # File Manager
    d["3"] = [
        "Navigator",
        "chromium",
        "chromium-browser",
        "brave-browser",
        "qutebrowser",
    ]  # Web Browsers
    d["4"] = ["code", "vscodium", "Sublime-text"]  # Code Editor
    d["5"] = ["figma-linux", "gimp-2.10", "Inkscape", "org.inkscape.Inkscape"]
    d["6"] = ["vlc", "libreoffice"]  # media
    d["7"] = [
        "",
    ]  #
    d["8"] = [
        "VirtualBox Manager",
    ]  # Virtualbox
    d["9"] = [
        "",
    ]
    d["0"] = [
        "meld",
    ]
    ##########################################################
    wm_class = client.window.get_wm_class()[0]

    for i in range(len(d)):
        if wm_class in list(d.values())[i]:
            group = list(d.keys())[i]
            client.togroup(group)
            client.group.cmd_toscreen(toggle=False)
