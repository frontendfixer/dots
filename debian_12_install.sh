#!/usr/bin/env bash

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;32m'
B='\033[0;34m'
P='\033[0;35m'
C='\033[0;36m'
N='\033[0m'
echo -e "
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
\t${R}░█░░░█▀█░█░█░█▀▀░█░█░█▄█░▀█▀░█░█░█▀█░█▀█░▀█▀░█▀█
\t${N}░█░░░█▀█░█▀▄░▀▀█░█▀█░█░█░░█░░█▀▄░█▀█░█░█░░█░░█▀█
\t${G}░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀░▀░░▀░░▀░▀
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${N}\n"

## updateing system...
echo -e "\n${G}updateing system...${N} ===============\n"
sudo apt update && sudo apt upgrade -y

echo -e "\n${G}installing ${R}nala${N} ===============\n"
sudo apt install nala -y
#sudo nala fetch

echo -e "
################################################
${P}Initialized basic theming${N}
################################################
"
# ============ terminal settings ==============
echo -e "\n${G}installing packages${N} ===============\n"
sudo apt install -y exa zsh fish neofetch htop curl git wget kitty

echo -e "\n${G}installing starship....${N} ===============\n"
curl -sS https://starship.rs/install.sh | sh

# ======= Shell-Color-Script  ========
echo -e "\n${G}Installing shell-color-scripts${N} ===============\n"
echo -e  "${C}You can download the source code from this repository or use a git clone:
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
${N}"

cd Themeing/shell-color-scripts
sudo make install
cd ../..

echo -e "\n${G}copying config file${N} ===============\n"
mv $HOME/.bashrc $HOME/.bashrc.bak
mv $HOME/.zshrc $HOME/.zshrc.bak
mv $HOME/.Xresources $HOME/.Xresources.bak
cp .aliases .bashrc .zshrc .Xresources .face $HOME
yes | cp -r .zsh/ $HOME

echo -e "\n${G}clearing termiinal${N} ===============\n"
source ~/.bashrc
clear;colorscript random


echo -e "
\n###############################################
${P}Installing Window manager ${N}
###############################################
"
sudo apt install -y unzip build-essential xorg xbacklight xbindkeys xvkbd xinput

mkdir cache

# ============ BSPWM =============
echo -e "${G}Installing BSPWM ...${N} ===============\n"
sudo apt install -y bspwm suckless-tools sxhkd polybar dunst

mkdir -p ~/.config/{bspwm,sxhkd,dunst}

install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc

# ============ Qtile =============
echo -e "${G}Installing Qtile ...${N} ===============\n"

sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED

sudo apt install -y python3-full python3-pip libpangocairo-1.0-0 python3-cffi python3-xcffib

pip install --no-cache-dir cairocffi

cd cache

# Clone the Qtile Source Code from GitHub
git clone https://github.com/qtile/qtile.git

# Install Qtile
cd qtile
pip install .

# Install psutil
pip install psutil

# Install Qtile-Extras
cd ..
git clone https://github.com/elParaguayo/qtile-extras.git
cd qtile-extras
sudo python3 setup.py install


# Adding qtile.desktop to Lightdm xsessions directory
cat > ./temp << "EOF"
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Type=Application
Keywords=wm;tiling
EOF
sudo cp ./temp /usr/share/xsessions/qtile.desktop;rm ./temp
u=$USER
sudo echo "Exec=/home/$u/.local/bin/qtile start" | sudo tee -a /usr/share/xsessions/qtile.desktop

cd ../..

# ============ AwesomeWM =============
echo -e "${G}Installing AwesomeWM ...${N} ===============\n"
sudo apt install -y awesome

echo -e "
\n###############################################
${P}Updating theme, icons and wallpaper ${N}
###############################################
"
echo -e "\n${G}updating wallpaer${N} ===============\n"
echo $pw | sudo -S mkdir -p /usr/share/backgrounds/fantacy
echo $pw | sudo -S cp -r .background/* /usr/share/backgrounds/fantacy/

echo -e "${G}Updating theme and icons${N} ===============\n"
sudo apt install gtk2-engines-murrine gtk2-engines-pixbuf
sudo ./theme_install.sh

echo -e "\ncopying config file for ${G}gtkrc-2.0${N}"
mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.bak
yes | cp .gtkrc-2.0 .gtkrc-2.0.mine .gtkrc-xfce $HOME

echo -e "
\n###############################################
${P}Installing Essentials Packages ${N}
###############################################
"
# Network File Tools/System Events
sudo apt install -y dialog mtools dosfstools gvfs gvfs-backends xfce4-power-manager policykit-1-gnome network-manager network-manager-gnome linux-headers-amd64

sudo mv /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak

echo "
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true

[device]
wifi.scan-rand-mac-address=no
" | sudo tee -a /etc/NetworkManager/NetworkManager.conf 

sudo systemctl enable NetworkManager.service
sudo service NetworkManager restart 

# Sound packages
sudo apt install -y pulseaudio alsa-utils pavucontrol volumeicon-alsa pamixer

# Appearance management
sudo apt install -y lxappearance 

# Fonts and icons for now
sudo apt install -y fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus fonts-beng fonts-lohit-beng-bengali
./font_install.sh

# Bluetooth 
sudo apt install -y bluez blueman
sudo systemctl enable bluetooth

# Packages needed for window manager installation
sudo apt install -y picom rofi libnotify-bin unzip pcmanfm ranger xserver-xorg-input-synaptics

# Install Lightdm Console Display Manager
sudo apt install -y lightdm lightdm-settings
sudo systemctl enable lightdm

# Browsers (Firefox and Chromium)
sudo sh -c 'echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list'

sudo sh -c 'echo "
Package: *
Pin: release a=bookworm
Pin-Priority: 500

Package: firefox
Pin: release a=unstable
Pin-Priority: 900

Package: *
Pin: release a=unstable
Pin-Priority: 100
" >> /etc/apt/preferences'

sudo apt update && sudo apt install -y chromium chromium-l10n
sudo apt install -y firefox firefox-l10n-all -t unstable

# GUI Editors (VSCodium, mousepad)
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

sudo apt update && sudo apt install -y codium mousepad

# Other Essential packages
sudo apt install -y file-roller eog meld scrot galculator xdg-user-dirs brightnessctl light npm font-manager gnome-characters feh synaptic telegram-desktop vlc gparted adb fastboot android-file-transfer clipit numlockx papirus-icon-theme zsh-autosuggestions zsh-syntax-highlighting gimp gcolor3 fonts-noto-color-emoji node-emoji python3-emoji tlp tlp-rdw redshift yad transmission xscreensaver unclutter evince libreoffice-writer libreoffice-calc libreoffice-help-en-gb libreoffice-help-en-us libreoffice-l10n-bn hyphen-bn 

# Enable Services
sudo systemctl enable tlp
xdg-user-dirs-update

echo -e "
\n###############################################
${P}Copy final configaration and scripts${N}
###############################################
"
echo -e "${C}created a backup of current '.config' directory.....${N}"
cp -r $HOME/.config/ $HOME/.config.bak
echo -e "${C}copying scripts.....${N}"
yes | cp -r .scripts/ $HOME
echo -e "${C}copying configarations.....${N}"
yes | cp -r .config/ $HOME
echo -e "${C}copying .local files.....${N}"
yes | cp -r .local/ $HOME

echo -e "${C}copying mousepad theme....${N}"
mkdir -p "$HOME/.local/share/gtksourceview-4/styles"
yes|cp  Themeing/mousepad/dracula.xml Themeing/mousepad/draculaDarker.xml $HOME/.local/share/gtksourceview-4/styles

echo -e "${C}copying lightdm config file${N}"
yes | sudo cp -r Themeing/lightdm/dracula.png Themeing/lightdm/logo.png /usr/share/backgrounds/
yes | sudo cp -r Themeing/lightdm/lightdm-gtk-greeter.conf /etc/lightdm
yes | sudo cp -r Themeing/lightdm/slick-greeter.conf /etc/lightdm

######removimg cache directory
rm -rf cache

echo -e "
\n###############################################
${P}Installing grub theme ${N}
###############################################
"
echo -e "${C}copying grub config file${N}"
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
sudo ./install.sh -t tela
cd ..
rm -rf grub2-themes

clear;colorscript random
echo -e "
${R}###############################################
${N}########### Installations complete ############
${G}###############################################
"
echo -e "${R}Please reboot the system${N}"