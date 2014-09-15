export LANG=ja_JP.UTF-8
export TERM=xterm-256color

# 重複したパスを登録しない
typeset -U path
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
# rename: /usr/bin
export EDITOR='emacsclient -nw'
# export VISUAL=emacsclient
export ALTERNATE_EDITOR=''
export GIT_EDITOR='emacsclient -nw'
# alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'

# java
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
# http://d.hatena.ne.jp/snaka72/20120101/1325403702

case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshenv.darwin ]; then . $HOME/.zshenv.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshenv.linux ]; then . $HOME/.zshenv.linux; fi
    ;;
esac
if [ -f $HOME/.zshenv.local ]; then . $HOME/.zshenv.local; fi
