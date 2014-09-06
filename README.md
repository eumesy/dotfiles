# usage
## init
```shell
$ cd
$ git clone git@github.com:eumesy/dotfiles.git ~/.dotfiles

$ ln -sf ~/.dotfiles/.zshrc ~/.zshrc
$ ln -sf ~/.dotfiles/.zsh ~/.zsh
$ ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig

$ chmod 755 ~/.dotfiles/.zsh/zaw
$ zsh
$ rm -f ~/.zcompdump; compinit
```
ln -f: 上書き

## update
### push
```shell
$ git add .
$ git commit -m "some comment"
$ git push origin master
```

### pull
```shell
$ git pull
```
