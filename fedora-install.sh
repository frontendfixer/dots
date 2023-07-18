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
echo $pw | sudo -S dnf group update -y core
echo $pw | sudo -S dnf update -y

echo -e "\n${G}installing reqired groups${N} ===============\n"
echo $pw | sudo -S dnf group install -y "Administration Tools" "C Development Tools and Libraries" "Fonts" "Standard" "Hardware Support" "Input Methods" "base-x"

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

echo -e "\n${G}Installing shell-color-scripts${N} ===============\n"
echo -e  "${C}You can download the source code from this repository or use a git clone:
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
${N}"
cd Themeing/shell-color-scripts
echo $pw | sudo -S make install
cd ../..

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
cd ..

echo -e "${C}#### installing betterlockscreen${N}"
wget https://github.com/betterlockscreen/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip

cd betterlockscreen-main/
chmod u+x betterlockscreen
echo $pw | sudo -S cp betterlockscreen /usr/local/bin/

echo $pw | sudo -S cp system/betterlockscreen@.service /usr/lib/systemd/system/
echo $pw | sudo -S systemctl enable betterlockscreen@$USER
betterlockscreen -u /usr/share/backgrounds/fantacy/wal39.jpg
cd ../..

echo -e "
\n###############################################
${P}Updating theme icons fonts and wallpaper ${N}
###############################################
"
echo -e "${G}Updating theme and icons${N} ===============\n"

echo -e "${C}installing bibata cursor theme${N}"
yes | echo $pw | sudo -S dnf copr enable peterwu/rendezvous
echo $pw | sudo -S dnf install -y bibata-cursor-themes
yes | echo $pw | sudo -S dnf copr remove peterwu/rendezvous

echo -e "${C}copying dracula themes${N}"
yes | cp -r .icons/ $HOME
yes | cp -r .themes/ $HOME
yes | echo $pw | sudo -S cp -r $HOME/.themes/Dracula /usr/share/themes

echo -e "\ncopying config file for ${G}gtkrc-2.0${N}"
mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.bak
yes | cp .gtkrc-2.0 .gtkrc-2.0.mine .gtkrc-xfce $HOME

echo -e "\n${G}updateing fonts${N}"
mkdir -p $HOME/.local/share/fonts
yes | cp -r .fonts/* $HOME/.local/share/fonts
fc-cache -v $HOME/.local/share/fonts


echo -e "
\n###############################################
${P}Installing Window manager ${N}
###############################################
"
yes | echo $pw | sudo -S dnf copr enable frostyx/qtile
yes | echo $pw | sudo -S dnf copr enable david35mm/pamixer
yes | echo $pw | sudo -S dnf copr enable jerrycasiano/FontManager
yes | echo $pw | sudo -S rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
echo $pw | printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo -S tee -a /etc/yum.repos.d/vscodium.repo

echo -e "${R}installing require packages${N} ===========\n"
echo $pw | sudo -S dnf install -y htop pcmanfm picom ranger mousepad lightdm lightdm-gtk-greeter rofi dmenu xdg-user-dirs python3-pip firefox file-roller eog meld pavucontrol scrot galculator brightnessctl pamixer nodejs blueman font-manager gnome-characters telegram-desktop vlc codium android-tools android-file-transfer gvfs gvfs-mtp polkit-gnome clipit numlockx xset network-manager-applet papirus-icon-theme zsh-autosuggestions zsh-syntax-highlighting gimp gcolor3 xreader google-noto-emoji-color-fonts plymouth tlp tlp-rdw redshift polybar qtile qtile-extras i3-gaps bspwm sxhkd yad transmission

echo -e "${R}pip isntalling services ${N} ===========\n"
pip install rofimoji beautysh black  

echo -e "${R}enableling services ${N} ===========\n"
echo $pw | sudo -S systemctl enable tlp
echo $pw | sudo -S systemctl set-default graphical.target
echo $pw | sudo -S systemctl enable lightdm
echo $pw | sudo -S systemctl enable betterlockscreen@$USER
echo $pw | sudo -S plymouth-set-default-theme -R details
xdg-user-dirs-update

echo $pw | sudo -S dnf copr remove frostyx/qtile
echo $pw | sudo -S dnf copr remove david35mm/pamixer
echo $pw | sudo -S dnf copr remove jerrycasiano/FontManager

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
yes | echo $pw | sudo -S cp -r Themeing/lightdm/dracula.png Themeing/lightdm/logo.png /usr/share/backgrounds/
yes | echo $pw | sudo -S cp -r Themeing/lightdm/lightdm-gtk-greeter.conf /etc/lightdm

echo -e "${C}copying grub config file${N}"
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
echo $pw | sudo -S ./install.sh -t tela
cd ..
rm -rf grub2-themes

echo -e "${G}############### Mounting drives ############"
echo $pw | sudo -S sh -c 'echo "
UUID=6E9781F365706FF3	/mnt/Entertainment	ntfs	defaults	0	0
UUID=7796BF99038EDBCE	/mnt/Program		ntfs	defaults	0	0
" >>/etc/fstab'

echo -e "${G}############### Updating DNS ############"
echo $pw | sudo -S sh -c 'echo "
DNS=45.90.28.0#****d9.dns.nextdns.io
DNS=2a07:a8c0::#****d9.dns.nextdns.io
DNS=45.90.30.0#****d9.dns.nextdns.io
DNS=2a07:a8c1::#****d9.dns.nextdns.io
DNSOverTLS=yes
" >>/etc/systemd/resolved.conf'
echo $pw | sudo -S systemctl enable systemd-resolved.service

echo -e "
${R}###############################################
${N}########### Installations complete ############
${G}###############################################
"
echo -e "${R}Please reboot the system${N}"
