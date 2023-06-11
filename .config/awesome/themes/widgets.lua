--
--  ██╗    ██╗██╗██████╗  ██████╗ ███████╗████████╗███████╗
--  ██║    ██║██║██╔══██╗██╔════╝ ██╔════╝╚══██╔══╝██╔════╝
--  ██║ █╗ ██║██║██║  ██║██║  ███╗█████╗     ██║   ███████╗
--  ██║███╗██║██║██║  ██║██║   ██║██╔══╝     ██║   ╚════██║
--  ╚███╔███╔╝██║██████╔╝╚██████╔╝███████╗   ██║   ███████║
-- ╚══╝╚══╝ ╚═╝╚═════╝  ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝
--

--@diagnostic disable: undefined-global
local string, os = string, os
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local my_table = awful.util.table or gears.table
local dpi = require("beautiful.xresources").apply_dpi

local colors = require("themes.colors")
local fonts  = require("themes.fonts")


local widgets = {}
local markup = lain.util.markup

-- space
local sp = wibox.widget({
	markup = "<span background='#282a36'>  </span>",
	halign = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})
widgets.space = wibox.container.background(sp, colors.bg, gears.shape.rectangle)

-- CPU
local cpuUses = lain.widget.cpu({
	settings = function()
		widget:set_markup(
			markup(
				colors.dark,
				markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, cpu_now.usage .. "% ")
			)
		)
	end,
})
widgets.cpu = wibox.container.background(cpuUses.widget, colors.red, gears.shape.rectangle)

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
widgets.netspeed = wibox.container.background(net.widget, colors.pink, gears.shape.rectangle)

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

widgets.battery = wibox.container.background(bat.widget, colors.green, gears.shape.rectangle)

-- Brigtness
local bright = awful.widget.watch("light -G", 0.1, function(widget, stdout, _, _, _)
	local bright_level = tonumber(string.format("%.0f", stdout))
	widget:set_markup(
		markup(
			colors.dark,
			markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, bright_level .. "% ")
		)
	)
	widget:buttons(my_table.join(
    awful.button({ }, 4, function ()
			awful.util.spawn_with_shell("light -A 5")
		end ),
    awful.button({ }, 5, function ()
			awful.util.spawn_with_shell("light -U 5")
		end  )
))
end)

widgets.brightness = wibox.container.background(bright, colors.orange, gears.shape.rectangle)

-- volume
local alsa_volume = lain.widget.alsa({
	cmd = "amixer -D pulse sget Master",
	settings = function()
		if volume_now.status=="on" then			
			widget:set_markup(
				markup(
					colors.dark,
					markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, volume_now.level .. "% ")
				))
				else
					widget:set_markup(
				markup(
					colors.gray,
					markup.font(fonts.bold_big, "  ") .. markup.font(fonts.regular, "mute ")
				))
		end
	end,
})

alsa_volume.widget:buttons(my_table.join(
    awful.button({ }, 4, function ()
			awful.util.spawn_with_shell("amixer -D pulse sset Master 5%+")
		end ),
    awful.button({ }, 5, function ()
			awful.util.spawn_with_shell("amixer -D pulse sset Master 5%-")
		end  )
		))
widgets.volume = wibox.container.background(alsa_volume.widget, colors.yellow, gears.shape.rectangle)

-- systray
local tray = wibox.widget.systray()
widgets.systray = wibox.container.margin(tray, dpi(3), dpi(3), dpi(3), dpi(3))

-- Clock
local mytextclock = wibox.widget.textclock(
	markup(colors.dark, markup.font(fonts.bold_big, " ") .. markup.font(fonts.bold, "%l:%M %p "))
)
widgets.clock = wibox.container.background(mytextclock, colors.pink, gears.shape.rectangle)

widgets.cal = lain.widget.cal({
	cal = "cal --color=always",
	attach_to = { widgets.clock.widget },
	notification_preset = {
		font = fonts.regular,
		fg = colors.fg,
		bg = colors.bg,
	},
})

return widgets
