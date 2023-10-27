#!/bin/sh
#

which brightnessctl || exit 99

device="tpacpi::kbd_backlight"
current_brightness=$(brightnessctl -d $device g -m)

if [ "$current_brightness" == "2" ]; then
	brightnessctl -q -d $device s 0
else
	brightnessctl -q -d $device s 2
fi
