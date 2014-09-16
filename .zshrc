alias q='exit'

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
  echo -ne "\ek/$PWD:t:idle\e\\" # screen/tmux: change window name
}
PROMPT=$'%f%3F%~ %1(v|%F{green}%1v%f|)
[%n@%m]$ '
# PROMPT="%{${fg[yellow]}%}%~%{${reset_color}%} 
# [%n]$ '
PROMPT2='[%n]> '

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

# gnu ls
# http://linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
alias l='ls -lhGAF --color'
alias ls='ls -F --color'
# -l     use a long listing format
# -h, --human-readable
#        with -l, print sizes in human readable format (e.g., 1K 234M 2G)
# -G, --no-group
#        in a long listing, don't print group names
# -A, --almost-all
#        do not list implied . and ..
# -F, --classify
#        append indicator (one of */=>@|) to entries

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
function chpwd() { # 
  ls
  echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"
}
function preexec() { # コマンド実行直後
  mycmd=(${(s: :)${1}})
  echo -ne "\ek/$PWD:t:$mycmd[1]\e\\" # screen/tmux: change window name
}

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

alias screen='screen -U' # utf-8

alias t='latexmk'
alias tp='latexmk -pvc'
alias tc='latexmk -c'
alias tC='latexmk -C'

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

####################################
# history
####################################
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt share_history # share command history data

# 入力途中で C-p C-n
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# peco
# via. http://qiita.com/uchiko/items/f6b1528d7362c9310da0
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^R' peco-select-history


# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

setopt extended_glob




case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshrc.darwin ]; then . $HOME/.zshrc.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshrc.linux ]; then . $HOME/.zshrc.linux; fi
    ;;
esac
if [ -f $HOME/.zshrc.local ]; then . $HOME/.zshrc.local; fi
