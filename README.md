# egg-tart

## これは何？

Emacs24.3以降でFreewnn+tamago-tsunagiを使って日本語入力するためのEmacs Lispです。

## 動作環境

このファイルを動作させるためには、次の3つが必要です。

### Emacs（24.3以降）

[Emacs](https://www.gnu.org/software/emacs/)

主にUNIX系OSで使われているテキストエディタです。


UNIX系OSを利用している場合、パッケージ管理システムからインストールできると思います。

```
sudo apt-get install emacs
```

### FreeWnn（freewnn 1.1.1-a023）

[FreeWnn](https://ja.osdn.net/projects/freewnn/)

老舗のかな漢字変換システムです。

UNIX系OSを利用している場合、パッケージ管理システムからインストールできると思います。

```
sudo apt-get install freewnn-jserver
```

### tamago-tsunagi（5.0.7.1）

[tamago-tsunagi](https://ja.osdn.net/projects/tamago-tsunagi/)

Emacs上でFreeWnnを使えるようにするアプリです。

次のコマンドでインストールすることができます。

```
wget -O tamago-tsunagi-5.0.7.1.tar.gz 'https://ja.osdn.net/frs/redir.php?m=gigenet&f=tamago-tsunagi%2F62701%2Ftamago-tsunagi-5.0.7.1.tar.gz'
tar xvfz tamago-tsunagi-5.0.7.1.tar.gz
cd tamago-tsunagi-5.0.7.1
./configure
make
sudo make install
```

## インストール

次のコマンドを実行して、ファイルをインストールしてください。

### ファイルのインストール

```
emacs -batch -f batch-byte-compile egg-tart.el
sudo cp -p egg-tart.el egg-tart.elc /usr/local/share/emacs/site-lisp/egg/
cd /usr/local/share/emacs/site-lisp/egg/
sudo chown root:root egg-tart.el egg-tart.elc
sudo chmod 644 egg-tart.el egg-tart.elc

```

`/usr/local/share/emacs/site-lisp/egg`はtamago-tsunagiのインストールディレクトリです。
必要に応じて`/usr/share/emacs/site-lisp/egg`などに書き換えてください。

### 設定のインストール

次のコマンドを実行して、設定をインストールしてください。

```
cat << EOM > "~/.emacs.d/init.el"
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/egg")
(require 'egg)
(load "/usr/local/share/emacs/site-lisp/egg/leim-list")
(load "/usr/local/share/emacs/site-lisp/egg/menudiag")
(load "/usr/local/share/emacs/site-lisp/egg/egg-tart")
(setq default-input-method "japanese-egg-wnn")
(setq wnn-jserver "127.0.0.1")
(setq egg-default-startup-file "~/.eggrc.el")
EOM
```

`~/.emacs.d/init.el`は、Emacsの設定ファイルです。
必要に応じて`~/.emacs`や`~/.emacs.el`に書き換えてください。

`/usr/local/share/emacs/site-lisp/egg`はtamago-tsunagiのインストールディレクトリです。
必要に応じて`/usr/share/emacs/site-lisp/egg`などに書き換えてください。

`127.0.0.1`はFreeWnnのサーバのIPアドレスです。
必要に応じて書き換えてください。

`~/.eggrc.el`はtamago-tsunagiの設定ファイルです。
必要に応じて`~/.emacs.d/.eggrc.el`などに書き換えてください。

## 実行方法

次のコマンドで実行してください。

```
env XMODIFIERS= emacs [file]
```

## ヒストリー

2020.08.02 v01 リリース

2020.09.19 v02 リリース

2020.11.19 v03 リリース

2021.01.19 v04 リリース

