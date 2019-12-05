#!/bin/zsh
# catch non-zsh and non-interactive shells

[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

#####PUT THESE  LINES IN OTHER .ZSH configs if need be ######
#needed for pywal theme
(cat ~/.cache/wal/sequences &)

#put this line in /etc/enviroment file to make path permenant for login sesion
#this will let zathura not openned hrough terminal use pywal theme
export PATH="/home/moiz/.local/bin:$PATH"
##################################################

# set some defaults
export MANWIDTH=90
export HISTSIZE=10000
export SAVEHIST=10000

# path to the framework root directory
SIMPL_ZSH_DIR=$HOME/.zsh

# add ~/bin to the path if not already, the -U flag means 'unique'
typeset -U path=($HOME/bin "${path[@]:#}")

# used internally by zsh for loading themes and completions
typeset -U fpath=("$SIMPL_ZSH_DIR/"{completion,themes} $fpath)

# initialize the prompt
autoload -U promptinit && promptinit

# source shell configuration files
for f in "$SIMPL_ZSH_DIR"/{settings,plugins}/*?.zsh; do
    . "$f" 2>/dev/null
done

# uncomment these lines to disable the multi-line prompt
# add user@host, and remove the unicode line-wrap characters

# PROMPT_LNBR1=''
# PROMPT_MULTILINE=''
# PROMPT_USERFMT='%n%f@%F{red}%m'
# PROMPT_ECODE="%(?,,%F{red}%? )"

# load the prompt last
prompt adam2 

# system info and AL ascii art
al-info

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

