------------------------------
-- Default awesome modules  --
------------------------------
local string, os = string, os
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local theme_assets = require("beautiful.theme_assets")
local gfs = require("gears.filesystem")
local home_config_dir = gfs.get_xdg_config_home()
local themes_path = home_config_dir .. "awesome/themes/dracula-soft/"

local dpi = require("beautiful.xresources").apply_dpi

-------------------------
-- Dracula-soft Color
-------------------------
local colors = {
	bg = "#212128",
	fg = "#eeeef4",
	dark = "#1a1a1e",
	gray = "#565656",
	cyan = "#63fff7",
	green = "#ABE9B3",
	orange = "#ffc370",
	pink = "#fc88d1",
	purple = "#ff3dff",
	red = "#ff8fad",
	yellow = "#FAE3B0",
}

local fonts = {
	regular = "FiraCode Nerd Font Regular 11",
	bold = "FiraCode Nerd Font Bold 11",
	big = "FiraCode Nerd Font Bold 12",
	bold_big = "FiraCode Nerd Font Bold 12",
}

local theme = {}

theme.wallpaper = themes_path .. "wal39.jpg"

theme.font = fonts["regular"]
theme.taglist_font = fonts["icon"]

theme.bg_normal = colors["bg"]
theme.bg_focus = colors["cyan"]
theme.bg_urgent = colors["red"]
theme.bg_minimize = colors["gray"]
theme.bg_systray = colors["bg"]

theme.fg_normal = colors["fg"]
theme.fg_focus = colors["dark"]
theme.fg_urgent = colors["dark"]
theme.fg_minimize = colors["fg"]

theme.useless_gap = 4

theme.border_width = 1
theme.border_normal = colors["bg"]
theme.border_focus = colors["gray"]
theme.border_marked = colors["red"]

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
-- theme.taglist_bg_focus = "#ff0000"

theme.taglist_bg_focus = colors["cyan"]
theme.taglist_bg_urgent = colors["red"]
theme.taglist_bg_occupied = colors["gray"]
theme.taglist_bg_empty = colors["dark"]
theme.taglist_bg_volatile = colors["dark"]

theme.titlebar_bg_normal = colors["gray"]
theme.titlebar_bg_focus = colors["cyan"]

theme.tasklist_bg_normal = colors["gray"]
theme.tasklist_fg_normal = colors["fg"]
theme.tasklist_bg_focus = colors["bg"]
theme.tasklist_fg_focus = colors["fg"]
theme.tasklist_bg_urgent = colors["red"]
theme.tasklist_fg_urgent = colors["dark"]

-- Generate taglist squares:
--theme.taglist_squares_sel                       = themes_path.."/icons/square_a.png"
--theme.taglist_squares_unsel                     = themes_path.."/icons/square_b.png"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true

local taglist_square_size = 0
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = fonts["regular"]
theme.notification_bg = colors["gray"]
theme.notification_fg = colors["fg"]
theme.notification_width = 400
theme.notification_height = 120
theme.notification_margin = 10

-- Variables set for theming the menu:
theme.menu_submenu_icon = themes_path .. "icons/submenu.png"
theme.menu_bg_normal = colors["gray"]
theme.menu_bg_focus = colors["cyan"]
theme.menu_fg_normal = colors["fg"]
theme.menu_fg_focus = colors["dark"]
theme.menu_border_color = colors["dark"]
theme.menu_border_width = 0
theme.menu_height = dpi(22)
theme.menu_width = dpi(180)
theme.menu_icon_size = dpi(32)

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "/icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "/icons/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "/icons/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "/icons/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "/icons/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "/icons/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "/icons/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "/icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "/icons/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_tile = themes_path .. "/icons/tile.png"
theme.layout_tilegaps = themes_path .. "/icons/tilegaps.png"
theme.layout_tileleft = themes_path .. "/icons/tileleft.png"
theme.layout_tilebottom = themes_path .. "/icons/tilebottom.png"
theme.layout_tiletop = themes_path .. "/icons/tiletop.png"
theme.layout_fairv = themes_path .. "/icons/fairv.png"
theme.layout_fairh = themes_path .. "/icons/fairh.png"
theme.layout_spiral = themes_path .. "/icons/spiral.png"
theme.layout_dwindle = themes_path .. "/icons/dwindle.png"
theme.layout_max = themes_path .. "/icons/max.png"
theme.layout_fullscreen = themes_path .. "/icons/fullscreen.png"
theme.layout_magnifier = themes_path .. "/icons/magnifier.png"
theme.layout_floating = themes_path .. "/icons/floating.png"

-- Generates icons:
theme.awesome_icon = theme_assets.awesome_icon(16, theme.bg_focus, theme.fg_focus)
theme.linux_icon = themes_path .. "/icons/distro/redhat.png"

theme.clock_icon = themes_path .. "/icons/apps/clock.png"
theme.calendar_icon = themes_path .. "/icons/apps/calendar.png"
theme.terminal_icon = themes_path .. "/icons/apps/terminal.png"
theme.poweroff_icon = themes_path .. "/icons/apps/power.png"
theme.widget_clock = themes_path .. "/icons/clock.png"

theme.icon_theme = "/usr/share/icons/Papirus-Dark"

-- ########### Widgets #############
local markup = lain.util.markup

-- space
local sp = wibox.widget({
	markup = "<span background='#282a36'>  </span>",
	halign = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})
local space = wibox.container.background(sp, colors.bg, gears.shape.rectangle)

-- CPU
local cpu = lain.widget.cpu({
	settings = function()
		widget:set_markup(
			markup(
				colors.dark,
				markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, cpu_now.usage .. "% ")
			)
		)
	end,
})
local cpuwidget = wibox.container.background(cpu.widget, colors.red, gears.shape.rectangle)

-- Net
local net = lain.widget.net({
	settings = function()
		widget:set_markup(
			markup(
				colors.dark,
				markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, net_now.received .. "kb ")
			)
		)
	end,
})
local networkwidget = wibox.container.background(net.widget, colors.pink, gears.shape.rectangle)

local bat = lain.widget.bat({
	settings = function()
		if bat_now.perc == "N/A" or bat_now.perc == "100" then
			return widget:set_markup(
				markup(colors.dark, markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, "100% "))
			)
		else
			local bat_perc = tonumber(bat_now.perc) or 0
			if bat_perc > 50 then
				return widget:set_markup(
					markup(
						colors.dark,
						markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, bat_now.perc .. "% ")
					)
				)
			elseif bat_perc > 15 then
				return widget:set_markup(
					markup(
						colors.dark,
						markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, bat_now.perc .. "% ")
					)
				)
			else
				return widget:set_markup(
					markup(
						colors.dark,
						markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, bat_now.perc .. "% ")
					)
				)
			end
		end
	end,
})
theme.bat_notification_charged_preset = {
	title   = "Battery full",
	text    = "You can unplug the cable",
	timeout = 10,
	fg      = colors.dark,
	bg      = colors.green
}
theme.bat_notification_low_preset = {
	title = "Battery low",
	text = "Plug the cable!",
	timeout = 10,
	fg = colors.dark,
	bg = colors.red
}
theme.bat_notification_critical_preset = {
	title = "Battery exhausted",
	text = "Shutdown imminent",
	timeout = 10,
	fg = colors.dark,
	bg = "#ff5555"
}

local batterywidget = wibox.container.background(bat.widget, colors.green, gears.shape.rectangle)

-- Brigtness
local brightness = awful.widget.watch("xbacklight -get", 0.1, function(widget, stdout, stderr, exitreason, exitcode)
	local brightness_level = tonumber(string.format("%.0f", stdout))
	widget:set_markup(
		markup(
			colors.dark,
			markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, brightness_level .. "% ")
		)
	)
end)
local brightwidget = wibox.container.background(brightness, colors.orange, gears.shape.rectangle)

-- volume
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

-- systray
theme.systray_icon_spacing = 10
local systray = wibox.widget.systray()
local systray_widget = wibox.container.background(systray, colors.cyan, gears.shape.rectangle)
systray_widget = wibox.container.margin(systray_widget, dpi(3), dpi(3), dpi(3), dpi(3))
-- Clock
local mytextclock = wibox.widget.textclock(
	markup(colors.dark, markup.font(fonts.bold_big, " ") .. markup.font(fonts.bold, " %H:%M %p "))
)
local clockwidget = wibox.container.background(mytextclock, colors.pink, gears.shape.rectangle)

-- Calendar
theme.cal = lain.widget.cal({
	--cal = "cal --color=always",
	attach_to = { clockwidget.widget },
	notification_preset = {
		font = fonts.regular,
		fg = theme.fg_normal,
		bg = theme.bg_normal,
		width = 400,
		height = 155,
	},
})

-- Launcher
local mylauncher = awful.widget.button({ image = theme.linux_icon })
mylauncher:connect_signal("button::press", function()
	awful.util.mymainmenu:toggle()
end)

function theme.at_screen_connect(s)
	-- Quake application
	s.quake = lain.util.quake({ app = awful.util.terminal })

	-- If wallpaper is a function, call it with the screen
	local wallpaper = theme.wallpaper
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)

	-- Tags
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(my_table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 2, function()
			awful.layout.set(awful.layout.layouts[1])
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(
		s,
		awful.widget.taglist.filter.noempty,
		awful.util.taglist_buttons,
		{ font = fonts.bold_big }
	)

	local mytaglistwidget = wibox.container.background(s.mytaglist, theme.bg_focus, gears.shape.rectangle)

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, {
		shape = gears.shape.rectangle,
		shape_border_width = 0,
		shape_border_color = theme.tasklist_bg_normal,
		align = "left",
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(24) })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			space,
			mytaglistwidget,
			s.mypromptbox,
			space,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			cpuwidget,
			networkwidget,
			batterywidget,
			brightwidget,
			space,
			volume_widget({
				widget_type = "horizontal_bar",
				main_color = colors.orange,
				mute_color = colors.gray,
				bg_color = colors.fg,
				width = 50,
				margins = 8,
				shape = "octogon",
				with_icon = true,
			}),
			space,
			systray_widget,
			space,
			clockwidget,
			s.mylayoutbox,
		},
	})
end

return theme
