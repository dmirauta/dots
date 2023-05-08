 
Basic set of configs (mostly from corresponding defaults) for a bspwm based desktop environment.

Goals:
1. Keep my configs synchronised and reproduceable across the various machines and accounts I use.

For a minimum change quickstart, duplicate an example in`/global` creating `/global/config.sh` and edit to suit your device/monitors. Then use `./auto.sh compose && ./auto.sh update` to apply these changes, first time use may also require `./auto.sh set-exec`. Dependencies can be grabbed with the `./auto.sh setup` command (edit `INSTALL_CMD` variable if not using `pacman`).

As well as setting up the DE, this also syncs some nvim configs, comment out undesired dots from `DOTDIRS` array in `auto.sh`.

The keys `ctrl+shift+b` will list keybindings.

Todo:
- fix lingering logins (`bspc quit` not loggin out? seen with `loginctl list-sessions`)
- laptop
    - auto lock and suspend on lid down? Currently must manually lock before lid down...
- full desktop zoom (e.g. on `<super> + <plus>`) like in KDE would be nice, though would have to be supported in compositor, possibly only available in compiz (old)

Notes:
- some configs do not like comments after definitions! (keep comments on separate lines)
- spectacle is nice but may bring in too many KDE dependencies? (Otherwise KDE system settings and system monitor is also quite nice)
- many use thunar as part of their minimal setup so xfce4 apps are not a worry? (hence xfce4-power-manager is ok)
    - otherwise ranger and/or broot

Resources used:
    - cascadia font from https://www.nerdfonts.com/font-downloads
    - dunst config based on: https://github.com/dracula/dunst themes/dunst
    - rofi theme: https://github.com/catppuccin/rofi themes/rofi

