
grep -Pzo "\\n# \S.*\\n.*\\n" $HOME/.config/sxhkd/sxhkdrc | tr '\n' ':' | sed 's/:#/\n/g' | sed 's/:/   ##   /g' | rofi -dmenu -theme-str 'window {width: 80%;}' -theme-str 'listview {columns:1;}'
