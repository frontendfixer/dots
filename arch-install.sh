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
    [ -f arch-install.sh ] && [ -d .config ] \
        || die "Run from the dots repo root (arch-install.sh and .config must exist)."
}

require_not_root() {
    [ "$EUID" -ne 0 ] || die "Run as your regular user, not with sudo."
}

require_sudo() {
    sudo -v || die "sudo is required."
}

ensure_curl() {
    if command -v curl &>/dev/null; then
        return 0
    fi
    echo -e "${G}Installing curl for network checks and bootstrap downloads...${N}"
    sudo pacman -Syu --needed --noconfirm curl \
        || die "curl is required and could not be installed."
}

require_network() {
    curl -fsSL --max-time 15 -o /dev/null https://archlinux.org \
        || die "Network check failed (could not reach archlinux.org)."
}

append_pacman_conf_if_missing() {
    local marker="# dots-arch-install optimizations"
    if sudo grep -qF "$marker" /etc/pacman.conf 2>/dev/null; then
        echo -e "${Y}pacman.conf already contains dots-arch-install block, skipping.${N}"
        return 0
    fi
    sudo sed -i "/^\[options\]/a $marker\nParallelDownloads = 10" /etc/pacman.conf
}

enable_multilib_if_needed() {
    if grep -qE '^\[multilib\]' /etc/pacman.conf 2>/dev/null; then
        return 0
    fi
    if grep -qE '^#\[multilib\]' /etc/pacman.conf 2>/dev/null; then
        echo -e "${G}Enabling multilib repository...${N}"
        sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
        sudo pacman -Sy --noconfirm
    fi
}

install_paru_if_missing() {
    if command -v paru &>/dev/null; then
        return 0
    fi
    echo -e "${G}Installing paru (AUR helper)...${N}"
    sudo pacman -S --needed --noconfirm base-devel git
    local tmpdir
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
    (cd "$tmpdir/paru" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
}

pacman_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

aur_install() {
    paru -S --needed --noconfirm "$@" \
        || {
            echo -e "${Y}AUR install failed for: $*${N}"
            AUR_FAILED+=("$*")
            return 1
        }
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

install_python_user_tools() {
    local venv="$HOME/.local/share/dots-python-tools"
    local bin_dir="$HOME/.local/bin"

    mkdir -p "$bin_dir"
    python -m venv "$venv"
    "$venv/bin/python" -m pip install --upgrade pip
    "$venv/bin/python" -m pip install rofimoji beautysh black psutil

    for tool in rofimoji beautysh black; do
        if [ -x "$venv/bin/$tool" ]; then
            ln -sf "$venv/bin/$tool" "$bin_dir/$tool"
        fi
    done
}

patch_x11_polkit_autostarts() {
    local polkit_sh_loop
    polkit_sh_loop='for agent in /usr/libexec/polkit-gnome-authentication-agent-1 /usr/libexec/polkit-mate-authentication-agent-1 /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1; do if [ -x "$agent" ]; then "$agent" & break; fi; done'

    local awesome_autostart="$HOME/.config/awesome/autostart.sh"
    if [ -f "$awesome_autostart" ]; then
        sed -i '/policykit-1-gnome\/polkit-gnome-authentication-agent-1/d' "$awesome_autostart"
        sed -i '/#Fedora/d' "$awesome_autostart"
        sed -i '/#\/usr\/lib\/polkit-gnome/d' "$awesome_autostart"
        sed -i "/^nm-applet &$/a $polkit_sh_loop" "$awesome_autostart"
    fi

    local bspwmrc="$HOME/.config/bspwm/bspwmrc"
    if [ -f "$bspwmrc" ]; then
        sed -i '/policykit-1-gnome\/polkit-gnome-authentication-agent-1/d' "$bspwmrc"
        sed -i '/#Fedora/d' "$bspwmrc"
        sed -i '/#\/usr\/lib\/polkit-gnome/d' "$bspwmrc"
        sed -i "/^nm-applet &$/a $polkit_sh_loop" "$bspwmrc"
    fi

    local i3_config="$HOME/.config/i3/config"
    if [ -f "$i3_config" ]; then
        sed -i 's|exec --no-startup-id  /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &|exec --no-startup-id sh -c '"'"'for a in /usr/libexec/polkit-gnome-authentication-agent-1 /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1; do [ -x "$a" ] && exec "$a"; done'"'"' \&|' "$i3_config"
    fi
}

init_postgresql_if_needed() {
    local pgdata="/var/lib/postgres/data"
    if [ ! -d "$pgdata" ] || [ -z "$(ls -A "$pgdata" 2>/dev/null)" ]; then
        echo -e "${G}Initializing PostgreSQL database cluster...${N}"
        sudo -iu postgres initdb -D "$pgdata" 2>/dev/null \
            || echo -e "${Y}PostgreSQL init skipped (may already be initialized)${N}"
    fi
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"
AUR_FAILED=()
require_repo_root
require_not_root
require_sudo
ensure_curl
require_network

echo -e "
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
\t${R}░█░░░█▀█░█░█░█▀▀░█░█░█▄█░▀█▀░█░█░█▀█░█▀█░▀█▀░█▀█
\t${N}░█░░░█▀█░█▀▄░▀▀█░█▀█░█░█░░█░░█▀▄░█▀█░█░█░░█░░█▀█
\t${G}░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀░▀░░▀░░▀░▀
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${N}
${Y}Arch Linux ThinkPad Edition${N}
"

echo -e "${G}Setting up the environment${N} ===============\n"
read -r -p "Enter your hostname: " host
echo -e "Changed hostname to ${G}$host${N}"
sudo hostnamectl set-hostname "$host"

echo -e "\n${G}Editing pacman.conf...${N}\n"
append_pacman_conf_if_missing

echo -e "\n${G}Updating system...${N} ===============\n"
sudo pacman -Syu --noconfirm

install_paru_if_missing

echo -e "\n${G}Installing base development tools${N} ===============\n"
pacman_install base-devel gcc make openssl pkgconf python python-pip

echo -e "\n${G}Installing multimedia codecs${N} ===============\n"
pacman_install ffmpeg gst-libav gst-plugins-base gst-plugins-good \
    gst-plugins-ugly gst-plugins-bad lame libmad

echo -e "
################################################
${P}ThinkPad Laptop Optimization${N}
################################################
"

enable_multilib_if_needed

echo -e "\n${G}Installing ThinkPad AMD tools and power management${N} ===============\n"
pacman_install tlp tlp-rdw powertop acpi acpid linux-headers libinput \
    xf86-input-libinput mesa vulkan-radeon vulkan-tools \
    libva-utils libva-mesa-driver
pacman_install lib32-vulkan-radeon \
    || echo -e "${Y}lib32-vulkan-radeon not installed (multilib may be unavailable)${N}"

echo -e "\n${G}Installing laptop utilities${N} ===============\n"
pacman_install bluez bluez-utils fwupd fprintd

echo -e "\n${G}Configuring TLP for better battery life${N} ===============\n"
sudo systemctl enable tlp.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket 2>/dev/null || true

echo -e "\n${G}Installing AMD microcode updates${N} ===============\n"
pacman_install amd-ucode

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
pacman_install zsh fish fastfetch curl git wget neovim feh kitty

echo -e "
################################################
${P}Web development (fnm)${N}
################################################
"

echo -e "\n${G}Installing optional web-dev tools${N} ===============\n"
for pkg in git-lfs github-cli jq tmux; do
    pacman_install "$pkg" \
        || echo -e "${Y}$pkg not available, skipping${N}"
done

echo -e "\n${G}Installing container and database tooling${N} ===============\n"
pacman_install docker docker-compose podman podman-compose postgresql redis

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
for dotfile in .aliases .bashrc .zshrc .Xresources .face; do
    copy_into_home "$dotfile" "$HOME/"
done
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
command -v colorscript &> /dev/null && colorscript random || fastfetch

echo -e "
\n###############################################
${P}Installing Window Managers${N}
###############################################
"

echo -e "\n${G}Installing PipeWire audio stack${N} ===========\n"
pacman_install pipewire pipewire-pulse pipewire-alsa wireplumber \
    pamixer pavucontrol alsa-utils

echo -e "\n${G}Installing window managers and desktop utilities${N} ===========\n"
pacman_install \
    xorg-server xorg-xinit xorg-xset xorg-xsetroot xorg-xrandr arandr \
    lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
    hyprland hypridle hyprlock awesome i3 i3blocks bspwm sxhkd qtile \
    polybar picom dunst rofi waybar swaync wlogout swappy \
    btop lxappearance pcmanfm thunar ranger mousepad vim \
    firefox file-roller eog meld flameshot maim xclip scrot \
    galculator brightnessctl light blueman android-tools \
    gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb gvfs-afc nfs \
    polkit-gnome network-manager-applet nm-connection-editor \
    eza dmenu xdg-user-dirs papirus-icon-theme \
    redshift yad zenity transmission-gtk xscreensaver unclutter \
    feh nitrogen numlockx volumeicon plymouth \
    gtk-engine-murrine gtk-engines \
    noto-fonts noto-fonts-emoji \
    swww wl-clipboard cliphist xdg-desktop-portal-hyprland \
    wlsunset gammastep dex xfce4-power-manager \
    zsh-autosuggestions zsh-syntax-highlighting

echo -e "\n${G}Installing AUR packages (paru)${N} ===========\n"
for aur_pkg in vscodium-bin qtile-extras pyprland wallust clipit autotiling ags; do
    aur_install "$aur_pkg" || true
done
aur_install android-file-transfer \
    || echo -e "${Y}android-file-transfer not installed (gvfs-mtp may be sufficient)${N}"

echo -e "\n${G}Installing Python packages${N} ===========\n"
install_python_user_tools

echo -e "\n${G}Enabling services${N} ===========\n"
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm bluetooth acpid docker
init_postgresql_if_needed
sudo systemctl enable --now postgresql redis 2>/dev/null \
    || echo -e "${Y}postgresql/redis enable skipped${N}"
sudo usermod -aG docker "$USER" 2>/dev/null \
    || echo -e "${Y}Could not add $USER to docker group${N}"

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

echo -e "${C}Patching polkit autostart paths for Arch...${N}"
patch_x11_polkit_autostarts

echo -e "${C}Copying mousepad theme...${N}"
mkdir -p "$HOME/.local/share/gtksourceview-4/styles"
if [ -f "Themeing/mousepad/dracula.xml" ]; then
    cp -a Themeing/mousepad/dracula*.xml "$HOME/.local/share/gtksourceview-4/styles/" 2>/dev/null || true
fi

rm -rf catch 2>/dev/null || true

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
if [ -f "theme_install.sh" ]; then
    chmod +x theme_install.sh
    ./theme_install.sh
else
    echo -e "${Y}theme_install.sh not found, skipping themes${N}"
fi

echo -e "\n${G}Copying GTK config files${N}"
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
if [ -d /sys/class/backlight/amdgpu_bl0 ]; then
    thinkpad_tmpfiles+="w /sys/class/backlight/amdgpu_bl0/brightness - - - - 500"$'\n'
else
    echo -e "${Y}amdgpu_bl0 backlight not found — skipping (different GPU/panel)${N}"
fi
if [ -n "$thinkpad_tmpfiles" ]; then
    printf '%s' "$thinkpad_tmpfiles" | sudo tee /etc/tmpfiles.d/thinkpad-battery.conf > /dev/null
fi

echo -e "${C}Enabling AMD GPU power saving${N}"
sudo tee /etc/modprobe.d/amdgpu.conf > /dev/null <<'EOF'
options amdgpu ppfeaturemask=0xffffffff
EOF

echo -e "${C}Creating laptop optimization script${N}"
mkdir -p "$HOME/.scripts"
cat > "$HOME/.scripts/laptop-optimize.sh" <<'EOF'
#!/bin/bash
# Optimize laptop for battery life
sudo powertop --auto-tune
echo "Laptop optimized for battery life"
EOF
chmod +x "$HOME/.scripts/laptop-optimize.sh"

if [ "${#AUR_FAILED[@]}" -gt 0 ]; then
    echo -e "\n${Y}AUR packages that failed to install:${N}"
    printf ' - %s\n' "${AUR_FAILED[@]}"
fi

clear
command -v colorscript &> /dev/null && colorscript random || fastfetch

echo -e "
${R}###############################################
${N}########### Installation Complete ############
${G}###############################################

${Y}Installed Window Managers:${N}
✓ Hyprland (Wayland)
✓ Qtile (+ qtile-extras via AUR)
✓ i3 (+ i3blocks, autotiling)
✓ AwesomeWM
✓ BSPWM (+ sxhkd)

${Y}Audio:${N}
✓ PipeWire + WirePlumber (pamixer/pavucontrol)

${Y}AUR (paru):${N}
✓ vscodium-bin, pyprland, wallust, clipit, autotiling, ags

${Y}ThinkPad E14 AMD Optimizations Applied:${N}
✓ TLP power management
✓ AMD GPU drivers (AMDGPU)
✓ AMD microcode updates
✓ Vulkan support for AMD
✓ Touchpad gestures enabled
✓ Natural scrolling enabled
✓ Fingerprint reader support
✓ Better battery life tweaks (where hardware paths exist)

${Y}Node / fnm:${N}
✓ fnm + Node LTS (no distro nodejs/npm)
✓ corepack enabled (when Node is on PATH)

${Y}Arch-specific notes:${N}
• PostgreSQL initialized if cluster was empty; services enabled
• User added to docker group (log out/in for docker without sudo)
• Polkit autostart paths patched for awesome/i3/bspwm
• Optional AUR browser: helium (not installed by default)

${Y}Tips:${N}
• At login screen, select your preferred WM from the session menu
• Hyprland: waybar, swaync, swww, hypridle should autostart from config
• i3/awesome/bspwm: polybar, picom, dunst configured in dotfiles
• Run 'sudo tlp-stat' to check TLP status
• Run 'sudo powertop' for power consumption analysis
• Use 'glxinfo | grep AMD' to verify GPU driver
• Check AMD GPU: 'lspci -k | grep -A 3 VGA'
• Use 'xinput list' to verify touchpad settings
• Fingerprint: Use 'fprintd-enroll' to setup
• Node: which node && node -v && fnm current

${R}Please reboot the system${N}
"
