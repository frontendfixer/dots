
--	████████╗██╗  ██╗███████╗███╗   ███╗███████╗
--	╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--	   ██║   ███████║█████╗  ██╔████╔██║█████╗  
--	   ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
--	   ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--	   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝                    

local gears = require("gears")

local theme_assets = require("beautiful.theme_assets")
local dpi = require("beautiful.xresources").apply_dpi

local gfs = require("gears.filesystem")
local home_config_dir = gfs.get_xdg_config_home()
local themes_path = home_config_dir .. "awesome/themes/"


local colors = require("themes.colors")
local fonts = require("themes.fonts")
local bar = require("themes.menubar")

local menubar_height =dpi(24)
local menubar_width = dpi(180)
local gap = 4
local border_width = 1

local theme = {}

-- ########## Settings ############
theme.useless_gap = gap
theme.wallpaper = themes_path .. "default_wall.jpg"
theme.font = fonts.regular
theme.taglist_font = fonts.bold_big

theme.bg_normal = colors.bg
theme.bg_focus = colors.primary
theme.bg_urgent = colors.red
theme.bg_minimize = colors.gray

theme.fg_normal = colors.fg
theme.fg_minimize = colors.fg
theme.fg_focus = colors.dark
theme.fg_urgent = colors.dark


theme.border_width = border_width
theme.border_normal = colors.bg
theme.border_focus = colors.primary
theme.border_marked = colors.red

-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- ########## Taglist ############
theme.taglist_bg_focus = colors.primary
theme.taglist_bg_urgent = colors.red
theme.taglist_bg_occupied = colors.gray
theme.taglist_bg_empty = colors.dark
theme.taglist_bg_volatile = colors.dark

-- ########## Tasklist ############
theme.tasklist_bg_focus = colors.bg
theme.tasklist_fg_focus = colors.fg
theme.tasklist_bg_urgent = colors.red
theme.tasklist_fg_urgent = colors.dark

-- Generate taglist squares:
--theme.taglist_squares_sel  = themes_path.."/icons/square_a.png"
--theme.taglist_squares_unsel = themes_path.."/icons/square_b.png"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true

local taglist_square_size = 0
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- ########## Menu ############
theme.menu_submenu_icon = themes_path .. "icons/submenu.png"
theme.menu_bg_normal = colors.bg
theme.menu_fg_normal = colors.fg
theme.menu_bg_focus = colors.gray
theme.menu_fg_focus = colors.fg
theme.menu_border_color = colors.primary
theme.menu_border_width = 0
theme.menu_height = menubar_height
theme.menu_width = menubar_width
theme.menu_icon_size = menubar_height

-- ########## Titlebar ############
theme.titlebar_bg_normal = colors.gray
theme.titlebar_fg_normal = colors.fg
theme.titlebar_bg_focus = colors.primary
theme.titlebar_fg_focus = colors.dark

-- Close Button
theme.titlebar_close_button_normal = themes_path .. 'icons/titlebar/normal.png'
theme.titlebar_close_button_focus  = themes_path .. 'icons/titlebar/close_focus.png'

-- Minimize Button
theme.titlebar_minimize_button_normal = themes_path .. 'icons/titlebar/normal.png'
theme.titlebar_minimize_button_focus  = themes_path .. 'icons/titlebar/minimize_focus.png'
theme.titlebar_minimize_button_focus_hover  = themes_path .. 'icons/titlebar/minimize_focus_hover.png'

-- Maximized Button (While Window is Maximized)
theme.titlebar_maximized_button_normal_active = themes_path .. 'icons/titlebar/normal.png'
theme.titlebar_maximized_button_focus_active  = themes_path .. 'icons/titlebar/maximized_focus.png'
theme.titlebar_maximized_button_normal_active_hover = themes_path .. 'icons/titlebar/maximized_focus_hover.png'
theme.titlebar_maximized_button_focus_active_hover  = themes_path .. 'icons/titlebar/maximized_focus_hover.png'

-- Maximized Button (While Window is not Maximized)
theme.titlebar_maximized_button_normal_inactive = themes_path .. 'icons/titlebar/normal.png'
theme.titlebar_maximized_button_focus_inactive  = themes_path .. 'icons/titlebar/maximized_focus.png'
theme.titlebar_maximized_button_normal_inactive_hover = themes_path .. 'icons/titlebar/maximized_focus_hover.png'
theme.titlebar_maximized_button_focus_inactive_hover  = themes_path .. 'icons/titlebar/maximized_focus_hover.png'

-- ########## Layout ############
theme.layout_tile = themes_path .. "/icons/tiled.png"
theme.layout_max = themes_path .. "/icons/maximized.png"
theme.layout_floating = themes_path .. "/icons/floating.png"

--########### Generates icons ###########
theme.awesome_icon = theme_assets.awesome_icon(menubar_height, theme.bg_focus, theme.fg_focus)
theme.icon_theme = "Papirus-Dark"
theme.terminal_icon = themes_path.."/icons/apps/kitty.png"
theme.power_icon = themes_path .. "/icons/power.png"

-- ########## Notification ############
theme.notification_font = fonts.regular
theme.notification_bg = colors.bg
theme.notification_fg = colors.fg
theme.notification_border_width = border_width
theme.notification_border_color = colors.primary
theme.notification_shape = gears.shape.reactagle
theme.notification_margin = dpi(20)
theme.notification_max_width = dpi(340)
theme.notification_max_height = dpi(150)
theme.notification_icon_size = dpi(64)
theme.bat_notification_charged_preset = {
	title = "Battery full",
	text = "You can unplug the cable",
	timeout = 10,
	fg = colors.dark,
	bg = colors.green,
}
theme.bat_notification_low_preset = {
	title = "Battery low",
	text = "Plug the cable!",
	timeout = 10,
	fg = colors.dark,
	bg = colors.red,
}
theme.bat_notification_critical_preset = {
	title = "Battery exhausted",
	text = "Shutdown imminent",
	timeout = 10,
	fg = colors.dark,
	bg = "#ff5555",
}

-- ########## Systray ############
--theme.bg_systray = colors.bg
--theme.fg_systray = colors.fg
theme.systray_icon_spacing = 10

-- ########## Create menubar ############
function theme.at_screen_connect(s)
	bar.at_screen_connect(s)
end

return theme
