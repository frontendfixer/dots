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

mkdir themes
cd themes

echo -e "+#+#+#+#+#+#+#+#+#+# Installing ${R}cursor icons{N} +#+#+#+#+#+#+#+#+#+#"
curl -OL https://github.com/dracula/gtk/releases/latest/download/Dracula-cursors.tar.xz
sudo tar -xf Dracula-cursors.tar.xz --directory=/usr/share/icons
curl -OL https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.gz
sudo tar -xf Bibata-Modern-Ice.tar.gz --directory=/usr/share/icons

echo -e "+#+#+#+#+#+#+#+#+#+# Installing ${R}Dracula theme{N} +#+#+#+#+#+#+#+#+#+#"
curl -OL https://github.com/dracula/gtk/releases/latest/download/Dracula.tar.xz
sudo tar -xf Dracula.tar.xz --directory=/usr/share/themes
curl -OL https://github.com/EliverLara/Nordic/releases/latest/download/Nordic-darker.xz
sudo tar -xf Nordic-darker.xz --directory=/usr/share/themes

git clone https://github.com/vinceliuice/vimix-gtk-themes.git
cd vimix-gtk-themes
yes | ./install.sh -d /usr/share/themes -t doder beryl ruby jade -c dark -s compact -l --tweaks translucent
cd ..

git clone https://github.com/vinceliuice/vimix-icon-theme.git
cd vimix-icon-theme
sudo ./install.sh -d /usr/share/icons doder beryl ruby jade white