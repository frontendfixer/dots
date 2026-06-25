from libqtile import layout, hook
from libqtile.config import Match

##########################
######    Colors   #######
##########################
from colors import colors, backgroundColor


################################
###### Layout Customizing ######
################################

layout_theme = {
    "border_width": 1,
    "margin": 4,
    "border_focus": colors[9],
    "border_normal": backgroundColor,
}
layouts = [
    layout.Bsp(name="bsp", **layout_theme),
    layout.MonadTall(
        max_ratio=0.75,
        min_ratio=0.35,
        new_client_position="bottom",
        **layout_theme,
    ),
    layout.Max(**layout_theme),
]

###################################
######## Floating Windows #########
###################################
# default_float_rules already floats wm_type dialog/utility/notification and
# fixed-size windows. Custom rules below add Fedora/dotfile apps and browser
# PiP; transient children float via is_transient_for (auth, downloads, etc.)
# without floating main browser/editor windows.

float_rules = [
    *layout.Floating.default_float_rules,
    # Transient dialogs (browser auth, downloads, app sub-dialogs)
    Match(func=lambda c: bool(c.is_transient_for())),
    # --- Browsers (popups & PiP only; main windows stay tiled) ---
    Match(title="Picture-in-Picture"),
    Match(wm_class="Firefox", wm_type="utility"),
    Match(wm_class="firefox", wm_type="utility"),
    Match(wm_class="Helium", wm_type="utility"),
    Match(wm_class="helium", wm_type="utility"),
    Match(wm_class="helium-browser", wm_type="utility"),
    Match(wm_class="Toolkit"),  # Chromium extension popups
    # --- Editors / IDEs ---
    Match(wm_class="VSCodium", title="Add Folder to Workspace"),
    Match(wm_class="codium", title="Add Folder to Workspace"),
    Match(wm_class="code-oss", title="Add Folder to Workspace"),
    Match(wm_class="codium-url-handler"),
    Match(wm_class="code-url-handler"),
    Match(wm_class="VSCodium-url-handler"),
    Match(wm_class="Code", wm_type="dialog"),
    # --- Launchers & screenshots ---
    Match(wm_class="Rofi"),
    Match(wm_class="rofi"),
    Match(wm_class="dmenu"),
    Match(wm_class="flameshot"),
    Match(wm_class="Flameshot"),
    # --- Network / audio / bluetooth ---
    Match(wm_class="Blueman-manager"),
    Match(wm_class="nm-applet"),
    Match(wm_class="nm-connection-editor"),
    Match(wm_class="Pavucontrol"),
    # --- File managers & archives ---
    Match(wm_class="Thunar", title="File Operation Progress"),
    Match(wm_class="Thunar", title="Confirm to replace files"),
    Match(wm_class="thunar", title="File Operation Progress"),
    Match(wm_class="thunar", title="Confirm to replace files"),
    Match(wm_class="file-roller"),
    Match(wm_class="Engrampa"),
    Match(wm_class="Xarchiver"),
    # --- System / settings / security ---
    Match(wm_class="Lxappearance"),
    Match(wm_class="GParted"),
    Match(wm_class="Synaptic"),
    Match(wm_class="Xfce4-power-manager-settings"),
    Match(wm_class="xdg-desktop-portal-gtk"),
    Match(wm_class="Xdg-desktop-portal-gtk"),
    Match(wm_class="polkit-gnome-authentication-agent-1"),
    Match(wm_class="Xfce4-appfinder"),
    Match(title="pinentry"),
    Match(wm_class="ssh-askpass"),
    # --- Utilities (Fedora install / dotfiles) ---
    Match(wm_class="Galculator"),
    Match(wm_class="Yad"),
    Match(wm_class="zenity"),
    Match(wm_class="Eog"),
    Match(wm_class="Mousepad"),
    Match(wm_class="meld"),
    Match(wm_class="Meld"),
    Match(wm_class="transmission-gtk"),
    Match(wm_class="Transmission-gtk"),
    Match(wm_class="VirtualBox Manager"),
    Match(wm_class="VirtualBox"),
    Match(wm_class="Nitrogen"),
    Match(wm_class="gcolor2"),
    Match(wm_class="gcolor3"),
    Match(wm_class="copyq"),
    Match(wm_class="TelegramDesktop"),
    # --- Legacy / shared ---
    Match(title="Confirm File Replacing"),
    Match(wm_class="confirmreset"),
    Match(wm_class="makebranch"),
    Match(wm_class="maketag"),
    Match(title="branchdialog"),
    Match(wm_class="floating"),
    Match(wm_class="Xreader"),
    Match(wm_class="Gedit"),
    Match(wm_class="Grub Customize"),
    Match(wm_class="Xed"),
    Match(wm_class="audacious"),
    Match(wm_class="crx_hpfldicfbfomlpcikngkocigghgafkph"),
    Match(role="GtkFileChooserDialog"),
    Match(role="pop-up"),
    Match(role="AlarmWindow"),
    Match(role="ConfigManager"),
]

floating_layout = layout.Floating(
    float_rules=float_rules,
    border_width=2,
    border_focus=colors[9],
    border_normal=backgroundColor,
)


def _screen_geometry(window):
    s = window.screen
    return s.x, s.y, s.width, s.height


def _center_floating(window, width, height):
    sx, sy, sw, sh = _screen_geometry(window)
    window.cmd_set_size_floating(width, height)
    window.cmd_set_position_floating(sx + (sw - width) // 2, sy + (sh - height) // 2)


@hook.subscribe.client_managed
def configure_floating_ui(window):
    """Size/place floated dialogs; Qtile already centers unmatched floaters."""
    if not window.floating:
        return

    info = window.cmd_inspect()
    title = info.get("name") or ""
    role = info.get("role") or ""
    wm_class = info.get("wm_class")
    if isinstance(wm_class, (list, tuple)):
        wm_class = wm_class[0] if wm_class else ""
    wm_class = wm_class or ""

    sx, sy, sw, sh = _screen_geometry(window)

    # Browser PiP — bottom-right (matches Hypr placement intent)
    if title == "Picture-in-Picture":
        w = max(320, int(sw * 0.26))
        h = int(w * 9 / 16)
        window.cmd_set_size_floating(w, h)
        window.cmd_set_position_floating(sx + sw - w - 16, sy + sh - h - 56)
        return

    # Large file picker / portal
    if role == "GtkFileChooserDialog" or wm_class in (
        "xdg-desktop-portal-gtk",
        "Xdg-desktop-portal-gtk",
    ):
        _center_floating(window, int(sw * 0.55), int(sh * 0.75))
        return

    # Audio / Bluetooth manager panels
    if wm_class == "Pavucontrol":
        if "Bluetooth" in title:
            _center_floating(window, int(sw * 0.35), int(sh * 0.45))
        else:
            _center_floating(window, int(sw * 0.4), int(sh * 0.55))
        return

    # Archive / disk tools
    if wm_class in ("file-roller", "Engrampa", "GParted"):
        _center_floating(window, int(sw * 0.5), int(sh * 0.65))
        return

    # Small calculators / pickers
    if wm_class in ("Galculator", "gcolor2", "gcolor3", "Yad", "zenity"):
        _center_floating(window, min(400, int(sw * 0.35)), min(500, int(sh * 0.5)))
        return
