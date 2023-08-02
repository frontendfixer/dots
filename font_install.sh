#!/usr/bin/env bash

# All list of fonts is available at 
#   https://github.com/ryanoasis/nerd-fonts/releases/latest
# visit the link and update 'fonts' list of your need.

fonts=( 
"CascadiaCode"
"FiraCode" 
"Hack"
"IBMPlexMono"
)

mkdir fonts && cd fonts
for font in ${fonts[@]}
do
  curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz
  mkdir $HOME/.local/share/fonts/$font
  tar -xf $font.tar.xz --directory=$HOME/.local/share/fonts/$font
done
cd .. && rm -rf fonts

fc-cache -v $HOME/.local/share/fonts