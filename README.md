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
    - 環境非依存に
        - OS による分岐は少なめに
        - OS X でも ghq のインストールは (homebrew ではなく) go 経由
        - 特に実験に関わるもの (python など) は共通のフローで管理

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

- `/etc/zprofile` をコメントアウト (El Capitan 以後)
    - <http://richa.avasthi.name/blog/2015/10/fixing-your-zsh-path-after-upgrading-to-el-capitan/>

# 準備 (Linux)

## zsh
- ログインシェルの変更

    ```shell
    $ which zsh
    $ chsh -s /path/to/zsh
    ```

    ```shell
    $ which zsh
    $ ypchsh
    > {password}
    $ /path/to/zsh
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
# to generate ~/.ssh/id_rsa, id_rsa.pub
$ chmod 600 id_rsa
# もともと 600 だと思うけど一応
```

- ~/.ssh/config に以下を追加 (スペースはすべてタブ)

```
Host bitbucket.org
    HostName bitbucket.org
    IdentityFile ~/.ssh/id_rsa
    User git
Host github
    Hostname github.com
    IdentityFile ~/.ssh/id_rsa
    User git
```

- GitHub
    1. 右上自分アイコン→settings
    2. SSH Keys
    3. Add SSH key
    4. id_rsa.pub の中身を登録

- Bitbucket
    1. 右上自分アイコン→Settings
    2. SSH keys
    3. Add key
    4. id_rsa.pub の中身を登録

- post processing
```shell
$ ssh -T git@github.com
```

## ag (the silver searcher)

# usage
## init
- ghq で管理している src を移行 (可能なら Dropbox 経由?)

```shell
$ cd

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
$ ln -sf ~/.dotfiles/.pip_requirements_anaconda ~/.pip_requirements_anaconda
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

## python
- pyenv, virtualenv

```bash
$ ghq get git@github.com:yyuu/pyenv.git
$ ln -sf ~/src/github.com/yyuu/pyenv ~/.pyenv
$ ghq get git@github.com:yyuu/pyenv-virtualenv.git
$ ln -sf ~/src/github.com/yyuu/pyenv-virtualenv ~/.pyenv/plugins/pyenv-virtualenv
$ source ~/.zshrc
```

- 実験環境

```bash
$ pyenv install anaconda2-2.4.1
$ pyenv global anaconda2-2.4.1
$ pip install -r ~/.pip_requirements_anaconda
$ conda install seaborn
```

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
