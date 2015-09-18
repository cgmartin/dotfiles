
# Node paths
# ---------------------------------------------------------------------
NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Java / Maven
# ---------------------------------------------------------------------
export MAVEN_OPTS="-Xmx1024m"
export M2_HOME="/Users/chmartin/apache-maven-2.2.1"
export MAVEN_HOME=$M2_HOME
export MVN_HOME=$M2_HOME
export M2=${M2_HOME}/bin
#export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home" # 1.6+
#export JAVA_HOME="/Library/Java/Home"  # 1.7+
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home"
export TOMCAT_HOME=/usr/local/TomcatTSS-6.0.35.1
export TOMCAT_PID=/var/tmp/TomcatTSS-6.0.35.1.pid

# Path
# ---------------------------------------------------------------------
PATH=/usr/local/bin:$PATH
PATH=$M2:$PATH
PATH=$TOMCAT_HOME/bin:$PATH
PATH=$NPM_PACKAGES/bin:$PATH
PATH=~/bin:$PATH
PATH=$(npm bin):$PATH
export PATH

# Colors
# ---------------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export TERM="xterm-color"
. ~/.bash_colors

# Bash Completion
# ---------------------------------------------------------------------
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# History
# ---------------------------------------------------------------------
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

# Prompt
# ---------------------------------------------------------------------
GIT_PS1_SHOWDIRTYSTATE=true
PS1=""
PS1+="$C_WHITE\u$C_RESET" # user
PS1+="@mbp"
#PS1+="$C_WHITE\h$C_RESET" # hostname
PS1+=" "
PS1+="$C_CYAN\w$C_RESET" # cwd
#PS1+="$C_YELLOW$(__git_ps1)$C_RESET" # git branch
PS1+='$(
    if [[ $(__git_ps1) =~ \+\)$ ]]; then
        echo "'$C_RED'"
    elif [[ $(__git_ps1) =~ \*\)$ ]]; then
        echo "'$C_YELLOW'"
    else
        echo "'$C_GREEN'"
    fi
)$(__git_ps1)$(echo "'$C_RESET'")'
PS1+='$(
    if [ ! -z "$DOCKER_MACHINE_NAME" ]; then
        echo " '$C_DARKGRAY'[$DOCKER_MACHINE_NAME]'$C_RESET'"
    fi
)'
PS1+=" \$ "
export PS1

PROMPT_COMMAND="history -a; history -c; history -r;"     # save and reload history after each command
PROMPT_COMMAND+='echo -ne "\033]0;${USER}@mbp: ${PWD/#${HOME}/~}\007";'
export PROMPT_COMMAND

# Set VI Editor
# ---------------------------------------------------------------------
set -o vi
export EDITOR=/usr/bin/vi

# Set default blocksize for ls, df, du
# ---------------------------------------------------------------------
export BLOCKSIZE=1k

# Aliases
# ---------------------------------------------------------------------
alias ls='ls -F'
alias ll='ls -FGlAhp'
ide () { /Applications/IntelliJ\ IDEA\ 14.app/Contents/MacOS/idea "$(cd ${1:-`pwd`}; pwd)" >/dev/null 2>&1; }
mkcd () { mkdir -p "$1" && cd "$1"; }
trash () { command mv "$@" ~/.Trash ; }
numFiles () { ls -1 | wc -l; }

function col {
    awk -v col=$1 '{print $col}'
}

function skip {
    n=$(($1 + 1))
    cut -d' ' -f$n-
}

alias jump='ssh MGMTPROD\\martc342@qn7prlts01.starwave.com'
alias npmb='npm --registry=https://registry.npmjs.org/'
alias nbi='npm install && bower install'
alias make1mb='mkfile 1m ./1MB.dat'
alias make5mb='mkfile 5m ./5MB.dat'
alias make10mb='mkfile 10m ./10MB.dat'
alias qfind="find . -name "
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias ttop="top -R -F -s 10 -o rsize"
myPs() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; } 
alias getUrl='curl -Lks'

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias usedPorts='sudo lsof -i | grep LISTEN'        # usedPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

ii() {
    red="\033[31m"
    cr="\033[m"
    echo -e "\n${red}System info:$cr " ; uname -a
    echo -e "\n${red}Users logged on:$cr " ; w -h
    echo -e "\n${red}Current date :$cr " ; date
    echo -e "\n${red}Machine stats :$cr " ; uptime
    echo -e "\n${red}Current network location :$cr " ; scselect
    echo -e "\n${red}Public facing IP Address :$cr " ; myip
    #echo -e "\n${red}DNS Configuration:$cr " ; scutil --dns
    echo
}

function gclonecd(){
    git clone $1 && cd $(basename $1 .git)
}

alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

httpHeaders () { /usr/bin/curl -I -L $@ ; }
httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

# Docker Utils
# ---------------------------------------------------------------------
alias d='docker'
alias b2d='boot2docker'
alias dm='docker-machine'
alias ds='docker-swarm'

dme() { eval "$(docker-machine env $1)"; }
dmes() { eval "$(docker-machine env --swarm $1)"; }

alias drmStopped='docker rm -v $(docker ps -a -q -f status=exited)'
alias drmiUntagged='docker rmi $(docker images -q -f dangling=true)'
alias drmiAll='docker rmi $(docker images -q)'
alias docker-stats='docker stats $(docker ps -q)'
alias docker-clean='echo "Cleaning stopped containers..."; drmStopped 2>/dev/null; echo "Cleaning untagged images..."; drmiUntagged 2>/dev/null'
alias docker-clean-all='docker-clean; echo "Cleaning all images..."; drmiAll 2>/dev/null'
function dimgEnv {
    docker run --rm "$1" env
}

# Mark Directories
# ---------------------------------------------------------------------
export MARKPATH=$HOME/.marks
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}   
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}   
function unmark { 
    rm -i "$MARKPATH/$1"
}   
function marks {
    /bin/ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f10- | sed "s/ -/	-/g" && echo
}   
function _marks {
    /bin/ls "$MARKPATH"
}

# completion command for jump
function _jumpcomp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_marks`' -- $curw))
    return 0
}

# bind completion for jump to _jumpcomp
complete -F _jumpcomp jump

# Todos
# ---------------------------------------------------------------------
export TODO=$HOME/.todos
function todo() { 
    if [ $# == "0" ];
        then cat $TODO;
    else 
        echo "• $@" >> $TODO;
    fi
}   
function todone() { 
    sed -i -e "/$*/d" $TODO;
}
