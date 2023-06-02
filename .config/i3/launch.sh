#!/bin/bash

while ! pidof polybar; do
	sleep 1
done
picom -f --config /dev/null &
/usr/bin/udiskie -t &
/usr/bin/numlockx on
/usr/bin/nextcloud &
/usr/bin/slack -u &
/usr/bin/ckb-next -b &
/usr/bin/pasystray &
