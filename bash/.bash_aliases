#author: Aurelien Martin
#My daily aliases that used on all my Linux (Debian) desktop.
#Some aliases and functions have been taken on various website so
#feel free to copy and use them to save your fingers

#### Generic aliases

alias ll='ls -l'
alias la='ls -la'
alias d='ls -l | grep -E "^d"'
alias c='clear'
#alias apt-get='sudo apt-get'
alias aptgi='sudo apt-get install'
alias aptgu='sudo apt-get update'
alias aptcp='sudo apt-cache policy'
alias aptcs='sudo apt-cache search'
alias bashupdate='source ~/.bash_aliases'
alias ports='netstat -tulanp'
alias header='curl -I'
alias mount='mount |column -t'
alias pubkey='cat ~/.ssh/id_rsa.pub'
alias pubhash='find ~/.ssh/ -name *.pub -exec ssh-keygen -E md5 -lf {} \;'
alias logmess='sudo tail -50 /var/log/messages'

alias vimrc='vim ~/.vimrc'
alias vialias='vim ~/.bash_aliases'
alias svim='sudo vim'
alias vipkg='vim ~/debian-mypkg.sh'
alias viplug='vim ~/.vim/plugins.vim'

alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

alias suspendinfo='systemctl list-unit-files | egrep "sleep|suspend|hibernate|hybrid"'

alias back='cd $OLDPWD'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Load private aliases if exist.

if [ -f ~/.bash_aliases_private ]; then
    source ~/.bash_aliases_private
fi

#### Private non-versinoned aliases

#### Functions

lan_ip() {
  echo "$(/sbin/ifconfig 2>/dev/null | grep 'inet '|grep -v '127.0.0.1'| awk '{print $2}'|cut -d':' -f2|head -1)"
}

wan_ip() {
  curl ifconfig.me 
}

lsln() {
 ls -la --color=always $1 | grep --color=never '>'
}

genpasswd() {
    local l=$1
        [ "$l" == "" ] && l=16
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

xevkey() {
    xev | sed -n 's/^.*state \([0-9].*\), keycode *\([0-9]\+\) *\(.*\), .*$/keycode \2 = \3, state = \1/p'
}

xcolors() {
   (x=`tput op` y=`printf %76s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)
}

cppk() {
if [ $# -eq 0 ];then
    echo "Please provide full path of the pub key";
    else
        cat $1 | ssh $2 $3 'cat - >> ~/.ssh/authorized_keys'
fi
}

extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

mkcdr() {
    mkdir -p -v $1
    cd $1
}

mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

listcolors () {
	for((i=16; i<256; i++)); do
		printf "\e[48;5;${i}m%03d" $i;
		printf '\e[0m';
		[ ! $((($i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
	done
}

aptcheck() {

cat /etc/apt/sources.list
ls -l /etc/apt/sources.list.d
cat /etc/apt/preferences
ls -l /etc/apt/preferences.d
ping -c 3 debian.org


}
