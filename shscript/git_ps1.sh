MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[0;32m\]"
NORMAL="\[\033[0;00m\]"
GIT_PS1_SHOWDIRTYSTATE=true

PS1="[\u@\h \W"'$(
    if [[ $(__git_ps1) =~ \*\)$ ]]
    # a file has been modified but not added
    then echo "'$YELLOW'"$(__git_ps1 " (%s)")"'$NORMAL'"
    elif [[ $(__git_ps1) =~ \+\)$ ]]
    # a file has been added, but not commited
    then echo "'$MAGENTA'"$(__git_ps1 " (%s)")"'$NORMAL'"
    # the state is clean, changes are commited
    else echo "'$GREEN'"$(__git_ps1 " (%s)")"'$NORMAL'"
    fi)'"]\$ "
