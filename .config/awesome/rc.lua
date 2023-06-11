--	:*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*:
--	:*:																													:*:
--	:*:	██████╗  ██████╗ ████████╗███████╗   										:*:
--	:*:	██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝   										:*:
--	:*:	██║  ██║██║   ██║   ██║   ███████╗   										:*:
--	:*:	██║  ██║██║   ██║   ██║   ╚════██║   										:*:
--	:*:	██████╔╝╚██████╔╝   ██║   ███████║██╗										:*:
--	:*:	╚═════╝  ╚═════╝    ╚═╝   ╚══════╝╚═╝										:*:
--	:*:	🅱🆈 - 🅻🅰🅺🆂🅷🅼🅸🅺🅰🅽🆃🅰 🅿🅰🆃🆁🅰								    :*:
--	:*:				🅶🅸🆃🅷🆄🅱.🅲🅾🅼/🅵🆁🅾🅽🆃🅴🅽🅳🅵🅸🆇🅴🆁/🅳🅾🆃🆂		:*:
--	:*:																													:*:
--	:*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*::*:

---@diagnostic disable: undefined-global
pcall(require, "luarocks.loader")

-- ####### Standard awesome library ########
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

local freedesktop = require("freedesktop")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

-- ######### Error handling #############
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

-- ############# Themes for WM ################
local theme_path = string.format("%s/.config/awesome/themes/theme.lua", os.getenv("HOME"))
beautiful.init(theme_path)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- ##### personal variables ######

local editor_gui = "xed"
local terminal = "kitty"
local modkey = "Mod4"

-- ######### Layouts ##########
awful.util.terminal = terminal
awful.util.tagnames = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.max,
}

-- ############ Awesome Free_Desktop Menu ##########

local myawesomemenu = {
	{
		"hotkeys",
		function()
			return false, hotkeys_popup.show_help
		end,
	},
	{ "edit config", string.format("%s %s", editor_gui, awesome.conffile) },
	{ "restart",     awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local powermenu = {
	{
		"Log out",
		function()
			awesome.quit()
		end,
	},
	{ "Sleep",    "systemctl suspend" },
	{ "Restart",  "systemctl reboot" },
	{ "Shutdown", "systemctl poweroff" },
}

awful.util.mymainmenu = freedesktop.menu.build({
	before = {
		{ "Awesome", myawesomemenu, beautiful.awesome_icon },
		-- other triads can be put here
	},
	after = {
		{ "Open terminal", terminal },
		{ "Powermenu",     powermenu },
	},
	--sub_menu = "Applications"
})

-- Hide the menu when the mouse leaves it
awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
	if
			not awful.util.mymainmenu.active_child
			or (
				awful.util.mymainmenu.wibox ~= mouse.current_wibox
				and awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox
			)
	then
		awful.util.mymainmenu:hide()
	else
		awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave", function()
			if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
				awful.util.mymainmenu:hide()
			end
		end)
	end
end)

-- ######## Mouse bindings ########
awful.util.taglist_buttons = mytable.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

awful.util.tasklist_buttons = mytable.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

-- ############# Key bindings ##############
local keys = require("keys")
root.keys(keys.globalkeys)

root.buttons(mytable.join(
	awful.button({}, 3, function()
		awful.util.mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))

-- ############# Rules ############
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- ############# Create a wibox #############
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
end)

-- ############# Signals ##############
client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
	local only_one = #s.tiled_clients == 1
	for _, c in pairs(s.clients) do
		if only_one and not c.floating or c.maximized or c.fullscreen then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width
		end
	end
end)

-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
	-- Custom
	if beautiful.titlebar_fun then
		beautiful.titlebar_fun(c)
		return
	end

	-- Default
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c, { size = 24 }):setup({
		{
		-- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{
		 -- Middle
			{
			-- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{
		-- Right
			awful.titlebar.widget.minimizebutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- enable titlebar for onlyfor floating windows
client.connect_signal("property::floating", function(c)
	if c.floating then
		awful.titlebar.show(c)
	else
		awful.titlebar.hide(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- switch to parent after closing child window
local function backham()
	local s = awful.screen.focused()
	local c = awful.client.focus.history.get(s, 0)
	if c then
		client.focus = c
		c:raise()
	end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- ########## Autostart windowless processes ########
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
	end
end

local script_path = string.format("%s/.config/awesome/autostart.sh", os.getenv("HOME"))
run_once({script_path})
