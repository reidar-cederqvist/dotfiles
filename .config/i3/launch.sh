#!/bin/bash

BG=$(find $HOME/.wallpapers/ -name "*.jpg" | sort -R | head -1)

[ -f $BG ] && wal -i $BG
killall -9 polybar
sleep 0.2

$HOME/.config/polybar/launch.py
#/usr/bin/dunst &

BIN='/usr/bin/picom -f --config /dev/null &
/usr/bin/numlockx on
/usr/bin/nextcloud &
/usr/bin/slack -u &
/usr/bin/udiskie -t &
/usr/bin/ckb-next -b &
/usr/bin/pasystray &
/usr/bin/nm-applet &'

IFS='
'

for line in $BIN; do
	prog=${line%% *}
	if [ ! -x $prog ]; then
		logger -p user.err -t launch.sh "error: could not find $prog\n will not run $line"
		continue
	fi
	eval "$line"
done
