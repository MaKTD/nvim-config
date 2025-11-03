#!/usr/bin/env bash

if [ -d "$HOME/.config/nvim" ]; then 
 if [ -d "$HOME/.config/nvim.bak" ]; then 
      rm -r $HOME/.config/nvim.bak
    fi
    mv -f $HOME/.config/nvim $HOME/.config/nvim.bak
fi

cp -r $PWD/src $HOME/.config/nvim

