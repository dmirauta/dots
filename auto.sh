#!/bin/bash

DOTDIRS=( .xinitrc:$HOME
           bspwmrc:$HOME/.config/bspwm/ 
           sxhkdrc:$HOME/.config/sxhkd/
           dunstrc:$HOME/.config/dunst/
           config.ini:$HOME/.config/polybar/ )

INSTALL="pacman -S"

case $1 in

  deps)
    echo "Installing main packages..."
    $INSTALL xorg-xinit bspwm sxhkd picom feh polybar alacritty rofi spectacle dunst xsecurelock
    # $INSTALL pactl playerctl
    ;;

  lapdeps)
    echo "Installing laptop packages..."
    $INSTALL xfce4-power-manager brightnessctl
    ;;

  update)
    echo "Installing dots..."
    for dotdirpair in "${DOTDIRS[@]}" ; do
        sourcefile="${dotdirpair%%:*}"
        targetdir="${dotdirpair##*:}"
        # printf "source: %s  target: %s\n" "$sourcefile" "$targetdir"
        mkdir -p $targetdir
        cp $sourcefile $targetdir
    done
    ;;

  *)
    echo Issue \'deps\', \'lapdeps\' or \'update\' as argument.
    ;;

esac
