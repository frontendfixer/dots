#!/bin/bash
set -euo pipefail

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
P='\033[0;35m'
C='\033[0;36m'
N='\033[0m'

die() { echo -e "${R}Error:${N} $*" >&2; exit 1; }

require_repo_root() {
    [ -f fedora-install.sh ] && [ -d .config ] \
        || die "Run from the dots repo root (fedora-install.sh and .config must exist)."
}

require_sudo() {
    sudo -v || die "sudo is required."
}

require_network() {
    curl -fsSL --max-time 15 -o /dev/null https://fedoraproject.org \
        || die "Network check failed (could not reach fedoraproject.org)."
}

dnf_install() {
    sudo dnf install -y "$@"
}

dnf_install_optional() {
    local pkg
    for pkg in "$@"; do
        sudo dnf install -y "$pkg" 2>/dev/null \
            || echo -e "${Y}$pkg not available, skipping${N}"
    done
}

enable_copr_optional() {
    local repo=$1
    sudo dnf copr enable -y "$repo" 2>/dev/null \
        || echo -e "${Y}$repo COPR not available, skipping${N}"
}

install_python_user_tools() {
    local venv="$HOME/.local/share/dots-python-tools"
    local bin_dir="$HOME/.local/bin"

    mkdir -p "$bin_dir"
    python3 -m venv "$venv"
    "$venv/bin/python" -m pip install --upgrade pip
    "$venv/bin/python" -m pip install rofimoji beautysh black psutil

    for tool in rofimoji beautysh black; do
        if [ -x "$venv/bin/$tool" ]; then
            ln -sf "$venv/bin/$tool" "$bin_dir/$tool"
        fi
    done
}

append_dnf_conf_if_missing() {
    local marker="# dots-fedora-install optimizations"
    if sudo grep -qF "$marker" /etc/dnf/dnf.conf 2>/dev/null; then
        echo -e "${Y}dnf.conf already contains dots-fedora-install block, skipping.${N}"
        return 0
    fi
    sudo tee -a /etc/dnf/dnf.conf > /dev/null <<EOF

$marker
gpgcheck=1
installonly_limit=2
clean_requirements_on_remove=True
best=True
skip_if_unavailable=True

# Speed optimizations
max_parallel_downloads=10
deltarpm=0
fastestmirror=True
metadata_expire=1d
defaultyes=True
EOF
}

copy_into_home() {
    local src=$1
    local dest=$2
    [ -e "$src" ] || return 0
    if [ -d "$src" ]; then
        mkdir -p "$dest"
        cp -a "$src"/. "$dest"/
    else
        cp -a "$src" "$dest"
    fi
}

install_vscodium_extensions() {
    local list="$HOME/.config/VSCodium/User/vscode-extensions.list"
    if ! command -v codium &> /dev/null; then
        echo -e "${Y}codium not found, skipping extension install${N}"
        return 0
    fi
    if [ ! -f "$list" ]; then
        echo -e "${Y}Extension list not found at $list, skipping${N}"
        return 0
    fi
    echo -e "\n${G}Installing VSCodium extensions from vscode-extensions.list${N} ===============\n"
    while IFS= read -r ext || [ -n "$ext" ]; do
        [[ -z "$ext" || "$ext" =~ ^[[:space:]]*# ]] && continue
        codium --install-extension "$ext" --force 2>/dev/null \
            || echo -e "${Y}Could not install extension: $ext${N}"
    done < "$list"
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"
require_repo_root
require_sudo
require_network

echo -e "
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
\t${R}░█░░░█▀█░█░█░█▀▀░█░█░█▄█░▀█▀░█░█░█▀█░█▀█░▀█▀░█▀█
\t${N}░█░░░█▀█░█▀▄░▀▀█░█▀█░█░█░░█░░█▀▄░█▀█░█░█░░█░░█▀█
\t${G}░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀░▀░░▀░░▀░▀
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${N}
${Y}Fedora 44 ThinkPad Edition${N}
"

echo -e "${G}Setting up the environment${N} ===============\n"
read -p "Enter your hostname: " host
echo -e "Changed hostname to ${G}$host${N}"
sudo hostnamectl set-hostname "$host"

echo -e "\n${G}Editing dnf.conf...${N}\n"
append_dnf_conf_if_missing

## Updating system...
echo -e "\n${G}Installing RPM Fusion free and non-free${N} ===============\n"
dnf_install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf_install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf group upgrade -y core
sudo dnf update -y

echo -e "\n${G}Installing required groups${N} ===============\n"
sudo dnf group install -y c-development development-tools

echo -e "\n${G}Installing multimedia codecs${N} ===============\n"
sudo dnf install -y gstreamer1-plugins-{bad-free,bad-free-extras,good,ugly} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf install -y ffmpeg --allowerasing
sudo dnf group upgrade -y multimedia --exclude=PackageKit-gstreamer-plugin
sudo dnf group install -y sound-and-video

echo -e "
################################################
${P}ThinkPad Laptop Optimization${N}
################################################
"

echo -e "\n${G}Installing ThinkPad AMD tools and power management${N} ===============\n"
sudo dnf remove -y tuned tuned-ppd power-profiles-daemon 2>/dev/null || true
sudo dnf install -y --allowerasing tlp tlp-pd tlp-rdw
dnf_install powertop acpi acpid kernel-devel libinput libinput-utils \
	xorg-x11-drv-libinput mesa-dri-drivers mesa-vulkan-drivers vulkan-tools \
	xorg-x11-drv-amdgpu mesa-vulkan-drivers mesa-vulkan-drivers.i686 \
	libva-utils mesa-va-drivers


echo -e "\n${G}Installing laptop utilities${N} ===============\n"
dnf_install bluez bluez-tools blueman fwupd fprintd fprintd-pam
dnf_install_optional bluetui

echo -e "\n${G}Configuring TLP for better battery life${N} ===============\n"
sudo systemctl enable tlp.service
sudo systemctl enable tlp-pd.service
sudo systemctl mask power-profiles-daemon.service 2>/dev/null || true
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket 2>/dev/null || true
if [ -e /sys/class/power_supply/BAT0/charge_control_start_threshold ] \
    || [ -e /sys/class/power_supply/BAT0/charge_start_threshold ]; then
    sudo mkdir -p /etc/tlp.d
    sudo tee /etc/tlp.d/90-thinkpad-battery.conf > /dev/null <<'EOF'
# Keep the built-in ThinkPad battery away from prolonged 100% charge.
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
RESTORE_THRESHOLDS_ON_BAT=1
EOF
fi

echo -e "\n${G}Installing AMD microcode updates${N} ===============\n"
dnf_install amd-ucode-firmware

echo -e "\n${G}Configuring touchpad (libinput)${N} ===============\n"
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null <<'EOF'
Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "AccelSpeed" "0.3"
    Option "DisableWhileTyping" "true"
EndSection
EOF

echo -e "
################################################
${P}Terminal Theming${N}
################################################
"

echo -e "\n${G}Installing packages${N} ===============\n"
dnf_install zsh fish fastfetch curl git wget neovim feh kitty playerctl wl-clipboard \
    inotify-tools jq yad zenity

echo -e "
################################################
${P}Web development (fnm)${N}
################################################
"

echo -e "\n${G}Installing native build dependencies${N} ===============\n"
dnf_install gcc gcc-c++ make openssl-devel pkgconf-pkg-config python3-devel python3-pip

echo -e "\n${G}Installing optional web-dev tools${N} ===============\n"
dnf_install_optional git-lfs gh jq tmux

# Add container/database tooling:
dnf_install dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo 2>/dev/null \
    || sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo 2>/dev/null \
    || echo -e "${Y}Docker CE repo setup failed; trying Fedora container packages only.${N}"
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null \
    || echo -e "${Y}Docker CE packages unavailable; continuing with Podman.${N}"
dnf_install podman podman-compose postgresql-server redis

echo -e "\n${G}Installing fnm (Node via fnm, not distro nodejs)${N} ===============\n"
FNM_DIR="${HOME}/.local/share/fnm"
if [ ! -x "${FNM_DIR}/fnm" ]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi
export PATH="${FNM_DIR}:${PATH}"
if command -v fnm &> /dev/null; then
    fnm install --lts
    fnm default lts-latest
    # shellcheck disable=SC1090
    eval "$(fnm env --shell bash)"
    corepack enable 2>/dev/null \
        || echo -e "${Y}corepack enable skipped (Node may need a new shell)${N}"
else
    echo -e "${Y}fnm not on PATH after install; open a new shell and run: fnm install --lts && fnm default lts-latest${N}"
fi

echo -e "\n${G}Installing starship...${N} ===============\n"
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo -e "\n${G}Copying shell dotfiles${N} ===============\n"
[ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$HOME/.bashrc.bak"
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
[ -f "$HOME/.Xresources" ] && mv "$HOME/.Xresources" "$HOME/.Xresources.bak"
cp -a .aliases .bashrc .zshrc .Xresources .face "$HOME/"
copy_into_home .zsh "$HOME/.zsh"

echo -e "\n${G}Installing shell-color-scripts${N} ===============\n"
if [ -d "Themeing/shell-color-scripts" ]; then
    cd Themeing/shell-color-scripts
    sudo make install
    cd "$SCRIPT_DIR"
else
    echo -e "${Y}Warning: shell-color-scripts directory not found, skipping...${N}"
fi

echo -e "\n${G}Clearing terminal${N} ===============\n"
# shellcheck disable=SC1090
command -v colorscript &> /dev/null && colorscript random || fastfetch

echo -e "
\n###############################################
${P}Installing Window Managers & Desktop Environment${N}
###############################################
"

echo -e "${G}Enabling COPR repositories${N} ===========\n"
enable_copr_optional alternateved/eza
enable_copr_optional imput/helium
enable_copr_optional sdegler/hyprland

echo -e "\n${G}Installing XFCE Desktop Environment${N} ===========\n"
sudo dnf install -y @xfce-desktop-environment
sudo dnf install -y xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin \
    xfce4-weather-plugin xfce4-screenshooter xfce4-taskmanager \
    xfce4-clipman-plugin xfce4-systemload-plugin xfce4-cpugraph-plugin \
    xfce4-netload-plugin xfce4-sensors-plugin xfce4-battery-plugin \
    xfce4-power-manager xfce4-notifyd

echo -e "\n${G}Installing required packages${N} ===========\n"
dnf_install btop htop lxappearance picom rofi dunst \
    eza ranger thunar mousepad vim-enhanced \
    lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
    dmenu xdg-user-dirs python3-pip python3-devel \
    firefox file-roller papirus-icon-theme eog meld \
    pipewire pipewire-pulseaudio pipewire-alsa pipewire-jack-audio-connection-kit pipewire-utils wireplumber \
    pavucontrol pulseaudio-utils alsa-utils pamixer libnotify \
    flameshot maim xclip \
    galculator \
    brightnessctl light \
    blueman bluez-tools \
    android-tools android-file-transfer \
    gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb gvfs-archive \
    mate-polkit \
    NetworkManager network-manager-applet nm-connection-editor \
    xset xsetroot \
    zsh-autosuggestions zsh-syntax-highlighting \
    google-noto-color-emoji-fonts google-noto-sans-fonts google-noto-serif-fonts \
    plymouth plymouth-plugin-script \
    redshift \
    polybar \
    yad zenity \
    transmission-gtk \
    xscreensaver \
    unclutter \
    feh nitrogen \
    arandr \
    volumeicon

echo -e "\n${G}Installing Helium browser${N} ===========\n"
dnf_install_optional helium-bin
if ! command -v helium-browser >/dev/null 2>&1 && command -v helium >/dev/null 2>&1; then
    sudo ln -sf "$(command -v helium)" /usr/local/bin/helium-browser
fi

echo -e "\n${G}Installing Hyprland and optional WM packages${N} ===========\n"
dnf_install_optional hyprland hypridle hyprlock hyprpolkitagent xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk waybar wofi cliphist swaync wlogout pyprland qtile qtile-extras \
    polybar gammastep wlsunset

dnf_install_optional awww zscroll autotiling

echo -e "\n${G}Installing Python packages${N} ===========\n"
install_python_user_tools

echo -e "\n${G}Enabling services${N} ===========\n"
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm bluetooth acpid NetworkManager.service
sudo systemctl enable docker.service 2>/dev/null \
    || echo -e "${Y}docker.service not enabled; Docker CE may not be installed.${N}"
sudo systemctl enable podman.socket 2>/dev/null || true

systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null \
    || echo -e "${Y}PipeWire user services not enabled now; they should start in the next graphical user session.${N}"

if [ ! -s /var/lib/pgsql/data/PG_VERSION ]; then
    sudo postgresql-setup --initdb 2>/dev/null \
        || echo -e "${Y}PostgreSQL initdb skipped or failed; run 'sudo postgresql-setup --initdb' before starting postgresql.service.${N}"
fi
sudo systemctl enable postgresql.service redis.service 2>/dev/null \
    || echo -e "${Y}PostgreSQL/Redis services not enabled; check package installation.${N}"

# Plymouth theme (updated command)
if command -v plymouth-set-default-theme &> /dev/null; then
    sudo plymouth-set-default-theme details -R 2>/dev/null || echo -e "${Y}Plymouth theme not set${N}"
fi

xdg-user-dirs-update

echo -e "
\n###############################################
${P}Copy final configuration and scripts${N}
###############################################
"

echo -e "${C}Creating backup of current '.config' directory...${N}"
[ -d "$HOME/.config" ] && cp -a "$HOME/.config" "$HOME/.config.bak"

echo -e "${C}Copying scripts, config, and .local...${N}"
copy_into_home .scripts "$HOME/.scripts"
copy_into_home .config "$HOME/.config"
copy_into_home .local "$HOME/.local"

echo -e "${C}Copying mousepad theme...${N}"
mkdir -p "$HOME/.local/share/gtksourceview-4/styles"
if [ -f "Themeing/mousepad/dracula.xml" ]; then
    cp -a Themeing/mousepad/dracula*.xml "$HOME/.local/share/gtksourceview-4/styles/" 2>/dev/null || true
fi

rm -rf catch 2>/dev/null || true

echo -e "
\n###############################################
${P}VSCodium${N}
###############################################
"

echo -e "\n${G}Adding VSCodium RPM repository${N} ===============\n"
if [ ! -f /etc/yum.repos.d/vscodium.repo ]; then
    sudo curl -fsSL -o /etc/yum.repos.d/vscodium.repo https://repo.vscodium.dev/vscodium.repo \
        || echo -e "${Y}Could not add VSCodium repo, codium install may fail.${N}"
else
    echo -e "${Y}vscodium.repo already present, skipping${N}"
fi
dnf_install_optional codium
install_vscodium_extensions

echo -e "
\n###############################################
${P}Theming LightDM${N}
###############################################
"

echo -e "${C}Copying LightDM config files${N}"
if [ -d "Themeing/lightdm" ]; then
    sudo cp -a Themeing/lightdm/dracula.png Themeing/lightdm/logo.png /usr/share/backgrounds/ 2>/dev/null || true
    sudo cp -a Themeing/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/ 2>/dev/null || true
    sudo cp -a Themeing/lightdm/slick-greeter.conf /etc/lightdm/ 2>/dev/null || true
fi

echo -e "
\n###############################################
${P}Updating theme, icons, fonts and wallpaper${N}
###############################################
"

echo -e "\n${G}Updating wallpaper${N} ===============\n"
sudo mkdir -p /usr/share/backgrounds/fantasy
if [ -d ".background" ]; then
    sudo cp -a .background/* /usr/share/backgrounds/fantasy/
    [ -f ".fehbg" ] && cp -a .fehbg "$HOME/"
fi

echo -e "\n${G}Updating theme and icons${N} ===============\n"
sudo dnf install -y gtk-murrine-engine gtk2-engines
if [ -f "theme_install.sh" ]; then
    chmod +x theme_install.sh
    ./theme_install.sh
else
    echo -e "${Y}theme_install.sh not found, skipping fonts${N}"
fi

echo -e "\n${G}Copying GTK and XFCE config files${N}"
[ -f "$HOME/.gtkrc-2.0" ] && mv "$HOME/.gtkrc-2.0" "$HOME/.gtkrc-2.0.bak"
[ -f "$HOME/.gtkrc-xfce" ] && mv "$HOME/.gtkrc-xfce" "$HOME/.gtkrc-xfce.bak"
cp -a .gtkrc-2.0 .gtkrc-2.0.mine .gtkrc-xfce "$HOME/" 2>/dev/null || true

echo -e "\n${G}Updating fonts${N}"
if [ -f "font_install.sh" ]; then
    chmod +x font_install.sh
    ./font_install.sh
else
    echo -e "${Y}font_install.sh not found, skipping fonts${N}"
fi

echo -e "
\n###############################################
${P}Installing GRUB theme${N}
###############################################
"

echo -e "${C}Installing Tela GRUB theme${N}"
if [ ! -d "grub2-themes" ]; then
    git clone https://github.com/vinceliuice/grub2-themes.git
fi
cd grub2-themes
sudo ./install.sh -t tela
cd "$SCRIPT_DIR"
rm -rf grub2-themes

echo -e "
\n###############################################
${P}Final ThinkPad Tweaks${N}
###############################################
"

echo -e "${C}Setting up ThinkPad / AMD sysfs tweaks (skipped if hardware paths missing)${N}"
thinkpad_tmpfiles=""
if [ -e /sys/devices/platform/thinkpad_acpi/leds/tpacpi::power/brightness ]; then
    thinkpad_tmpfiles+="w /sys/devices/platform/thinkpad_acpi/leds/tpacpi::power/brightness - - - - 0"$'\n'
else
    echo -e "${Y}thinkpad_acpi power LED not found — skipping LED brightness rule${N}"
fi
backlight_rule_added=0
for backlight in /sys/class/backlight/amdgpu_bl* /sys/class/backlight/*; do
    [ -e "$backlight/brightness" ] || continue
    max_brightness=$(<"$backlight/max_brightness")
    target_brightness=$((max_brightness * 60 / 100))
    thinkpad_tmpfiles+="w $backlight/brightness - - - - $target_brightness"$'\n'
    backlight_rule_added=1
    break
done
[ "$backlight_rule_added" -eq 1 ] \
    || echo -e "${Y}No backlight sysfs path found — skipping brightness rule${N}"
if [ -n "$thinkpad_tmpfiles" ]; then
    printf '%s' "$thinkpad_tmpfiles" | sudo tee /etc/tmpfiles.d/thinkpad-battery.conf > /dev/null
fi

echo -e "${C}Skipping unsafe AMDGPU ppfeaturemask override${N}"
echo -e "${Y}Use the kernel default unless you explicitly need AMDGPU overdrive controls.${N}"

echo -e "${C}Creating laptop optimization script${N}"
mkdir -p "$HOME/.scripts"
cat > "$HOME/.scripts/laptop-optimize.sh" <<'EOF'
#!/bin/bash
# Optimize laptop for battery life
sudo powertop --auto-tune
echo "Laptop optimized for battery life"
EOF
chmod +x "$HOME/.scripts/laptop-optimize.sh"

clear
command -v colorscript &> /dev/null && colorscript random || fastfetch

echo -e "
${R}###############################################
${N}########### Installation Complete ############
${G}###############################################

${Y}Installed Desktop Environments & WMs:${N}
✓ XFCE Desktop Environment (full DE)
✓ Hyprland stack (when COPR packages are available)
✓ Qtile Window Manager (when Fedora package is available)

${Y}Apps:${N}
✓ Kitty terminal
✓ Helium browser (via official COPR when available)
✓ VSCodium (codium)

${Y}ThinkPad E14 AMD Optimizations Applied:${N}
✓ TLP power management
✓ AMD GPU drivers (AMDGPU)
✓ AMD microcode updates
✓ Vulkan support for AMD
✓ Touchpad gestures enabled
✓ Natural scrolling enabled
✓ Fingerprint reader support
✓ ThinkPad charge thresholds configured when supported
✓ Better battery life tweaks (where hardware paths exist)

${Y}Node / fnm:${N}
✓ fnm + Node LTS (no distro nodejs/npm)
✓ corepack enabled (when Node is on PATH)

${Y}Tips:${N}
• At login screen, select your preferred WM/DE from the session menu
• XFCE: Full desktop with panel and apps
• Hyprland: waybar, swaync, pyprland, hypridle should autostart from config when installed
• Run 'sudo tlp-stat' to check TLP status
• Run 'sudo powertop' for power consumption analysis
• Use 'glxinfo | grep AMD' to verify GPU driver
• Check AMD GPU: 'lspci -k | grep -A 3 VGA'
• Use 'xinput list' to verify touchpad settings
• Fingerprint: Use 'fprintd-enroll' to setup
• Node: which node && node -v && fnm current

${R}Please reboot the system${N}
"
