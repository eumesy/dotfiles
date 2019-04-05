# If not running interactively, don't do anything
# ref. https://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html
# ref. https://unix.stackexchange.com/questions/257571/why-does-bashrc-check-whether-the-current-shell-is-interactive
if [ -z "$PS1" ]; then
   return
fi

