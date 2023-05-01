Install required packages

```bash
pacman -Syyu bspwm sxhkd picom feh polybar alacritty rofi spectacle brightnessctl
```

(assume `pactl playerctl` installed?)


Install dots

```bash
mkdir ~/.config/sxhkd && mkdir ~/.config/bspwm/ && mkdir ~/.config/polybar/
cp sxhkdrc ~/.config/sxhkd/ && cp bspwmrc ~/.config/bspwm/ && cp .xinitrc ~ && cp config.ini ~/.config/polybar/
```

