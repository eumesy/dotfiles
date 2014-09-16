# 方針
- 古く枯れたソフト/バージョンしか無い環境でも困らないように
  - 操作者としての自分が困らないように
    - 上位互換のキーバインド設定
   	  - tmux を普段使いする場合も、キーバインドは screen 互換とする
    - より便利な機能を追加する場合も、デフォルトに近いキーバインド設定
   	  - helm-for-files を C-x b にバインド
  - 設定ファイルをどこへでも持ち込めるように
    - OS による分岐
	- コマンドの存在を確認してからロード
  
- 設定に時間をかけすぎない
  - 鬼門
    - 色指定
    - escape sequence

# usage
## init
```shell
$ cd
$ git clone git@github.com:eumesy/dotfiles.git ~/.dotfiles

$ ln -sf ~/.dotfiles/.zshrc ~/.zshrc
$ ln -sf ~/.dotfiles/.zsh ~/.zsh
$ ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
$ ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
$ ln -sf ~/.dotfiles/.screenrc ~/.screenrc

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

# todo
## シンボリックリンクを自動ではる
- shell script
  - http://www.d-wood.com/blog/2014/03/19_5845.html
- Makefile
  - https://github.com/etheriqa/dotfiles
