export LANG=ja_JP.UTF-8

alias reload='source ~/.zshrc'
alias q='exit'

export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/texbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
# Homebrew coreutils: /usr/local/opt/coreutils/libexec/gnubin
#  $(brew --prefix coreutils)/libexec/gnubin
# Homebrew: /usr/local/bin
# MacTeX: /usr/texbin
# rename: /usr/bin

if [ `hostname -s` = "lotus" ];then
    export PATH=/data/tmplocal/bin/:$PATH
fi

export TERM=xterm-256color

# http://nanabit.net/blog/2009/11/29/insert-date-on-single-key/
function insert_date {
  LBUFFER=$LBUFFER'$(date +%Y-%m-%d)'
}
zle -N insert_date
bindkey '^[[15~' insert_date

autoload colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)[%b]'
zstyle ':vcs_info:*' actionformats '(%s)[%b|%a]'
precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_
}
PROMPT=$'%f%3F%~ %1(v|%F{green}%1v%f|)
[%n@%m]$ '
# PROMPT="%{${fg[yellow]}%}%~%{${reset_color}%} 
# [%n]$ '
PROMPT2='[%n]> '

export EDITOR='emacsclient -nw'
# export VISUAL=emacsclient
export ALTERNATE_EDITOR=''
export GIT_EDITOR='emacsclient -nw'
# alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
alias e='emacsclient -nw'    # CUI
alias ee='emacsclient -c -n' # GUI
function kes() {
    emacsclient -e '(kill-emacs)';
}
function kec() {
    pkill -f 'emacsclient -nw';
}
function kill-emacs()  {
    emacsclient -e '(kill-emacs)';
    pkill -f 'emacsclient -nw';
}

# gnu like
# $ brew install coreutils findutils gnu-sed gawk 

# coreutils
export MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH
# findutils
alias find='gfind'
alias locate='glocate'
alias updatedb='gupdatedb'
alias xargs='gxargs'
# gnu-tar, gnu-sed, gawk
alias tar='gtar'
alias sed='gsed'
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
alias awk='gawk'

# gls
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
# http://linux-sxs.org/housekeeping/lscolors.html
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
alias l='ls -lhGAF --color'
alias ls='ls -F --color'
#       -l     use a long listing format
#       -h, --human-readable
#              with -l, print sizes in human readable format (e.g., 1K 234M 2G)
#       -G, --no-group
#              in a long listing, don't print group names
#       -A, --almost-all
#              do not list implied . and ..
#       -F, --classify
#              append indicator (one of */=>@|) to entries

alias diff='colordiff -u'
#       -u  -U NUM  --unified[=NUM]
#              Output NUM (default 3) lines of unified context.

export LESS=-R
# alias less='less -R'
#       -R or --RAW-CONTROL-CHARS
#              Like  -r,  but  only ANSI "color" escape sequences are output in "raw" form.
#              Unlike -r, the screen appearance is  maintained  correctly  in  most  cases.
#              ANSI "color" escape sequences are sequences of the form:
# 
#                   ESC [ ... m
# 
#              where  the "..." is zero or more color specification characters For the pur-
#              pose of keeping track of screen appearance, ANSI color escape sequences  are
#              assumed  to  not  move  the cursor.  You can make less think that characters
#              other than "m" can end ANSI color escape sequences by setting  the  environ-
#              ment  variable  LESSANSIENDCHARS  to  the list of characters which can end a
#              color escape sequence.  And you can make less think  that  characters  other
#              than  the  standard ones may appear between the ESC and the m by setting the
#              environment variable LESSANSIMIDCHARS to the list of  characters  which  can
#              appear.
alias ll='less'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
setopt auto_cd # ディレクトリ名だけで移動
setopt auto_pushd
setopt pushd_ignore_dups
alias p='popd'
function chpwd() { ls; echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"} # ls後にcd?

alias f='fg'

alias grep='grep --color'

alias m='make'
alias mc='make clean'
alias md='make depend'

alias g='git'
alias gi='git init'
alias ga='git add'
alias gr='git reset'
alias gc='git commit'
alias gco='git checkout'
alias gl='git log'
alias gb='git branch'

alias o='open'
alias of='open .'

# java
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
# http://d.hatena.ne.jp/snaka72/20120101/1325403702

alias t='latexmk'
alias tp='latexmk -pvc'
alias tc='latexmk -c'
alias tC='latexmk -C'

alias jakld='rlwrap java -Xss1m -jar ~/Dropbox/java/scheme/jakld-20121227.jar'
alias jak='jakld'

# alias ngspice='rlwrap ngspice'

# 存在するファイルにリダイレクトしない
#
# リダイレクトしたい場合は
# unset noclobber
#  or
# >!
setopt noclobber

# mv 拡張
autoload -Uz zmv
alias zmv="noglob zmv -w"

# 補完
# fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(~/.zsh/zsh-completions $fpath)

autoload -U compinit
compinit
zstyle ':completion:*:default' list-colors ${LS_COLORS} # 補完候補に色
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # tab補完時に大文字小文字無視

setopt complete_aliases

# history
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt share_history # share command history data
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# zaw
source ~/.zsh/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes
bindkey '^l' zaw-cdr

setopt extended_glob

