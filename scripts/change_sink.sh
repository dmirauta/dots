#!/bin/bash

SINKS="$(pactl list sinks | grep Description | awk -F ": " '{print NR-1 " : " $2}')"
SELECTED=$(echo -e "$SINKS" | rofi -dmenu -p "Select audio out")

i=$(echo $SELECTED | awk -F " : " '{print $1}' )
echo $i

for j in $(pacmd list-sink-inputs | grep index | awk -F ": " '{print $2}') ; do
  echo "Changing input $j to $SELECTED"
  pacmd move-sink-input $j $i
done

