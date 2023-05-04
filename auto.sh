#!/bin/bash

source userconfig.sh

DOTDIRS=( .xinitrc:$HOME/
           bspwmrc:$HOME/.config/bspwm/ 
           sxhkdrc:$HOME/.config/sxhkd/
           dunstrc:$HOME/.config/dunst/
           config.ini:$HOME/.config/polybar/ )

function foreachdot {
  for dotdirpair in "${DOTDIRS[@]}" ; do
     sourcefile="${dotdirpair%%:*}"
     targetdir="${dotdirpair##*:}"
     # printf "source: %s  target: %s\n" "$sourcefile" "$targetdir"
     eval $1
  done
}

case $1 in

  compose)

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
    envsubst < templates/config.ini > ./src/config.ini
    envsubst < templates/bspwmrc > ./src/bspwmrc
    SCRIPTS=$PWD/scripts envsubst < templates/sxhkdrc > ./src/sxhkdrc

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

  themes)
    echo "Installing rofi theme..."
    git clone https://github.com/catppuccin/rofi && ./rofi/basic/install.sh

  update)
    echo "Installing dots..."
    foreachdot $'mkdir -p $targetdir && cp ./src/$sourcefile $targetdir'
    ;;

  backup)
    echo "Backing up..."
    foreachdot $'cp ${targetdir}${sourcefile} ./backedup/'
    ;;

  restore)
    echo 'Restoring...'
    foreachdot $'cp ./backedup/${sourcefile} ${targetdir}'
    ;;

  *)
    CMDS=("compose" "deps" "themes" "backup" "restore" "update")
    echo "Usage \"./auto.sh <cmd>\" with command from:"
    for cmd in ${CMDS[@]} ; do 
      echo $'\t' $cmd
    done
    ;;

esac
