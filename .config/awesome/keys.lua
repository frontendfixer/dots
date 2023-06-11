--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝

---@diagnostic disable: undefined-global

local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
require("awful.hotkeys_popup.keys")

local var = require("variables")

-- ############# Functions #################
-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end



local keys = {}

-- ############# Key bindings ##############
keys.globalkeys = gears.table.join(
-- ##### awesome ####
	awful.key({ var.modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ var.modkey }, "w", function()
		awful.util.mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),
	awful.key({ var.modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ var.modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ var.modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),

	-- ##### workspace ####
	awful.key({ var.modkey, var.altkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "workspace" }),
	awful.key({ var.modkey, var.altkey }, "Right", awful.tag.viewnext, { description = "view next", group = "workspace" }),
	awful.key({ var.modkey, var.altkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "workspace" }),

	-- ##### client ####
	awful.key({ var.modkey }, "Right", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next window", group = "client" }),
	awful.key({ var.modkey }, "Left", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous window", group = "client" }),
	awful.key({ var.modkey, "Shift" }, "Right", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next window", group = "client" }),
	awful.key({ var.modkey, "Shift" }, "Left", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous window", group = "client" }),
	awful.key({ var.modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent window", group = "client" }),
	awful.key({ var.modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back to previous window", group = "client" }),
	awful.key({ var.modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized window", group = "client" }),

	awful.key({ var.modkey, "Shift" }, "l", function()
		awful.spawn(var.lock_prompt)
	end, { description = "lock screen", group = "screen" }),

	-- ##### app launcher ####
	awful.key({ var.modkey }, "Return", function()
		awful.spawn(var.terminal)
	end, { description = "open a terminal", group = "app launcher" }),
	awful.key({ var.modkey }, "b", function()
		awful.spawn(var.browser)
	end, { description = "open browser", group = "app launcher" }),
	awful.key({ var.modkey }, "c", function()
		awful.spawn(var.main_editor)
	end, { description = "open a VSCode", group = "app launcher" }),
	awful.key({ var.modkey }, "e", function()
		awful.spawn(var.filemanager)
	end, { description = "open filemanager", group = "app launcher" }),

	-- ##### run scripts ####
	awful.key({ var.modkey }, "p", function()
		awful.spawn(var.rofi_prompt)
	end, { description = "rofi launcher", group = "run scripts" }),
	awful.key({ var.modkey }, "r", function()
		awful.spawn(var.dmenu_prompt)
	end, { description = "show dmenu", group = "run scripts" }),
	awful.key({ var.modkey, "Shift" }, ".", function()
		awful.spawn(var.emoji_prompt)
	end, { description = "show emoji", group = "run scripts" }),
	awful.key({ var.modkey }, "Insert", function()
		awful.spawn(var.screenshot_prompt)
	end, { description = "screenshot", group = "run scripts" }),
	awful.key({ var.modkey, "Shift" }, "e", function()
		awful.spawn.with_shell(var.powermenu_prompt)
	end, { description = "rofi powermenu", group = "run scripts" }),

	-- ##### laout ####
	-- awful.key({ var.modkey, var.ctrl }, "Right", function()
	-- 	awful.tag.incmwfact(0.05)
	-- end, { description = "increase master width", group = "layout" }),
	-- awful.key({ var.modkey, var.ctrl }, "Left", function()
	-- 	awful.tag.incmwfact(-0.05)
	-- end, { description = "decrease master width", group = "layout" }),

	awful.key({var.modkey, var.ctrl}, "Down",
      function(c)
         resize_client(client.focus, "down")
      end,{ description = "increase height downward", group = "layout" }
	),
   awful.key({var.modkey, var.ctrl}, "Up",
      function(c)
         resize_client(client.focus, "up")
      end,{ description = "increase height upward", group = "layout" }
   ),
   awful.key({var.modkey, var.ctrl}, "Left",
      function(c)
         resize_client(client.focus, "left")
      end, { description = "increase width leftside", group = "layout" }
   ),
   awful.key({var.modkey, var.ctrl}, "Right",
      function(c)
         resize_client(client.focus, "right")
      end, { description = "increase width rightside", group = "layout" }
   ),

	awful.key({ var.altkey }, "l", function()
		awful.layout.inc(1)
	end, { description = "select next layout", group = "layout" }),

	-- ##### multimedia ####
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.util.spawn_with_shell("amixer -D pulse sset Master 5%+")
	end, { description = "increase volume", group = "multimedia" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.util.spawn_with_shell("amixer -D pulse sset Master 5%-")
	end, { description = "decrease volume", group = "multimedia" }),
	awful.key({}, "XF86AudioMute", function()
		awful.util.spawn_with_shell("amixer -D pulse set Master 1+ toggle")
	end, { description = "toggle mute", group = "multimedia" })
)

keys.clientkeys = gears.table.join(
	awful.key({}, "F11", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ var.modkey }, "q", function(c)
		c:kill()
	end, { description = "close focus window", group = "client" }),
	awful.key(
		{ var.modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ var.modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" })
)

for i = 1, 9 do
	keys.globalkeys = gears.table.join(
		keys.globalkeys,
		-- View tag only.
		awful.key({ var.modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ var.modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" })
	)
end

keys.clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ var.modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ var.modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

return keys