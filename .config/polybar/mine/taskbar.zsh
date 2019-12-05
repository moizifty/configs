#!/bin/zsh
if [[ -z $1 ]]; then
	export path_proj=$HOME/.config/polybar
	. $path_proj/taskbar_vars.zsh
	prog
	>| /tmp/taskbar
	. $path_proj/taskbar_prog.zsh
	direcionamento
else
	export path_proj=$HOME/.config/polybar
	. $path_proj/taskbar_vars.zsh
	func
	. $path_proj/taskbar_func.zsh
	$1 $2
fi


	
	
	
	





