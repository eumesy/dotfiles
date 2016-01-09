export LANG=ja_JP.UTF-8
export TERM=xterm-256color

# go
export GOPATH=${HOME}
# ghq -> ~/.gitconfig

# 重複したパスを登録しない
typeset -U path

# OS X, El Capitan
# from /etc/zprofile
case $OSTYPE in
    darwin*)
        # system-wide environment settings for zsh(1)
        if [ -x /usr/libexec/path_helper ]; then
            eval `/usr/libexec/path_helper -s`
        fi
        ;;
esac

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
export PYENV_ROOT=${HOME}/.pyenv
export PATH=${PYENV_ROOT}/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

case $OSTYPE in
  darwin*)
    if [ -f ${HOME}/.zshenv.darwin ]; then . ${HOME}/.zshenv.darwin; fi
    ;;
  linux*)
    if [ -f ${HOME}/.zshenv.linux ]; then . ${HOME}/.zshenv.linux; fi
    ;;
esac
if [ -f ${HOME}/.zshenv.local ]; then . ${HOME}/.zshenv.local; fi
