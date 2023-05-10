
grep -Pzo "\\n# \S.*\\n.*\\n" $HOME/.config/sxhkd/sxhkdrc | tr '\n' ':' | sed 's/:#/\n/g' | column --separator : -t | rofi -dmenu -p "Cheat sheet (input map)" -theme-str 'window {width: 80%;}' -theme-str 'listview {columns:1;}'

