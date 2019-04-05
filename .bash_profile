export PATH
export MANPATH

# homebrew
PATH=/usr/local/bin:/usr/local/sbin:${PATH}
MANPATH=/usr/local/share/man:${MANPATH}

# coreutils
PATH=/usr/local/opt/coreutils/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}
# ed
PATH=/usr/local/opt/ed/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/ed/libexec/gnuman:${MANPATH}
# findutils
PATH=/usr/local/opt/findutils/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/findutils/libexec/gnuman:${MANPATH}
# gnu-sed
PATH=/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:${MANPATH}
# gnu-tar
PATH=/usr/local/opt/gnu-tar/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/gnu-tar/libexec/gnuman:${MANPATH}
# grep
PATH=/usr/local/opt/grep/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/grep/libexec/gnuman:${MANPATH}



# for login (and then interactive) shell
# ref. https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
