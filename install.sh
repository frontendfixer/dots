#!/bin/bash

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
# updateing system...
echo -e "${G}updateing system${N} ===============\n"
sudo dnf update -y
sudo dnf group install -y "C Development Tools and Libraries"
sudo dnf group install -y "Development Tools"
sudo dnf group install -y "Fonts"

echo -e "
###############################################
${P}Initialized therminal theming
###############################################
"
# terminal settings
echo -e "\n${G}installing packages${N} ===============\n"
sudo dnf install -y exa zsh fish neofetch curl git wget neovim feh kitty

echo -e "\n${G}installing starship....${N} ===============\n"
#curl -sS https://starship.rs/install.sh | sh

echo -e "\n${G}copying config file${N} ===============\n"
mv $HOME/.bashrc $HOME/.bashrc.bak
mv $HOME/.zshrc $HOME/.zshrc.bak
mv $HOME/.Xresources $HOME/.Xresources.bak
cp .aliases .bashrc .zshrc .Xresources .face $HOME
cp -r .zsh/ $HOME
cp -r .config/kitty $HOME/.config
cp -r .config/fish $HOME/.config
cp .config/starship.toml

echo -e "\n${G}updating wallpaer${N} ===============\n"
sudo mkdir -p /usr/share/backgrounds/fantacy
sudo cp -r .background/* /usr/share/backgrounds/fantacy/
cp .fehbg $HOME

echo -e "
++++++++++++++++++
Installing betterlockscreen.....
installation script can be found here[https://github.com/betterlockscreen/betterlockscreen#installation]
++++++++++++++++
"
sudo dnf install -y ImageMagick xset xrdb xdpyinfo xrandr autoconf automake cairo-devel fontconfig gcc libev-devel libjpeg-turbo-devel libXinerama libxkbcommon-devel libxkbcommon-x11-devel libXrandr pam-devel pkgconf xcb-util-image-devel xcb-util-xrm-devel

mkdir catch
cd catch
echo -e "#### installing i3lock-color "
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./install-i3lock-color.sh

echo -e "#### installing betterlockscreen"
cd ..
wget https://github.com/betterlockscreen/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip

cd betterlockscreen-main/
chmod u+x betterlockscreen
sudo cp betterlockscreen /usr/local/bin/

sudo cp system/betterlockscreen@.service /usr/lib/systemd/system/
sudo systemctl enable betterlockscreen@$USER
cd ../..
betterlockscreen -u /usr/share/backgrounds/fantacy/wal28.jpg

echo -e "
\n###############################################
${P}Updating theme icons fonts and wallpaper
###############################################
"
echo -e "
\n${G}Updating theme and icons${N} ===============\n"
echo -e "copying icons and themes"
cp -r .icons/ $HOME
cp -r .themes/ $HOME
echo -e "\ncopying config file for ${G}gtkrc-2.0${N}"
mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.bak
cp .gtkrc-2.0 .gtkrc-2.0.mine .gtkrc-xfce $HOME

echo -e "\n${G}updateing fonts${N}"
mkdir -p $HOME/.local/share/fonts
cp -r .fonts/* $HOME/.local/share/fonts
fc-cache -v $HOME/.local/share/fonts


echo -e "
\n###############################################
${P}Installing Window manager
###############################################
"
sudo dnf copr enable frostyx/qtile
sudo dnf copr enable david35mm/pamixer

echo -e "${R}installing require packages${N} ===========\n"
sudo dnf install htop pcmanfm picom ranger rofi dmenu python3-pip mousepad xarchiver eog meld pavucontrol scrot galculator brightnessctl qtile pamixer qtile-extras nodejs blueman

sudo dnf copr remove frostyx/qtile
sudo dnf copr remove david35mm/pamixer

echo -e "
\n###############################################
${P}Copy final configaration
###############################################
"
echo -e "copying alacritty....."
yes|cp -r .config/alacritty $HOME/.config 
echo -e "copying fish....."
yes|cp -r .config/fish $HOME/.config 
echo -e "copying gtk....."
yes|cp -r .config/gtk-3.0 $HOME/.config 
echo -e "copying htop....."
yes|cp -r .config/htop $HOME/.config 
echo -e "copying kitty....."
yes|cp -r .config/kitty $HOME/.config 
echo -e "copying neofetch....."
yes|cp -r .config/neofetch $HOME/.config 
echo -e "copying nvim....."
yes|cp -r .config/nvim $HOME/.config 
echo -e "copying pcmanfm....."
yes|cp -r .config/pcmanfm $HOME/.config 
echo -e "copying picom....."
yes|cp -r .config/picom $HOME/.config 
echo -e "copying qtile....."
yes|cp -r .config/qtile $HOME/.config 
echo -e "copying ranger....."
yes|cp -r .config/ranger $HOME/.config 
echo -e "copying rofi....."
yes|cp -r .config/rofi $HOME/.config 
echo -e "copying betterlockscreen....."
yes|cp .config/.betterlockscreenrc $HOME/.config 

#######removimg catch directory
rm-rf catch

echo -e "
\n###############################################
${P}Installations compleate
###############################################
"