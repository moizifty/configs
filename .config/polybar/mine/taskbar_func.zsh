#!/bin/zsh
##########BSPC###################
label () {printf '%26s' "$(sed -n $1'p' $bd|awk {'print "%{T2}"$2"%{T-}"'}) $(printf '%-23s' "$(sed -n $1'p' $bd|awk {'print $3,$4,$5,$6'}|tail -c 23)") $(printf '%1s' "%{T2}﬋%{T-}")"}
foco () {bspc node $(sed -n $1'p' $bd |awk {'print $1'}) -f}
close () {bspc node $(sed -n $1'p' $bd |awk {'print $1'}) -k}
tiled () {bspc node $(sed -n $1'p' $bd |awk {'print $1'}) -t tiled}
floating () {bspc node $(sed -n $1'p' $bd |awk {'print $1'}) -t floating}
sticky () {bspc node $(sed -n $1'p' $bd |awk {'print $1'}) --flag sticky=on}
stickyoff () {bspc node $(sed -n $1'p' $bd |awk {'print $1'}) --flag sticky=off}
###########LAUNCH POLYBAR########
launch () {
pkill -9 polybar
if [[ $(xrandr |grep -E "HDMI|conectado"|grep -v "desconectado") ]];then 
    polybar -c $config $bars[1] -q -r  &> /dev/null &
    polybar -c $config taskbar1 -q -r &> /dev/null &
    polybar -c $config taskbar2 -q -r &> /dev/null &
    polybar -c $config $bars[2] -q -r &> /dev/null &
else
    polybar -c $config dock -r &> /dev/null 
    polybar -c $config taskbar1 -r &> /dev/null
fi
}
launch.test () {
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload taskbar &
    MONITOR=$m polybar --reload bar2 &
done
}
##########PROCESS#################
process_base () {
echo $USER@$HOST
for ((i=1;i<=$(($(echo $USER@$HOST|wc -c)-1));i++)){echo -n $i"*"|sed 's/'$i'//g'}
echo
ps aux |\
grep -E '[m]onitor.zsh|[t]askbar.zsh|[p]olybar'|\
grep -v '[p]'rocess|\
awk {'print $11, $12, $13,$ 14"|",$2"|",$3"|",$4"|"'}|\
column --table --table-truncate=PROCESS --separator "|" --table-columns PROCESS,PID,CPU%,MEM% -o "|" --table-order PID,MEM%,CPU%,PROCESS |\
sort -gk 1
}
process () {
bg=(tput setab $1)
fg=(tput setaf $1)
while true; do
  echo -n "$(process_base)" > /tmp/process
  i=8
  while read line; do
    [[ $i -le 7 ]] && i=$(($i+1)) || i=1
    $bg $i; $fg 0; echo $line;$fg 0;$bg 0
  done < /tmp/process
  sleep 2
  clear 
done
}
###########REDE#########
rede () {
#wifi=($(head /proc/net/wireless |grep 000|awk {'print $1'}|sed 's/://g'))
#eth=($(head /proc/net/dev |grep -Ev 'wlp|lo|face|Inter'|awk {'print $1'}|sed 's/://g'))
#con=($eth $wifi)
con=($(head /proc/net/wireless |grep 000|awk {'print $1'}|sed 's/://g') $(head /proc/net/dev |grep -Ev 'wlp|lo|face|Inter'|awk {'print $1'}|sed 's/://g'))
for (( i = 1; i <= ${#con[@]}; i++ )); do
  ativ=$(grep $con[$i] /proc/net/dev|awk {'print $2'})
  [[ $ativ > 0 ]]&&\
    case $con[$i] in
      enp* ) icon[$i]="";;
      wlp* ) icon[$i]="";;
      tun* ) icon[$i]="";;
      modem* ) icon[$i]="";;
      * ) icon[$i]="<?>";;
    esac || continue
done
echo $icon[@]
}
###########UPTIME#########
uptime () {
menuuptime=$(dialog --menu "Selecione uma opção" 0 0 0 \
1 "poweroff" \
2 "reboot" \
3 "tty" --stdout)

case $menuuptime in
  1) "poweroff";;
  2) "reboot";;
  3) "pkill -9 -U $USER";;
esac
}
###########RELOGIO & CALENDARIO#########
relogio () {
hour=$(date +%H%M)
for (( i = 1; i <= 4; i++ )); do
  case `echo $hour |cut -c$i` in
   0)icons[$i]="";;
   1)icons[$i]="";; 
   2)icons[$i]="";;
   3)icons[$i]="";;
   4)icons[$i]="";;
   5)icons[$i]="";;
   6)icons[$i]="";;
   7)icons[$i]="";;
   8)icons[$i]="";;
   9)icons[$i]="";;
   *)icons[$i]=":";;
  esac
done
echo "%{T3} $icons[1]$icons[2]:$icons[3]$icons[4]  ⏽"
}
relogio-extenso () {
dayweek=$(date |awk {'print $1'})
date=$(date +%d%m)
for (( i = 1; i <= 4; i++ )); do
  case `echo $date |cut -c$i` in
   0)icons[$i]="";;
   1)icons[$i]="";; 
   2)icons[$i]="";;
   3)icons[$i]="";;
   4)icons[$i]="";;
   5)icons[$i]="";;
   6)icons[$i]="";;
   7)icons[$i]="";;
   8)icons[$i]="";;
   9)icons[$i]="";;
   *)icons[$i]=":";;
  esac
done
echo "$icons[1]$icons[2]/$icons[3]$icons[4] %{T2}$dayweek %{T3}"
}
calendario () {
nohup xterm -geometry 42x19 -e 'dialog --stdout --calendar "Olá Losão hoje é" 2 37 "$(date +%d%m%y)"' &
}
##########COLOR#################
color () {
bg=(tput setab $1)
fg=(tput setaf $1)
for ((f=0;f<=16;f++))
{
  for ((b=0;b<=16;b++))
  { 
    $bg $b;$fg $f ;echo -n "|$(printf '%-4s' "bg$b")|$(printf '%-4s' "fg$f")|"; $bg 0; $fg 0  
  }
  echo
}
$fg 0;$bg 0
}
###AUTOSTART####
monitores () {
xrandr|grep -E "'[A-Z]'|connected "|grep -v "disconnect"|awk {'print $1'}|sed -n $1'p'
}
start () {
nohup zsh $path_proj/taskbar_monitor.zsh &> /dev/null &
}
restart () {
pid_task=($(ps aux|\grep -E '[m]onitor.zsh|[t]askbar.zsh$'|\grep -v '[p]'rocess|awk {'print $2'}))
kill $pid_task[@]
taskbar.zsh start
}
stop () {
pid_task=($(ps aux|\grep -E '[m]onitor.zsh|[t]askbar.zsh$'|\grep -v '[p]'rocess|awk {'print $2'}))
kill $pid_task[@]
}
###DIVERSOS###
programas () { 
export ids=($(bspc query -N)) 
xwinfo -i ${ids[@]}|grep -v "N/A" 
}
ids_function () { 
export listarray=($(bspc query -N))
for ((i=1;i<=${#listarray};i++)) 
{ 
  [[ $(xwinfo -c $listarray[$i]|grep -v "N/A") ]]&& echo $listarray[$i] 
} 
}
id () {
head -100 $bd
}

title () {
[[ -n $1 ]]
  url=$(youtube-dl --get-title $1)
  nohup mpv $1 --title "$url" > /dev/null &
[[ -z $1 ]]
  url=$(youtube-dl --get-title $(xclip -sel clipboard -o))
  nohup mpv $(xclip -sel clipboard -o) --title "$url" > /dev/null &
}
titlepl () {
url=$(youtube-dl --get-title $1)
smplayer -add-to-playlist $1
}
mpvurl ()  {
pids=($(pgrep mpv))
for ((i=1;i<=${#pids};i++))
{
  url=$(ps aux |grep $pids[$i]|sed 's/.*bitrate\:0\} //g'|sed -n "$i"p)
  echo $(youtube-dl --get-title $url)
}
}
mpvlocal () {
echo $(ps aux |grep '[m]'pv|grep -Ev 'config|taskbar.zsh'|awk {'print $12,$13,$14,$15,$16,$17,$18'})
}
smplayerg () {
echo "$(ps aux |grep '[t]mp\/smplayer' |sed -E 's/.*\}|.*\///g'|head -c 50)"  
}
player () {
echo $($1)
}
