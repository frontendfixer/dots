
###############################
#### Importing all Modules ####
###############################
import os
import subprocess
from libqtile import hook

from var import *
from assign_app import assign_app_group
from keys import keybinding, mouse
from layouts import layouts, floating_layout
from workspace import *
from screens import screens

from extras import *

##################################
######## Autostart Apps ##########
##################################
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

wmname = "LG3D"
