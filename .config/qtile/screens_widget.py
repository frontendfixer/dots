from libqtile.config import Screen
from libqtile import bar

from powermenu import show_power_menu
from widget import main_widgets


def status_bar(widgets):
    return bar.Bar(widgets, 24, opacity=0.92)


screens = [
    Screen(top=status_bar(main_widgets)),
]
