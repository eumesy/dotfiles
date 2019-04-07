export LANG="ja_JP.UTF-8"
export LC_CTYPE="ja_JP.UTF-8"
export LC_TIME="en_US.UTF-8"
# export TERM=xterm-256color

# go
export GOPATH=${HOME}
# ghq -> ~/.gitconfig

# -U: keep only the first occurrence of each duplicated value
# ref. http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html#index-typeset
typeset -U PATH path MANPATH manpath

# ignore /etc/zprofile, /etc/zshrc, /etc/zlogin, and /etc/zlogout
# ref. http://zsh.sourceforge.net/Doc/Release/Files.html
# ref. http://zsh.sourceforge.net/Doc/Release/Options.html#index-GLOBALRCS
unsetopt GLOBAL_RCS
# copied from /etc/zprofile
case $OSTYPE in
    darwin*)
        # system-wide environment settings for zsh(1)
        if [ -x /usr/libexec/path_helper ]; then
            eval `/usr/libexec/path_helper -s`
        fi
        ;;
esac

#   path=xxxx(N-/)
#     (N-/): 存在しないディレクトリは登録しない
#     パス(...): ...という条件にマッチするパスのみ残す
#        N: NULL_GLOBオプションを設定。
#           globがマッチしなかったり存在しないパスを無視する
#        -: シンボリックリンク先のパスを評価
#        /: ディレクトリのみ残す
#        .: 通常のファイルのみ残す
# via. zshでHomebrewを使用する場合に設定しておいたほうが良いこと - よんちゅBlog http://yonchu.hatenablog.com/entry/20120415/1334506855
path=(
    /usr/bin(N-/)
    /bin(N-/)
    /usr/sbin(N-/)
    /sbin(N-/)
    /usr/X11/bin(N-/)
    ${GOPATH}/bin(N-/)
    ${HOME}/local/bin(N-/)
    ${HOME}/.cask/bin(N-/)
    ${path}
)

export EDITOR='emacsclient -nw'
# export VISUAL=emacsclient
export ALTERNATE_EDITOR=''
export GIT_EDITOR='emacsclient -nw'
# alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'

# python
## pyenv
export PYENV_ROOT=${HOME}/.pyenv
if [ -d "${PYENV_ROOT}" ]; then
    PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
#     eval "$(pyenv virtualenv-init -)"
fi

# ruby
if which rbenv > /dev/null; then
    PATH=${HOME}/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
fi

case $OSTYPE in
  darwin*)
    if [ -f ${HOME}/.zshenv.darwin ]; then . ${HOME}/.zshenv.darwin; fi
    ;;
  linux*)
    if [ -f ${HOME}/.zshenv.linux ]; then . ${HOME}/.zshenv.linux; fi
    ;;
esac
if [ -f ${HOME}/.zshenv.local ]; then . ${HOME}/.zshenv.local; fi
