export LANG=ja_JP.UTF-8
export TERM=xterm-256color

# 重複したパスを登録しない
typeset -U path
path=(
    /usr/bin(N-/)
    /bin(N-/)
    /usr/sbin(N-/)
    /sbin(N-/)
    /usr/X11/bin(N-/)
    $HOME/.cask/bin(N-/)
    $HOME/local/bin(N-/)
    $path
)

export EDITOR='emacsclient -nw'
# export VISUAL=emacsclient
export ALTERNATE_EDITOR=''
export GIT_EDITOR='emacsclient -nw'
# alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'

case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshenv.darwin ]; then . $HOME/.zshenv.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshenv.linux ]; then . $HOME/.zshenv.linux; fi
    ;;
esac
if [ -f $HOME/.zshenv.local ]; then . $HOME/.zshenv.local; fi
