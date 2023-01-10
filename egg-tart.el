;;; Name:         egg-tart.el
;;; Version:      v04
;;; Time-stamp:   <2021.01.19-18:27:54-JST>
;;;
;;; Copyright (C) 2016-2021  Seiichiro HATA
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

;;;                                  使用法
;;;
;;; (1) このファイルは"tamago-tsunagi-5.0.7.1"を前提としていますので，
;;;   まず，"tamago-tsunagi-5.0.7.1"を"/usr"以下にインストールしてください。
;;;
;;; (2) このファイルを"/usr/share/emacs/site-lisp/egg/"にコピーしてください。
;;;
;;; (3)  "~/.emacs"又は"~/.emacs.el"又は"~/.emacs.d/init.el"に，
;;;   ;;;======================================================;;;
;;;   (add-to-list 'load-path "/usr/share/emacs/site-lisp/egg")
;;;   (require 'egg)
;;;   (load "/usr/share/emacs/site-lisp/egg/leim-list")
;;;   (load "/usr/share/emacs/site-lisp/egg/menudiag")
;;;   (load "/usr/share/emacs/site-lisp/egg/egg-tart")
;;;   (setq default-input-method "japanese-egg-wnn")
;;;   (setq wnn-jserver "127.0.0.1")
;;;   (setq egg-default-startup-file "~/.eggrc.el")
;;;   ;;;======================================================;;;
;;;   などと書き込んでください。
;;;     なお，環境などに応じて，"127.0.0.1"を"localhost"に変えたり，
;;;   "~/.eggrc.el"を"~/.emacs.d/.eggrc.el"に変えたりしてください。
;;;
;;; (4) "env XMODIFIERS= emacs"で"Emacs"を起動してください。
;;;     これでだいたい使えると思います。

;;;======================================================;;;
;;; "egg-cnv.el"を修正

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
;; 問題があれば，コメントアウトしてください。
(defun egg-kill-emacs-function () (ignore-errors (egg-finalize-backend)))
