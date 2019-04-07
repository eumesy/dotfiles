export PATH
export MANPATH

case $OSTYPE in
  darwin*)
    if [ -f $HOME/.bash_profile.darwin ]; then . $HOME/.bash_profile.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.bash_profile.linux ]; then . $HOME/.bash_profile.linux; fi
    ;;
esac

# for login (and then interactive) shell
# ref. https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
