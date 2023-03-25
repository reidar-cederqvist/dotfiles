#!/usr/bin/env bash
#
# Find applicaation and execute based on .desktop file

set -x

Application=$1
search_dirs="/usr/share/applications/ /usr/local/share/applications/ $HOME/.local/share/applications/ /var/lib/snapd/"

for dir in $search_dirs; do
	[ -d "$dir" ] || continue
	entries=$(grep -ril "Name=.*$Application" $dir 2>/dev/null)
	for entry in $entries; do
		exec_string=$(awk -F 'Exec=' '/Exec=/ {print $2; exit}' $entry)
		while [[ "$exec_string" == *"%"* ]]; do
			exec_string=${exec_string%\%*}
		done
		[ $exec_string ] && break
	done
done

$exec_string
