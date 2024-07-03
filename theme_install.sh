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

echo -e "${Y}+#+#+#+#+#+#+#+#+#+# Installing cursor icons +#+#+#+#+#+#+#+#+#+#${N}"
curl -OL https://github.com/dracula/gtk/releases/latest/download/Dracula-cursors.tar.xz
tar -xf Dracula-cursors.tar.xz --directory=/usr/share/icons
curl -OL https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz
tar -xf Bibata-Modern-Ice.tar.xz --directory=/usr/share/icons

echo -e "${Y}+#+#+#+#+#+#+#+#+#+# Installing theme +#+#+#+#+#+#+#+#+#+#${N}"
curl -OL https://github.com/dracula/gtk/releases/latest/download/Dracula.tar.xz
tar -xf Dracula.tar.xz --directory=/usr/share/themes
curl -OL https://github.com/EliverLara/Nordic/releases/latest/download/Nordic-darker.tar.xz
tar -xf Nordic-darker.tar.xz --directory=/usr/share/themes