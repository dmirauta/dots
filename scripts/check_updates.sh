#!/bin/sh

# Based on:
# https://github.com/polybar/polybar-scripts/blob/master/polybar-scripts/updates-pacman/updates-pacman.sh

# on arch, checkupdates is found in pacman-contrib
if ! updates=$(checkupdates 2>/dev/null | wc -l); then
	updates=0
fi

if [ "$updates" -gt 0 ]; then
	notify-send "Updates available" "$updates newer packages"
fi
