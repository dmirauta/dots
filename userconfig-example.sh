#!/bin/bash

WALLBASE=$HOME/Pictures/dual_1440p/cuts
export WALLPAPERS="$WALLBASE/6593144_right.jpg $WALLBASE/6593144_left.jpg"
# order acording to `xrandr --listmonitors`
DISPLAYS=("DisplayPort-2" "DisplayPort-1") # can leave empty () for single monitor
WORKSPACES=("I II III IV" "V VI VII VIII")
N_MONITORS=2

export INTERFACE_NAME=enp39s0

INSTALL_CMD="pacman -S"
