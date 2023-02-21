from libqtile import hook
from libqtile.config import Group, Key
from libqtile.lazy import lazy
from var import *

import keys
keys = keys.keybinding()

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

@hook.subscribe.client_new
def client_new(client):
    if client.name == 'kitty':
        client.togroup(1)
   