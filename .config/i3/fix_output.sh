#!/usr/bin/env bash

monitor_main="$(xrandr --listmonitors  | awk '/0:/ {print $4}')"
monitor_sec="$(xrandr --listmonitors  | awk '/1:/ {print $4}')"

sed -i "s/set \$display1.*/set \$display1 ${monitor_main}/" "/home/reidar/.config/i3/config"
sed -i "s/set \$display2.*/set \$display2 ${monitor_sec}/" "/home/reidar/.config/i3/config"
