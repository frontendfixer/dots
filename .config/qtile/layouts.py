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
    "margin": 2,
    "border_focus": colors[9],
    "border_normal": backgroundColor,
}
layouts = [
    layout.Bsp(name="bsp", **layout_theme),
    # layout.Columns(**layout_theme),
    # layout.MonadTall(
    #    align = 'MonadTall._left',
    #    ratio = 0.42,
    #    new_client_position = 'bottom',
    #    **layout_theme),
    layout.Max(**layout_theme),
    # layout.Floating(
    #        border_width = 2,
    #        border_focus=colors[9],
    #        border_normal= backgroundColor
    # )
]

###################################
######## Floating Windows #########
###################################
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(title="Confirm File Replacing"),
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="file-roller"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="floating"),
        Match(wm_class="Blueman-manager"),
        Match(wm_class="Galculator"),
        Match(wm_class="GParted"),
        Match(wm_class="Lxappearance"),
        Match(wm_class="Nitrogen"),
        Match(wm_class="Xarchiver"),
        Match(wm_class="TelegramDesktop"),
        Match(wm_class="Eog"),
        Match(wm_class="Xreader"),
        Match(wm_class="Engrampa"),
        Match(wm_class="Mousepad"),
        Match(wm_class="Gedit"),
        Match(wm_class="gcolor2"),
        Match(wm_class="Grub Customize"),
        Match(wm_class="Xed"),
        Match(wm_class="Pavucontrol"),
        Match(wm_class="audacious"),
        Match(wm_class="Xfce4-power-manager-settings"),
        Match(role="GtkFileChooserDialog"),
    ],
    border_width=2,
    border_focus=colors[9],
    border_normal=backgroundColor,
)


@hook.subscribe.client_new
def center_floating_win(window):
    role = window.cmd_inspect()["role"]
    if role == "GtkFileChooserDialog":
        window.toggle_floating()
        window.cmd_set_size_floating(301, 227)
        window.cmd_set_position_floating((1366 - 301) // 2, (768 - 227) // 2)
