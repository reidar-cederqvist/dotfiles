#!/bin/bash

set -x

WAL_DIR="$HOME/.wallpapers"

monitors=$(hyprctl -j monitors | jq ".[].name" | xargs)

# preload a random image

img=$WAL_DIR/$(ls $WAL_DIR | sort -R | tail -1)

[ -f $img ] || exit 99

hyprctl hyprpaper preload $img

for monitor in $monitors; do
	hyprctl hyprpaper wallpaper "$monitor,$img"
done

sleep 0.1
hyprctl hyprpaper unload $img
