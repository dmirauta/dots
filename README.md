 
Basic set of configs (mostly from corresponding defaults) for a bspwm based desktop environment.

Minimum changes:
- `config.ini`: define `monitor = ` (per bar) for multi monitor setup or comment out otherwise.
- `bspwmrc`: Edit wallpaper paths(s) for `feh`, number of polybars and `bspc monitor` lines.

Use `auto.sh` to install dependencies and insert modified configs in the relevant directories.

Todo:
- Autogen multimonitor configs (minimise min changes and put in one place)
- option to quickly swap arrows and hjkl in keybinds for whichever is prefered as promminent?

Notes:
- spectacle is nice but may bring in too many KDE dependencies? (Otherwise KDE system settings is also quite nice)
- many use thunar as part of their minimal setup so xfce4 apps are not a worry? (hence xfce4-power-manager is ok)
    - otherwise ranger and/or broot
