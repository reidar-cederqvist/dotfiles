#!/bin/bash
#

monitors=$(hyprctl -j monitors | jq -r .[].name)
hyprctl dispatch cyclenext prev
active_window_address=$(hyprctl -j activewindow | jq -r .address)

echo $monitors

for monitor in $monitors; do
	hyprctl dispatch focusmonitor $monitor
	alacritty -o 'window.startup_mode="Fullscreen"' -e bash -c "sleep 0.2 && cmatrix -ab -C cyan" &
	sleep 0.4
	pids="$pids $!"
done

swaylock -c "00000000"

for pid in $pids; do
	kill $pid
done

hyprctl dispatch focuswindow address:$active_window_address
