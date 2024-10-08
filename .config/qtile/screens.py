from libqtile.config import Screen
from libqtile.lazy import lazy
from libqtile import qtile, bar, widget
from var import terminal
from qtile_extras import widget

from powermenu import show_power_menu

##########################
######    Colors   #######
##########################
from colors import colors, backgroundColor, foregroundColor, workspaceColor

###################################
##### DEFAULT WIDGET SETTINGS #####
###################################
widget_defaults = dict(
    font="Hack Nerd Font",
    fontsize=12,
    padding=4,
    background=backgroundColor,
)
extension_defaults = widget_defaults.copy()

fonts = {"font": "Hack Nerd Font SemiBold", "fontsize": 13, "padding": 4}

fonts_large = {
    "font": "Hack Nerd Font Bold",
    "fontsize": 16,
    "padding": 8,
}

top_bar = [
    widget.TextBox(
        text="",
        width=36,
        background="#ff5555",
        foreground=backgroundColor,
        padding=8,
        font="Hack Nerd Font Bold",
        fontsize=20,
        mouse_callbacks={
            "Button1": lazy.spawn(
                "rofi -modi drun -show drun -config ~/.config/rofi/panel.rasi"
            )
        },
    ),
    # widget.CurrentLayoutIcon(
    #   background = backgroundColor,
    #   scale = 0.7,
    #   use_mask = True,
    #  foreground = colors[7]
    # ),
    widget.GroupBox(
        hide_unused=True,
        highlight_method="block",
        highlight_color=[backgroundColor, workspaceColor],
        this_current_screen_border=workspaceColor,
        block_highlight_text_color=foregroundColor,
        foreground=workspaceColor,
        urgent_border=colors[9],
        urgent_text=foregroundColor,
        borderwidth=0,
        **fonts_large,
    ),
    widget.Sep(
        linewidth=0,
        padding=8,
        background=backgroundColor,
    ),
    widget.TextBox(
        text="∷",
        width=20,
        background=backgroundColor,
        foreground=colors[4],
        padding=0,
        margin=-5,
        fontsize=18,
    ),
    widget.TextBox("❱", foreground=foregroundColor, background=colors[4], name="icon"),
    widget.WindowName(
        max_chars=60,
        foreground=foregroundColor,
        background=colors[4],
        **fonts,
    ),
    widget.Sep(
        linewidth=0,
        padding=8,
        background=backgroundColor,
    ),
    widget.TextBox(
        text="∷",
        width=20,
        background=backgroundColor,
        foreground=colors[4],
        padding=0,
        margin=-5,
        fontsize=18,
    ),
    widget.Sep(
        linewidth=0,
        padding=8,
        background=colors[9],
    ),
    widget.TextBox(
        text="",
        width=22,
        background=colors[9],
        foreground=foregroundColor,
        padding=0,
        fontsize=18,
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(terminal + " -e htop")},
    ),
    widget.CPU(
        background=colors[9],
        foreground=foregroundColor,
        format="{load_percent}%",
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(terminal + " -e htop")},
        **fonts,
    ),
    widget.Sep(linewidth=0, padding=8, background=colors[9]),
    widget.TextBox(
        text=" ",
        width=24,
        padding=0,
        fontsize=18,
        foreground=foregroundColor,
        background=colors[8],
    ),
    widget.Net(
        background=colors[8],
        foreground=foregroundColor,
        format=" {down} ",
        prefix="k",
        **fonts,
    ),    
    widget.Sep(
        linewidth=0,
        padding=6,
        background=colors[10],
        foreground=foregroundColor,
    ),
    widget.TextBox(
        text="󰕾",
        width=22,
        foreground=foregroundColor,
        background=colors[10],
        padding=4,
        fontsize=18,
        mouse_callbacks={"Button1": lazy.spawn("pavucontrol")},
    ),
    widget.Volume(background=colors[10], foreground=foregroundColor, **fonts),
    widget.Sep(
        linewidth=0,
        padding=6,
        background=colors[10],
        foreground=foregroundColor,
    ),
    widget.Systray(background=colors[1], padding=5),
    widget.Sep(
        linewidth=0,
        padding=6,
        background=colors[1],
    ),
    widget.Sep(
        linewidth=0,
        padding=8,
        background=colors[7],
    ),
    widget.TextBox(
        text="",
        width=22,
        foreground=foregroundColor,
        background=colors[7],
        padding=4,
        fontsize=18,
    ),
    widget.Clock(
        foreground=foregroundColor,
        background=colors[7],
        format="%I:%M %p ",
        mouse_callbacks={
            "Button1": lazy.spawn(
                'yad --calendar --undecorated --close-on-unfocus --no-buttons --posx=-10 --posy=30 --text=" Yad Calendar"'
            )
        },
        **fonts,
    ),
    widget.TextBox(
        text="",
        width=27,
        foreground=foregroundColor,
        background="#ff5555",
        padding=6,
        fontsize=20,
        mouse_callbacks={"Button1": lazy.function(show_power_menu)},
    ),
    widget.Sep(
        linewidth=0,
        padding=6,
        background="#ff5555",
    ),
]

screens = [
    Screen(
        top=bar.Bar(
            top_bar,
            24,
        ),
    ),
]
