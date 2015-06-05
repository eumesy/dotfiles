# 方針
- 古く枯れたソフト/バージョンで構成された環境でも困らない設定
    - 操作者としての自分が困らない
        - 上位互換のキーバインド設定
            - tmux を普段使いする場合も、キーバインドは screen 互換
            - helm-for-files は C-x b にバインド
    - レガシーな環境に設定ファイルを持ち込んでも問題無いように
        - OS による分岐
        - コマンドの存在を確認してからロード

- 設定に時間をかけすぎない
    - 鬼門
        - 色指定
        - escape sequence

- 覚えることは少なく
    - Anything 的機能を積極的に導入
        - helm, peco
    - 「ポケットひとつ」にはそれなりに拘る

## Emacs
- モード毎の設定
    - 「auto-complete-mode をデフォルトで有効にするか」は autocomplete.el にまとめて記述

# Requirements
- ag (the silver searcher)
- Cask
    - python
- git
- ghq
- peco
- zsh

# 準備 (Mac)
## dotfiles

    ```shell
    # symbolic links
    $ ./init-osx.sh
    # ime
    $ sudo cp /System/Library/Input\ Methods/JapaneseIM.app/Contents/Resources/KeySetting_Default.plist /System/Library/Input\ Methods/JapaneseIM.app/Contents/Resources/KeySetting_Default.plist.orig
    $ ./init-osx-JapaneseIM.sh
    ```

## homebrew

    ```shell
    $ brew update
    $ brew doctor
    $ brew upgrade
    $ brew install rcmdnk/file/brew-file
    $ brew file install
    ```

- [Homebrew/homebrew-bundle - GitHub](https://github.com/Homebrew/homebrew-bundle)

## zsh
- `/etc/shells` に追記

    ```shell
    /usr/local/bin/zsh
    ```

- ログインシェルの変更

    ```shell
    $ chsh -s /usr/local/bin/zsh
    ```

# 準備 (Linux)

## zsh
- ログインシェルの変更

    ```shell
    $ which zsh
    $ chsh -s /path/to/zsh
    ```

## peco
- バイナリ版を落として使う
    - [バイナリ置き場](https://github.com/peco/peco/releases)
    - http://qiita.com/lestrrat/items/de8565fe32864f76ac19

- CPUの確認

    ```shell
    $ uname -a
    ```

    - x86_64 -> amd64
    - i389 -> 386

- ダウンロードしてパスが通っているディレクトリへ

    ```shell
    $ wget https://github.com/peco/peco/releases/download/v0.*.*/peco_linux_***.tar.gz
    $ tar zxvf peco_linux_***.tar.gz
    $ mv peco_linux_***/peco $HOME/local/bin
    $ rm peco_linux_***.tar.gz
    $ rm -rf peco_linux_***
    ```

## Cask
- .emacs.d 移行後にインストールすれば，初期化までしてくれる?

- installation

    ```shell
    $ curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
    ```

    - or

        ```shell
        git clone https://github.com/cask/cask.git $HOME/.cask
        ```

    - or

        ```shell
        git clone git@github.com:cask/cask.git $HOME/.cask
        ```


- upgrade cask
```shell
$ cask upgrade-cask
```

- path

## ssh key for GitHub/Bitbucket
- RSA 公開鍵作成
```shell
$ ssh-keygen -t rsa -C "your_email@example.com"
# generated ~/.ssh/id_rsa
```

## ag (the silver searcher)

# 準備 (Mac)

# usage
## init
- ghq で管理している src を移行 (可能なら Dropbox 経由?)

```shell
$ cd

$ ln -s hoge/src ~/src

$ git clone git@github.com:eumesy/dotfiles.git ~/.dotfiles

$ ln -sf ~/.dotfiles/Brewfile ~/Brewfile
$ ln -sf ~/.dotfiles/.aspell.conf ~/.aspell.conf
$ ln -sf ~/.dotfiles/.emacs.d ~/.emacs.d
$ ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
$ ln -sf ~/.dotfiles/.gitignore.global ~/.gitignore
$ ln -sf ~/.dotfiles/.screenrc ~/.screenrc
$ ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
$ ln -sf ~/.dotfiles/.peco ~/.peco
$ ln -sf ~/.dotfiles/.pip_requirements ~/.pip_requirements
$ ln -sf ~/.dotfiles/.zshenv ~/.zshenv
$ ln -sf ~/.dotfiles/.zshenv.darwin ~/.zshenv.darwin
$ ln -sf ~/.dotfiles/.zshenv.linux ~/.zshenv.linux
$ ln -sf ~/.dotfiles/.zshrc ~/.zshrc
$ ln -sf ~/.dotfiles/.zshrc.darwin ~/.zshrc.darwin
$ ln -sf ~/.dotfiles/.zsh ~/.zsh

$ zsh
$ rm -f ~/.zcompdump; compinit

$ cd ~/.emacs.d/
$ cask
```
ln -f: 上書き

## update
### push
```shell
$ git add .
$ git commit -m "some comments"
$ git push origin master
```

### pull
```shell
$ git pull
```
