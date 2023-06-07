--
--     ██╗      █████╗ ██╗  ██╗███████╗██╗  ██╗███╗   ███╗██╗██╗  ██╗ █████╗ ███╗   ██╗████████╗ █████╗
--     ██║     ██╔══██╗██║ ██╔╝██╔════╝██║  ██║████╗ ████║██║██║ ██╔╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗
--     ██║     ███████║█████╔╝ ███████╗███████║██╔████╔██║██║█████╔╝ ███████║██╔██╗ ██║   ██║   ███████║
--     ██║     ██╔══██║██╔═██╗ ╚════██║██╔══██║██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╗██║   ██║   ██╔══██║
--     ███████╗██║  ██║██║  ██╗███████║██║  ██║██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║
--     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
--

---@diagnostic disable: undefined-global
pcall(require, "luarocks.loader")

-- ####### Standard awesome library ########
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local gfs = require("gears.filesystem")
local home_config_dir = gfs.get_xdg_config_home()
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

local freedesktop = require("freedesktop")
local lain = require("lain")

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

-- ########## Autostart windowless processes ########
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
	end
end
-- Install the "unclutter" package.
run_once({
	"picom -b --config ~/.config/picom/picom.conf",
	"blueman-applet",
	"nm-applet",
	"/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1",
	-- #### for fedora
	--/usr/libexec/polkit-gnome-authentication-agent-1 &
	--/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
	"numlockx on",
	"dunst",
	"clipit",
	"unclutter -root",
})

--######## Autostart startup scripts
--awful.spawn.with_shell("$HOME/.config/awesome/autostart.sh")

-- ############# Themes for WM ################
local themes = {
	"dracula-soft", --1
	"holo", -- 2
	"powerarrow", -- 3
}
local chosen_theme = themes[1]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
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
local browser = "firefox"
local editor = os.getenv("EDITOR") or "nvim"
local editor_gui = "mousepad"
local main_editor = "code"
local filemanager = "pcmanfm"
local terminal = "alacritty"

local powermenu_prompt = "$HOME/.scripts/rofi-powermenu.sh"
local lock_prompt = "betterlockscreen -l dimblur"
local rofi_prompt = "rofi -modi drun -show drun -config ~/.config/rofi/col_singlerow.rasi"
local dmenu_prompt = string.format(
	"dmenu_run -nb '#1a1e1e' -sf '#212128' -sb '#f24054' -nf '#00e5ff' -fn 'Cascadia Code 9' -p 'Applications:'"
)
local emoji_prompt =
	"rofimoji --prompt='Emoji' --selector-args='-theme /home/lakshmi/.config/rofi/emoji-selector.rasi' --hidden-descriptions"
local screenshot_prompt = "scrot /home/lakshmi/Pictures/%Y-%m-%d-%T-scr.png"

local modkey = "Mod4"
local altkey = "Mod1"
local ctrl = "Control"

-- ######### Layouts ##########
awful.util.terminal = terminal
awful.util.tagnames = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.fair,
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
	{ "restart", awesome.restart },
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
	{ "Sleep", "systemctl suspend" },
	{ "Restart", "systemctl reboot" },
	{ "Shutdown", "systemctl poweroff" },
}

awful.util.mymainmenu = freedesktop.menu.build({
	before = {
		{ "Awesome", myawesomemenu, beautiful.awesome_icon },
		-- other triads can be put here
	},
	after = {
		{ "Open terminal", terminal },
		{ "Powermenu", powermenu },
	},
	--sub_menu = "Applications"
})
menubar.utils.terminal = terminal

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
-- ############## Menubar configuration ###############

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

-- ############# Create a wibox #############
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
end)

-- ######## Mouse bindings ########
root.buttons(mytable.join(
	awful.button({}, 3, function()
		awful.util.mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))

-- ############# Key bindings ##############
local globalkeys = gears.table.join(
	-- ##### awesome ####
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "w", function()
		awful.util.mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),

	-- ##### workspace ####
	awful.key({ modkey, altkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "workspace" }),
	awful.key({ modkey, altkey }, "Right", awful.tag.viewnext, { description = "view next", group = "workspace" }),
	awful.key({ modkey, altkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "workspace" }),

	-- ##### client ####
	awful.key({ modkey }, "Right", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next window", group = "client" }),
	awful.key({ modkey }, "Left", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous window", group = "client" }),
	awful.key({ modkey, "Shift" }, "Right", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next window", group = "client" }),
	awful.key({ modkey, "Shift" }, "Left", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous window", group = "client" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent window", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back to previous window", group = "client" }),
	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized window", group = "client" }),

	awful.key({ modkey, "Shift" }, "l", function()
		awful.spawn(lock_prompt)
	end, { description = "lock screen", group = "screen" }),

	-- ##### app launcher ####
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "app launcher" }),
	awful.key({ modkey }, "b", function()
		awful.spawn(browser)
	end, { description = "open browser", group = "app launcher" }),
	awful.key({ modkey }, "c", function()
		awful.spawn(main_editor)
	end, { description = "open a VSCode", group = "app launcher" }),
	awful.key({ modkey }, "e", function()
		awful.spawn(filemanager)
	end, { description = "open filemanager", group = "app launcher" }),

	-- ##### run scripts ####
	awful.key({ modkey }, "p", function()
		awful.spawn(rofi_prompt)
	end, { description = "rofi launcher", group = "run scripts" }),
	awful.key({ modkey }, "r", function()
		awful.spawn(dmenu_prompt)
	end, { description = "show dmenu", group = "run scripts" }),
	awful.key({ modkey, "Shift" }, ".", function()
		awful.spawn(emoji_prompt)
	end, { description = "show emoji", group = "run scripts" }),
	awful.key({ modkey }, "Insert", function()
		awful.spawn(screenshot_prompt)
	end, { description = "screenshot", group = "run scripts" }),
	awful.key({ modkey, "Shift" }, "e", function()
		awful.spawn.with_shell(powermenu_prompt)
	end, { description = "rofi powermenu", group = "run scripts" }),

	-- ##### laout ####
	awful.key({ modkey, ctrl }, "Right", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width", group = "layout" }),
	awful.key({ modkey, ctrl }, "Left", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width", group = "layout" }),
	awful.key({ altkey }, "l", function()
		awful.layout.inc(1)
	end, { description = "select next layout", group = "layout" }),

	-- ##### multimedia ####
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn.with_shell("pamixer +i 5")
	end, { description = "increase volume", group = "multimedia" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn.with_shell("pamixer -i 5")
	end, { description = "decrease volume", group = "multimedia" }),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn.with_shell("pamixer -t")
	end, { description = "toggle mute", group = "multimedia" })
)

local clientkeys = gears.table.join(
	awful.key({}, "F11", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end, { description = "close focus window", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" })
)

for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" })
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)
-- Set keys
root.keys(globalkeys)

-- ############# Rules ############
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			callback = awful.client.setslave,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honor = false,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Mousepad",
				"Galculator",
				"GParted",
				"Lxappearance",
				"Nitrogen",
				"Xarchiver",
				"TelegramDesktop",
				"Eog",
				"Yad",
				"Xreader",
				"Engrampa",
				"Gedit",
				"Grub Customize",
				"gcolor3",
				"Xed",
				"Pavucontrol",
				"Xfce4-power-manager-settings",
			},
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow",
				"ConfigManager",
				"pop-up",
				"GtkFileChooserDialog",
			},
		},
		properties = {
			floating = true,
		},
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = { "normal", "dialog" },
		},
		properties = {
			titlebars_enabled = false,
		},
	},

	-- ######## Set app on a specific windows
	{
		rule_any = {
			class = {
				"kitty",
				"Alacritty",
			},
		},
		properties = { screen = 1, tag = awful.screen.focused().tags[1], switchtotag = true },
	},
	{
		rule_any = {
			class = {
				"Thunar",
				"Pcmanfm",
			},
		},
		properties = { screen = 1, tag = awful.screen.focused().tags[2], switchtotag = true },
	},
	{
		rule_any = {
			class = {
				"firefox",
				"chromium",
				"chromium-browser",
				"brave-browser",
				"qutebrowser",
			},
		},
		except_any = {
			role = { "GtkFileChooserDialog" },
			instance = { "Toolkit" },
			type = { "dialog" },
		},
		properties = { screen = 1, tag = awful.screen.focused().tags[3], switchtotag = true },
	},
	{
		rule_any = {
			class = {
				"Code",
				"VSCodium",
				"Sublime-text",
			},
		},
		properties = { screen = 1, tag = awful.screen.focused().tags[4], switchtotag = true },
	},
	{
		rule_any = {
			class = {
				"figma-linux",
				"Gimp-2.10",
				"Inkscape",
			},
		},
		properties = { screen = 1, tag = awful.screen.focused().tags[5], switchtotag = true },
	},
	{
		rule_any = {
			class = {
				"vlc",
				"libreoffice",
			},
		},
		properties = { screen = 1, tag = awful.screen.focused().tags[6], switchtotag = true, floating =true },
	},
}

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
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.minimizebutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton(c),
			-- awful.titlebar.widget.floatingbutton (c),
			-- awful.titlebar.widget.ontopbutton    (c),
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
