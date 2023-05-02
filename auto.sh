#!/bin/bash

#### Quickstart

WALLBASE=$HOME/Pictures/dual_1440p/cuts
export WALLPAPERS="$WALLBASE/6593144_right.jpg $WALLBASE/6593144_left.jpg"
# order acording to `xrandr --listmonitors`
DISPLAYS=("DisplayPort-2" "DisplayPort-1") # can leave empty () for single monitor
WORKSPACES=("I II III IV" "V VI VII VIII")
N_MONITORS=2

#### 

INSTALL="pacman -S"

DOTDIRS=( .xinitrc:$HOME
           bspwmrc:$HOME/.config/bspwm/ 
           sxhkdrc:$HOME/.config/sxhkd/
           dunstrc:$HOME/.config/dunst/
           config.ini:$HOME/.config/polybar/ )
 

case $1 in

  generate)

    NL=$'\n'
    BARDEFS=""
    BARSENABLE=""
    BSPCMON=""
    let I=N_MONITORS-1
    for i in $(seq 0 $I) ; do
      export BARID="BAR$i"
      export MON="monitor = ${DISPLAYS[i]}"
      export BAR="$(envsubst < templates/poly.bar)"
      export BARDEFS="${BARDEFS}${BAR}${NL}"
      export BARSENABLE="${BARSENABLE}polybar $BARID &$NL"
      export BSPCMON="${BSPCMON}bspc monitor ${DISPLAYS[i]} -d ${WORKSPACES[i]} &$NL"
    done
    envsubst < templates/config.ini > config.ini
    envsubst < templates/bspwmrc > bspwmrc

    ;;

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
    echo Issue \'generate\', \'deps\', \'lapdeps\' or \'update\' as argument.
    ;;

esac
