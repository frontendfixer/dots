#!/usr/bin/env bash

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
${C}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${N}\n"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

cd "$TEMP_DIR"

# Ensure directories exist
sudo mkdir -p /usr/share/icons
sudo mkdir -p /usr/share/themes

echo -e "${Y}+#+#+#+#+#+#+#+#+#+# Installing cursor icons +#+#+#+#+#+#+#+#+#+#${N}\n"

# Dracula Cursors
if curl -fSL https://github.com/dracula/gtk/releases/latest/download/Dracula-cursors.tar.xz -o Dracula-cursors.tar.xz; then
    echo -e "${G}Downloaded Dracula cursors${N}"
    sudo tar -xf Dracula-cursors.tar.xz -C /usr/share/icons
    echo -e "${G}Installed Dracula cursors${N}"
else
    echo -e "${R}Failed to download Dracula cursors${N}"
fi

# Bibata Modern Ice Cursors (using latest)
BIBATA_VERSION="v2.0.7"
if curl -fSL "https://github.com/ful1e5/Bibata_Cursor/releases/download/$BIBATA_VERSION/Bibata-Modern-Ice.tar.xz" -o Bibata-Modern-Ice.tar.xz; then
    echo -e "${G}Downloaded Bibata Modern Ice cursors${N}"
    sudo tar -xf Bibata-Modern-Ice.tar.xz -C /usr/share/icons
    echo -e "${G}Installed Bibata Modern Ice cursors${N}"
else
    echo -e "${R}Failed to download Bibata cursors (trying to continue...)${N}"
fi

echo -e "\n${Y}+#+#+#+#+#+#+#+#+#+# Installing GTK themes +#+#+#+#+#+#+#+#+#+#${N}\n"

# Dracula Theme
if curl -fSL https://github.com/dracula/gtk/releases/latest/download/Dracula.tar.xz -o Dracula.tar.xz; then
    echo -e "${G}Downloaded Dracula theme${N}"
    sudo tar -xf Dracula.tar.xz -C /usr/share/themes
    echo -e "${G}Installed Dracula theme${N}"
else
    echo -e "${R}Failed to download Dracula theme${N}"
fi

# Nordic Darker Theme
if curl -fSL https://github.com/EliverLara/Nordic/releases/latest/download/Nordic-darker.tar.xz -o Nordic-darker.tar.xz; then
    echo -e "${G}Downloaded Nordic-darker theme${N}"
    sudo tar -xf Nordic-darker.tar.xz -C /usr/share/themes
    echo -e "${G}Installed Nordic-darker theme${N}"
else
    echo -e "${R}Failed to download Nordic-darker theme${N}"
fi

# Optional: Install additional popular themes
echo -e "\n${Y}Installing additional themes (optional)...${N}\n"

# Gruvbox Theme
if curl -fSL https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme/archive/refs/heads/master.tar.gz -o gruvbox.tar.gz; then
    echo -e "${G}Downloaded Gruvbox theme${N}"
    tar -xf gruvbox.tar.gz
    sudo cp -r Gruvbox-GTK-Theme-master/themes/* /usr/share/themes/ 2>/dev/null || true
    echo -e "${G}Installed Gruvbox theme${N}"
else
    echo -e "${Y}Skipping Gruvbox theme${N}"
fi

echo -e "\n${G}Theme installation complete!${N}"
echo -e "${Y}Installed themes and cursors can be selected in:${N}"
echo -e "  - lxappearance (GTK theme selector)"
echo -e "  - XFCE Settings > Appearance"
echo -e "  - Your window manager configuration"