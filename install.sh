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
echo -e "${R}Enter your password here,
it will be saved only for this operation
so that you don't need to type it manually every time${N}"
IFS= read -r -s -p 'Password: ' pw

echo -e "${G}setting up the envirenment ${N} ===============\n"
read -p "Enter your hostname: " host
echo -e "Changed hostname to ${G}$host${N}"
echo $pw | sudo -S hostnamectl set-hostname "$host"

echo -e "\n editing ${G}dnf.conf....${N} \n"
echo $pw | sudo -S sh -c 'echo "fastestmirror=True" >>/etc/dnf/dnf.conf'
echo $pw | sudo -S sh -c 'echo "max_parallel_downloads=5" >>/etc/dnf/dnf.conf'
echo $pw | sudo -S sh -c 'echo "defaultyes=True" >>/etc/dnf/dnf.conf'
echo $pw | sudo -S sh -c 'echo "deltarpm=True" >>/etc/dnf/dnf.conf'

## updateing system...
echo -e "\n${G}installing RPM free and non-free${N} ===============\n"
echo $pw | sudo -S dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
echo $pw | sudo -S dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo $pw | sudo -S dnf group update core
echo $pw | sudo -S dnf update -y
echo $pw | sudo -S dnf group install -y "C Development Tools and Libraries"
echo $pw | sudo -S dnf group install -y "Fonts"

echo -e "${G}installing multimedia codac${N} ===============\n"
echo $pw | sudo -S dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
echo $pw | sudo -S dnf install -y lame\* --exclude=lame-devel
echo $pw | sudo -S dnf -y group upgrade --with-optional Multimedia

echo -e "
################################################
${P}Initialized therminal theming${N}
################################################
"
## terminal settings
echo -e "\n${G}installing packages${N} ===============\n"
echo $pw | sudo -S dnf install -y exa zsh fish neofetch curl git wget neovim feh kitty

echo -e "\n${G}installing starship....${N} ===============\n"
curl -sS https://starship.rs/install.sh | sh

echo -e "\n${G}copying config file${N} ===============\n"
mv $HOME/.bashrc $HOME/.bashrc.bak
mv $HOME/.zshrc $HOME/.zshrc.bak
mv $HOME/.Xresources $HOME/.Xresources.bak
cp .aliases .bashrc .zshrc .Xresources .face $HOME
yes | cp -r .zsh/ $HOME
yes | cp -r .config/kitty $HOME/.config
yes | cp -r .config/fish $HOME/.config
cp .config/starship.toml

echo -e "\n${G}Installing shell-color-scripts${N} ===============\n"
echo -e  "${C}You can download the source code from this repository or use a git clone:
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
${N}"
cd Theaming/shell-color-scripts
echo $pw | sudo -S make install

echo -e "\n${G}clearing termiinal${N} ===============\n"
clear;colorscript random

echo -e "\n${G}updating wallpaer${N} ===============\n"
echo $pw | sudo -S mkdir -p /usr/share/backgrounds/fantacy
echo $pw | sudo -S cp -r .background/* /usr/share/backgrounds/fantacy/
cp .fehbg $HOME

echo -e "
${R}++++++++++++++++++
Installing betterlockscreen.....
installation script can be found here[https://github.com/betterlockscreen/betterlockscreen#installation]
++++++++++++++++${N}
"
echo $pw | sudo -S dnf install -y ImageMagick xset xrdb xdpyinfo xrandr autoconf automake cairo-devel fontconfig gcc libev-devel libjpeg-turbo-devel libXinerama libxkbcommon-devel libxkbcommon-x11-devel libXrandr pam-devel pkgconf xcb-util-image-devel xcb-util-xrm-devel

mkdir catch
cd catch
echo -e "${C}#### installing i3lock-color${N}"
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./install-i3lock-color.sh

echo -e "${C}#### installing betterlockscreen${N}"
cd ..
wget https://github.com/betterlockscreen/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip

cd betterlockscreen-main/
chmod u+x betterlockscreen
echo $pw | sudo -S cp betterlockscreen /usr/local/bin/

echo $pw | sudo -S cp system/betterlockscreen@.service /usr/lib/systemd/system/
echo $pw | sudo -S systemctl enable betterlockscreen@$USER
cd ../..
betterlockscreen -u /usr/share/backgrounds/fantacy/wal28.jpg

echo -e "
\n###############################################
${P}Updating theme icons fonts and wallpaper ${N}
###############################################
"
echo -e "${G}Updating theme and icons${N} ===============\n"
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
${P}Installing Window manager ${N}
###############################################
"
echo $pw | sudo -S dnf copr enable frostyx/qtile
echo $pw | sudo -S dnf copr enable david35mm/pamixer

echo -e "${R}installing require packages${N} ===========\n"
echo $pw | sudo -S dnf install -y htop pcmanfm picom ranger mousepad rofi dmenu python3-pip mousepad file-roller eog meld pavucontrol scrot galculator brightnessctl qtile pamixer qtile-extras nodejs blueman telegram-desktop vlc android-tools android-file-transfer polkit-gnome clipit numlockx xset chromium codium gnome-clocks network-manager-applet papirus-icon-theme zsh-autosuggestions zsh-syntax-highlighting

echo $pw | sudo -S dnf copr remove frostyx/qtile
echo $pw | sudo -S dnf copr remove david35mm/pamixer

echo -e "
\n###############################################
${P}Copy final configaration${N}
###############################################
"
cp -r $HOME/.config/ $HOME/.config.bak
echo -e "${C}copying alacritty.....${N}"
yes|cp -r .config/alacritty $HOME/.config
echo -e "${C}copying fish.....${N}"
yes|cp -r .config/fish $HOME/.config
echo -e "${C}copying gtk.....${N}"
yes|cp -r .config/gtk-3.0 $HOME/.config
echo -e "${C}copying htop.....${N}"
yes|cp -r .config/htop $HOME/.config
echo -e "${C}copying kitty.....${N}"
yes|cp -r .config/kitty $HOME/.config
echo -e "${C}copying neofetch.....${N}"
yes|cp -r .config/neofetch $HOME/.config
echo -e "${C}copying nvim.....${N}"
yes|cp -r .config/nvim $HOME/.config
echo -e "${C}copying pcmanfm.....${N}"
yes|cp -r .config/pcmanfm $HOME/.config
echo -e "${C}copying picom.....${N}"
yes|cp -r .config/picom $HOME/.config
echo -e "${C}copying qtile.....${N}"
yes|cp -r .config/qtile $HOME/.config
echo -e "${C}copying ranger.....${N}"
yes|cp -r .config/ranger $HOME/.config
echo -e "${C}copying rofi.....${N}"
yes|cp -r .config/rofi $HOME/.config
echo -e "${C}copying betterlockscreen.....${N}"
yes|cp .config/betterlockscreenrc $HOME/.config/
echo -e "${C}copying vscodium....${N}"
yes|cp -r .config/VSCodium $HOME/.config/
echo -e "${C}copying mousepad....${N}"
mkdir -p "$HOME/.local/share/gtksourceview-4/styles"
yes|cp  Themeing/mousepad/dracula.xml Themeing/mousepad/draculaDarker.xml $HOME/.local/share/gtksourceview-4/styles

######removimg catch directory
rm -rf catch
rm -f install

echo -e "
\n###############################################
${P}Theaming lightdm and grub${N}
###############################################
"
echo -e "${C}copying lightdm config file${N}"
echo $pw | sudo -S cp Themeing/lightdm/dracula.png Themeing/lightdm/logo.png /usr/share/backgrounds/
echo $pw | sudo -S cp Themeing/lightdm/lightdm-gtk-greeter.conf /etc/lightdm

echo -e "${C}copying grub config file${N}"
mkdir -p Grub/Dracula
tar -xf Grub/Dracula.tar -C Grub/Dracula
echo $pw | sudo mv Grub/Dracula /boot/grub/themes/
echo $pw | sudo -S sh -c 'echo "GRUB_THEME='/boot/grub/themes/Dracula/theme.txt'" >>/etc/default/grub'
echo $pw | sudo -S grub2-mkconfig -o /boot/grub2/grub.cfg

echo -e "\n${G}clearing termiinal${N} ===============\n"
clear;colorscript random

echo -e "
${R}###############################################
${N}########### Installations complete ############
${G}###############################################
"
echo -e "${R}Please reboot the system"