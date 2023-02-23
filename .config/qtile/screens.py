from libqtile.config import Screen
from libqtile.lazy import lazy
from libqtile import qtile, bar, widget
from var import terminal
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

from powermenu import show_power_menu

##########################
######    Colors   #######
##########################
from colors import colors, backgroundColor, foregroundColor, workspaceColor

###################################
##### DEFAULT WIDGET SETTINGS #####
###################################
widget_defaults = dict(
    font="FiraCode Nerd Font",
    fontsize=12,
    padding=5,
    background = backgroundColor,
)
extension_defaults = widget_defaults.copy()

decor = {
    "decorations": [
        RectDecoration(colour='#fff555', radius=0, filled=False, padding_y=0)
    ],
    "padding": 10,
}

fonts = {
    "font":"Cascadia Code",
    "fontsize":13,
    "padding": 4
}

fonts_large ={
    "font": "Cascadia Code",
    "fontsize": 16,
    "padding": 8,
}

top_bar = [
       widget.TextBox(
           text = "",
           width=30,
           background = '#ff5555',
           foreground = backgroundColor,
           padding = 8,
           margin = 5,
           fontsize = 20,
           mouse_callbacks={"Button1": lazy.spawn("rofi -modi drun -show drun -config ~/.config/rofi/panel.rasi")},
       ),
       #widget.CurrentLayoutIcon(
        #   background = backgroundColor,
        #   scale = 0.7,
        #   use_mask = True,
        #  foreground = colors[7]
       #),
       widget.GroupBox(
           hide_unused = True,
           highlight_method='block',
           highlight_color = [backgroundColor, workspaceColor],
           this_current_screen_border = workspaceColor,
           block_highlight_text_color = foregroundColor,
           foreground = workspaceColor,                    
           urgent_border = colors[9],                    
           urgent_text = foregroundColor,
           borderwidth = 0,
        **fonts_large,
       ),
       widget.Sep(
              linewidth = 0,
              padding = 8,
              background = backgroundColor,
       ),
       widget.TextBox(
              text = "∷",
              width=20,
              background = backgroundColor,
              foreground = colors[4],
              padding = 0,
              margin = -5,
              fontsize = 20
              ),
       widget.TextBox(
           "❱",
           foreground = foregroundColor , 
           background = colors[4],
           name="icon"
       ),
       widget.WindowName(
           max_chars = 60,
           foreground = foregroundColor,
           background = colors[4],
        **fonts,
       ),
       widget.Sep(
              linewidth = 0,
              padding = 8,
              background = backgroundColor,
       ),
       widget.TextBox(
              text = "∷",
              width=20,
              background = backgroundColor,
              foreground = colors[4],
              padding = 0,
              margin = -5,
              fontsize = 20
              ), 
       widget.Sep(
              linewidth = 0,
              padding = 8,
              background = colors[9],
       ),               
       widget.TextBox(
              text = " ",
              width=22,
              background = colors[9],
              foreground = foregroundColor,
              padding = 0,
              fontsize = 30,
              mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e htop')},
              ),
       widget.CPU(
           background = colors[9],
           foreground = foregroundColor,
           format = '{load_percent}%',
           mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e htop')},
        **fonts
       ),
       widget.Sep(
              linewidth = 0,
              padding = 6,
              foreground = foregroundColor,
              background = colors[9]
       ),
       widget.TextBox(
        text = "",
        width = 16,
        foreground = foregroundColor,
        background = colors[8],
        fontsize = 16
        ),
       widget.Net(
           background = colors[8],
           foreground = foregroundColor,
           format='{down}',
           prefix='k',
        **fonts
       ),
       widget.Sep(
              linewidth = 0,
              padding = 6,
              background = colors[5],
              foreground = foregroundColor,
       ),
       widget.TextBox(
              text = "󱓞",
              width=22,
              background = colors[5],
              foreground = foregroundColor,
              padding = 0,
              fontsize = 24
              ),
       widget.Battery(
           background = colors[5],
           foreground = foregroundColor,
           low_background = colors[9],
           low_foreground = foregroundColor,
           low_percentage = 0.2,
           format ='{percent:2.0%}',
           update_interval = 5,  
        **fonts
       ), widget.Sep(
              linewidth = 0,
              padding = 6,
              background = colors[5],
              foreground = foregroundColor,
       ),

       widget.Sep(
              linewidth = 0,
              padding = 6,
              background = colors[6],
              foreground = foregroundColor,
       ),
       widget.TextBox(
              text = "",
              width=22,
              background = colors[6],
              foreground = foregroundColor,
              padding = 0,
              fontsize = 30,
              mouse_callbacks = {
               'Button4': lambda: qtile.cmd_spawn('brightnessctl set +5%'),'Button5': lambda: qtile.cmd_spawn('brightnessctl set 5%-')
               },
              ),
       widget.Backlight(
           background = colors[6],
           foreground = foregroundColor,
           backlight_name = "intel_backlight",
           # brightness_file = '/sys/class/backlight/intel_backlight/brightness',
           # max_brightness_file = '/sys/class/backlight/intel_backlight/max_brightness',
           format = '{percent:2.0%}',
           mouse_callbacks = {
               'Button4': lambda: qtile.cmd_spawn('brightnessctl set +5%'),'Button5': lambda: qtile.cmd_spawn('brightnessctl set 5%-')
           },
        **fonts
       ),
       widget.Sep(
              linewidth = 0,
              padding = 6,
              background = colors[10],
              foreground = foregroundColor,
       ),
       widget.TextBox(
              text = "",
              width = 22,
              foreground = foregroundColor,
              background = colors[10],
              padding = 0,
              fontsize = 30,
              mouse_callbacks={"Button1": lazy.spawn("pavucontrol")},
              ),
       widget.Volume(
           background = colors[10],
           foreground = foregroundColor,
        **fonts
       ),
       widget.Sep(
              linewidth = 0,
              padding = 6,
              background = colors[10],
              foreground = foregroundColor,
       ),
       widget.Systray(
           background = colors[1],
              padding = 5                        
       ), widget.Sep(
              linewidth = 0,
              padding = 6,
              background = colors[1],
       ),
       widget.Sep(
              linewidth = 0,
              padding = 6,
              background = colors[7],
              foreground = foregroundColor,
       ),
       widget.Clock(
           foreground = foregroundColor,
           background = colors[7],
           format = "%I:%M %p ",
        **fonts_large
       ),
       widget.TextBox(
       	text = "⏻",
         width = 30,
         foreground = foregroundColor,
         background = '#ff5555',
         padding = 10,
         fontsize = 22,
         mouse_callbacks={"Button1": lazy.function(show_power_menu)},    
       ),
       widget.Sep(
              linewidth = 0,
              padding = 6,
              background = '#ff5555',
       ),
]

screens = [
    Screen(
        top=bar.Bar( top_bar,24,),
    ),
]
