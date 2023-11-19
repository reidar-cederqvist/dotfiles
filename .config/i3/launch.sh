#!/bin/bash

BG=$(find $HOME/.wallpapers/ -name "*.jpg" | sort -R | head -1)

[ -f $BG ] && wal -i $BG
$HOME/.config/polybar/launch.py
picom -f --config /dev/null &
/usr/bin/udiskie -t &
/usr/bin/numlockx on
/usr/bin/picom &
/usr/bin/nextcloud &
/usr/bin/slack -u &
/usr/bin/ckb-next -b &
/usr/bin/pasystray &
/usr/bin/nm-applet &
