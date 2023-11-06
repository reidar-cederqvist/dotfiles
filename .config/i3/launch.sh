#!/bin/bash

$HOME/.config/polybar/launch.py
picom -f --config /dev/null &
/usr/bin/udiskie -t &
/usr/bin/numlockx on
/usr/bin/picom &
/usr/bin/nextcloud &
/usr/bin/slack -u &
/usr/bin/ckb-next -b &
/usr/bin/pasystray &
