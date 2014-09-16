# 方針
- 古く枯れたソフト/バージョンしか無い環境でも困らないように
  - 操作者としての自分が困らないように
    - 上位互換のキーバインド設定
   	  - tmux を普段使いする場合も、キーバインドは screen 互換
   	  - helm-for-files を C-x b にバインド
  - レガシーな環境に設定ファイルを持ち込んでも問題無いように
    - OS による分岐
	- コマンドの存在を確認してからロード

- 設定に時間をかけすぎない
  - 鬼門
    - 色指定
    - escape sequence

# Requirement
- peco

# 準備 (Linux)
## peco
- バイナリ版を落として使う
    - https://github.com/peco/peco/releases
	- http://qiita.com/lestrrat/items/de8565fe32864f76ac19
	
- CPUの確認
    ```shell
    $ uname -a
    ```
	
    - x86_64 -> amd64
    - i389 -> 386
	
- ダウンロードしてパスが通っているディレクトリへ
    ```shell
    $ cd $HOME/local/bin
    $ wget https://github.com/peco/peco/releases/download/v0.*.*/peco_linux_***.tar.gz
    $ tar zxvf peco_linux_***.tar.gz
    $ mv peco_linux_***/peco $HOME/local/bin
    $ rm peco_linux_***.tar.gz
    $ rm -rf peco_linux_***
    ```

# 準備 (Mac)

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
$ ln -sf ~/.dotfiles/.peco ~/.peco

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
