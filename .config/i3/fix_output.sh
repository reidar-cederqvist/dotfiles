#!/usr/bin/env bash

monitor_main="$(xrandr --listmonitors  | awk '/0:/ {print $4}')"
monitor_sec="$(xrandr --listmonitors  | awk '/1:/ {print $4}')"
if [ -z "$monitor_sec" ]; then
       monitor_sec="${monitor_main}"
       sed -i 's/mode dock/mode invisible/' "${HOME}/.config/i3/config"
else
       sed -i 's/mode invisible/mode dock/' "${HOME}/.config/i3/config"
fi

sed -i "s/set \$display1.*/set \$display1 ${monitor_main}/" "${HOME}/.config/i3/config"
sed -i "s/set \$display2.*/set \$display2 ${monitor_sec}/" "${HOME}/.config/i3/config"
