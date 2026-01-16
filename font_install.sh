#!/bin/bash

# All list of fonts is available at 
#   https://github.com/ryanoasis/nerd-fonts/releases/latest
# visit the link and update 'fonts' list of your need.

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
N='\033[0m'

fonts=(
  "CascadiaCode"
  "CascadiaMono"
  "FiraCode" 
  "Hack"
  "JetBrainsMono"
  "Meslo"
)

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

cd "$TEMP_DIR"

# Create fonts directory if it doesn't exist
mkdir -p "$HOME/.local/share/fonts"

echo -e "${Y}Starting Nerd Fonts installation...${N}\n"

for font in "${fonts[@]}"
do
  echo -e "+#+#+#+#+#+#+#+#+#+# Installing ${R}$font${N} Font +#+#+#+#+#+#+#+#+#+#"
  
  # Try .tar.xz first (newer format)
  if curl -fSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz" -o "$font.tar.xz" 2>/dev/null; then
    echo -e "${G}Downloaded $font.tar.xz${N}"
    mkdir -p "$HOME/.local/share/fonts/$font"
    tar -xf "$font.tar.xz" --directory="$HOME/.local/share/fonts/$font"
    echo -e "${G}Installed $font successfully${N}"
  # Fallback to .zip (older format)
  elif curl -fSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip" -o "$font.zip" 2>/dev/null; then
    echo -e "${Y}Downloaded $font.zip (fallback)${N}"
    mkdir -p "$HOME/.local/share/fonts/$font"
    unzip -q "$font.zip" -d "$HOME/.local/share/fonts/$font"
    echo -e "${G}Installed $font successfully${N}"
  else
    echo -e "${R}Failed to download $font - skipping${N}"
  fi
  
  echo -e "${G}+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#${N}\n"
done

echo -e "${Y}Rebuilding font cache...${N}"
fc-cache -fv "$HOME/.local/share/fonts"

echo -e "${G}Font installation complete!${N}"
echo -e "${Y}Installed fonts: ${fonts[*]}${N}"