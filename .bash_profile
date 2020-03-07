#------------
## My Servers
#-------------

HOST_NAME=""
ROUTER_IP=""

NASUSER=()
NAS=()

LAP101USER=()
LAP101=()
LAP101PORT=()
LAP101GUI=()

BERRYUSER=()
BERRY=()
BERRYPORT=()

TORRENTUSER=()
TORRENT=()

SSHUTTLEIP=()
SSHUTTLEPORT=()
SSHUTTLEUSER=()

#---------------
## Export PATHS 
#---------------

export PS1="\[\e[36;40m\]\u\[\e[m\]\[\e[35m\]@\[\e[m\][\[\e[33m\]\h\[\e[m\]]\[\e[36m\]\w\[\e[m\]: "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PATH="/usr/local/opt/cython/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export BASH_SILENCE_DEPRECATION_WARNING=1



#----------
## Programs 
#----------


#--------------clock----------------------
#Terminal clock,  needs figlet installed
#----------------------------------------

alias clock="while true ; printf '\e[8;6;38t' ; do tput clear; date +'%H : %M : %S' | figlet -f small ; sleep 1; done"


#------------- macinfo ----------------------
# Displays info about the mac,  cpu , net etc.
#--------------------------------------------

macinfo () {

my_user="$(whoami)"
text_user=$my_user

mkdir -p /tmp/"$text_user"displayinfo
top -l 1 > /tmp/"$text_user"displayinfo/topstats
tmp_top="/tmp/"$text_user"displayinfo/topstats"

macos_ver="$(sw_vers | grep ProductVersion | sed 's/ProductVersion/MacOS/g' | awk '{print $2}')"

#Uptime
uptime_time="$(uptime | sed 's/.*up \([^,]*\), .*/\1/')"

uptime_load="$(uptime | rev | awk '{print $1, $2, $3}' | rev)"

#Network
network_down="$(cat $tmp_top | grep "Networks" | awk '{print $3}' | sed -e 's/[\/&]/\\ /g' | awk '{print $2}')"

network_up="$(cat $tmp_top | grep "Networks" | awk '{print $5}' | sed -e 's/[\/&]/\\ /g' | awk '{print $2}')"

#CPU Usage
cpu_used_user="$(cat $tmp_top | grep "CPU usage" | awk '{print $3}')"

cpu_used_sys="$(cat $tmp_top | grep "CPU usage" | awk '{print $5}')"

cpu_used_idle="$(cat $tmp_top | grep "CPU usage" | awk '{print $7}')"


#Disk name
startup_name="$(osascript -e 'tell app "Finder" to get name of startup disk')"

startup_size="$(df -H / | awk '{print $2}' | awk 'NR==2')"

startup_used="$(df -H / | awk '{print $3}' | awk 'NR==2')"

startup_free="$(df -H / | awk '{print $4}' | awk 'NR==2')"


#colours
colour_blue="\033[36m"

colour_yellow="\033[33m"

tmp_file="/tmp/"$text_user"displayinfo/terminfo"

echo " " > $tmp_file

echo -e "$colour_yellow" "MacOS" "*&*" "Boot Volume" "*&*" "Volumes Size" "*&*" "Total Used" "*&*" "Total Free" "*&*" "Uptime" "*&*" "Load Averages"  "*&*" "CPU User" "*&*" "CPU System" "*&*" "CPU Idle" "*&*" "Network Down" "*&*" "Network Up" "$colour_stop" >> $tmp_file
echo -e "$colour_blue"  "${macos_ver}" "*&*" "${startup_name}" "*&*" "${startup_size}"bs "*&*" "${startup_used}"bs "*&*" "${startup_free}"bs "*&*" "${uptime_time}" "*&*" "${uptime_load}" "*&*" "${cpu_used_user}" "*&*" "${cpu_used_sys}" "*&*" "${cpu_used_idle}" "*&*" "${network_down}" "*&*" "${network_up}" "$colour_stop" >> $tmp_file


#prints screen
cat /tmp/"$text_user"displayinfo/terminfo | awk '$1=$1' > /tmp/"$text_user"displayinfo/termdone

display_center(){
    columns="$(tput cols)"
    while IFS= read -r line; do
        printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
    done < "$1"
}

cat /tmp/"$text_user"displayinfo/termdone | column -s "*&*" -t 

terminalsize="$(head -1 /tmp/"$text_user"displayinfo/termdone | column -s "*&*" -t | wc -c)"

fix_printf="'\e[8;20; $terminalsize t'"
fixspace_printf="$(echo $fix_printf | sed 's/ //g' > /tmp/"$text_user"displayinfo/termsize)"
cmd_printf="$(cat /tmp/"$text_user"displayinfo/termsize)"
printf $cmd_printf


}



#------------------- gosu ---------------------------------------------
#Runs Sudo -s in a diffrent window and changes the colour of the window
#----------------------------------------------------------------------
gosu () {
/usr/bin/osascript <<EOT
tell application "Terminal"
set newTab to do script "sudo -s"
                set theWindow to first window of (every window whose tabs contains newTab)
                set windowId to theWindow's id
                repeat with i from 1 to the count of theWindow's tabs
                        if item i of theWindow's tabs is newTab then set tabNumber to i
                end repeat
                get {windowId, tabNumber}
                set current settings of newTab to settings set "Red Sands"

end tell
EOT
}



#------------ extract ---------------
#unzips all files using the right tool
#-------------------------------------
extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

#----------- cd -------------------------
# List directory when cd
#----------------------------------------
cd() { builtin cd "$@"; ls -hla; }   




#   ––––––––--------- cdf ------------------------
#   Cd to frontmost window of MacOS Finder
#   -----------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#-------- gohome---------------------------
#starts sshuttle,  gets info from my servers
#-------------------------------------------

gohome () {
sshuttle --no-latency-control --dns -N --remote $SSHUTTLEUSER@$SSHUTTLEIP':'$SSHUTTLEPORT 0/0   
}



#-------- stophome -----------------
#stops sshuttle
#-----------------------------------

stophome () {
get_pid=$(ps aux | grep "sshuttle" | grep $SSHUTTLEIP | awk '{print $2}')
try_kill=$(kill $get_pid && echo -n "Disconnected" ||  echo -n  'Could not Disconnect, Is SShuttle running?' 1>&2 ; exit 1;  )
$try_kill
}


#-------- make_ssh -----------------
# function make_ssh
# 
# 
# 
# Arguments:
#  e.g. make_ssh dave 192.168.5.10 22 -Y 
#
#-----------------------------------



function make_ssh() {

gui_on="$4"
ssh_user="$1"
ssh_ip="$2"
ssh_port="$3"

ssh_cmd="ssh"

get_loc="$(networksetup -getinfo Wi-Fi |  awk 'NR==4' | awk '{print $2}')"

if [ "$get_loc" != "$ROUTER_IP" ]; then

ssh_ip="$HOST_NAME"

fi

if [ -z "$gui_on" ]; then

ssh_cmd="$ssh_cmd"

else
      ssh_cmd="$ssh_cmd $gui_on "
fi

ssh_cmd="$ssh_cmd $ssh_user"@"$ssh_ip"


if [ -z "$ssh_port" ]; then

ssh_cmd="$ssh_cmd"

else
      ssh_cmd="$ssh_cmd -p $ssh_port"
fi

$ssh_cmd

}


#----------
## Programs End 
#----------


#--------
## Alias
#---------

alias ls='ls -GFhla'
alias flushDNS='dscacheutil -flushcache'
alias jdir='wget -r -c --no-parent '
alias jd='wget -c '
alias checkip='curl ipinfo.io'


#--------
## Server Alias
#---------

alias mynas='make_ssh $NASUSER $NAS'
alias myberry='make_ssh $BERRYUSER $BERRY $BERRYPORT $PIGUI'
alias lintop101='make_ssh $LAP101USER $LAP101 $LAP101PORT $LAP101GUI'
alias torrentbox='make_ssh $TORRENTUSER $TORRENT'

#---------
## X11 Window manager
#---------
alias startx11='exec startxfce4 --disable-wm-check'

#-----------------------------------
##END
#-----------------------------------

