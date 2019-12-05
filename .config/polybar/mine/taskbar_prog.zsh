#!/bin/zsh
titulos_function () {
export ids=($(bspc query -N))
if { xwinfo -n $ids[@]|grep -v "N/A" 2>/dev/null } && continue || titulos_correcao
}
titulos_correcao () {
for (( i = 1; i <= ${#ids}; i++ ))
	{ if { xwinfo -n $ids[$i] | grep -v "N/A" 2>/dev/null } && continue ||echo "BUGADO" }
}

youtube () {
export url=`ps $(pgrep mpv)|sed -n 2p|sed 's/.*bitrate\:0\} //g'`
[[ "$urlold" != "$url" ]] && tube=`youtube-dl --get-title $url` && export tubeold=$tube && echo $tube || echo $tubeold
}

titulos_correcao.bkp () {
export ids=($(bspc query -N))
for (( i = 1; i <= ${#ids}; i++ ))
{
	{xwinfo -n $ids[$i] | grep -v N/A} 2>/dev/null
	[[ $? > 0 ]]&& echo "BUGADO"
}
}

ids_function () { 
export listarray=($(bspc query -N))
for ((i=1;i<=${#listarray};i++)) 
{ 
	[[ $(xwinfo -c $listarray[$i]|grep -v "N/A") ]]&& echo $listarray[$i] 
} 
}

direcionamento () { 
sleep 0.5 
export titulonew="$(titulos_function)" 
[[ "$tituloold" != "$titulonew" ]]&& export tituloold=$titulonew && icons||direcionamento 
}

icons () { 
export ids=($(ids_function))
for (( i=1;  i<=${#ids}; i++ )) 
{ 
	if { xwinfo -n $ids[$i] 2>/dev/null } && export titulo=`xwinfo -n $ids[$i]|awk {'print $1,$2,$3'}` || export titulo="$(youtube)"    #$(youtube-dl --get-title `ps $(pgrep smplayer)| sed 's/.*-playlist//g'|sed -n 2p`)
	export programa=`xwinfo -i ${ids[$i]}|sed 's/\-//g'` 
	export id=${ids[$i]}
	eval icon='$'$programa
	[[ -z $icon ]] && icon=$default
	export labels="${labels}\n$id $icon $titulo" 
}
echo "$labels" |grep '[[:digit:]]' > $bd 
export labels=""
modules 
}

modules () {
for (( i=1; i <= ${#ids}; i++ )) 
{ 
	polybar-msg hook x$i 2
	sleep 0.05 
}
for (( i=$(( ${#ids} + 1 )); i <= $contadorold; i++ ))
{ 
	polybar-msg hook x$i 1
	sleep 0.05 
} 
export contadorold=${#ids} 
direcionamento 
}
export urlold="PORRA"
. $path_proj/taskbar_icons.zsh




