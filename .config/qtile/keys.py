from libqtile.config import Group, Click, Drag, ScratchPad, DropDown, Key
from libqtile.lazy import lazy
from powermenu import show_power_menu

from var import *


def keybinding():
    keys = [
        ########### The essentials
        Key([mod], "Return", lazy.spawn(terminal)),
        Key([mod], "e", lazy.spawn(file)),
        Key([mod], "b", lazy.spawn(myBrowser)),
        Key([mod], "c", lazy.spawn(codeEditor)),
        ########## Applications
        Key([mod, "shift"], "w", lazy.spawn(broswer_alt)),
        Key([mod, "shift"], "c", lazy.spawn("galculator")),
        Key([mod, "shift"], "g", lazy.spawn("gcolor3")),
        ########### Dmenu and Rofi
        Key(
            [mod, "shift"],
            "Return",
            lazy.spawn(
                "dmenu_run -nb '#1a1e1e' -sf '#212128' -sb '#f24054' -nf '#00e5ff' -p 'Run: '"
            ),
        ),
        Key(
            [mod],
            "p",
            lazy.spawn(
                "rofi -modi drun -show drun -config ~/.config/rofi/col_singlerow.rasi"
            ),
        ),
        Key(
            ["control", "shift"],
            "space",
            lazy.spawn(
                "rofimoji --prompt='Emoji' --selector-args='-theme /home/lakshmi/.config/rofi/emoji-selector.rasi' --hidden-descriptions"
            ),
        ),
        ########### Scripts
        Key([mod, "shift"], "l", lazy.spawn("betterlockscreen -l dimblur")),
        # Key([mod, "shift"], "e", lazy.spawn("sh /home/lakshmi/.config/qtile/scripts/powermenu")),
        # Key([mod, "shift"], "e", lazy.spawn("rofi -show power-menu -modi power-menu:/home/lakshmi/.config/qtile/scripts/rofi-power-menu -config ~/.config/qtile/scripts/powermenu.rasi")),
        Key([mod, "shift"], "e", lazy.function(show_power_menu)),
        ############ Switch between windows
        Key([mod], "Left", lazy.layout.left()),
        Key([mod], "Right", lazy.layout.right()),
        Key([mod], "Down", lazy.layout.down()),
        Key([mod], "Up", lazy.layout.up()),
        Key([mod], "space", lazy.layout.next()),
        ########### Move windows
        Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
        Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),
        Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
        Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
        ########## Grow windows.
        Key([mod, "control"], "Left", lazy.layout.grow_left(), resize_left),
        Key([mod, "control"], "Right", lazy.layout.grow_right(), resize_right),
        Key([mod, "control"], "Down", lazy.layout.grow_down(), resize_down),
        Key([mod, "control"], "Up", lazy.layout.grow_up(), resize_up),
        ######################
        Key([mod], "Escape", lazy.layout.normalize()),
        # -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
        ########### Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key([mod, "shift"], "s", lazy.layout.toggle_split()),
        Key([mod, "shift"], "space", lazy.window.toggle_floating()),
        # Key([mod], "F11", lazy.window.toggle_fullscreen()),
        ########### Toggle between different layouts as defined below
        Key([mod], "BackSpace", lazy.next_layout()),
        Key([mod], "q", lazy.window.kill()),
        Key([mod, "control"], "r", lazy.reload_config()),
        Key([mod, "control"], "End", lazy.shutdown()),
        ########### Multimedia Keys
        Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5")),
        Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5")),
        Key([], "XF86AudioMute", lazy.spawn("pamixer -t")),
        Key(
            [mod],
            "insert",
            lazy.spawn("scrot /home/lakshmi/Pictures/%Y-%m-%d-%T-scr.png"),
        ),
    ]

    groups = [Group(i) for i in "123456789"]
    for i in groups:
        keys.extend(
            [
                # mod1 + letter of group = switch to group
                Key(
                    [mod],
                    i.name,
                    lazy.group[i.name].toscreen(),
                    desc="Switch to group {}".format(i.name),
                ),
                # mod1 + shift + letter of group = switch to & move focused window to group
                Key(
                    [mod, "shift"],
                    i.name,
                    lazy.window.togroup(i.name, switch_group=True),
                    desc="Switch to & move focused window to group {}".format(i.name),
                ),
            ]
        )

    return keys


mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


# BSP resizing taken from https://github.com/qtile/qtile/issues/1402
def resize(qtile, direction):
    layout = qtile.current_layout
    child = layout.current
    parent = child.parent

    while parent:
        if child in parent.children:
            layout_all = False

            if (direction == "left" and parent.split_horizontal) or (
                direction == "up" and not parent.split_horizontal
            ):
                parent.split_ratio = max(5, parent.split_ratio - layout.grow_amount)
                layout_all = True
            elif (direction == "right" and parent.split_horizontal) or (
                direction == "down" and not parent.split_horizontal
            ):
                parent.split_ratio = min(95, parent.split_ratio + layout.grow_amount)
                layout_all = True

            if layout_all:
                layout.group.layout_all()
                break

        child = parent
        parent = child.parent


@lazy.function
def resize_left(qtile):
    resize(qtile, "left")


@lazy.function
def resize_right(qtile):
    resize(qtile, "right")


@lazy.function
def resize_up(qtile):
    resize(qtile, "up")


@lazy.function
def resize_down(qtile):
    resize(qtile, "down")


@lazy.function
def float_to_front(qtile):
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.cmd_bring_to_front()
