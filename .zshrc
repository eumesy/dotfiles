autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz colors

export LANG=ja_JP.UTF-8

case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshrc.darwin ]; then . $HOME/.zshrc.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshrc.linux ]; then . $HOME/.zshrc.linux; fi
    ;;
esac
if [ -f $HOME/.zshrc.local ]; then . $HOME/.zshrc.local; fi

alias q='exit'

# http://nanabit.net/blog/2009/11/29/insert-date-on-single-key/
function insert_date {
  LBUFFER=$LBUFFER'$(date +%Y-%m-%d)'
}
zle -N insert_date
bindkey '^[[15~' insert_date

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

# GNU ls
# http://linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
alias ls='ls --color=auto'
alias ll='ls -lhGAF --color=auto'
# alias ll='ls -F --color=auto'
# With --color=auto, ls emits color codes only when  standard  output is connected to a terminal.
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

alias c='pygmentize -O style=monokai -f terminal256 -g'

export LESS='-R'
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
export LESSOPEN='|pygmentize-lessfilter %s'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

function chpwd() { # exec following commands after cd
  ls
  # echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"
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

########################################################################
# 補完
########################################################################
# fpath=(/usr/local/share/zsh-completions $fpath) # homebrew
fpath=(${HOME}/.zsh/zsh-completions/src $fpath)

autoload -U compinit
compinit
zstyle ':completion:*:default' list-colors ${LS_COLORS} # 補完候補に色
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # tab補完時に大文字小文字無視

setopt complete_aliases

# peco
function insert-file-by-peco(){
    LBUFFER=$LBUFFER$(ls -A | peco | tr '\n' ' ' | \
	sed 's/[[:space:]]*$//') # delete trailing space
    zle -R -c
}
zle -N insert-file-by-peco
bindkey '^o' insert-file-by-peco

########################################################################
# command history
########################################################################
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

# http://qiita.com/uchiko/items/f6b1528d7362c9310da0
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

########################################################################
# cd
########################################################################
# - http://blog.n-z.jp/blog/2013-11-12-zsh-cdr.html
# - > cdr: Peter Stephenson さんによる、ディレクトリ移動の履歴を複数のシェルのセッションをまたいで追跡するための関数群および含まれている関数
# - ~/.chpwd-recent-dirs に保存
########################################################################
# alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
setopt auto_cd # ディレクトリ名だけで移動
setopt auto_pushd
setopt pushd_ignore_dups
alias p='popd'

# cdr
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# peco-cdr
# http://futurismo.biz/archives/2514
function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^l' peco-cdr

setopt extended_glob

########################################################################
# ghq
########################################################################

function peco-src () {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src
