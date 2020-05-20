get_all()
{
	echo $(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null)
}
get_album()
{
	echo $(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | egrep -A 1 "album" | egrep -v "album" | cut -b 44- | cut -d '"' -f 1 | egrep -v ^$)
}
get_artist()
{
	echo $(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null |	egrep -A 2 "artist" | egrep -v "artist" | egrep -v "array" | cut -b 27- | cut -d '"' -f 1 | egrep -v ^$)
}
get_id()
{
	echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | grep spotify:track | cut -d ":" -f3 | cut -d '"' -f1 | sed -n '1p')
}
get_imgurl()
{
	echo $(curl -X GET https://api.spotify.com/v1/tracks/$1 2>/dev/null | grep '"url" : ' | sed '2q;d' | cut -d '"' -f4)
}
get_title()
{
	echo $(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 "title"|egrep -v "title"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$)
}
get_cover()
{
	if [ ! -d ~/dotfiles/conky/conky-spotify/current ]; then
		mkdir -p ~/dotfiles/conky/conky-spotify/current
	fi
	id_current=$(cat ~/dotfiles/conky/conky-spotify/current/current.txt 2>/dev/null)
	id_new=$(get_id)
	cover=
	imgurl=

	if [ "$id_new" != "$id_current" ]; then

		cover=`ls ~/dotfiles/conky/conky-spotify/covers | grep $id_new`

		if [ "$cover" == "" ]; then

			imgurl=$(get_imgurl $id_new)
			wget -O ~/dotfiles/conky/conky-spotify/covers/$id_new.jpg $imgurl
			cover=`ls ~/dotfiles/conky/conky-spotify/covers | grep $id_new`
		fi

		if [ "$cover" != "" ]; then
			cp ~/dotfiles/conky/conky-spotify/covers/$cover ~/dotfiles/conky/conky-spotify/current/current.jpg
		else
			cp ~/dotfiles/conky/conky-spotify/covers/empty.jpg ~/dotfiles/conky/conky-spotify/current/current.jpg
		fi

		echo $id_new > ~/dotfiles/conky/conky-spotify/current/current.txt
	fi
}

case $1 in
	*album*)
		get_album
		;;
	*title*)
		get_title
		;;
	*id*)
		get_id
		;;
	*artist*)
		get_artist
		;;
	*cover*)
		get_cover 2>/dev/null
		;;
	*imgurl*)
		get_imgurl $2
		;;
	*running*)
		pidof spotify >/dev/null || exit 1
		;;
	*)
		get_all
		;;
esac
