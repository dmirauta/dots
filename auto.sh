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
      export BAR=";

[bar/$BARID]
inherit = module/bar
monitor = ${DISPLAYS[i]}

;"
      export BARDEFS="${BARDEFS}${BAR}${NL}"
      export BARSENABLE="${BARSENABLE}polybar $BARID &$NL"
      export BSPCMON="${BSPCMON}bspc monitor ${DISPLAYS[i]} -d ${WORKSPACES[i]} &$NL"
    done

    export SCRIPTS=$PWD/scripts 
    envsubst < ./templates/config.ini > ./src/config.ini
    envsubst < ./templates/bspwmrc    > ./src/bspwmrc
    envsubst < ./templates/sxhkdrc    > ./src/sxhkdrc
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
    THIS=$PWD

    if [[ ! -d themes/rofi ]] ; then
      echo "Installing rofi theme..."
      git clone https://github.com/catppuccin/rofi themes/rofi
      cd ./themes/rofi/basic/
      ./install.sh
      cd $THIS
    else
      echo "https://github.com/catppuccin/rofi already present, may already have installed?"
    fi

    # just using for fonts currently
    if [[ ! -d themes/polybar ]] ; then
      echo "Installing polybar theme..."
      git clone https://github.com/adi1090x/polybar-themes themes/polybar
      cd ./themes/polybar


      FDIR="$HOME/.local/share/fonts"
      PDIR="$HOME/.config/polybar"

      ### directly from setup.sh in adi1090x/polybar-themes
      # Install Fonts
	    echo -e "\n[*] Installing fonts..."
      [[ ! -d "$FDIR" ]] && mkdir -p "$FDIR"
      cp -rf fonts/* "$FDIR"
      ###

      cd $THIS
    else
      echo "https://github.com/adi1090x/polybar-themes already present, may already have installed?"
    fi

    ;;

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
