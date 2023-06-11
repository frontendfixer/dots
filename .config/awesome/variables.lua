
--	██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
--	██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
--	██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
--	╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
--	 ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
--	  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝


local var = {
	browser = "firefox",
	editor = os.getenv("EDITOR") or "nvim",
	editor_gui = "xed",
	main_editor = "code",
	filemanager = "pcmanfm",
	terminal = "kitty",

	powermenu_prompt = "$HOME/.scripts/rofi-powermenu.sh",
	lock_prompt = "betterlockscreen -l dimblur",
	rofi_prompt = "rofi -modi drun -show drun -config ~/.config/rofi/col_singlerow.rasi",
	dmenu_prompt = string.format(
		"dmenu_run -nb '#1a1e1e' -sf '#212128' -sb '#f24054' -nf '#00e5ff' -fn 'Cascadia Code 9' -p 'Applications:'"
	),
	emoji_prompt =
	"rofimoji --prompt='Emoji' --selector-args='-theme /home/lakshmi/.config/rofi/emoji-selector.rasi' --hidden-descriptions",
	screenshot_prompt = "scrot /home/lakshmi/Pictures/%Y-%m-%d-%T-scr.png",

	modkey = "Mod4",
	altkey = "Mod1",
	ctrl = "Control",
}

return var
