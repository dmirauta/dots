#!/bin/bash

source global/config.sh

CONF=$HOME/.config
DOTDIRS=( .xinitrc:$HOME/
           bspwmrc:$CONF/bspwm/ 
           sxhkdrc:$CONF/sxhkd/
           dunstrc:$CONF/dunst/
           rc.conf:$CONF/ranger/
           config.ini:$CONF/polybar/
           config.rasi:$CONF/rofi/
           alacritty.yml:$CONF/alacritty/
           catppuccin-mocha-mod.rasi:$HOME/.local/share/rofi/themes
         )

function foreachdot {
  for dotdirpair in "${DOTDIRS[@]}" ; do
     sourcefile="${dotdirpair%%:*}"
     targetdir="${dotdirpair##*:}"
     eval $1
  done
}
# foreachdot $'printf "source: %s  target: %s\n" "$sourcefile" "$targetdir"'

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
    envsubst < ./templates/config.ini                > ./src/config.ini
    envsubst < ./templates/bspwmrc                   > ./src/bspwmrc
    envsubst < ./templates/sxhkdrc                   > ./src/sxhkdrc
    envsubst < ./templates/dunstrc                   > ./src/dunstrc
    envsubst < ./templates/alacritty.yml             > ./src/alacritty.yml
    envsubst < ./templates/catppuccin-mocha-mod.rasi > ./src/catppuccin-mocha-mod.rasi

    ;;

  setup)
    echo "Installing main packages..."
    $INSTALL_CMD xorg-xinit bspwm sxhkd picom feh polybar zsh alacritty rofi dunst xsecurelock playerctl spectacle git
    echo "Installing secondary packages..."
    $INSTALL_CMD ranger ueberzug broot zsh-theme-powerlevel10k
    echo "Remember to run \"p10k configure\" to customise zsh prompt."
         
    AUDIOLIB=$(printf "libpulse\npipewire-pulse\nnone" | rofi -dmenu -p "Select audio library")
    if [ $AUDIOLIB!="none" ] ; then 
      $INSTALL_CMD $AUDIOLIB
    fi

    KDE_PACKAGES="qt5ct dolphin systemsettings plasma-workspace"
    INSTKDEDEPS=$(printf "Yes\nNo" | rofi -dmenu -p "Install KDE packages? ($KDE_PACKAGES)")
    if [ $INSTKDEDEPS=="Yes" ] ; then 
      $INSTALL_CMD $KDE_PACKAGES
    fi

    LAPTOP_PACKAGES="xfce4-power-manager brightnessctl"
    INSTLAPDEPS=$(printf "Yes\nNo" | rofi -dmenu -p "Install laptop packages? ($LAPTOP_PACKAGES)")
    if [ $INSTLAPDEPS=="Yes" ] ; then 
      $INSTALL_CMD $LAPTOP_PACKAGES
      xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -s false
    fi

    INSTNVC=$(printf "Yes\nNo" | rofi -dmenu -p "Install nvchad? (set of neovim plugins)")
    if [ $INSTNVC=="Yes" ] ; then 
      git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
    fi

    ;;

  set-exec)
    sudo chmod +x $HOME/.xinitrc
    sudo chmod +x $CONF/bspwm/bspwmrc
    ;;

  us-greek-kbd)
    echo "Installing custom keyboard layout..."

    cd ./kbd
    bash add_layout

    localectl set-x11-keymap cu
    ;;

  update)
    echo "Installing dots..."
    foreachdot $'[[ -f ./src/$sourcefile ]] && mkdir -p $targetdir && cp ./src/$sourcefile $targetdir'
    ;;

  backup)
    echo "Backing up... (keep in mind that doing this a second time will overwrite the other backup)"
    mkdir -p ./backedup/
    foreachdot $'[[ -f ${targetdir}${sourcefile} ]] && cp ${targetdir}${sourcefile} ./backedup/'
    ;;

  restore)
    echo 'Restoring...'
    foreachdot $'[[ -f ./backedup/${sourcefile} ]] && cp ./backedup/${sourcefile} ${targetdir}'
    ;;

  *)
    CMDS=("setup" "set-exec" "us-greek-kbd" "backup" "restore" "compose" "update")
    echo "Usage \"./auto.sh <cmd>\" with command from:"
    for cmd in ${CMDS[@]} ; do 
      echo $'\t' $cmd
    done
    ;;

esac
