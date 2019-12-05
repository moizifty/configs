#!/bin/zsh
. $HOME/.config/polybar/taskbar_icons.zsh

mpvurl ()  {
pids=($(pgrep mpv))
for ((i=1;i<=${#pids};i++))
{
	url=$(ps aux |grep $pids[$i]|sed 's/.*bitrate\:0\} //g'|sed -n "$i"p)
	echo $mpv $(youtube-dl --get-title $url)
}
}
mpvlocal () {
echo $mpv $(ps aux |grep '[m]'pv|grep -Ev 'config|teste.zsh'|awk {'print $12,$13,$14,$15,$16,$17,$18'})
}
smplayerg () {
echo $smplayer "$(ps aux |grep '[t]mp\/smplayer' |sed -E 's/.*\}|.*\///g'|head -c 50)"	
}
smplayerg



