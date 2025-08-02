;;; Name:         egg-tart.el
;;; Version:      v05
;;; Time-stamp:   <2025.08.03-06:02:54-JST>
;;;
;;; Copyright (C) 2016-2025  Seiichiro HATA
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License
;;; as published by the Free Software Foundation; either version 2
;;; of the License, or (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

;;;                                   概要
;;;
;;;   このファイルは、近時のEmacs（Emacs24.3以降）上で、egg（tamago）を使って
;;; FreeWnnのJserverにアクセスして、かな漢字変換をするためのファイルです。
;;;   eggの開発は止まっており、近時のEmacsでは動作しなくなってきています。
;;;   そこで、このファイルは、eggを少しだけ修正して、最近のEmacs上で、最低限の
;;; 動作をするようにするものです。
;;;
;;;                                  使用法
;;;
;;; (1) このファイルは最新のegg（"tamago-tsunagi-5.0.7.1"）を前提としていますので、
;;;   下記のコマンドで、"tamago-tsunagi-5.0.7.1"を"/usr"以下にインストールします。
;;;   root> tar xvfz tamago-tsunagi-5.0.7.1.tar.gz
;;;   root> cd tamago-tsunagi-5.0.7.1
;;;   root> mkdir /usr/local/share/emacs/site-lisp/egg
;;;   root> mv egg its *.el /usr/local/share/emacs/site-lisp/egg/
;;;     なお、"INSTALL"というファイルにインストールの手順が書かれていますので、
;;;   その方法でインストールしても良いのですが、新しいEmacsではエラーになるため、
;;;   インストールできなくなっています。
;;;
;;; (2) もし"/usr/local/share/emacs/site-lisp/egg/egg-com.elc"（←最後に"c"あり）が
;;;   あれば、削除します（なくても動きますし、あると新しいEmacsで誤作動します。）。
;;;     なお、"/usr/local/share/emacs/site-lisp/egg/egg-com.el"（←最後に"c"なし）は
;;;   必要ですので、削除しないでください。
;;;   root> rm -f /usr/local/share/emacs/site-lisp/egg/egg-com.elc
;;;
;;; (3) このファイル（egg-tart.el）を、"/usr/local/share/emacs/site-lisp/egg/"に
;;;   コピーしてください。
;;;   root> cp -p egg-tart.el /usr/local/share/emacs/site-lisp/egg/
;;;   root> chmod 444 /usr/local/share/emacs/site-lisp/egg/egg-tart.el
;;;   root> chown root:root /usr/local/share/emacs/site-lisp/egg/egg-tart.el
;;;
;;; (4)  "~/.emacs"又は"~/.emacs.el"又は"~/.emacs.d/init.el"に、
;;;   ;;;=========================================================;;;
;;;   (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/egg")
;;;   (if (not (fboundp 'make-coding-system))
;;;       (defun make-coding-system (coding-system &rest rest)
;;;         (define-coding-system coding-system ""
;;;           :mnemonic ?w :coding-type 'charset)))
;;;   (require 'egg)
;;;   (load "/usr/local/share/emacs/site-lisp/egg/leim-list")
;;;   (load "/usr/local/share/emacs/site-lisp/egg/menudiag")
;;;   (load "/usr/local/share/emacs/site-lisp/egg/egg-tart")
;;;   (setq default-input-method "japanese-egg-wnn")
;;;   (setq wnn-jserver "127.0.0.1")
;;;   (setq egg-default-startup-file "~/.eggrc.el")
;;;   ;;;=========================================================;;;
;;;   などと書き込んでください。
;;;     なお、環境などに応じて、"127.0.0.1"を"localhost"に変えたり、
;;;   "~/.eggrc.el"を"~/.eggrc"又は"~/.emacs.d/.eggrc.el"に変えたり
;;;   してください。
;;;
;;; (5) FreeWnnのJserverを起動させておき、
;;;   "env XMODIFIERS= emacs"で、"Emacs"を起動してください。
;;;     これでたぶん使えると思います。
;;;
;;;   環境によっては、"/usr/local/share/emacs/site-lisp/egg"を
;;; "/usr/share/emacs/site-lisp/egg"などにに変えてください。

;;;======================================================;;;
;;; "egg.el"と"menudiag.el"を修正

(define-obsolete-variable-alias
  'inactivate-current-input-method-function
  'deactivate-current-input-method-function
  "24.3")
(define-obsolete-function-alias
  'inactivate-input-method
  'deactivate-input-method
  "24.3")

;;;======================================================;;;
;;; "egg-cnv.el"を修正

;; 形だけ定義していれば動くようですが、不具合があれば教えてください。
(if (not (fboundp 'buffer-has-markers-at))
    (defun buffer-has-markers-at (position)))

(defun egg-backward-bunsetsu (n)
  (interactive "p")
  (if (>= emacs-major-version 25)
      (egg-backward-bunsetsu-current n)
    (egg-backward-bunsetsu-v24-or-under n)))

(defun egg-backward-bunsetsu-current (n)
  (interactive "p")
  (while (and (> n 0)
              (null (get-text-property (1- (point)) 'egg-start)))
    (backward-char)
    (while (equal (egg-get-bunsetsu-info (+ (point) 0))
                  (egg-get-bunsetsu-info (- (point) 1)))
      (backward-char))
    (setq n (1- n)))
  (if (> n 0)
      (signal 'beginning-of-buffer nil)))

(defun egg-backward-bunsetsu-v24-or-under (n)
  (interactive "p")
  (while (and (> n 0)
              (null (get-text-property (1- (point)) 'egg-start)))
    (backward-char)
    (setq n (1- n)))
  (if (> n 0)
      (signal 'beginning-of-buffer nil)))

(defun egg-forward-bunsetsu (n)
  (interactive "p")
  (if (>= emacs-major-version 25)
      (egg-forward-bunsetsu-current n)
    (egg-forward-bunsetsu-v24-or-under n)))

(defun egg-forward-bunsetsu-current (n)
  (interactive "p")
  (egg-next-candidate 0) (egg-previous-candidate 0)
  (while (and (>= n 0)
              (null (get-text-property (point) 'egg-end)))
    (while (equal (egg-get-bunsetsu-info (+ (point) 0))
                  (egg-get-bunsetsu-info (+ (point) 1)))
        (forward-char))
    (setq n (1- n)))
  (if (null (get-text-property (1+ (point)) 'egg-end))
      (forward-char)
    (progn (while (equal (egg-get-bunsetsu-info (+ (point) 0))
                         (egg-get-bunsetsu-info (- (point) 1)))
             (backward-char))
           (signal 'end-of-buffer nil))))

(defun egg-forward-bunsetsu-v24-or-under (n)
  (interactive "p")
  (while (and (>= n 0)
              (null (get-text-property (point) 'egg-end)))
    (forward-char)
    (setq n (1- n)))
  (backward-char)
  (if (>= n 0)
      (signal 'end-of-buffer nil)))

;;;======================================================;;;
;;; "egg-com.el"を修正

;; エラーを無視して，強制的にEmacsを終了します。
(defun egg-kill-emacs-function () (ignore-errors (egg-finalize-backend)))
