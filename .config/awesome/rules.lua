--
--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
--

local awful = require("awful")
local beautiful = require("beautiful")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

local rules = {}

-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
	return {
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
					"copyq",
					"pinentry",
				},
				class = {
					"Arandr",
					"Blueman-manager",
					"Mousepad",
					"Galculator",
					"GParted",
					"Rhythmbox",
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
					"Parole",
					"Synaptic",
					"Pavucontrol",
					"Xfce4-power-manager-settings",
					"Transmission-gtk",
					"Flameshot",
					"dmenu",
					"meld",
					"Meld",
					"VirtualBox",
					"zenity",
					"ssh-askpass",
					"copyq",
				},
				name = {
					"Event Tester", -- xev.
					"Software Manager",
					"System Reports",
					"Timeshift",
					"Update Manager",
					"Backup Tool",
					"Color Picker",
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
				placement = awful.placement.centered,
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
			properties = { screen = 1, tag = " 1 ", switchtotag = true },
		},
		{
			rule_any = {
				class = {
					"Thunar",
					"thunar",
				},
			},
			properties = { screen = 1, tag = " 2 ", switchtotag = true },
		},
		{
			rule_any = {
				role = {
					"browser",
				},
				class = {
					"firefox",
					"Chromium",
					"Chromium-browser",
					"Google-chrome",
					"brave-browser",
					"qutebrowser",
					"Helium",
					"helium",
				},
			},
			except_any = {
				role = { "GtkFileChooserDialog" },
				instance = { "Toolkit" },
				type = { "dialog" },
			},
			properties = { screen = 1, tag = " 3 ", switchtotag = true },
		},
		{
			rule_any = {
				class = {
					"Code",
					"VSCodium",
					"Sublime-text",
					"codium",
					"code-oss",
				},
			},
			properties = { screen = 1, tag = " 4 ", switchtotag = true },
		},
		{
			rule_any = {
				class = {
					"figma-linux",
					"Gimp-2.10",
					"Inkscape",
					"postman",
				},
			},
			properties = { screen = 1, tag = " 5 ", switchtotag = true },
		},
		{
			rule_any = {
				class = {
					"vlc",
					"libreoffice",
					"DBeaver",
				},
			},
			properties = { screen = 1, tag = " 6 ", switchtotag = true },
		},
		{
			rule_any = {
				class = {
					"VirtualBox Manager",
				},
			},
			properties = { screen = 1, tag = " 8 ", switchtotag = true },
		},
		{
			rule_any = {
				class = {
					"meld",
					"Meld",
				},
			},
			properties = { screen = 1, tag = " 9 ", switchtotag = true },
		},
		-- ####### specify size for a perticular window
		{
			rule_any = { role = { "GtkFileChooserDialog" } },
			properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.75 },
		},

		-- Pavucontrol & Bluetooth Devices
		{
			rule_any = { class = { "Pavucontrol" }, name = { "Bluetooth Devices" } },
			properties = { floating = true, width = screen_width * 0.35, height = screen_height * 0.45 },
		},
	}
end

return rules
