# in ~/.zshenv, executed `unsetopt GLOBAL_RCS` and ignored /etc/zshrc
[ -r /etc/zshrc ] && . /etc/zshrc

autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz vcs_info

case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshrc.darwin ]; then . $HOME/.zshrc.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshrc.linux ]; then . $HOME/.zshrc.linux; fi
    ;;
esac
if [ -f $HOME/.zshrc.local ]; then . $HOME/.zshrc.local; fi

########################################################################
# 補完
########################################################################
typeset -U fpath
# zsh-completion via homebrew
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
# fpath=(${HOME}/.zsh/zsh-completions/src $fpath)
# conda
if [ -e $HOME/src/github.com/esc/conda-zsh-completion ]; then 
    fpath=($HOME/src/github.com/esc/conda-zsh-completion $fpath)
fi

autoload -U compinit
compinit
zstyle ':completion:*:default' list-colors ${LS_COLORS} # 補完候補に色
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # tab補完時に大文字小文字無視

setopt complete_aliases

alias q='exit'

# http://nanabit.net/blog/2009/11/29/insert-date-on-single-key/
function insert_date {
  LBUFFER=$LBUFFER'$(date +%Y-%m-%d)'
}
zle -N insert_date
bindkey '^[[15~' insert_date

########################################################################
# prompt
########################################################################
## ANSI escape sequences
local RESET_FORMAT="%{[0m%}"
local REVERSE="%{[7m%}"
### text color (foreground)
local FG_DEFAULT="%{[39m%}"
local FG_BLACK="%{[30m%}"
local FG_RED="%{[31m%}"
local FG_GREEN="%{[32m%}"
local FG_YELLOW="%{[33m%}"
local FG_BLUE="%{[34m%}"
local FG_MAGENTA="%{[35m%}"
local FG_CYAN="%{[36m%}"
local FG_GRAY="%{[37m%}"
local FG_DARK_GRAY="%{[90m%}"
local FG_LIGHT_RED="%{[91m%}"
local FG_LIGHT_GREEN="%{[92m%}"
local FG_LIGHT_YELLOW="%{[93m%}"
local FG_LIGHT_BLUE="%{[94m%}"
local FG_LIGHT_MAGENTA="%{[95m%}"
local FG_LIGHT_CYAN="%{[96m%}"
local FG_WHITE="%{[97m%}"
local FG_GRAY00="%{[38;5;232m%}" # black
local FG_GRAY01="%{[38;5;233m%}"
local FG_GRAY02="%{[38;5;234m%}"
local FG_GRAY03="%{[38;5;235m%}"
local FG_GRAY04="%{[38;5;236m%}"
local FG_GRAY05="%{[38;5;237m%}"
local FG_GRAY06="%{[38;5;238m%}"
local FG_GRAY07="%{[38;5;239m%}"
local FG_GRAY08="%{[38;5;240m%}"
local FG_GRAY09="%{[38;5;241m%}"
local FG_GRAY10="%{[38;5;242m%}"
local FG_GRAY11="%{[38;5;243m%}"
local FG_GRAY12="%{[38;5;244m%}"
local FG_GRAY13="%{[38;5;245m%}"
local FG_GRAY14="%{[38;5;246m%}"
local FG_GRAY15="%{[38;5;247m%}"
local FG_GRAY16="%{[38;5;248m%}"
local FG_GRAY17="%{[38;5;249m%}"
local FG_GRAY18="%{[38;5;250m%}"
local FG_GRAY19="%{[38;5;251m%}"
local FG_GRAY20="%{[38;5;252m%}"
local FG_GRAY21="%{[38;5;253m%}"
local FG_GRAY22="%{[38;5;254m%}"
local FG_GRAY23="%{[38;5;255m%}" # white
### text color (background)
local BG_DEFAULT="%{[49m%}"
local BG_BLACK="%{[40m%}"
local BG_RED="%{[41m%}"
local BG_GREEN="%{[42m%}"
local BG_YELLOW="%{[43m%}"
local BG_BLUE="%{[44m%}"
local BG_MAGENTA="%{[45m%}"
local BG_CYAN="%{[46m%}"
local BG_GRAY="%{[47m%}"
local BG_DARK_GRAY="%{[100m%}"
local BG_LIGHT_RED="%{[101m%}"
local BG_LIGHT_GREEN="%{[102m%}"
local BG_LIGHT_YELLOW="%{[103m%}"
local BG_LIGHT_BLUE="%{[104m%}"
local BG_LIGHT_MAGENTA="%{[105m%}"
local BG_LIGHT_CYAN="%{[106m%}"
local BG_WHITE="%{[107m%}"
# git
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:*' formats "@%b(%7.7i)"
zstyle ':vcs_info:*' actionformats '(%s)[%b|%a]'

# executed before each prompt
precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_

    # python (pyenv, conda)
    PS_PYTHON_VERSION=$(pyenv version-name)
    PS_PYTHON_ENV=""
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
	PS_PYTHON_ENV="@$CONDA_DEFAULT_ENV"
    fi
  
    echo -ne "\ek/$PWD:t:idle\e\\" # screen/tmux: change window name

PROMPT="
${FG_GRAY14}%n@%m ${FG_YELLOW}%~${FG_GREEN}%(1V. %1v.)${FG_GRAY14}%(2V. (%2v).) ${FG_GREEN}py:${PS_PYTHON_VERSION}${PS_PYTHON_ENV}
${FG_GRAY14}${DATE_AND_TIME} ${FG_CYAN}%(!.#.$)${RESET_FORMAT} "
RPROMPT=""
PROMPT2="${FG_GRAY14}(%_) ${FG_CYAN}%(!.#.>)${RESET_FORMAT} "
SPROMPT="correct: %R -> %r ? [n,y,a,e]: "
}

# date
local DATE_AND_TIME="%D{%Y-%m-%d(%a) %H:%M:%S}" # 曜日:%a, 秒:%S

# virtualenv 周り
# http://askubuntu.com/questions/353636/edit-zsh-theme-for-virtualenv-name
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
function virtenv_indicator {
    if [ -z $VIRTUAL_ENV ]; then
        psvar[2]=''
    else
        psvar[2]=${VIRTUAL_ENV##*/}
    fi
}
add-zsh-hook precmd virtenv_indicator
# コマンド実行時に時刻を更新
# ref. http://vorfee.hatenablog.jp/entry/2015/03/28/174901
re-prompt() {
    zle .reset-prompt
    zle .accept-line
}
zle -N accept-line re-prompt

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

#############################################################################
# alias
#############################################################################

# Python
## Anaconda
## activate command の pyenv とのバッティングを避ける & conda init を避ける (anaconda の python が pyenv の python より優先順位が高くなる)
## pyenvとanacondaを共存させる時のactivate衝突問題の回避策3種類 - Qiita https://qiita.com/y__sama/items/f732bb7bec2bff355b69
## zsh - Can I alias a subcommand? (shortening the output of `docker ps`) - Stack Overflow https://stackoverflow.com/questions/34748747/can-i-alias-a-subcommand-shortening-the-output-of-docker-ps
## todo: pyenv が anaconda でないときに souce が実行されてしまう (そんなファイルはなさそうだけど)
conda() {
  case $1 in
    activate)
      shift
      source $PYENV_ROOT/versions/$(pyenv version-name)/bin/activate "$@";;
    *)
      command conda "$@";;
  esac
}

# GNU ls
# http://linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
alias ls='ls -A --color=auto'
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
# export LESSOPEN='|pygmentize-lessfilter %s'
# export LESSOPEN='|/usr/local/bin/lesspipe.sh %s'
alias l='less'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

function chpwd() { # exec following commands after cd
  ls
  # echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"
}
# function preexec() { # コマンド実行直後
#   mycmd=(${(s: :)${1}})
#   echo -ne "\ek/$PWD:t:$mycmd[1]\e\\" # screen/tmux: change window name
# }

alias f='fg'

alias grep='grep --color'

alias m='make'
alias mc='make clean'
alias md='make depend'

alias g='git'
compdef g=git
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gst='git status'
alias push='git push'
alias pull='git pull'

alias screen='screen -U' # utf-8

alias t='latexmk'
alias tp='latexmk -pvc'
alias tc='latexmk -c'
alias tC='latexmk -C'

# alias ngspice='rlwrap ngspice'

# 存在するファイルにリダイレクトしない
# リダイレクトしたい場合は
# unset noclobber
#  or
# >!
setopt noclobber

# mv 拡張
autoload -Uz zmv
alias zmv="noglob zmv -w"

########################################################################
# command history
########################################################################
HISTFILE=~/.zsh_history
HISTSIZE=6000000 # on memory
SAVEHIST=6000000
setopt hist_ignore_all_dups
setopt share_history # 複数起動
setopt extended_history # 実行時刻を記録

# 入力途中で C-p C-n
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

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
zstyle ':chpwd:*' recent-dirs-max 1000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

setopt extended_glob

########################################################################
# ghq
########################################################################


########################################################################
# interactive shell
########################################################################

# using anyframe https://github.com/mollifier/anyframe
# init
fpath=(${HOME}/src/github.com/mollifier/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init

zstyle ":anyframe:selector:" use fzf
zstyle ":anyframe:selector:fzf:" command 'fzf --exact --no-sort'

# peco-cdr
bindkey '^l' anyframe-widget-cdr
# http://futurismo.biz/archives/2514
# function peco-cdr () {
#     local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
#     if [ -n "$selected_dir" ]; then
#         # BUFFER="cd ${selected_dir}"
#         BUFFER="${selected_dir}"
#         # zle accept-line
#     fi
#     # zle clear-screen
# }
# zle -N peco-cdr
# bindkey '^l' peco-cdr

# command history
bindkey '^r' anyframe-widget-put-history
# other imprementations
# - http://qiita.com/uchiko/items/f6b1528d7362c9310da0
# function peco-select-history() {
#     local tac
#     if which tac > /dev/null; then
#         tac="tac"
#     else
#         tac="tail -r"
#     fi
#     BUFFER=$(\history -n 1 | \
#         eval $tac | \
#         peco --query "$LBUFFER")
#     CURSOR=$#BUFFER
#     zle clear-screen
# }
# zle -N peco-select-history
# bindkey '^R' peco-select-history

# insert file name in current directory
bindkey '^o' anyframe-widget-insert-filename
# function insert-file-by-peco(){
#     LBUFFER=$LBUFFER$(ls -A | peco | tr '\n' ' ' | \
#                              sed 's/[[:space:]]*$//') # delete trailing space
#     zle -R -c
# }
# zle -N insert-file-by-peco
# bindkey '^o' insert-file-by-peco

# go to dir of ghq
bindkey '^]' anyframe-widget-cd-ghq-repository
# http://weblog.bulknews.net/post/89635306479/ghq-pecopercol
# function peco-src () {
#     local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
#     if [ -n "$selected_dir" ]; then
#         BUFFER="cd ${selected_dir}"
#         zle accept-line
#     fi
#     zle clear-screen
# }
# zle -N peco-src
# bindkey '^]' peco-src


########################################################################
# misc
########################################################################

alias p3='python3'
