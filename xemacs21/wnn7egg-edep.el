;; Wnn7Egg is Egg modified for Wnn7, and the current maintainer 
;; is OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;;
;; This file is part of Wnn7Egg. (base code is egg-edep.el (eggV4))
;;
;;; ------------------------------------------------------------------
;;;
;;; Wnn7Egg （Wnn "なな"たまご）--- Wnn7 Emacs Client 
;;; 
;;; Wnn7Egg は、「たまご第３版」v3.09 をベースに 「たまご第４版」の通信、
;;; ライブラリ部を組み込んだ、Wnn7 の為の専用クライアントです。
;;;
;;; すべてのソースが Emacs Lisp で記述されているので、Wnn SDK/Library を必要
;;; とせず、GNU Emacs 及び XEmacs 環境で使用することができます。使用許諾条件
;;; は GPL です。
;;;
;;; GNU Emacs 20.3 以降、XEmacs 21.x 以降で動作確認しています。
;;;
;;;
;;; Wnn7Egg は Wnn7 の機能である楽々入力（入力予測）、連想変換をサポート
;;; しています。
;;;
;;; 「たまご」と独立／共存できるように、影響する主要な関数／変数名を
;;; "wnn7..." という形に変更しています。
;;;
;;; ------------------------------------------------------------------

;; egg-edep.el --- This file serves Emacs version dependent definitions

;; Copyright (C) 1999,2000 PFU LIMITED

;; Author: NIIBE Yutaka <gniibe@chroot.org>
;;         KATAYAMA Yoshio <kate@pfu.co.jp>

;; Maintainer: TOMURA Satoru <tomura@etl.go.jp>

;; Keywords: mule, multilingual, input method

;; This file is part of EGG.

;; EGG is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; EGG is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;; Code:


(if (featurep 'xemacs)
    (progn
      (defun set-buffer-multibyte (flag)
	(setq enable-multibyte-characters flag))
      (defun egg-chars-in-period (str pos len) len)
      (defalias 'string-as-unibyte 'identity)
      (defalias 'string-as-multibyte 'identity);;
      (defalias 'coding-system-put 'put));;
  (if (fboundp 'set-buffer-multibyte)
      (if (subrp (symbol-function 'set-buffer-multibyte))
	  ;; Emacs 20.3
	  (progn
	    (defun egg-chars-in-period (str pos len) len))
	;; Emacs 20.2
	(defun set-buffer-multibyte (flag)
	  (setq enable-multibyte-characters flag))
	(defalias 'string-as-unibyte 'identity)
	(defalias 'string-as-multibyte 'identity)
	(defalias 'coding-system-put 'put)
	(defun egg-chars-in-period (str pos len)
	  (chars-in-string (substring str pos (+ pos len)))))))

(provide 'wnn7egg-edep)

;;; wnn7egg-edep.el ends here
