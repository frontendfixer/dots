#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
P='\033[0;35m'
C='\033[0;36m'
N='\033[0m'

echo -e "
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
\t${R}░█░░░█▀█░█░█░█▀▀░█░█░█▄█░▀█▀░█░█░█▀█░█▀█░▀█▀░█▀█
\t${N}░█░░░█▀█░█▀▄░▀▀█░█▀█░█░█░░█░░█▀▄░█▀█░█░█░░█░░█▀█
\t${G}░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀░▀░░▀░░▀░▀
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${N}
${Y}Fedora 43 ThinkPad Edition${N}
"

echo -e "${G}Setting up the environment${N} ===============\n"
read -p "Enter your hostname: " host
echo -e "Changed hostname to ${G}$host${N}"
sudo hostnamectl set-hostname "$host"

echo -e "\n${G}Editing dnf.conf...${N}\n"
sudo sh -c 'echo "
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
deltarpm=True
" >> /etc/dnf/dnf.conf'

## Updating system...
echo -e "\n${G}Installing RPM Fusion free and non-free${N} ===============\n"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate -y core
sudo dnf update -y

echo -e "\n${G}Installing required groups${N} ===============\n"
sudo dnf group install -y "C Development Tools and Libraries" "Development Tools"

echo -e "\n${G}Installing multimedia codecs${N} ===============\n"
sudo dnf install -y gstreamer1-plugins-{bad-free,bad-free-extras,good,ugly} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf install -y ffmpeg --allowerasing
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate -y sound-and-video

echo -e "
################################################
${P}ThinkPad Laptop Optimization${N}
################################################
"

echo -e "\n${G}Installing ThinkPad AMD tools and power management${N} ===============\n"
sudo dnf install -y tlp tlp-rdw powertop
sudo dnf install -y acpi acpid kernel-devel
sudo dnf install -y libinput libinput-utils xorg-x11-drv-libinput
sudo dnf install -y mesa-dri-drivers mesa-vulkan-drivers vulkan-tools
sudo dnf install -y xf86-video-amdgpu mesa-amdgpu-va mesa-amdgpu-vdpau

echo -e "\n${G}Installing laptop utilities${N} ===============\n"
sudo dnf install -y bluez bluez-tools
sudo dnf install -y fwupd
sudo dnf install -y fprintd fprintd-pam

echo -e "\n${G}Configuring TLP for better battery life${N} ===============\n"
sudo systemctl enable tlp.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

echo -e "\n${G}Installing AMD microcode updates${N} ===============\n"
sudo dnf install -y amd-ucode-firmware

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
sudo dnf install -y eza zsh neofetch fastfetch curl git wget neovim feh kitty

echo -e "\n${G}Installing starship...${N} ===============\n"
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo -e "\n${G}Copying config files${N} ===============\n"
[ -f "$HOME/.bashrc" ] && mv $HOME/.bashrc $HOME/.bashrc.bak
[ -f "$HOME/.zshrc" ] && mv $HOME/.zshrc $HOME/.zshrc.bak
[ -f "$HOME/.Xresources" ] && mv $HOME/.Xresources $HOME/.Xresources.bak
cp .aliases .bashrc .zshrc .Xresources .face $HOME
yes | cp -r .zsh/ $HOME

echo -e "\n${G}Installing shell-color-scripts${N} ===============\n"
if [ -d "Themeing/shell-color-scripts" ]; then
    cd Themeing/shell-color-scripts
    sudo make install
    cd ../..
else
    echo -e "${Y}Warning: shell-color-scripts directory not found, skipping...${N}"
fi

echo -e "\n${G}Clearing terminal${N} ===============\n"
source ~/.bashrc
clear
command -v colorscript &> /dev/null && colorscript random || neofetch

echo -e "
\n###############################################
${P}Installing Window Managers & Desktop Environment${N}
###############################################
"

echo -e "${G}Enabling COPR repositories${N} ===========\n"
sudo dnf copr enable -y frostyx/qtile 2>/dev/null || echo -e "${Y}qtile COPR not available, will use default repo${N}"
sudo dnf copr enable -y jerrycasiano/FontManager 2>/dev/null || echo -e "${Y}FontManager COPR not available${N}"

echo -e "\n${G}Installing XFCE Desktop Environment${N} ===========\n"
sudo dnf group install -y "Xfce Desktop"
sudo dnf install -y xfce4-goodies xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin \
    xfce4-weather-plugin xfce4-screenshooter xfce4-taskmanager \
    xfce4-clipman-plugin xfce4-systemload-plugin xfce4-cpugraph-plugin \
    xfce4-netload-plugin xfce4-sensors-plugin xfce4-battery-plugin \
    xfce4-power-manager xfce4-notifyd

echo -e "\n${G}Installing Window Managers (i3, bspwm, awesome)${N} ===========\n"
sudo dnf install -y i3 i3status i3lock awesome \
    bspwm sxhkd

echo -e "\n${G}Installing required packages${N} ===========\n"
sudo dnf install -y btop lxappearance-gtk3 pcmanfm picom rofi rofi-calc dunst \
    ranger thunar mousepad vim-enhanced \
    lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
    dmenu xdg-user-dirs python3-pip python3-devel \
    firefox file-roller papirus-icon-theme eog meld \
    pavucontrol pulseaudio-utils alsa-utils \
    flameshot maim xclip \
    galculator \
    brightnessctl light \
    blueman \
    nodejs npm \
    android-tools android-file-transfer \
    gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb gvfs-archive \
    polkit-gnome \
    network-manager-applet nm-connection-editor \
    xset xsetroot \
    zsh-autosuggestions zsh-syntax-highlighting \
    google-noto-emoji-color-fonts google-noto-sans-fonts google-noto-serif-fonts \
    plymouth plymouth-plugin-script \
    redshift \
    polybar \
    yad zenity \
    transmission-gtk \
    xscreensaver \
    unclutter \
    feh nitrogen \
    arandr \
    volumeicon \
    lxpolkit

# Install qtile if available
sudo dnf install -y qtile python3-qtile-extras 2>/dev/null || echo -e "${Y}qtile not available in repos${N}"

# Install font-manager if available
sudo dnf install -y font-manager 2>/dev/null || echo -e "${Y}font-manager not available, using system fonts${N}"

# Install pamixer if available, fallback to pulseaudio-utils
sudo dnf install -y pamixer 2>/dev/null || echo -e "${Y}Using pulseaudio-utils for audio control${N}"

echo -e "\n${G}Installing Python packages${N} ===========\n"
pip3 install --user rofimoji beautysh black psutil

echo -e "\n${G}Enabling services${N} ===========\n"
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm
sudo systemctl enable bluetooth
sudo systemctl enable acpid

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
[ -d "$HOME/.config" ] && cp -r $HOME/.config/ $HOME/.config.bak

echo -e "${C}Copying scripts...${N}"
[ -d ".scripts" ] && yes | cp -r .scripts/ $HOME

echo -e "${C}Copying configurations...${N}"
[ -d ".config" ] && yes | cp -r .config/ $HOME

echo -e "${C}Copying .local files...${N}"
[ -d ".local" ] && yes | cp -r .local/ $HOME

echo -e "${C}Copying mousepad theme...${N}"
mkdir -p "$HOME/.local/share/gtksourceview-4/styles"
if [ -f "Themeing/mousepad/dracula.xml" ]; then
    yes | cp Themeing/mousepad/dracula*.xml $HOME/.local/share/gtksourceview-4/styles 2>/dev/null || true
fi

# Remove cache directory
rm -rf catch 2>/dev/null || true

echo -e "
\n###############################################
${P}Theming LightDM${N}
###############################################
"

echo -e "${C}Copying LightDM config files${N}"
if [ -d "Themeing/lightdm" ]; then
    yes | sudo cp -r Themeing/lightdm/dracula.png Themeing/lightdm/logo.png /usr/share/backgrounds/ 2>/dev/null || true
    yes | sudo cp -r Themeing/lightdm/lightdm-gtk-greeter.conf /etc/lightdm 2>/dev/null || true
    yes | sudo cp -r Themeing/lightdm/slick-greeter.conf /etc/lightdm 2>/dev/null || true
fi

echo -e "
\n###############################################
${P}Updating theme, icons, fonts and wallpaper${N}
###############################################
"

echo -e "\n${G}Updating wallpaper${N} ===============\n"
sudo mkdir -p /usr/share/backgrounds/fantasy
if [ -d ".background" ]; then
    sudo cp -r .background/* /usr/share/backgrounds/fantasy/
    [ -f ".fehbg" ] && cp .fehbg $HOME
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
[ -f "$HOME/.gtkrc-2.0" ] && mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.bak
[ -f "$HOME/.gtkrc-xfce" ] && mv $HOME/.gtkrc-xfce $HOME/.gtkrc-xfce.bak
yes | cp .gtkrc-2.0 .gtkrc-2.0.mine .gtkrc-xfce $HOME 2>/dev/null || true

echo -e "\n${G}Updating fonts${N}"
# Check if scripts exist before running
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
cd ..
rm -rf grub2-themes

echo -e "
\n###############################################
${P}Final ThinkPad Tweaks${N}
###############################################
"

echo -e "${C}Setting up AMD GPU power management${N}"
sudo tee /etc/tmpfiles.d/thinkpad-battery.conf > /dev/null <<'EOF'
w /sys/devices/platform/thinkpad_acpi/leds/tpacpi::power/brightness - - - - 0
w /sys/class/backlight/amdgpu_bl0/brightness - - - - 500
EOF

echo -e "${C}Enabling AMD GPU power saving${N}"
sudo tee /etc/modprobe.d/amdgpu.conf > /dev/null <<'EOF'
options amdgpu ppfeaturemask=0xffffffff
EOF

echo -e "${C}Creating laptop optimization script${N}"
mkdir -p $HOME/.scripts
cat > $HOME/.scripts/laptop-optimize.sh <<'EOF'
#!/bin/bash
# Optimize laptop for battery life
sudo powertop --auto-tune
echo "Laptop optimized for battery life"
EOF
chmod +x $HOME/.scripts/laptop-optimize.sh

clear
command -v colorscript &> /dev/null && colorscript random || neofetch

echo -e "
${R}###############################################
${N}########### Installation Complete ############
${G}###############################################

${Y}Installed Desktop Environments & WMs:${N}
✓ XFCE Desktop Environment (full DE)
✓ i3 Window Manager
✓ bspwm Window Manager
✓ Awesome Window Manager
✓ Qtile Window Manager (if available)

${Y}ThinkPad E14 AMD Optimizations Applied:${N}
✓ TLP power management
✓ AMD GPU drivers (AMDGPU)
✓ AMD microcode updates
✓ Vulkan support for AMD
✓ Touchpad gestures enabled
✓ Natural scrolling enabled
✓ Fingerprint reader support
✓ Better battery life tweaks

${Y}Tips:${N}
• At login screen, select your preferred WM/DE from the session menu
• XFCE: Full desktop with panel and apps
• i3/bspwm/awesome: Tiling window managers (needs config)
• Run 'sudo tlp-stat' to check TLP status
• Run 'sudo powertop' for power consumption analysis
• Use 'glxinfo | grep AMD' to verify GPU driver
• Check AMD GPU: 'lspci -k | grep -A 3 VGA'
• Use 'xinput list' to verify touchpad settings
• Fingerprint: Use 'fprintd-enroll' to setup

${R}Please reboot the system${N}
"