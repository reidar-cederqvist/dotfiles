#!/bin/bash
#

CONF="$HOME/.config/hypr_work/hyprland.conf"
raw=$(hyprctl monitors -j)
monitors=$(echo "$raw" | jq .[].name | xargs)
monitor_list=($monitors)
number_of_monitors=${#monitor_list[@]}

main_monitor=""
sec_monitor=""


echo $monitors
echo $number_of_monitors

if [ $number_of_monitors -eq 1 ]; then # only one monitor use it for all workspaces
	main_monitor=$monitors
	sec_monitor=$monitors
elif [ $number_of_monitors -eq 2 ]; then # put the main workspaces on the external monitor
	for monitor in $monitors; do
		case $monitor in
			eDP*)
				sec_monitor=$monitor
				;;
			*)
				main_monitor=$monitor
				;;
		esac
	done
else # use both the external monitors as main and second monitors
	for monitor in $monitors; do
		case $monitor in
			eDP*)
				;;
			*)
				if [ "$main_monitor" == "" ]; then
					main_monitor=$monitor
				else
					sec_monitor=$monitor
				fi
				;;
		esac
	done
fi


# find the possition of the second monitor (right-of main_monitor)

width=$(echo "$raw" | jq ".[] | select(.name==\"$main_monitor\").width")

hyprctl keyword monitor $main_monitor, highres, 0x0, 1, bitdepth, 10
hyprctl keyword monitor $sec_monitor, highres, ${width}x800, 1, bitdepth, 10

for ((i=1; i <= 7; i++)); do
	cmd="$cmd keyword workspace $i, monitor:$main_monitor;"
done

for ((i=8; i <= 10; i++)); do
	cmd="$cmd keyword workspace $i, monitor:$sec_monitor;"
done

hyprctl --batch $cmd
