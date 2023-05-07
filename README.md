 
Basic set of configs (mostly from corresponding defaults) for a bspwm based desktop environment.

Goals:
1. Keep my configs synchronised and reproduceable across the various machines and accounts I use.

For a minimum change quickstart, duplicate `userconfig-example.sh` to `userconfig.sh` and edit to suit your monitor setup. Then use `./auto.sh compose && ./auto.sh update` to apply these changes. Dependencies can be grabbed with the `./auto.sh setup` command (edit `INSTALL_CMD` variable if not using `pacman`).

The keys `ctrl+shift+b` will list keybindings.

Todo:
- fix lingering logins (`bspc quit` not loggin out? seen with `loginctl list-sessions`)
- switch global font in userconfig?
- consistent primary and secondary colors (swappable in userconfig, or generated from wallpapers)
- window styling?

Notes:
- some configs do not like comments after definitions! (keep comments on separate lines)
- spectacle is nice but may bring in too many KDE dependencies? (Otherwise KDE system settings and system monitor is also quite nice)
- many use thunar as part of their minimal setup so xfce4 apps are not a worry? (hence xfce4-power-manager is ok)
    - otherwise ranger and/or broot

