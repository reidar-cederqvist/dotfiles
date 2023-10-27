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

sec_x=$(echo "$raw" | jq ".[] | select(.name==\"$sec_monitor\").width")
sec_y=$(echo "$raw" | jq ".[] | select(.name==\"$sec_monitor\").height")
sec_resolution="${sec_x}x${sec_y}"

sed -i 's/\$mainMonitor = .*/\$mainMonitor = '$main_monitor'/g' $CONF
sed -i 's/\$secMonitor = .*/\$secMonitor = '$sec_monitor'/g' $CONF
sed -i 's/monitor = \$secMonitor,.*/monitor = \$secMonitor, '$sec_resolution', '$width'x800, 1, bitdepth, 10/g' $CONF

