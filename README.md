 
Basic set of configs (mostly from corresponding defaults) for a bspwm based desktop environment.

For a minimum change quickstart, edit the quickstart section in `auto.sh` to suit your monitor setup and use `./auto.sh generate` to generate configs. These can be installed with `./auto.sh update`. Dependencies can be grabbed with the `./auto.sh deps` (and optionally `./auto.sh lapdeps` for laptop only components) command.

Todo:
- option to quickly swap arrows and hjkl in keybinds for whichever is prefered as promminent?

Notes:
- some configs do not like comments after definitions! (keep comments on separate lines)
- spectacle is nice but may bring in too many KDE dependencies? (Otherwise KDE system settings is also quite nice)
- many use thunar as part of their minimal setup so xfce4 apps are not a worry? (hence xfce4-power-manager is ok)
    - otherwise ranger and/or broot

