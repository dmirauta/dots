#!/bin/bash

source global/config.sh

CONF=$HOME/.config
VIMCONF=$CONF/nvim/lua/user
DOTDIRS=(.xinitrc:$HOME/
	# .zshrc:$HOME/
	.pylintrc:$HOME/
	bspwmrc:$CONF/bspwm/
	sxhkdrc:$CONF/sxhkd/
	dunstrc:$CONF/dunst/
	rc.conf:$CONF/ranger/
	config.ini:$CONF/polybar/
	config.rasi:$CONF/rofi/
	alacritty.toml:$CONF/alacritty/
	catppuccin-mocha-mod.rasi:$HOME/.local/share/rofi/themes/
	community.lua:$VIMCONF/plugins/
	user.lua:$VIMCONF/plugins/
	clangd.lua:$VIMCONF/lsp/config/
	options.lua:$VIMCONF/
)

function foreachdot {
	for dotdirpair in "${DOTDIRS[@]}"; do
		sourcefile="${dotdirpair%%:*}"
		targetdir="${dotdirpair##*:}"
		eval $1
	done
}
# foreachdot $'printf "source: %s  target: %s\n" "$sourcefile" "$targetdir"'

function install_nvim {
	[[ -d ~/.config/nvim ]] && mv -n ~/.config/nvim ~/.config/nvim.bak
	[[ -d ~/.local/share/nvim ]] && mv -n ~/.local/share/nvim ~/.local/share/nvim.bak
	[[ -d ~/.local/state/nvim ]] && mv -n ~/.local/state/nvim ~/.local/state/nvim.bak
	[[ -d ~/.cache/nvim ]] && mv -n ~/.cache/nvim ~/.cache/nvim.bak
	git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim --depth 1 && nvim
}

case $1 in

compose)

	NL=$'\n'
	BARDEFS=""
	BARSENABLE=""
	BSPCMON=""

	((I = N_MONITORS - 1))
	for i in $(seq 0 $I); do
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
	envsubst <./templates/config.ini >./src/config.ini
	envsubst <./templates/bspwmrc >./src/bspwmrc
	envsubst <./templates/sxhkdrc >./src/sxhkdrc
	envsubst <./templates/dunstrc >./src/dunstrc
	envsubst <./templates/alacritty.toml >./src/alacritty.toml
	envsubst <./templates/catppuccin-mocha-mod.rasi >./src/catppuccin-mocha-mod.rasi

	;;

setup-nvim)
	install_nvim
	;;

setup)
	echo "Installing main packages..."
	$INSTALL_CMD xorg-xinit bspwm sxhkd picom feh polybar zsh alacritty rofi dunst xsecurelock playerctl git
	;;

setup-secondary)
	echo "Installing secondary packages..."
	$INSTALL_CMD ranger ueberzug broot zsh-theme-powerlevel10k
	echo "Remember to run \"p10k configure\" to customise zsh prompt."

	AUDIOLIB=$(printf "libpulse\npipewire-pulse\nnone" | rofi -dmenu -p "Select audio library")
	if [ $AUDIOLIB != "none" ]; then
		$INSTALL_CMD $AUDIOLIB
	fi

	KDE_PACKAGES="qt5ct qt6ct spectacle dolphin systemsettings plasma-workspace polkit-kde-agent"
	INSTKDEDEPS=$(printf "Yes\nNo" | rofi -dmenu -p "Install KDE packages? ($KDE_PACKAGES)")
	if [ $INSTKDEDEPS == "Yes" ]; then
		$INSTALL_CMD $KDE_PACKAGES
	fi

	LAPTOP_PACKAGES="xfce4-power-manager brightnessctl"
	INSTLAPDEPS=$(printf "Yes\nNo" | rofi -dmenu -p "Install laptop packages? ($LAPTOP_PACKAGES)")
	if [ $INSTLAPDEPS == "Yes" ]; then
		$INSTALL_CMD $LAPTOP_PACKAGES
		xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -s false
	fi

	INSTNVC=$(printf "Yes\nNo" | rofi -dmenu -p "Install astronvim? (set of neovim plugins)")
	if [ $INSTNVC == "Yes" ]; then
		install_nvim
	fi

	SETUPPY=$(printf "Yes\nNo" | rofi -dmenu -p "Setup python LSPs?")
	if [ $SETUPPY == "Yes" ]; then
		$INSTALL_CMD ruff-lsp python-pylint
	fi

	SETUPRUST=$(printf "Yes\nNo" | rofi -dmenu -p "Setup rust?")
	if [ $SETUPRUST == "Yes" ]; then
		$INSTALL_CMD rustup
		rustup install stable
		rustup component add rust-analyzer
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
	CMDS=("setup" "setup-nvim" "setup-secondary" "set-exec" "us-greek-kbd" "backup" "restore" "compose" "update")
	echo "Usage \"./auto.sh <cmd>\" with command from:"
	for cmd in ${CMDS[@]}; do
		echo $'\t' $cmd
	done
	;;

esac
