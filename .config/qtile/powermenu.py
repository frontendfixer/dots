from colors import colors
from qtile_extras.popup.toolkit import PopupAbsoluteLayout, PopupImage, PopupText

# from libqtile import qtile
from libqtile.lazy import lazy


def show_power_menu(qtile):
    config_img = {
        "width": 64,
        "height": 64,
        "highlight_method": "border",
        "highlight_border": 2,
    }
    config_txt = {
        "width": 80,
        "height": 20,
        "font": "Hack Nerd Font",
        "fontsize": 14,
        "foreground": colors[0],
        "h_align": "center",
    }
    controls = [
        # ======== Lock Method ========
        PopupImage(
            filename="~/.config/qtile/icons/lock.svg",
            pos_x=25,
            pos_y=20,
            highlight=colors[4],
            mouse_callbacks={"Button1": lazy.spawn("xscreensaver-command -lock")},
            **config_img,
        ),
        PopupText(
            text="Lock",
            pos_x=15,
            pos_y=100,
            background=colors[3],
            **config_txt,
        ),
        # ======== Sleep Method ========
        PopupImage(
            filename="~/.config/qtile/icons/sleep.svg",
            pos_x=115,
            pos_y=20,
            highlight=colors[8],
            mouse_callbacks={"Button1": lazy.spawn("systemctl suspend")},
            **config_img,
        ),
        PopupText(
            text="Sleep",
            pos_x=105,
            pos_y=100,
            background=colors[10],
            **config_txt,
        ),
        # ======== Restart Method ========
        PopupImage(
            filename="~/.config/qtile/icons/restart.svg",
            pos_x=205,
            pos_y=20,
            highlight=colors[9],
            mouse_callbacks={"Button1": lazy.spawn("systemctl reboot")},
            **config_img,
        ),
        PopupText(
            text="Restart",
            pos_x=195,
            pos_y=100,
            background=colors[4],
            **config_txt,
        ),
        # ======== Shutdown Method ========
        PopupImage(
            filename="~/.config/qtile/icons/shutdown.svg",
            pos_x=295,
            pos_y=20,
            highlight=colors[10],
            mouse_callbacks={"Button1": lazy.spawn("systemctl poweroff")},
            **config_img,
        ),
        PopupText(
            text="Shutdown",
            pos_x=285,
            pos_y=100,
            background=colors[9],
            **config_txt,
        ),
        # ======== Logout Method ========
        PopupImage(
            filename="~/.config/qtile/icons/logout.svg",
            pos_x=385,
            pos_y=20,
            highlight=colors[5],
            mouse_callbacks={"Button1": lazy.shutdown()},
            **config_img,
        ),
        PopupText(
            text="Logout",
            pos_x=375,
            pos_y=100,
            background=colors[6],
            **config_txt,
        ),
    ]

    layout = PopupAbsoluteLayout(
        qtile,
        pos_x=0.9,
        pos_y=0.1,
        width=480,
        height=130,
        controls=controls,
        initial_focus=3,
        background="6f6f6f99",
        margin=10,
        keymap={
            "close": ["Escape"],
            "up": ["Up"],
            "down": ["Down"],
            "left": ["Left"],
            "right": ["Right"],
            "select": ["Return", "space"],
            "step": ["Tab"],
        },
    )

    layout.show(centered=True)
