## Export PATHS ----------
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PATH="/usr/local/opt/cython/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"

## Alias ------------
alias ls='ls -GFhla'
alias mynas='ssh root@192.168.1.141'
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

alias qfind="find . -name "                 # qfind:    Quickly search for file
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cach

## Programs ----------

#unzips all files
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

# Always list directory contents upon 'cd'
cd() { builtin cd "$@"; ls; }   


#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
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


