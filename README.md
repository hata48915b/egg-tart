# egg-tart

## これは何？

Emacs24.3以降でFreewnnとegg（tamago-tsunagi）を使って日本語入力するための
Emacs Lispです。

## 動作環境

このファイルを動作させるためには、次の3つが必要です。

### Emacs（24.3以降）

[Emacs](https://www.gnu.org/software/emacs/)

主にUNIX系OSで使われているテキストエディタです。

Ubuntu等のUNIX系OSを利用している場合、パッケージ管理システムからインストール
できると思います。

``` sh
sudo apt-get install emacs
```

### FreeWnn（freewnn 1.1.1-a023）

[FreeWnn](https://ja.osdn.net/projects/freewnn/)

（※ URLが消滅しています。）

老舗のかな漢字変換システムです。

UNIX系OSを利用している場合、パッケージ管理システムからインストールできると
思います。

``` sh
sudo apt-get install freewnn-jserver
```

### tamago-tsunagi（5.0.7.1）

[tamago-tsunagi](https://ja.osdn.net/projects/tamago-tsunagi/)

（※ URLが消滅しています。）

Emacs上でFreeWnnを使えるようにするアプリです。

ファイルのURLが消滅しているため、同封いたしました。

次のコマンドでインストールすることができます。

``` /bin/sh
sudo tar xvfz tamago-tsunagi-5.0.7.1.tar.gz
sudo cd tamago-tsunagi-5.0.7.1
sudo mkdir /usr/local/share/emacs/site-lisp/egg
sudo mv egg its \*.el /usr/local/share/emacs/site-lisp/egg/
```

`/usr/local/share/emacs/site-lisp/egg`は、環境に応じて
`/usr/share/emacs/site-lisp/egg`などに書き換えてください
（以下も同様です）。

なお、"tamago-tsunagi-5.0.7.1"の中には、"INSTALL"というファイルがあり、
インストールの手順が書かれていますので、その方法でインストールしても良いの
ですが、新しいEmacsではエラーになるため、インストールできなくなっています。

もし"/usr/local/share/emacs/site-lisp/egg/egg-com.elc"（←最後に"c"あり）が
あれば、削除します（なくても動きますし、あると新しいEmacsで誤作動します。）。
なお、"/usr/local/share/emacs/site-lisp/egg/egg-com.el"（←最後に"c"なし）は
必要ですので、削除しないでください。

``` sh
sudo rm -f /usr/local/share/emacs/site-lisp/egg/egg-com.elc
```

## インストール

次のコマンドを実行して、ファイルをインストールしてください。

### ファイルのインストール

``` sh
sudo cp -p egg-tart.el /usr/local/share/emacs/site-lisp/egg/
sudo chmod 444 /usr/local/share/emacs/site-lisp/egg/egg-tart.el
sudo chown root:root /usr/local/share/emacs/site-lisp/egg/egg-tart.el
```

### 設定のインストール

次のコマンドを実行して、設定をインストールしてください。

``` sh
cat << EOM > "~/.emacs.d/init.el"
;;;=========================================================;;;
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/egg")
(if (not (fboundp 'make-coding-system))
    (defun make-coding-system (coding-system &rest rest)
      (define-coding-system coding-system ""
        :mnemonic ?w :coding-type 'charset)))
(require 'egg)
(load "/usr/local/share/emacs/site-lisp/egg/leim-list")
(load "/usr/local/share/emacs/site-lisp/egg/menudiag")
(load "/usr/local/share/emacs/site-lisp/egg/egg-tart")
(setq default-input-method "japanese-egg-wnn")
(setq wnn-jserver "127.0.0.1")
(setq egg-default-startup-file "~/.eggrc.el")
;;;=========================================================;;;
EOM
```

`~/.emacs.d/init.el`は、Emacsの設定ファイルです。
必要に応じて`~/.emacs`や`~/.emacs.el`に書き換えてください。

`127.0.0.1`はFreeWnnのサーバのIPアドレスです。
必要に応じて書き換えてください。

`~/.eggrc.el`はtamago-tsunagiの設定ファイルです。
必要に応じて`~/.emacs.d/.eggrc.el`などに書き換えてください。

## 実行方法

次のコマンドでEmacsを起動してください。

``` bash or zsh
env XMODIFIERS= emacs [file]
```

## ヒストリー

2020-08-02 v01 リリース

2020-09-19 v02 リリース

2020-11-19 v03 リリース

2021-01-19 v04 リリース

2021-07-26 v05 リリース
