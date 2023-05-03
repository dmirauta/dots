#!/bin/bash

source userconfig.sh

DOTDIRS=( .xinitrc:$HOME/
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
    $INSTALL_CMD xorg-xinit bspwm sxhkd picom feh polybar alacritty rofi spectacle dunst xsecurelock playerctl

    AUDIOLIB=$(printf "libpulse\npipewire-pulse\nnone" | rofi -dmenu -p "Select audio library")
    if [ $AUDIOLIB!="none" ] ; then 
      $INSTALL_CMD $AUDIOLIB
    fi

    LAPTOP_PACKAGES="xfce4-power-manager brightnessctl"
    INSTLAPDEPS=$(printf "Yes\nNo" | rofi -dmenu -p "Install laptop packages? ($LAPTOP_PACKAGES)")
    if [ $INSTLAPDEPS=="Yes" ] ; then 
      $INSTALL_CMD $LAPTOP_PACKAGES
    fi

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

  backup)

    echo "Backing up..."
    for dotdirpair in "${DOTDIRS[@]}" ; do
        sourcefile="${dotdirpair%%:*}"
        targetdir="${dotdirpair##*:}"
        cp ${targetdir}${sourcefile} ./backedup/
    done

    ;;

  *)
    echo Issue \'generate\', \'deps\', \'backup\' or \'update\' as argument.
    ;;

esac
