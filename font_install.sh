#!/bin/bash

# All list of fonts is available at 
#   https://github.com/ryanoasis/nerd-fonts/releases/latest
# visit the link and update 'fonts' list of your need.

R='\033[0;31m'
G='\033[0;32m'
N='\033[0m'

fonts=(
  "CascadiaCode"
  "FiraCode" 
  "Hack"
  "IBMPlexMono"
  "Ubuntu"
)

mkdir fonts 
cd fonts
mkdir $HOME/.local/share/fonts/
echo -e " "
for font in ${fonts[@]}
do
  echo -e "+#+#+#+#+#+#+#+#+#+# Installing ${R}$font${N} Font +#+#+#+#+#+#+#+#+#+#"
  echo -e " "
  curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz
  mkdir $HOME/.local/share/fonts/$font
  tar -xf $font.tar.xz --directory=$HOME/.local/share/fonts/$font
  echo -e "${G}+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#${N}"
  echo -e " "
done
cd ..
rm -rf fonts

fc-cache -v $HOME/.local/share/fonts