#!/bin/bash

WALLBASE=$HOME/Pictures/dual_1440p/cuts
export WALLPAPERS="$WALLBASE/6593144_right.jpg $WALLBASE/6593144_left.jpg"
# order acording to `xrandr --listmonitors`
DISPLAYS=("DisplayPort-2" "DisplayPort-1") # can leave empty () for single monitor
WORKSPACES=("󰬺 󰬻 󰬼 󰬽" "󰬾 󰬿 󰭀 󰭁")
N_MONITORS=2

export BACKGROUND_COLOR=#282A2E
export BACKGROUND_ALT_COLOR=#373B41
export PRIMARY_COLOR=#F0C674
export SECONDARY_COLOR=#8ABEB7
export NEUTRAL_COLOR=#707880
export ALERT_COLOR=#FF5555

export INTERFACE_NAME=enp39s0
export MAX_TITLE_WIDTH=60

export EXTRA_POLYBAR_MODULES="
"

export EXTRA_MODULES_BAR="network"

export EXTRA_KEYDEFS="
"

INSTALL_CMD="pacman -S"
