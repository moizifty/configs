#!/bin/zsh
#--------------VARS-----------------#
func () {
export bd=/tmp/taskbar
export config=$path_proj/taskbar_config
export bars=("dock" "dockx") #altere para o nome suas bars ela precisam estar a posição bottom.
}

prog () {
export ids=($(zsh $path_proj/taskbar.zsh ids_function))
export tituloold=""
export contadorold=${#ids}
export bd=/tmp/taskbar
}
