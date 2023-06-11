
--	███╗   ███╗███████╗███╗   ██╗██╗   ██╗██████╗  █████╗ ██████╗ 
--	████╗ ████║██╔════╝████╗  ██║██║   ██║██╔══██╗██╔══██╗██╔══██╗
--	██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║██████╔╝███████║██████╔╝
--	██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║██╔══██╗██╔══██║██╔══██╗
--	██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝██████╔╝██║  ██║██║  ██║
--	╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local menubar = require("menubar")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi = require("beautiful.xresources").apply_dpi

local gfs = require("gears.filesystem")
local home_config_dir = gfs.get_xdg_config_home()
local themes_path = home_config_dir .. "awesome/themes/"
local fonts = require("themes.fonts")
local widgets = require("themes.widgets")
local var = require("variables")

local bar = {}

menubar.utils.terminal = var.terminal
-- Launcher
local launcher_icon = {
	redhat_icon = themes_path .. "/icons/distro/redhat.png",
	linuxmint_icon = themes_path .. "/icons/distro/linuxmint.png",
}

bar.linux_icon = launcher_icon.linuxmint_icon

local mylauncher = awful.widget.button({ image = bar.linux_icon })
mylauncher:connect_signal("button::press", function()
	awful.util.mymainmenu:toggle()
end)

function bar.at_screen_connect(s)
	-- Quake application
	s.quake = lain.util.quake({ app = awful.util.terminal })

	-- If wallpaper is a function, call it with the screen
	local wallpaper = beautiful.wallpaper
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)

	-- Tags
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

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

	local mytaglistwidget = wibox.container.background(s.mytaglist, beautiful.bg_focus, gears.shape.rectangle)

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, {
		shape = gears.shape.rectangle,
		shape_border_width = 0,
		shape_border_color = beautiful.tasklist_bg_normal,
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
			widgets.space,
			mytaglistwidget,
			widgets.space,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			widgets.cpu,
			widgets.netspeed,
			widgets.battery,
			widgets.brightness,
			widgets.volume,
			widgets.space,
			widgets.systray,
			widgets.space,
			widgets.clock,
			s.mylayoutbox,
		},
	})
end

return bar