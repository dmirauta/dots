Install required packages

```bash
pacman -Syyu bspwm sxhkd picom feh polybar alacritty rofi spectacle brightnessctl dunst xsecurelock
```

(assume `pactl playerctl` installed?)


On laptops

```bash
pacman -Syyu xfce4-power-manager
```

Install dots

```bash
mkdir ~/.config/sxhkd && mkdir ~/.config/bspwm/ && mkdir ~/.config/polybar/ && mkdir ~/.config/dunst
cp sxhkdrc ~/.config/sxhkd/ && cp bspwmrc ~/.config/bspwm/ && cp .xinitrc ~ && cp config.ini ~/.config/polybar/ && cp dunstrc ~/.config/dunst/
```

Edit wallpaper paths(s) (`feh` command in `bspwmrc`) and monitor count related lines.

Done!
