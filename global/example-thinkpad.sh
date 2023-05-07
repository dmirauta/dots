#!/bin/bash

WALLBASE=$HOME/Pictures
export WALLPAPERS="$WALLBASE/wallpaper.jpg"
# order acording to `xrandr --listmonitors`
DISPLAYS=( ) # can leave empty () for single monitor
WORKSPACES=("󰇊 󰇋 󰇌 󰇍 󰇎")
N_MONITORS=1

export BACKGROUND_COLOR=#282A2E
export BACKGROUND_ALT_COLOR=#373B41
export PRIMARY_COLOR=#F0C674
export SECONDARY_COLOR=#8ABEB7
export NEUTRAL_COLOR=#707880
export ALERT_COLOR=#FF5555

export GLOBAL_FONT="CaskaydiaCove Nerd Font Mono"

export INTERFACE_NAME=wls1
export MAX_TITLE_WIDTH=30

export EXTRA_POLYBAR_MODULES="
[module/cheat-sheet]
type = custom/text
content = CH
click-left = bash $SCRIPTS/cheat_sheet.sh
"

export EXTRA_MODULES_BAR="battery"

export EXTRA_KEYDEFS="
## Thinkpad keys ##

# btn 1
XF86TaskPane
	bspc desktop -f next

# btn 2
XF86RotateWindows
	~/.screen_rotate

# btn 4 (lock)
XF86ScreenSaver
	XSECURELOCK_COMPOSITE_OBSCURER=0 xsecurelock
"

INSTALL_CMD="sudo pacman -S"
