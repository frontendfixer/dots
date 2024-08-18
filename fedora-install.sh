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

echo -e "${G}setting up the envirenment ${N} ===============\n"
read -p "Enter your hostname: " host
echo -e "Changed hostname to ${G}$host${N}"
sudo hostnamectl set-hostname "$host"

echo -e "\n editing ${G}dnf.conf....${N} \n"
sudo sh -c 'echo "
fastestmirror=True
max_parallel_downloads=5
defaultyes=True
deltarpm=True
" >>/etc/dnf/dnf.conf'

## updateing system...
echo -e "\n${G}installing RPM free and non-free${N} ===============\n"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf group update -y core
sudo dnf update -y

echo -e "\n${G}installing reqired groups${N} ===============\n"
sudo dnf group install -y "Administration Tools" "C Development Tools and Libraries" "Fonts" "Standard" "Hardware Support" "Input Methods" "base-x"

echo -e "${G}installing multimedia codac${N} ===============\n"
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf -y group upgrade --with-optional Multimedia

echo -e "
################################################
${P}Initialized therminal theming${N}
################################################
"
## terminal settings
echo -e "\n${G}installing packages${N} ===============\n"
sudo dnf install -y exa zsh fish neofetch curl git wget neovim feh kitty

echo -e "\n${G}installing starship....${N} ===============\n"
curl -sS https://starship.rs/install.sh | sh

echo -e "\n${G}copying config file${N} ===============\n"
mv $HOME/.bashrc $HOME/.bashrc.bak
mv $HOME/.zshrc $HOME/.zshrc.bak
mv $HOME/.Xresources $HOME/.Xresources.bak
cp .aliases .bashrc .zshrc .Xresources .face $HOME
yes | cp -r .zsh/ $HOME

echo -e "\n${G}Installing shell-color-scripts${N} ===============\n"
echo -e  "${C}You can download the source code from this repository or use a git clone:
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
${N}"
cd Themeing/shell-color-scripts
sudo make install
cd ../..

echo -e "\n${G}clearing termiinal${N} ===============\n"
source ~/.bashrc
clear;colorscript random

echo -e "
\n###############################################
${P}Updating theme icons fonts and wallpaper ${N}
###############################################
"
echo -e "\n${G}updating wallpaer${N} ===============\n"
sudo mkdir -p /usr/share/backgrounds/fantacy
sudo cp -r .background/* /usr/share/backgrounds/fantacy/
cp .fehbg $HOME

echo -e "${G}Updating theme and icons${N} ===============\n"
sudo dnf install -y gtk-murrine-engine gtk2-engines
sudo ./theme_install.sh

echo -e "\ncopying config file for ${G}gtkrc-2.0${N}"
mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.bak
yes | cp .gtkrc-2.0 .gtkrc-2.0.mine .gtkrc-xfce $HOME

echo -e "\n${G}updateing fonts${N}"
./font_install.sh

echo -e "
\n###############################################
${P}Installing Window manager ${N}
###############################################
"
yes | sudo dnf copr enable frostyx/qtile
yes | sudo dnf copr enable david35mm/pamixer
yes | sudo dnf copr enable jerrycasiano/FontManager
yes | sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo

echo -e "${R}installing require packages${N} ===========\n"
sudo dnf install -y htop pcmanfm picom ranger mousepad lightdm lightdm-gtk-greeter rofi dmenu xdg-user-dirs python3-pip firefox file-roller eog meld pavucontrol scrot galculator brightnessctl pamixer blueman font-manager gnome-characters android-tools android-file-transfer gvfs gvfs-mtp polkit-gnome clipit numlockx xset network-manager-applet papirus-icon-theme zsh-autosuggestions zsh-syntax-highlighting gimp gcolor3 xreader google-noto-emoji-color-fonts plymouth redshift polybar qtile qtile-extras i3-gaps bspwm sxhkd yad transmission xscreensaver unclutter

echo -e "${R}pip isntalling services ${N} ===========\n"
pip install rofimoji beautysh black  

echo -e "${R}enableling services ${N} ===========\n"
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm
sudo systemctl enable betterlockscreen@$USER
sudo plymouth-set-default-theme -R details
xdg-user-dirs-update

sudo dnf copr remove frostyx/qtile
sudo dnf copr remove david35mm/pamixer
sudo dnf copr remove jerrycasiano/FontManager

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

######removimg catch directory
rm -rf catch

echo -e "
\n###############################################
${P}Theaming lightdm and grub${N}
###############################################
"
echo -e "${C}copying lightdm config file${N}"
yes | sudo cp -r Themeing/lightdm/dracula.png Themeing/lightdm/logo.png /usr/share/backgrounds/
yes | sudo cp -r Themeing/lightdm/lightdm-gtk-greeter.conf /etc/lightdm
yes | sudo cp -r Themeing/lightdm/slick-greeter.conf /etc/lightdm

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