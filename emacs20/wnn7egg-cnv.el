;; Wnn7Egg is Egg modified for Wnn7, and the current maintainer 
;; is OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;;
;; This file is part of Wnn7Egg. (base code is wnn-egg.el (eggV3.09))
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


;;;  wnn-egg.el --- a inputting method communicating with [jck]server

;; Author: Satoru Tomura (tomura@etl.go.jp), and
;;         Toshiaki Shingu (shingu@cpr.canon.co.jp)
;; Keywords: inputting method

;; This file is part of Egg on Mule (Multilingual Environment)

;; Egg is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; Egg is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the Free
;; Software Foundation Inc., 59 Temple Place - Suite 330, Boston,
;; MA 02111-1307, USA.

;;; Commentary:

;;;  Modified for Wnn V4 and Wnn6 by Satoru Tomura(tomura@etl.go.jp)
;;;  Modified for Wnn6 by OMRON
;;;  Written by Toshiaki Shingu (shingu@cpr.canon.co.jp)
;;;  Modified for Wnn V4 library on wnn4v3-egg.el

;;; たまご「たかな」バージョン
;;; 「たかな」とは漬け物のたかなではありません。
;;; 「たまごよ／かしこく／なーーれ」の略をとって命名しました。
;;; Wnn V4 の jl ライブラリを使います。
;;; ライブラリとのインターフェースは wnnfns.c で定義されています。

;;;  修正メモ

;;;  02/5/16  小文字ひらがな（ぁぃぅ）の変換後の M-k, M-h 動作の修正
;;;  02/5/16  skip-wnn-setenv-if-env-exist を t に変更
;;;  01/9/30  bug fix by OMRON SOFTWARE Co.,Ltd.

;;;  94/2/3   kWnn support by H.Kuribayashi
;;;  93/11/24 henkan-select-kouho: bug fixed
;;;  93/7/22  hinsi-from-menu updated
;;;  93/5/12  remove-regexp-in-string 
;;;		fixed by Shuji NARAZAKI <narazaki@csce.kyushu-u.ac.jp>
;;;  93/4/22  set-wnn-host-name, set-cwnn-host-name
;;;  93/4/5   EGG:open-wnn, close-wnn modified by tsuiki.
;;;  93/4/2   wnn-param-set
;;;  93/4/2   modified along with wnn4fns.c
;;;  93/3/3   edit-dict-item: bug fixed
;;;  93/1/8   henkan-help-command modified.
;;;  92/12/1  buffer local 'wnn-server-type' and 'cwnn-zhuyin'
;;;	 so as to support individual its mode with multiple buffers.
;;;  92/11/26 set-cserver-host-name fixed.
;;;  92/11/26 its:{previous,next}-mode by <yasutome@ics.osaka-u.ac.jp>
;;;  92/11/25 set-wnn-host-name was changed to set-{j,c}server-host-name.
;;;  92/11/25 redefined its:select-mode and its:select-mode-from-menu 
;;;	defined in egg.el to run hook with its mode selection.
;;;  92/11/20 bug fixed related to henkan mode attribute.
;;;  92/11/12 get-wnn-host-name and set-wnn-host-name were changed.
;;;  92/11/10 (set-dict-comment) bug fixed
;;;  92/10/27 (henkan-region-internal) display message if error occurs.
;;;  92/9/28 completely modified for chinese trandlation.
;;;  92/9/28 diced-{use,hindo-set} bug fixed <tetsuya@rabbit.is.s.u-tokyo.ac.jp>
;;;  92/9/22 touroku-henkan-mode by <tsuiki@sfc.keio.ac.jp>
;;;  92/9/18 rewrite wnn-dict-add to support password files.
;;;  92/9/8  henkan-region-internal was modified.
;;;  92/9/8  henkan-mode-map " "  'henkan-next-kouho-dai -> 'henkan-next-kouho
;;;  92/9/7  henkan-mode-map "\C-h" 'help-command -> 'henkan-help-command (Shuji Narazaki)
;;;  92/9/3  wnn-server-get-msg without wnn-error-code.
;;;  92/9/3  get-wnn-lang-name was modified.
;;;  92/8/19 get-wnn-lang-name の変更 (by T.Matsuzawa)
;;;  92/8/5  Bug in henkan-kakutei-first-char fixed. (by Y.Kasai)
;;;  92/7/17 set-egg-henkan-format の変更
;;;  92/7/17 egg:error の引数を format &rest args に変更
;;;  92/7/17 henkan/gyaku-henkan-word の修正
;;;  92/7/17 henkan/gyaku-henkan-paragraph/sentence/word で、
;;;	     表示が乱れるのを修正（save-excursion をはずす）
;;;  92.7.14 Unnecessary '*' in comments of variables deleted. (by T.Ito)
;;;  92/7/10 henkan-kakutei-first-char を追加、C-@ に割り当て。(by K.Handa)
;;;  92/7/8  overwrite-mode のサポート(by K. Handa)
;;;  92/6/30 startup file 周りの変更
;;;  92/6/30 変換モードのアトリビュートに bold を追加
;;;	     (by ITO Toshiyuki <toshi@his.cpl.melco.co.jp>)
;;;  92/6/22 空文字列を変換すると落ちるバグを修正
;;;  92/5/20 set-egg-henkan-mode-format の bug fix
;;;  92/5/20 egg:set-bunsetu-attribute が大文節で正しく動くように変更
;;;  92/5/19 version 0
;;; ----------------------------------------------------------------

;;; Code:

;;; Last modified date: 2002/5/16
;;; wnn7egg-cnv.el version 1.02

(require 'wnn7egg-lib)

(defvar egg:*sho-bunsetu-face* nil "*小文節表示に用いる face または nil")
(defvar egg:*sho-bunsetu-kugiri* "-" "*小文節の区切りを示す文字列")
(defvar egg:*dai-bunsetu-face* nil "*大文節表示に用いる face または nil")
(defvar egg:*dai-bunsetu-kugiri* " " "*大文節の区切りを示す文字列")
(defvar egg:*henkan-face* nil "*変換領域を表示する face または nil")

(if (featurep 'xemacs)
    (progn
      (make-variable-buffer-local
       (defvar egg:*sho-bunsetu-extent* nil "小文節の表示に使う extent"))
      (make-variable-buffer-local
       (defvar egg:*dai-bunsetu-extent* nil "大文節の表示に使う extent"))
      (make-variable-buffer-local
       (defvar egg:*henkan-extent* nil "変換領域の表示に使う extent")))
  (make-variable-buffer-local
   (defvar egg:*sho-bunsetu-overlay* nil "小文節の表示に使う overlay"))
  (make-variable-buffer-local
   (defvar egg:*dai-bunsetu-overlay* nil "大文節の表示に使う overlay"))
  (make-variable-buffer-local
   (defvar egg:*henkan-overlay* nil "変換領域の表示に使う overlay")))

(defvar egg:*henkan-open*  "|" "*変換の始点を示す文字列")
(defvar egg:*henkan-close* "|" "*変換の終点を示す文字列")

(make-variable-buffer-local
 (defvar wnn7-henkan-mode-in-use nil "buffer が変換中の時 t"))

;;; ----------------------------------------------------------------
;;;	以下の its mode 関係の関数は、egg.el で定義されているが、
;;; たかなでは its mode の切替えに同期して、jserver/cserver,
;;; pinyin/zhuyin の切替えも行ないたいので、再定義している。
;;; 従って、egg.el, wnn-egg.el の順にロードしなければならない。

(defun its:select-mode (name)
  (interactive (list (completing-read "ITS mode: " its:*mode-alist*)))
  (if (its:get-mode-map name)
      (progn
	(setq its:*current-map* (its:get-mode-map name))
	(egg:mode-line-display)
	(run-hooks 'its:select-mode-hook))
    (beep)))

(defun its:select-mode-from-menu ()
  (interactive)
  (setcar (nthcdr 2 its:*select-mode-menu*) its:*mode-alist*)
  (setq its:*current-map* (menu:select-from-menu its:*select-mode-menu*))
  (egg:mode-line-display)
  (run-hooks 'its:select-mode-hook))

(defvar its:select-mode-hook
  nil)

(defun its:next-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (% (1+ pos) (length its:*standard-modes*))
	       its:*standard-modes*))
    (egg:mode-line-display)
    (run-hooks 'its:select-mode-hook)))

(defun its:previous-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (1- (if (= pos 0) (length its:*standard-modes*) pos))
	       its:*standard-modes*))
    (egg:mode-line-display)
    (run-hooks 'its:select-mode-hook)))

(defun read-current-its-string (prompt &optional initial-input henkan)
  (let ((egg:fence-buffer (window-buffer (minibuffer-window)))
        (old-its-map its:*current-map*))
    (save-excursion
      (set-buffer egg:fence-buffer)
      (setq egg:*input-mode* t
	    egg:*mode-on*    t
	    its:*current-map* old-its-map)
      (mode-line-egg-mode-update
       (nth 1 (its:get-mode-indicator its:*current-map*)))
      (read-from-minibuffer prompt initial-input
			    (if henkan nil
			      egg:*minibuffer-local-hiragana-map*)))))

;;;----------------------------------------------------------------------
;;;
;;; Kana Kanji Henkan 
;;;
;;;----------------------------------------------------------------------

(defvar wnn7-server-list nil "Wnn7 jserver host list")
(defvar wnn7-server-name nil "Wnn7 jserver host name")

(defvar egg:*sai-henkan-start* nil)
(defvar egg:*sai-henkan-end* nil)
(defvar egg:*old-bunsetu-suu* nil)

(add-hook 'kill-emacs-hook 'close-wnn7)


;;;
;;; Entry functions for egg-startup-file
;;;

(defvar skip-wnn-setenv-if-env-exist t
  "skip wnn environment setting when the same name environment exists")

(defmacro push-end (val loc)
  (list 'push-end-internal val (list 'quote loc)))

(defun push-end-internal (val loc)
  (set loc
       (if (eval loc)
	   (nconc (eval loc) (cons val nil))
	 (cons val nil))))

;;
;; for parameter operation
;;
(defun wnn7-set-reverse (arg)
  (wnn7-server-set-rev arg))

(defun wnn7-set-param (&rest param)
  "based upon set-wnn-param"
 (interactive)
  (let ((current-param (append (wnn7-server-get-param) nil))
	(new-param)
	(message (wnn7-msg-get 'param)))
    (while current-param
      (setq new-param
	    (cons
	     (if (or (null param) (null (car param)))
		 (string-to-int
		  (read-from-minibuffer (concat (car message) ": ")
					(int-to-string (car current-param))))
	       (car param))
	     new-param))
      (setq current-param (cdr current-param)
	    message (cdr message)
	    param (if param (cdr param) nil)))
    (wnn7-server-set-param (vconcat (nreverse new-param)))))

(defun wnn7-add-dict (dfile hfile priority dmode hmode &optional dpaswd hpaswd)
  "based upon add-wnn-dict"
  (wnn7-server-dict-add (substitute-in-file-name dfile)
			(substitute-in-file-name hfile)
			priority dmode hmode dpaswd hpaswd))

(defun wnn7-set-fuzokugo (ffile)
  "based upon set-wnn-fuzokugo"
  (wnn7-server-fuzokugo-set (substitute-in-file-name ffile)))

(defun wnn7-add-fisys-dict (dfile hfile hmode &optional hpaswd)
  "based upon add-wnn-fisys-dict"
  (wnn7-server-fisys-dict-add (substitute-in-file-name dfile)
			      (substitute-in-file-name hfile)
			      hmode hpaswd))

(defun wnn7-add-fiusr-dict (dfile hfile dmode hmode &optional dpaswd hpaswd)
  "based upon add-wnn-fiusr-dict"
  (wnn7-server-fiusr-dict-add (substitute-in-file-name dfile)
			      (substitute-in-file-name hfile)
			      dmode hmode dpaswd hpaswd))

(defun wnn7-add-notrans-dict (dfile priority dmode &optional dpaswd)
  "based upon add-wnn-notrans-dict"
  (wnn7-server-notrans-dict-add (substitute-in-file-name dfile)
				priority dmode dpaswd))

(defun wnn7-add-bmodify-dict (dfile priority dmode &optional dpaswd)
  "based upon add-wnn7-bmodify-dict"
  (wnn7-server-bmodify-dict-add (substitute-in-file-name dfile)
				priority dmode dpaswd))

(defun wnn7-set-last-is-first-mode (mode)
  "based upon set-last-is-first-mode"
  (let ((result (wnn7-server-set-last-is-first mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-complex-conv-mode (mode)
  "based upon set-complex-conv-mode"
  (let ((result (wnn7-server-set-complex-conv-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-okuri-learn-mode (mode)
  "based upon set-okuri-learn-mode"
  (let ((result (wnn7-server-set-okuri-learn-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-okuri-flag (mode)
  "based upon set-okuri-flag"
  (let ((result (wnn7-server-set-okuri-flag mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-prefix-learn-mode (mode)
  "based upon set-prefix-learn-mode"
  (let ((result (wnn7-server-set-prefix-learn-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-prefix-flag (mode)
  "based upon set-prefix-flag"
  (let ((result (wnn7-server-set-prefix-flag mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-suffix-learn-mode (mode)
  "based upon set-suffix-learn-mode"
  (let ((result (wnn7-server-set-suffix-learn-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-common-learn-mode (mode)
  "based upon set-common-learn-mode"
  (let ((result (wnn7-server-set-common-learn-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-freq-func-mode (mode)
  "based upon set-freq-func-mode"
  (let ((result (wnn7-server-set-freq-func-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-numeric-mode (mode)
  "based upon set-numeric-mode"
  (let ((result (wnn7-server-set-numeric-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-alphabet-mode (mode)
  "based upon set-alphabet-mode"
  (let ((result (wnn7-server-set-alphabet-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-symbol-mode (mode)
  "based upon set-symbol-mode"
  (let ((result (wnn7-server-set-symbol-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-yuragi-mode (mode)
  "based upon set-yuragi-mode"
  (let ((result (wnn7-server-set-yuragi-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-rendaku-mode (mode)
  "based upon set-rendaku-mode"
  (let ((result (wnn7-server-set-rendaku-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-yosoku-learn (mode)
  (let ((result (wnn7-server-set-yosoku-learn-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-yosoku-max-disp (max)
  (let ((result (wnn7-server-set-yosoku-max-disp max)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-yosoku-last-is-first (mode)
  (let ((result (wnn7-server-set-yosoku-last-is-first-mode mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-boin-kabusoku (mode)
  (let ((result (wnn7-server-set-boin-kabusoku mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-shiin-choka (mode)
  (let ((result (wnn7-server-set-shiin-choka mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-n-choka (mode)
  (let ((result (wnn7-server-set-n-choka mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

(defun wnn7-set-nihongo-kosei (mode)
  (let ((result (wnn7-server-set-nihongo-kosei mode)))
    (if (< result 0)
	(egg:error (wnn7rpc-get-error-message (- result))))))

;;;
;;; WNN interface
;;;

(defmacro make-host-list (name list)
  `(cons ,name (delete ,name ,list)))

(defun set-wnn7-host-name (name)
  (interactive "sHost name: ")
  (close-wnn7)
  (setq wnn7-server-list
	(make-host-list
	 name (or wnn7-server-list (list (or wnn7-server-name
					     (getenv "JSERVER")))))))

(fset 'set-jserver-host-name (symbol-function 'set-wnn7-host-name))

(defvar wnn7egg-default-startup-file "eggrc-wnn7"
  "*Wnn7Egg startup file name (system default)")

(defvar wnn7egg-startup-file ".eggrc-wnn7"
  "*Wnn7Egg startup file name.")

;;;  92/6/30, by K.Handa
(defvar egg-startup-file-search-path '("~" ".")
  "*List of directories to search for egg-startup-file
whose name defaults to .eggrc.")

(defun egg:search-file (filename searchpath)
  (if (file-name-directory filename)
      (let ((file (substitute-in-file-name (expand-file-name filename))))
	(if (file-exists-p file) file nil))
    (catch 'answer
      (while searchpath
	(let ((path (car searchpath)))
	  (if (stringp path)
	      (let ((file (substitute-in-file-name
			   (expand-file-name filename path))))
		(if (file-exists-p file) (throw 'answer file)))))
	(setq searchpath (cdr searchpath)))
      nil)))

;;;
;;; Entry functions for wnn7egg-startup-file
;;;
(defun open-wnn7 ()
  (if (null (wnn7-server-isconnect)); as wnn-search-environment (eggV4)
      (let ((hostlist (or wnn7-server-list
			  (list (or wnn7-server-name
				    (getenv "JSERVER")
				    "localhost"))))
	    (loginname (user-login-name))
	    result)
	(catch 'success
	  (while hostlist
	    (let ((hostname (car hostlist))
		  poffset pabs)
	      (setq wnn7-active-server-port wnn7-server-default-port)
	      (if (or (setq poffset (string-match ":" hostname))
		      (setq pabs (string-match "/" hostname)))
		  (if poffset
		      (progn
			(setq wnn7-active-server-port 
			      (+ wnn7-active-server-port 
				 (string-to-number 
				  (substring hostname (match-end 0)))))
			(setq hostname (substring hostname 0 
						  (match-beginning 0))))
		    (setq wnn7-active-server-port 
			  (string-to-number (substring hostname 
						       (1+ pabs) nil)))
		    (setq hostname (substring hostname 0 pabs))))
	      (if (or (not hostname) (equal hostname ""))
		  (setq hostname "localhost"))
	      (if (setq wnn7-process (wnn7-server-start hostname))
		  (progn
		    (and
		     (= 0 (setq result (wnn7-server-open wnn7-process 
							 hostname loginname)))
		     (<= 0 (setq result (wnn7-server-connect wnn7-process
							     loginname)))
		     (setq loginname (concat loginname "R"))
		     (<= 0 (setq result (wnn7-server-connect wnn7-process
							     loginname t)))
		     (setq wnn7-active-server-name hostname)
		     (throw 'success hostname))
		    (setq hostlist (cdr hostlist)))
		(setq hostlist (cdr hostlist))))))
	(cond 
	 ((and result (<= 0 result))
	  ;; connected 
	  (notify (wnn7-msg-get 'open-wnn) wnn7-active-server-name)
	  ;; parameter set
	  (wnn7-param-set)
	  ;; re-init input-predict, when jserver restarted.
	  (if (and (wnn7-p)
		   egg-yosoku-mode)
	      (egg-use-input-predict)))
	 ((and result (> 0 result))
	  ;; server error
	  (egg:error (wnn7rpc-get-error-message (- result))))
	 ((not result)
	  ;; cannot connect
	  (egg:error (wnn7-msg-get 'cannot-connect)))
	 ))))

(defun wnn7-param-set ()
  (let* ((path (append egg-startup-file-search-path load-path))
	 (eggrc (or (egg:search-file wnn7egg-startup-file path)
		    (egg:search-file wnn7egg-default-startup-file load-path))))
    (if (or (null skip-wnn-setenv-if-env-exist)
	    (null (wnn7-server-dict-list)))
	(if eggrc 
	    (load-file eggrc)
	  (wnn7-server-close)
	  (egg:error (wnn7-msg-get 'no-rcfile) path)))
    (run-hooks 'egg:open-wnn-hook)))

(defun disconnect-wnn7 ()
  (interactive)
  (if (wnn7-server-isconnect) (wnn7-server-close)))

(defun close-wnn7 ()
  (interactive)
  (if (wnn7-server-isconnect)
      (progn
	(wnn7-server-set-rev nil)
	(wnn7-server-dict-save)
	(message (wnn7-msg-get 'file-saved))
	(sit-for 0)
	(when egg-predict-status
	  (wnn7-server-predict-save-data)
	  (wnn7-server-predict-free))
	(wnn7-server-set-rev t)
	(wnn7-server-dict-save)
	(message (wnn7-msg-get 'file-saved))
	(sit-for 0)
	(wnn7-server-close)
	(run-hooks 'egg:close-wnn7-hook))))

;;;
;;; Kanji henkan
;;;

(defvar wnn7-rensou-touroku nil)
(defvar egg:*kanji-kanabuff* nil)
(defvar egg:*dai* t)
(defvar *bunsetu-number* nil)
(defvar *zenkouho-suu* nil)
(defvar *zenkouho-offset* nil)

(defun wnn7-bunsetu-length-sho (number)
  (length (wnn7-server-bunsetu-yomi number)))

(defun wnn7-bunsetu-length (number)
  (let ((max (wnn7-server-dai-end number))
	(i (1+ number))
	(l (wnn7-bunsetu-length-sho number)))
    (while (< i max)
      (setq l (+ l (wnn7-bunsetu-length-sho i)))
      (setq i (1+ i)))
    l))

(defun wnn7-bunsetu-position (number)
  (let ((pos egg:*region-start*) (i 0))
    (while (< i number)
      (setq pos (+ pos (length (wnn7-server-bunsetu-kanji  i))
		   (if (wnn7-server-dai-top (1+ i))
		       (length egg:*dai-bunsetu-kugiri*)
		     (length egg:*sho-bunsetu-kugiri*))))
      (setq i (1+ i)))
    pos))

(defun wnn7-bunsetu-kouho-suu (bunsetu-number init)
  (let ((cand))
    (when (or init (null (wnn7-server-zenkouho-bun-p bunsetu-number)))
      (setq cand (wnn7-server-zenkouho bunsetu-number egg:*dai*)))
    (setq cand (wnn7-server-get-zenkouho bunsetu-number)
	  *zenkouho-suu* (length cand))))

(defun wnn7-bunsetu-kouho-list (bunsetu-number init)
  (let ((cand))
    (when (or init (null (wnn7-server-zenkouho-bun-p bunsetu-number)))
      (setq cand (wnn7-server-zenkouho bunsetu-number egg:*dai*))
      (setq *zenkouho-offset* (car cand)))
    (setq cand (wnn7-server-get-zenkouho bunsetu-number)
	  *zenkouho-suu* (length cand))
    cand))

(defun wnn7-bunsetu-kouho-number (bunsetu-number init)
  (let ((cand))
    (when (or init (null (wnn7-server-zenkouho-bun-p bunsetu-number)))
      (setq cand (wnn7-server-zenkouho bunsetu-number egg:*dai*))
      (setq *zenkouho-offset* (car cand)))
    *zenkouho-offset*))

;;;;
;;;; User entry : henkan-region, henkan-paragraph, henkan-sentence
;;;;

(defun egg:henkan-face-on ()
  ;; Make an overlay if henkan overlay does not exist.
  ;; Move henkan overlay to henkan region.
  (if egg:*henkan-face*
      (if (featurep 'xemacs)
	  (progn
	    (if (extentp egg:*henkan-extent*)
		(set-extent-endpoints egg:*henkan-extent* 
				      egg:*region-start* egg:*region-end*)
	      (setq egg:*henkan-extent* (make-extent egg:*region-start* 
						     egg:*region-end*))
	      (set-extent-property egg:*henkan-extent* 'start-open nil)
	      (set-extent-property egg:*henkan-extent* 'end-open nil)
	      (set-extent-property egg:*henkan-extent* 'detachable nil))
	    (set-extent-face egg:*henkan-extent* egg:*henkan-face*))
	(progn
	  (if (overlayp egg:*henkan-overlay*)
	      nil
	    (setq egg:*henkan-overlay* (make-overlay 1 1 nil nil t))
	    (overlay-put egg:*henkan-overlay* 'face egg:*henkan-face*))
	  (move-overlay egg:*henkan-overlay* egg:*region-start* 
			egg:*region-end*)))))

(defun egg:henkan-face-off ()
  ;; detach henkan overlay from the current buffer.
  (if (featurep 'xemacs)
      (and egg:*henkan-face*
	   (extentp egg:*henkan-extent*)
	   (detach-extent egg:*henkan-extent*))
    (and egg:*henkan-face*
	 (overlayp egg:*henkan-overlay*)
	 (delete-overlay egg:*henkan-overlay*))))

(defun wnn7-henkan-region (start end)
  "Convert a text in the region between START and END from kana to kanji."
  (interactive "r")
  (if (interactive-p) (set-mark (point))) ;;; to be fixed
  (wnn7-henkan-region-internal start end))

(defun wnn7-gyaku-henkan-region (start end)
  "Convert a text in the region between START and END from kanji to kana."
  (interactive "r")
  (if (interactive-p) (set-mark (point))) ;;; to be fixed
  (wnn7-henkan-region-internal start end t))

(defun wnn7-henkan-region-internal (start end &optional rev)
  ;; region をかな漢字変換する
  (if wnn7-henkan-mode-in-use nil
    (let ((finished nil))
      (unwind-protect
	  (progn
	    (setq wnn7-henkan-mode-in-use t)
	    (if (null (wnn7-server-isconnect)) (open-wnn7))
	    (setq egg:*kanji-kanabuff* (buffer-substring start end))

	    (setq *bunsetu-number* 0)
	    (setq egg:*dai* t)		; 92.9.8 by T.shingu
	    (wnn7-server-set-rev rev)
	    (let ((result (wnn7-server-henkan-begin egg:*kanji-kanabuff*)))
	      (if (and result 
		       (> (car result) 0))
		  (progn
		    (mode-line-egg-mode-update (wnn7-msg-get 'henkan-mode-indicator))
		    (goto-char start)
		    (or (markerp egg:*region-start*)
			(setq egg:*region-start* (make-marker)))
		    (or (markerp egg:*region-end*)
			(progn
			  (setq egg:*region-end* (make-marker))
			  (set-marker-insertion-type egg:*region-end* t)))
		    (if (null (marker-position egg:*region-start*))
			(progn
			  (delete-region start end)
			  (suspend-undo)
			  (goto-char start)
			  (insert egg:*henkan-open*)
			  (set-marker egg:*region-start* (point))
			  (insert egg:*henkan-close*)
			  (set-marker egg:*region-end* egg:*region-start*)
			  (goto-char egg:*region-start*)
			  )
		      (progn
			(egg:fence-face-off)
			(delete-region (- egg:*region-start* (length egg:*fence-open*)) 
				       egg:*region-start*)
			(delete-region egg:*region-end*
				       (+ egg:*region-end* (length egg:*fence-close*)))
			(goto-char egg:*region-start*)
			(insert egg:*henkan-open*)
			(set-marker egg:*region-start* (point))
			(goto-char egg:*region-end*)
			(let ((point (point)))
			  (insert egg:*henkan-close*)
			  (set-marker egg:*region-end* point))
			(goto-char start)
			(delete-region start end)
			))
		    (wnn7-henkan-insert-kouho 0 (car result))
		    (egg:henkan-face-on)
		    (wnn7-bunsetu-face-on)
		    (wnn7-henkan-goto-bunsetu 0)
		    (run-hooks 'egg:henkan-start-hook))))
	    (setq finished t))
	(or finished (setq wnn7-henkan-mode-in-use nil)
	    (resume-undo-list)))))
  )

(defun wnn7-henkan-paragraph ()
  "Convert the current paragraph from kana to kanji."
  (interactive)
  (forward-paragraph)
  (let ((end (point)))
    (backward-paragraph)
    (wnn7-henkan-region-internal (point) end)))

(defun wnn7-gyaku-henkan-paragraph ()
  "Convert the current paragraph from kanji to kana."
  (interactive)
  (forward-paragraph)
  (let ((end (point)))
    (backward-paragraph)
    (wnn7-henkan-region-internal (point) end t)))

(defun wnn7-henkan-sentence ()
  "Convert the current sentence from kana to kanji."
  (interactive)
  (forward-sentence)
  (let ((end (point)))
    (backward-sentence)
    (wnn7-henkan-region-internal (point) end)))

(defun wnn7-gyaku-henkan-sentence ()
  "Convert the current sentence from kanji to kana."
  (interactive)
  (forward-sentence)
  (let ((end (point)))
    (backward-sentence)
    (wnn7-henkan-region-internal (point) end t)))

(defun wnn7-henkan-word ()
  "Convert the current word from kana to kanji."
  (interactive)
  (re-search-backward "\\<" nil t)
  (let ((start (point)))
    (re-search-forward "\\>" nil t)
    (wnn7-henkan-region-internal start (point))))

(defun wnn7-gyaku-henkan-word ()
  "Convert the current word from kanji to kana."
  (interactive)
  (re-search-backward "\\<" nil t)
  (let ((start (point)))
    (re-search-forward "\\>" nil t)
    (wnn7-henkan-region-internal start (point) t)))

;;;
;;; Kana Kanji Henkan Henshuu mode
;;;

(defun set-egg-henkan-mode-format (open close kugiri-dai kugiri-sho
					&optional henkan-face dai-bunsetu-face sho-bunsetu-face)
   "変換 mode の表示方法を設定する。OPEN は変換の始点を示す文字列または nil。
CLOSEは変換の終点を示す文字列または nil。
KUGIRI-DAIは大文節の区切りを表示する文字列または nil。
KUGIRI-SHOは小文節の区切りを表示する文字列または nil。
optional HENKAN-FACE は変換区間を表示する face または nil
optional DAI-BUNSETU-FACE は大文節区間を表示する face または nil
optional SHO-BUNSETU-FACE は小文節区間を表示する face または nil"

  (interactive (list (read-string (wnn7-msg-get 'begin-henkan))
		     (read-string (wnn7-msg-get 'end-henkan))
		     (read-string (wnn7-msg-get 'kugiri-dai))
		     (read-string (wnn7-msg-get 'kugiri-sho))
		     (cdr (assoc (completing-read (wnn7-msg-get 'face-henkan)
						  egg:*face-alist*)
				 egg:*face-alist*))
		     (cdr (assoc (completing-read (wnn7-msg-get 'face-dai)
						  egg:*face-alist*)
				 egg:*face-alist*))
		     (cdr (assoc (completing-read (wnn7-msg-get 'face-sho)
						  egg:*face-alist*)
				 egg:*face-alist*))
		     ))
  (if (or (stringp open)  (null open))
      (setq egg:*henkan-open* (or open ""))
    (egg:error "Wrong type of arguments(open): %s" open))

  (if (or (stringp close) (null close))
      (setq egg:*henkan-close* (or close ""))
    (egg:error "Wrong type of arguments(close): %s" close))

  (if (or (stringp kugiri-dai) (null kugiri-dai))
      (setq egg:*dai-bunsetu-kugiri* (or kugiri-dai ""))
    (egg:error "Wrong type of arguments(kugiri-dai): %s" kugiri-dai))

  (if (or (stringp kugiri-sho) (null kugiri-sho))
      (setq egg:*sho-bunsetu-kugiri* (or kugiri-sho ""))
    (egg:error "Wrong type of arguments(kugiri-sho): %s" kugiri-sho))

  (if (or (null henkan-face) (memq henkan-face (face-list)))
      (progn
	(setq egg:*henkan-face* henkan-face)
	(if (featurep 'xemacs)
	    (if (extentp egg:*henkan-extent*)
		(set-extent-property egg:*henkan-extent* 'face egg:*henkan-face*))
	  (if (overlayp egg:*henkan-overlay*)
	      (overlay-put egg:*henkan-overlay* 'face egg:*henkan-face*))))
    (egg:error "Wrong type of arguments(henkan-face): %s" henkan-face))

  (if (or (null dai-bunsetu-face) (memq dai-bunsetu-face (face-list)))
      (progn
	(setq egg:*dai-bunsetu-face* dai-bunsetu-face)
	(if (featurep 'xemacs)
	    (if (extentp egg:*dai-bunsetu-extent*)
		(set-extent-property egg:*dai-bunsetu-extent* 'face egg:*dai-bunsetu-face*))
	  (if (overlayp egg:*dai-bunsetu-overlay*)
	      (overlay-put egg:*dai-bunsetu-overlay* 'face egg:*dai-bunsetu-face*))))
    (egg:error "Wrong type of arguments(dai-bunsetu-face): %s" dai-bunsetu-face))

  (if (or (null sho-bunsetu-face) (memq sho-bunsetu-face (face-list)))
      (progn
	(setq egg:*sho-bunsetu-face* sho-bunsetu-face)
	(if (featurep 'xemacs)
	    (if (extentp egg:*sho-bunsetu-extent*)
		(set-extent-property egg:*sho-bunsetu-extent* 'face egg:*sho-bunsetu-face*))
	  (if (overlayp egg:*sho-bunsetu-overlay*)
	      (overlay-put egg:*sho-bunsetu-overlay* 'face egg:*sho-bunsetu-face*))))
    (egg:error "Wrong type of arguments(sho-bunsetu-face): %s" sho-bunsetu-face))
  )

(defun wnn7-henkan-insert-kouho (startno number)
  (let ((i startno))
    (while (< i number)
      (insert (wnn7-server-bunsetu-kanji i) ;; ここは大文節？
	      (if (= (1+ i) number)
		  ""
		(if (wnn7-server-dai-top (1+ i))
;;;             (if (wnn7-server-dai-top i)
		    egg:*dai-bunsetu-kugiri*
		  egg:*sho-bunsetu-kugiri*)))
      (setq i (1+ i)))))

(defun wnn7-henkan-kakutei ()
  (interactive)
  (egg:bunsetu-face-off)
  (egg:henkan-face-off)
  (setq wnn7-henkan-mode-in-use nil)
  (setq egg:*in-fence-mode* nil)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (setq egg:*sai-henkan-start* (point))
  (when egg-predict-status
    (egg-predict-clear))
  (resume-undo-list)
  (let ((i 0) (max (wnn7-server-bunsetu-suu)))
    (setq egg:*old-bunsetu-suu* max)
    (while (< i max)
      (insert (wnn7-server-bunsetu-kanji i))
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (setq egg:*sai-henkan-end* (point))
  (wnn7-server-hindo-update)
  (when egg-predict-status
    (egg-predict-inc-kakutei-length) 
    (if (not wnn7-rensou-touroku)
	(egg-predict-toroku)))
  (setq wnn7-rensou-touroku nil)
  (egg:quit-egg-mode)
  (run-hooks 'egg:henkan-end-hook)
  )

;; 92.7.10 by K.Handa
(defun wnn7-henkan-kakutei-first-char ()
  "確定文字列の最初の一文字だけ挿入する。"
  (interactive)
  (egg:bunsetu-face-off)
  (egg:henkan-face-off)
  (setq wnn7-henkan-mode-in-use nil)
  (setq egg:*in-fence-mode* nil)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end*
				     ;; 92.8.5  by Y.Kasai
				     (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (resume-undo-list)
  (insert (wnn7-server-bunsetu-kanji 0))
  (if (not overwrite-mode)
      (undo-boundary))
  (goto-char egg:*region-start*)
  (forward-char 1)
  (delete-region (point) egg:*region-end*)
  (wnn7-server-hindo-update)
  (egg:quit-egg-mode)
  )
;; end of patch

(defun wnn7-henkan-kakutei-before-point ()
  (interactive)
  (egg:bunsetu-face-off)
  (egg:henkan-face-off)
  (delete-region egg:*region-start* egg:*region-end*)
  (goto-char egg:*region-start*)
  (let ((i 0) (max *bunsetu-number*))
    (while (< i max)
      (insert (wnn7-server-bunsetu-kanji i ))
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (wnn7-server-hindo-update)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-end*)
  (let ((point (point)))
    (insert egg:*fence-close*)
    (set-marker egg:*region-end* point))
  (goto-char egg:*region-start*)
  (egg:fence-face-on)
  (let ((point (point))
	(i *bunsetu-number*) (max (wnn7-server-bunsetu-suu)))
    (while (< i max)
      (insert (wnn7-server-bunsetu-yomi i))
      (setq i (1+ i)))
    ;;;(insert "|")
    ;;;(insert egg:*fence-close*)
    ;;;(set-marker egg:*region-end* (point))
    (goto-char point))
  (setq egg:*mode-on* t)
  (setq wnn7-henkan-mode-in-use nil)
  (egg:mode-line-display))

(defun wnn7-sai-henkan ()
  (interactive)
  (if wnn7-henkan-mode-in-use nil
    (let ((finished nil))
      (unwind-protect
       (progn
	 (setq wnn7-henkan-mode-in-use t)
	 (mode-line-egg-mode-update (wnn7-msg-get 'henkan-mode-indicator))
	 (goto-char egg:*sai-henkan-start*)
	 (delete-region egg:*sai-henkan-start* egg:*sai-henkan-end*)
	 (suspend-undo)
	 (goto-char egg:*sai-henkan-start*)
	 (insert egg:*henkan-open*)
	 (set-marker egg:*region-start* (point))
	 (insert egg:*henkan-close*)
	 (set-marker egg:*region-end* egg:*region-start*)
	 (goto-char egg:*region-start*)
	 (wnn7-henkan-insert-kouho 0 egg:*old-bunsetu-suu*)
	 (egg:henkan-face-on)
	 (wnn7-bunsetu-face-on)
	 (wnn7-henkan-goto-bunsetu 0)
	 (setq finished t))
       (or finished (setq wnn7-henkan-mode-in-use nil)
	   (resume-undo-list)))))
  )

(defun wnn7-bunsetu-face-on ()
  ;; make dai-bunsetu overlay and sho-bunsetu overlay if they do not exist.
  ;; put thier faces to overlays and move them to each bunsetu.
  (let* ((bunsetu-begin *bunsetu-number*)
	 (bunsetu-end))
;	 (bunsetu-suu (wnn7-server-bunsetu-suu)))
; dai bunsetu
    (if egg:*dai-bunsetu-face*
	(if (featurep 'xemacs)
	    (progn
	      (if (extentp egg:*dai-bunsetu-extent*)
		  nil
		(setq egg:*dai-bunsetu-extent* (make-extent 1 1))
		(set-extent-property egg:*dai-bunsetu-extent* 
				     'face egg:*dai-bunsetu-face*))
	      (setq bunsetu-end (wnn7-server-dai-end *bunsetu-number*))
	      (while (not (wnn7-server-dai-top bunsetu-begin))
		(setq bunsetu-begin (1- bunsetu-begin)))
	      (set-extent-endpoints egg:*dai-bunsetu-extent*
				    (wnn7-bunsetu-position bunsetu-begin)
				    (+ (wnn7-bunsetu-position (1- bunsetu-end))
				       (length (wnn7-server-bunsetu-kanji 
						(if (>= 0 bunsetu-end)
						    0
						  (1- bunsetu-end)))))))
	  (progn
	    (if (overlayp egg:*dai-bunsetu-overlay*)
		nil
	      (setq egg:*dai-bunsetu-overlay* (make-overlay 1 1))
	      (overlay-put egg:*dai-bunsetu-overlay* 
			   'face egg:*dai-bunsetu-face*))
	    (setq bunsetu-end (wnn7-server-dai-end *bunsetu-number*))
	    (while (not (wnn7-server-dai-top bunsetu-begin))
	      (setq bunsetu-begin (1- bunsetu-begin)))
	    (move-overlay egg:*dai-bunsetu-overlay*
			  (wnn7-bunsetu-position bunsetu-begin)
			  (+ (wnn7-bunsetu-position (1- bunsetu-end))
			     (length (wnn7-server-bunsetu-kanji 
				      (if (>= 0 bunsetu-end)
					  0
					(1- bunsetu-end)))))))))
; sho bunsetu
    (if egg:*sho-bunsetu-face*
	(if (featurep 'xemacs)
	    (progn
	      (if (extentp egg:*sho-bunsetu-extent*)
		  nil
		(setq egg:*sho-bunsetu-extent* (make-extent 1 1))
		(set-extent-property egg:*sho-bunsetu-extent* 
				     'face egg:*sho-bunsetu-face*))
	      (setq bunsetu-end (1+ *bunsetu-number*))
	      (set-extent-endpoints 
	       egg:*sho-bunsetu-extent*
	       (let ((point (wnn7-bunsetu-position *bunsetu-number*)))
		 (if (eq egg:*sho-bunsetu-face* 'modeline)
		     (+ point 1)
		   point))
	       (+ (wnn7-bunsetu-position (1- bunsetu-end))
		  (length (wnn7-server-bunsetu-kanji (1- bunsetu-end))))))
	  (progn
	    (if (overlayp egg:*sho-bunsetu-overlay*)
		nil
	      (setq egg:*sho-bunsetu-overlay* (make-overlay 1 1))
	      (overlay-put egg:*sho-bunsetu-overlay* 
			   'face egg:*sho-bunsetu-face*))
	    (setq bunsetu-end (1+ *bunsetu-number*))
	    (move-overlay 
	     egg:*sho-bunsetu-overlay*
	     (let ((point (wnn7-bunsetu-position *bunsetu-number*)))
	       (if (eq egg:*sho-bunsetu-face* 'modeline)
		   (1+ point)
		 point))
	     (+ (wnn7-bunsetu-position (1- bunsetu-end))
		(length (wnn7-server-bunsetu-kanji (1- bunsetu-end))))))))))

(defun egg:bunsetu-face-off ()
  (if (featurep 'xemacs)
      (progn
	(and egg:*dai-bunsetu-face*
	     (extentp egg:*dai-bunsetu-extent*)
	     (detach-extent egg:*dai-bunsetu-extent*))
	(and egg:*sho-bunsetu-face*
	     (extentp egg:*sho-bunsetu-extent*)
	     (detach-extent egg:*sho-bunsetu-extent*)))
    (and egg:*dai-bunsetu-face*
	 (overlayp egg:*dai-bunsetu-overlay*)
	 (delete-overlay egg:*dai-bunsetu-overlay*))
    (and egg:*sho-bunsetu-face*
	 (overlayp egg:*sho-bunsetu-overlay*)
	 (delete-overlay egg:*sho-bunsetu-overlay*))))

(defun wnn7-henkan-goto-bunsetu (number)
  (setq *bunsetu-number*
	(check-number-range number 0 (1- (wnn7-server-bunsetu-suu))))
  (goto-char (wnn7-bunsetu-position *bunsetu-number*))
;  (egg:move-bunsetu-overlay)
  (wnn7-bunsetu-face-on))

(defun wnn7-henkan-forward-bunsetu ()
  (interactive)
  (wnn7-henkan-goto-bunsetu (1+ *bunsetu-number*)))

(defun wnn7-henkan-backward-bunsetu ()
  (interactive)
  (wnn7-henkan-goto-bunsetu (1- *bunsetu-number*)))

(defun wnn7-henkan-first-bunsetu ()
  (interactive)
  (wnn7-henkan-goto-bunsetu 0))

(defun wnn7-henkan-last-bunsetu ()
  (interactive)
  (wnn7-henkan-goto-bunsetu (1- (wnn7-server-bunsetu-suu))))
 
(defun check-number-range (i min max)
  (cond((< i min) max)
       ((< max i) min)
       (t i)))

(defun wnn7-henkan-hiragana ()
  (interactive)
  (if (= 2 (wnn7-bunsetu-kouho-suu *bunsetu-number* nil))
      (wnn7-henkan-goto-kouho (- (wnn7-bunsetu-kouho-suu *bunsetu-number* nil) 2))
    (wnn7-henkan-goto-kouho (- (wnn7-bunsetu-kouho-suu *bunsetu-number* nil) 1))))

(defun wnn7-henkan-katakana ()
  (interactive)
  (if (= 2 (wnn7-bunsetu-kouho-suu *bunsetu-number* nil))
      (wnn7-henkan-goto-kouho (- (wnn7-bunsetu-kouho-suu *bunsetu-number* nil) 1))
    (wnn7-henkan-goto-kouho (- (wnn7-bunsetu-kouho-suu *bunsetu-number* nil) 2))))

(defun wnn7-henkan-next-kouho ()
  (interactive)
  (wnn7-henkan-goto-kouho (1+ (wnn7-bunsetu-kouho-number *bunsetu-number* nil))))

(defun wnn7-henkan-next-kouho-dai ()
  (interactive)
  (let ((init (not egg:*dai*)))
    (setq egg:*dai* t)
    (wnn7-henkan-goto-kouho (1+ (wnn7-bunsetu-kouho-number *bunsetu-number* init)))))

(defun wnn7-henkan-next-kouho-sho ()
  (interactive)
  (let ((init egg:*dai*))
    (setq egg:*dai* nil)
    (wnn7-henkan-goto-kouho (1+ (wnn7-bunsetu-kouho-number *bunsetu-number* init)))))
  
(defun wnn7-henkan-previous-kouho ()
  (interactive)
  (wnn7-henkan-goto-kouho (1- (wnn7-bunsetu-kouho-number *bunsetu-number* nil))))

(defun wnn7-henkan-previous-kouho-dai ()
  (interactive)
  (let ((init (not egg:*dai*)))
    (setq egg:*dai* t)
    (wnn7-henkan-goto-kouho (1- (wnn7-bunsetu-kouho-number *bunsetu-number* init)))))

(defun wnn7-henkan-previous-kouho-sho ()
  (interactive)
  (let ((init (setq egg:*dai* nil)))
    ;;(setq egg:*dai* nil)
    (wnn7-henkan-goto-kouho (1- (wnn7-bunsetu-kouho-number *bunsetu-number* init)))))

(defun wnn7-henkan-goto-kouho (kouho-number)
;  (egg:bunsetu-face-off)
  (let ((point (point))
;	(yomi  (wnn7-server-bunsetu-yomi *bunsetu-number*))
	(max)
	(min))
    (setq kouho-number 
	  (check-number-range kouho-number 
			      0
			      (1- (length (wnn7-bunsetu-kouho-list
					   *bunsetu-number* nil)))))
    (setq *zenkouho-offset* kouho-number)
;;    (wnn-server-henkan-kakutei kouho-number egg:*dai*)
    (if egg:*dai*
	(wnn7-server-henkan-kakutei *bunsetu-number* kouho-number)
      (wnn7-server-henkan-kakutei-sho *bunsetu-number* kouho-number))
    (setq max (wnn7-server-bunsetu-suu))
    (setq min (max 0 (1- *bunsetu-number*)))
    (delete-region 
     (wnn7-bunsetu-position min) egg:*region-end*)
    (goto-char (wnn7-bunsetu-position min))
    (wnn7-henkan-insert-kouho min max)
    (goto-char point))
;  (egg:move-bunsetu-overlay)
  (wnn7-bunsetu-face-on)
  (egg:henkan-face-on)
  )
  
(defun wnn7-henkan-bunsetu-chijime-dai ()
  (interactive)
  (setq egg:*dai* t)
  (or (= (wnn7-bunsetu-length *bunsetu-number*) 1)
      (wnn7-bunsetu-length-henko (1- (wnn7-bunsetu-length *bunsetu-number*)))))

(defun wnn7-henkan-bunsetu-chijime-sho ()
  (interactive)
  (setq egg:*dai* nil)
  (or (= (wnn7-bunsetu-length-sho *bunsetu-number*) 1)
      (wnn7-bunsetu-length-henko (1- (wnn7-bunsetu-length-sho 
				      *bunsetu-number*)))))

(defun wnn7-henkan-bunsetu-nobasi-dai ()
  (interactive)
  (setq egg:*dai* t)
  (let ((i *bunsetu-number*)
	(max (wnn7-server-bunsetu-suu))
	(len (wnn7-bunsetu-length *bunsetu-number*))
	(maxlen 0))
    (while (< i max)
      (setq maxlen (+ maxlen (length (wnn7-server-bunsetu-yomi i))))
      (setq i (1+ i)))
    (if (not (= len maxlen))
	(wnn7-bunsetu-length-henko (1+ len)))))

(defun wnn7-henkan-bunsetu-nobasi-sho ()
  (interactive)
  (setq egg:*dai* nil)
  (let ((i *bunsetu-number*)
	(max (wnn7-server-bunsetu-suu))
	(len (wnn7-bunsetu-length-sho *bunsetu-number*))
	(maxlen 0))
    (while (< i max)
      (setq maxlen (+ maxlen (length (wnn7-server-bunsetu-yomi i))))
      (setq i (1+ i)))
    (if (not (= len maxlen))
	(wnn7-bunsetu-length-henko (1+ len)))))

(defun wnn7-henkan-saishou-bunsetu ()
  (interactive)
  (wnn7-bunsetu-length-henko 1))

(defun henkan-saichou-bunsetu ()
  (interactive)
  (let ((max (wnn7-server-bunsetu-suu)) (i *bunsetu-number*)
	(l 0))
    (while (< i max)
      (setq l (+ l (wnn7-bunsetu-length-sho i)))
      (setq i (1+ i)))
    (wnn7-bunsetu-length-henko l)))

(defun wnn7-bunsetu-length-henko (length)
  (let (r 
	(start (max 0 (1- *bunsetu-number*))))
    (setq r (wnn7-server-bunsetu-henkou *bunsetu-number* length egg:*dai*))
    (cond((> (car r) 0)
	  (setq wnn7-bun-list (cdr r))
;	  (egg:henkan-face-off)
;	  (egg:bunsetu-face-off)
	  (delete-region 
	   (wnn7-bunsetu-position start) egg:*region-end*)
	  (goto-char (wnn7-bunsetu-position start))
	  (wnn7-henkan-insert-kouho start (car r))
	  (wnn7-henkan-goto-bunsetu *bunsetu-number*)))))

(defun wnn7-henkan-quit ()
  (interactive)
  (egg:bunsetu-face-off)
  (egg:henkan-face-off)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (insert egg:*kanji-kanabuff*)
  (let ((point (point)))
    (insert egg:*fence-close*)
    (set-marker egg:*region-end* point))
  (goto-char egg:*region-end*)
  (egg:fence-face-on)
  (setq egg:*mode-on* t)
  (setq wnn7-henkan-mode-in-use nil)
  (setq egg:*in-fence-mode* t)
  (egg:mode-line-display))

(defun wnn7-henkan-select-kouho (init)
  (if (not (eq (selected-window) (minibuffer-window)))
      (let ((kouho-list (wnn7-bunsetu-kouho-list *bunsetu-number* init))
	    menu)
	(setq menu
	      (list 'menu (wnn7-msg-get 'jikouho)
		    (let ((l kouho-list) (r nil) (i 0))
		      (while l
			(setq r (cons (cons (car l) i) r))
			(setq i (1+ i))
			(setq l (cdr l)))
		      (reverse r))))
	(wnn7-henkan-goto-kouho 
	 (menu:select-from-menu menu (wnn7-bunsetu-kouho-number *bunsetu-number* nil))))
    (beep)))

(defun wnn7-henkan-select-kouho-dai ()
  (interactive)
  (let ((init (not egg:*dai*)))
    (setq egg:*dai* t)
    (wnn7-henkan-select-kouho init)))

(defun wnn7-henkan-select-kouho-sho ()
  (interactive)
  (let ((init egg:*dai*))
    (setq egg:*dai* nil)
    (wnn7-henkan-select-kouho init)))

;; 保留
;;(defun henkan-word-off ()
;;  (interactive)
;;  (let ((info (wnn7-server-inspect *bunsetu-number*)))
;;    (if (null info)
;;	(notify (wnn-server-get-msg))
;;      (progn
;;	(let* ((kanji (nth 0 info))
;;	       (yomi (nth 1 info))
;;	       (serial   (nth 3 info))
;;	       (jisho-no (nth 2 info))
;;	       (jisho-name (nth 10 info)))
;;	  (if (wnn-server-word-use jisho-no serial)
;;	      (notify (wnn7-msg-get 'off-msg)
;;		      kanji yomi jisho-name serial)
;;	    (egg:error (wnn-server-get-msg)))))))))))

(defun wnn7-henkan-kakutei-and-self-insert ()
  (interactive)
  (setq unread-command-events (list last-command-event))
  (wnn7-henkan-kakutei))

(if (featurep 'xemacs)
    (progn
      (defvar wnn7-henkan-mode-map (make-sparse-keymap))
      (set-keymap-default-binding wnn7-henkan-mode-map 'undefined))
  (defvar wnn7-henkan-mode-map (append '(keymap (t . undefined)
						(?\C-x keymap (t . undefined)))
				       function-key-map))
  (define-prefix-command 'wnn7-henkan-mode-esc-map)
  (define-key wnn7-henkan-mode-map "\e" wnn7-henkan-mode-esc-map)
  (define-key wnn7-henkan-mode-map [escape] wnn7-henkan-mode-esc-map)
  (define-key wnn7-henkan-mode-esc-map [t]  'undefined))

(substitute-key-definition 'egg-self-insert-command
			   'wnn7-henkan-kakutei-and-self-insert
			   wnn7-henkan-mode-map global-map)

(define-key wnn7-henkan-mode-map "\ei" 'wnn7-henkan-bunsetu-chijime-sho)
(define-key wnn7-henkan-mode-map "\eo" 'wnn7-henkan-bunsetu-nobasi-sho)
(define-key wnn7-henkan-mode-map "\es" 'wnn7-henkan-select-kouho-dai)
(define-key wnn7-henkan-mode-map "\eh" 'wnn7-henkan-hiragana)
(define-key wnn7-henkan-mode-map "\ek" 'wnn7-henkan-katakana)
(define-key wnn7-henkan-mode-map "\er" 'wnn7-henkan-synonym)
(define-key wnn7-henkan-mode-map "\ez" 'wnn7-henkan-select-kouho-sho)
(define-key wnn7-henkan-mode-map "\e<" 'wnn7-henkan-saishou-bunsetu)
(define-key wnn7-henkan-mode-map "\e>" 'wnn7-henkan-saichou-bunsetu)

(define-key wnn7-henkan-mode-map " "    'wnn7-henkan-next-kouho) ; 92.7.10 by K.Handa
(define-key wnn7-henkan-mode-map "\C-@" 'wnn7-henkan-kakutei-first-char)
(define-key wnn7-henkan-mode-map [?\C-\ ] 'wnn7-henkan-kakutei-first-char)
(define-key wnn7-henkan-mode-map "\C-a" 'wnn7-henkan-first-bunsetu)
(define-key wnn7-henkan-mode-map "\C-b" 'wnn7-henkan-backward-bunsetu)
(define-key wnn7-henkan-mode-map "\C-c" 'wnn7-henkan-quit)
(define-key wnn7-henkan-mode-map "\C-e" 'wnn7-henkan-last-bunsetu)
(define-key wnn7-henkan-mode-map "\C-f" 'wnn7-henkan-forward-bunsetu)
(define-key wnn7-henkan-mode-map "\C-g" 'wnn7-henkan-quit)
(define-key wnn7-henkan-mode-map "\C-h" 'wnn7-henkan-help-command)
(define-key wnn7-henkan-mode-map "\C-i" 'wnn7-henkan-bunsetu-chijime-dai)
(define-key wnn7-henkan-mode-map "\C-k" 'wnn7-henkan-kakutei-before-point)
(define-key wnn7-henkan-mode-map "\C-l" 'wnn7-henkan-kakutei)
(define-key wnn7-henkan-mode-map "\C-m" 'wnn7-henkan-kakutei)
(define-key wnn7-henkan-mode-map "\C-n" 'wnn7-henkan-next-kouho)
(define-key wnn7-henkan-mode-map "\C-o" 'wnn7-henkan-bunsetu-nobasi-dai)
(define-key wnn7-henkan-mode-map "\C-p" 'wnn7-henkan-previous-kouho)
(define-key wnn7-henkan-mode-map "\C-t" 'wnn7-toroku-henkan-mode)
(define-key wnn7-henkan-mode-map "\C-v" 'wnn7-henkan-inspect-bunsetu)
(define-key wnn7-henkan-mode-map "\C-w" 'wnn7-henkan-next-kouho-dai)
(define-key wnn7-henkan-mode-map "\C-z" 'wnn7-henkan-next-kouho-sho)
(define-key wnn7-henkan-mode-map "\177" 'wnn7-henkan-quit)
(define-key wnn7-henkan-mode-map [backspace] 'wnn7-henkan-quit)
(define-key wnn7-henkan-mode-map [clear]     'wnn7-henkan-quit)
(define-key wnn7-henkan-mode-map [delete]    'wnn7-henkan-quit)
(define-key wnn7-henkan-mode-map [down]      'wnn7-henkan-next-kouho)
(define-key wnn7-henkan-mode-map [help]      'wnn7-henkan-help-command)
(define-key wnn7-henkan-mode-map [kp-enter]  'wnn7-henkan-kakutei)
(define-key wnn7-henkan-mode-map [kp-down]   'wnn7-henkan-next-kouho)
(define-key wnn7-henkan-mode-map [kp-left]   'wnn7-henkan-backward-bunsetu)
(define-key wnn7-henkan-mode-map [kp-right]  'wnn7-henkan-forward-bunsetu)
(define-key wnn7-henkan-mode-map [kp-up]     'wnn7-henkan-previous-kouho)
(define-key wnn7-henkan-mode-map [left]      'wnn7-henkan-backward-bunsetu)
(define-key wnn7-henkan-mode-map [next]      'wnn7-henkan-next-kouho)
(define-key wnn7-henkan-mode-map [prior]     'wnn7-henkan-previous-kouho)
(define-key wnn7-henkan-mode-map [return]    'wnn7-henkan-kakutei)
(define-key wnn7-henkan-mode-map [right]     'wnn7-henkan-forward-bunsetu)
(define-key wnn7-henkan-mode-map [up]        'wnn7-henkan-previous-kouho)

(unless (assq 'wnn7-henkan-mode-in-use minor-mode-map-alist)
  (setq minor-mode-map-alist
	(cons (cons 'wnn7-henkan-mode-in-use wnn7-henkan-mode-map)
	      minor-mode-map-alist)))

(defun wnn7-henkan-help-command ()
  "Display documentation for henkan-mode."
  (interactive)
  (let ((buf "*Help*"))
    (if (eq (get-buffer buf) (current-buffer))
	(wnn7-henkan-quit)
      (with-output-to-temp-buffer buf
	;;(princ (substitute-command-keys henkan-mode-document-string))
	(princ (substitute-command-keys (wnn7-msg-get 'henkan-help)))
	(print-help-return-message)))))

;;;----------------------------------------------------------------------
;;;
;;; Dictionary management Facility
;;;
;;;----------------------------------------------------------------------

;;;
;;; 辞書登録 
;;;

;;;;
;;;; User entry: toroku-region
;;;;

(defun remove-regexp-in-string (regexp string)
  (cond((not(string-match regexp string))
	string)
       (t(let ((str nil)
	     (ostart 0)
	     (oend   (match-beginning 0))
	     (nstart (match-end 0)))
	 (setq str (concat str (substring string ostart oend)))
	 (while (string-match regexp string nstart)
	   (setq ostart nstart)
	   (setq oend   (match-beginning 0))
	   (setq nstart (match-end 0))
	   (setq str (concat str (substring string ostart oend))))
	 (concat str (substring string nstart))))))

(defun wnn-hinshi-select (env dic-id)
  (menu:select-from-menu (wnn-make-hinshi-menu
			  env dic-id "/"
			  (wnn7-msg-get 'hinsimei))))

(defun wnn-make-hinshi-menu (env dic-id hinshi prompt)
  (let ((hinshi-list (wnn7rpc-get-hinshi-list env dic-id hinshi)))
    (if (numberp hinshi-list)
	(egg:error "%s" (wnn7rpc-get-error-message (- hinshi-list)))
      (list 'menu
	    (format (if (equal hinshi "/") "%s:" "%s[%s]:")
		    prompt
		    (substring hinshi 0 (1- (length hinshi))))
	    (mapcar (lambda (h)
		      (if (= (aref h (1- (length h))) ?/)
			  (cons h (wnn-make-hinshi-menu env dic-id h prompt))
			h))
		    hinshi-list)))))

(defun wnn-find-dictionary-by-id (id dic-list)
  (catch 'return
    (while dic-list
      (let ((dic (car dic-list)))
	(if (= (wnndic-get-id dic) id)
	    (throw 'return dic)
	  (setq dic-list (cdr dic-list)))))))

(defun wnn-dict-name (dic-info)
  (let ((comment (wnndic-get-comment dic-info))
	(name (wnndic-get-dictname dic-info)))
    (cond ((null (string= comment "")) comment)
	  ((wnn7-client-file-p name) name)
	  (t (file-name-nondirectory name)))))

(defun wnn-list-writable-dictionaries-byname (env)
  (let ((dic-list (wnn7-get-dictionary-list-with-environment env))
	(w-id-list (wnn7rpc-get-writable-dictionary-id-list env)))
    (cond ((numberp w-id-list)
	   (egg:error "%s" (wnn7rpc-get-error-message (- w-id-list))))
	  ((null w-id-list)
	   (egg:error 'wnn-no-writable-d))
	  (t
	   (delq nil
		 (mapcar (lambda (id)
			   (let ((dic (wnn-find-dictionary-by-id id dic-list)))
			     (and dic (cons (wnn-dict-name dic) dic))))
			 w-id-list))))))

(defun wnn-dictionary-select (env)
  (menu:select-from-menu (list 'menu
			 (wnn7-msg-get 'touroku-jishomei)
			 (wnn-list-writable-dictionaries-byname env))))


(defun wnn7-toroku-word (yomi kanji interactive)
  (let* ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	 (dic (wnn-dictionary-select env))
	 (dic-id (wnndic-get-id dic))
	 (hinshi (wnn-hinshi-select env dic-id))
	 (result (wnn7rpc-hinshi-number (wnn7env-get-proc env) hinshi)))
    (if (or (not interactive)
	    (notify-yes-or-no-p (wnn7-msg-get 'register-notify)
				kanji yomi hinshi (wnn-dict-name dic)))
	(progn
	  (or (< result 0)
	      (setq result (wnn7rpc-add-word env dic-id yomi 
					    kanji "" result 0)))
	  (if (>= result 0)
	      (notify (wnn7-msg-get 'registerd) kanji 
		      yomi hinshi (wnn-dict-name dic))
;;;	      (list hinshi (wnn-dict-name dic))
	    (egg:error (wnn7rpc-get-error-message (- result))))))))

(defun wnn7-toroku-region (start end)
  (interactive "r")
  (if (null (wnn7-server-isconnect)) (open-wnn7))
  (wnn7-server-set-rev nil)
  (let*((kanji
	 (remove-regexp-in-string "[\0-\37]" (buffer-substring start end)))
	(yomi (read-current-its-string
	       (format (wnn7-msg-get 'jishotouroku-yomi) kanji))))
    (wnn7-toroku-word yomi kanji nil)))

(defun delete-space (string)
  (let ((len (length string)))
    (if (eq len 0) ""
      (if (or (char-equal (aref string 0) ? ) (char-equal (aref string 0) ?-)) 
	  (delete-space (substring string 1))
	(concat (substring string 0 1) (delete-space (substring string 1)))))))


(defun wnn7-toroku-henkan-mode ()
  (interactive)
  (let*((kanji 	 
	 (read-current-its-string (wnn7-msg-get 'kanji)
			       (delete-space 
				(buffer-substring (point) egg:*region-end* ))))
	(yomi (read-current-its-string
	       (format (wnn7-msg-get 'jishotouroku-yomi) kanji)
	       (let ((str "")
		     (i *bunsetu-number*) 
		     (max (wnn7-server-bunsetu-suu)))
		 (while (< i max)
		   (setq str (concat str (wnn7-server-bunsetu-yomi i)))
		   (setq i (1+ i)))
		 str))))
    (wnn7-toroku-word yomi kanji nil)))

;;;
;;; 辞書編集系 DicEd
;;;

;;; Sorry, not ported yet. Please, use wnndictutil.

;;;
;;; Pure inspect facility
;;;

(defun wnn7-henkan-inspect-bunsetu ()
  (interactive)
  (notify (wnn7-server-inspect *bunsetu-number*)))

;;;
;;;
;;; input predict command
;;;
;;;

(defvar yosoku-select nil "候補選択されているか")
(defvar through-yosoku nil "候補を一時選択したか")
(defvar yosoku-input 0   "入力予測キー入力数")
(defvar yosoku-kakutei 0 "入力予測も含めたキー入力数")
(defvar count-start nil "予測効率計測中ステータス")
(defvar yosoku-sec-start 0 "予測効率計測開始時間の合計秒数")
(defvar yosoku-kouho-len 0 "予測候補で選択した候補のキー数")

(defvar egg-predict-realtime t "*リアルタイム入力予測なら T")
(defvar egg-predict-mode 'inline "入力予測候補表示位置 inline あるいは window")

;; for window-predict
(defconst egg-yosoku-buffer-name "*egg-predict*" "入力予測候補表示バッファ名")
(defconst egg-yosoku-window-size 5 "予測候補表示ウィンドウの大きさ")
(defvar egg-win-previous-config nil "予測候補表示の window configuration")
(defvar egg-win-previous-point nil "予測候補表示の current buffer point")

;; for inline-predict
(defvar egg-predict-original-position nil "フェンス内のの戻り位置")
(defvar egg-predict-start-position nil "候補表示開始のマーカー")
(defvar egg-predict-end-position nil "候補表示終了のマーカー")
(defvar egg-predict-inline-pos 0 "インライン表示候補選択位置")

(defun egg-predict-realtime-p ()
  (and (wnn7-server-isconnect)
       egg-predict-realtime
       egg-yosoku-mode))

(defun egg-predict-inline-p ()
  (string= egg-predict-mode 'inline))

(defun egg-use-input-predict ()
  (interactive)
  (if (not (wnn7-p))
      (error (wnn7-msg-get 'no-wnn7egg))
    (setq egg-yosoku-mode t)
    (if (null (wnn7-server-isconnect)) (open-wnn7))
    (when (wnn7-server-isconnect)
      (wnn7-server-set-rev nil)
      (wnn7-server-predict-init)
      (egg:mode-line-display)
      (if (not (egg-predict-inline-p))
	  (egg-predict-open-window)))))

(defun egg-unuse-input-predict ()
  (interactive)
  (if (not (wnn7-p))
      (error (wnn7-msg-get 'no-wnn7egg))
    (setq egg-yosoku-mode nil)
    (egg:mode-line-display)
    (if (not (egg-predict-inline-p))
	(egg-predict-close-window))
    (when egg-predict-status
      (wnn7-server-predict-save-data)
      (wnn7-server-predict-free))))

(defun egg-predict-toggle-realtime-mode ()
  (interactive)
  (if egg-predict-realtime
      (setq egg-predict-realtime nil)
    (setq egg-predict-realtime t))
  (eval egg-predict-realtime))

(defun egg-predict-toggle-candidate-mode ()
  (interactive)
  (if (string= egg-predict-mode 'inline)
      (setq egg-predict-mode 'window)
    (setq egg-predict-mode 'inline))
  (if (egg-predict-inline-p)
      (egg-predict-close-window)))

(defun egg-predict-start-realtime ()
  (interactive)
  (when (and egg-yosoku-mode
	     (wnn7-server-isconnect)
	     (not (window-minibuffer-p (selected-window))))
    (if (string= egg-predict-mode 'inline)
	(egg-predict-start-internal-inline egg:*region-start* 
					   egg:*region-end*)
      (setq egg-win-previous-point (point))
      (egg-predict-open-window)
      (egg-predict-start-internal-window egg:*region-start* 
					 egg:*region-end*))))

(defun egg-predict-start-parttime ()
  (interactive)
  (when (and (wnn7-p)
	     egg-yosoku-mode
	     (wnn7-server-isconnect)
	     (not (window-minibuffer-p (selected-window))))
    (if (string= egg-predict-mode 'inline)
	(progn
	  (if (egg-predict-start-internal-inline egg:*region-start* 
						 egg:*region-end*)
	      (egg-predict-mode-in-inline)))
      (setq egg-win-previous-point (point))
      (egg-predict-open-window)
      (if (egg-predict-start-internal-window egg:*region-start* 
					     egg:*region-end*)
	  (egg-predict-mode-in-window)))))

(defun egg-predict-check-reset-connective ()
  (when (and egg-yosoku-mode
	     egg-predict-status
	     (wnn7-server-isconnect))
    (if (and (not (eq last-command 'fence-exit-mode))
	     (not (eq last-command 'egg-predict-select))
	     (not (eq last-command 'wnn7-henkan-kakutei)))
	(wnn7-server-predict-reset-connective))))

(defun egg-delete-backward-char (arg &optional killp)
 (interactive "*p\nP")
 (when (and (wnn7-p)
	    (wnn7-server-isconnect)
	    egg-yosoku-mode
	    egg-predict-status)
   (if (or (eq last-command 'fence-exit-mode)
	   (eq last-command 'wnn7-henkan-kakutei)
	   (eq last-command 'egg-predict-select))
       (wnn7-server-predict-cancel-toroku)))
 (delete-backward-char arg killp))

(defun egg-predict-toroku (&optional kakutei-str)
  (when (and (wnn7-server-isconnect)
	     egg-yosoku-mode)
    (wnn7-server-set-rev nil)
    (if (null egg-predict-status) (wnn7-server-predict-init))
;;;    (egg-predict-inc-kakutei-length) ;; move to wnn7-henkan-kakutei 
    (wnn7-server-predict-toroku kakutei-str)))

(defun egg-backward-delete-char-untabify (arg &optional killp)
 (interactive "*p\nP")
 (when (and (wnn7-p)
	    (wnn7-server-isconnect)
	    egg-yosoku-mode
	    egg-predict-status)
   (if (or (eq last-command 'fence-exit-mode)
	   (eq last-command 'wnn7-henkan-kakutei)
	   (eq last-command 'egg-predict-select))
       (wnn7-server-predict-cancel-toroku)))
 (backward-delete-char-untabify arg killp))

(defun egg-predict-select ()
  (interactive)
  (if (egg-predict-inline-p)
      (egg-predict-select-inline)
    (egg-predict-select-window)))

(defun egg-predict-next-candidate ()
  (interactive)
  (if (egg-predict-inline-p)
      (egg-predict-next-candidate-inline)
    (when (equal (buffer-name) egg-yosoku-buffer-name)
      (egg-predict-inc-input-length) ; key input count
      (forward-line 1)
      (beginning-of-line)
      (if (eobp)
	  (goto-char (point-min))))))

(defun egg-predict-prev-candidate ()
  (interactive)
  (if (egg-predict-inline-p)
      (egg-predict-prev-candidate-inline)
    (when (equal (buffer-name) egg-yosoku-buffer-name)
      (egg-predict-inc-input-length) ; key input count
      (forward-line -1)
      (beginning-of-line))))

(defun egg-predict-delete ()
  (interactive)
  (if (egg-predict-inline-p)
      (when (numberp egg-predict-inline-pos)
	(wnn7-server-predict-delete-cand egg-predict-inline-pos)
	(egg-predict-cancel)
	(egg-predict-start-parttime))
    (when (equal (buffer-name) egg-yosoku-buffer-name)
      (let (pos)
	(save-excursion
	  (setq pos (count-lines 1 (point))))
	(wnn7-server-predict-delete-cand pos)
	(egg-predict-cancel)
	(egg-predict-start-parttime)))))

(defun egg-predict-clear ()
  (if (egg-predict-inline-p)
      (egg-predict-clear-inline)
    (when (get-buffer egg-yosoku-buffer-name) 
      (with-current-buffer (get-buffer egg-yosoku-buffer-name) 
	(progn
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (setq buffer-read-only t))))))

(defun egg-predict-cancel ()
  (interactive)
  (if (egg-predict-inline-p)
      (progn
	(egg-predict-inc-input-length) ; key input count
	(egg-predict-mode-out-inline)
	(egg-predict-clear-inline))
    (if (equal (buffer-name) egg-yosoku-buffer-name)
	(progn
	  (egg-predict-inc-input-length) ; key input count
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (setq buffer-read-only t)))
    (egg-predict-mode-out-window)
    (goto-char egg-win-previous-point)))

(defun egg-predict-save-data ()
  (interactive)
  (when egg-predict-status
    (wnn7-server-predict-save-data)))

(if (featurep 'xemacs)
    (progn 
      (defvar egg-predict-mode-map (make-sparse-keymap))
      (set-keymap-default-binding egg-predict-mode-map 'undefined))
  (defvar egg-predict-mode-map (append '(keymap (t . undefined)
						(?\C-x keymap (t . undefined)))
				       function-key-map))
  (defvar egg-predict-mode-esc-map nil)
  (define-prefix-command 'egg-predict-mode-esc-map)
  (define-key egg-predict-mode-map "\C-x" egg-predict-mode-esc-map)
  (define-key egg-predict-mode-esc-map [t]  'undefined))

(define-key egg-predict-mode-map " "      'egg-predict-next-candidate)
(define-key egg-predict-mode-map [tab]    'egg-predict-next-candidate)
(define-key egg-predict-mode-map "\C-i" 'egg-predict-next-candidate)
(define-key egg-predict-mode-map "n"      'egg-predict-next-candidate)
(define-key egg-predict-mode-map "\C-n"   'egg-predict-next-candidate)
(define-key egg-predict-mode-map "f"      'egg-predict-next-candidate)
(define-key egg-predict-mode-map "\C-f"   'egg-predict-next-candidate)
(define-key egg-predict-mode-map "b"      'egg-predict-prev-candidate)
(define-key egg-predict-mode-map "\C-b"   'egg-predict-prev-candidate)
(define-key egg-predict-mode-map "p"      'egg-predict-prev-candidate)
(define-key egg-predict-mode-map "\C-p"   'egg-predict-prev-candidate)
(define-key egg-predict-mode-map [return] 'egg-predict-select)
(define-key egg-predict-mode-map "\C-m" 'egg-predict-select)
(define-key egg-predict-mode-map "q"      'egg-predict-cancel)
(define-key egg-predict-mode-map "\C-g"   'egg-predict-cancel)
(define-key egg-predict-mode-map "\C-xo"  'egg-predict-other-window)
(define-key egg-predict-mode-map "\C-d"   'egg-predict-delete)

(make-variable-buffer-local (defvar egg-predict-candidate-inline nil))

(unless (assq 'egg-predict-candidate-inline minor-mode-map-alist)
  (setq minor-mode-map-alist
	(cons (cons 'egg-predict-candidate-inline egg-predict-mode-map)
	      minor-mode-map-alist)))

(defun egg-predict-other-window ()
  (interactive)
  (if (equal (buffer-size) 0)
      (other-window 1)
    (beep)))

(defun egg-predict-candidate-mode ()
  (use-local-map egg-predict-mode-map)
  (setq mode-name "egg-predict")
  (setq major-mode 'egg-predict-candidate-mode)
  (buffer-disable-undo egg-yosoku-buffer-name))

;;; window mode


(defun egg-predict-open-window ()
  (get-buffer-create egg-yosoku-buffer-name)
  (if (get-buffer-window egg-yosoku-buffer-name)
      (display-buffer egg-yosoku-buffer-name)
    (let ((parent-win (selected-window)))
      (split-window-vertically (- egg-yosoku-window-size))
      (set-window-buffer (other-window 1) egg-yosoku-buffer-name)
      (select-window parent-win))))

(defun egg-predict-close-window ()
  (delete-windows-on egg-yosoku-buffer-name))

(defun egg-predict-mode-in-window ()
  (interactive)
  (egg-predict-open-window)
  (if (not egg-win-previous-config)
      (setq egg-win-previous-config (current-window-configuration)))
  (select-window (get-buffer-window egg-yosoku-buffer-name))
  (setq through-yosoku t)
  (or (eq major-mode 'egg-predict-candidate-mode) 
      (egg-predict-candidate-mode)))

(defun egg-predict-mode-out-window ()
  (interactive)
  (when (window-configuration-p egg-win-previous-config)
    (set-window-configuration egg-win-previous-config)
    (setq egg-win-previous-config nil)))

(defun egg-predict-start-internal-window (start end)
  (let (predict-string result)
    (wnn7-server-set-rev nil)
    (if (null egg-predict-status) (wnn7-server-predict-init))
    (setq predict-string (buffer-substring start end))
    (setq result (wnn7-server-predict-start predict-string))
    (cond ((null result)
	   (let ((cur-buf (current-buffer)))
	     (set-buffer egg-yosoku-buffer-name)
	     (setq buffer-read-only nil)
	     (erase-buffer)
	     (setq buffer-read-only t)
	     (set-buffer cur-buf)
	     nil))
	  ((eq result -3011)
	   (if (not egg-predict-realtime)
	       (egg:error "%s" (wnn7rpc-get-error-message (- result)))))
	  (t
	   (let ((cur-buf (current-buffer))
		 (count 0))
	     (set-buffer egg-yosoku-buffer-name)
	     (setq buffer-read-only nil)
	     (erase-buffer)
	     (while result
	       (insert (format "%d: %s\n"
			       count
			       (car result)))
	       (setq count (1+ count)
		     result (cdr result)))
	     (setq buffer-read-only t)
	     (goto-char (point-min))
	     (set-buffer cur-buf)
	     t)))))

(defun egg-predict-select-window ()
  (when (equal (buffer-name) egg-yosoku-buffer-name)
    (let ((cur-point (point)) 
	  start end kakutei-string pos result)
      (save-excursion
	(goto-char (point-min))
	(beginning-of-line)
	(setq start (point))
	(goto-char cur-point)
	(beginning-of-line)
	(setq pos (count-lines 1 (point)))
	(setq start (point))
	(end-of-line)
	(setq end (point))
	(setq kakutei-string (buffer-substring (+ start 3) end)))
      (setq result (wnn7-server-predict-selected-cand pos))
      (when result
	(setq yosoku-kouho-len (+ yosoku-kouho-len result))
	(setq yosoku-select t) 
	(egg-predict-inc-kakutei-length) ;;;
	(egg-predict-cancel)
	(egg:fence-face-off)
	(setq egg:*in-fence-mode* nil)
	(delete-region (- egg:*region-start* (length egg:*fence-open*)) 
		       egg:*region-start*)
	(delete-region egg:*region-start* egg:*region-end*)
	(delete-region egg:*region-end* (+ egg:*region-end* 
					   (length egg:*fence-close*)))
	(goto-char egg:*region-start*)
	(resume-undo-list)
	(insert kakutei-string)))
    (if its:*previous-map*
	(setq its:*current-map* its:*previous-map*
	      its:*previous-map* nil))
    (egg:quit-egg-mode)))
      

;;; inline version

(defvar egg-ud-face nil "underline face")
(if (not egg-ud-face)
    (progn
      (setq egg-ud-face (make-face 'egg-ud-face))
      (set-face-underline-p egg-ud-face t)))

(defun egg-predict-mode-in-inline ()
  (interactive)
  (setq through-yosoku t)
  (setq egg-predict-inline-pos 0)
  (setq egg-predict-original-position (point))
  (goto-char (next-overlay-change (marker-position egg-predict-start-position)))
  (setq egg-predict-candidate-inline t))

(defun egg-predict-mode-out-inline ()
  (interactive)
  (setq egg-predict-candidate-inline nil)
  (goto-char egg-predict-original-position))

(defun egg-predict-next-candidate-inline ()
  (interactive)
  (let (pos overlay-list)
    (setq pos (next-overlay-change (point)))
    (setq overlay-list (overlays-at (point)))
    (egg-predict-inc-input-length) ; key input count
    (while overlay-list
      (if (and (string= (overlay-get (car overlay-list) 'face) 'egg-ud-face)
	       (= pos (overlay-end (car overlay-list))))
	  (setq pos (next-overlay-change pos)))
      (setq overlay-list (cdr overlay-list)))
    (if (or (not pos) 
	    (not (marker-position egg-predict-end-position))
	    (<= (marker-position egg-predict-end-position) pos))
	;; goto top
	(progn
	  (goto-char (next-overlay-change (marker-position egg-predict-start-position)))
	  (setq egg-predict-inline-pos 0))
      (goto-char pos)
      (setq egg-predict-inline-pos (1+ egg-predict-inline-pos)))))

(defun egg-predict-prev-candidate-inline ()
  (interactive)
  (let (pos overlay-list)
    (setq pos (previous-overlay-change (point)))
    (setq overlay-list (overlays-at (1- pos)))
    (egg-predict-inc-input-length) ; key input count
    (while overlay-list
      (if (and (string= (overlay-get (car overlay-list) 'face) 'egg-ud-face)
	       (= pos (overlay-end (car overlay-list))))
	  (setq pos (previous-overlay-change pos)))
      (setq overlay-list (cdr overlay-list)))
    (if (and pos
	     (marker-position egg-predict-start-position)
	     (>= (marker-position egg-predict-start-position) pos))
	;; goto top
	(progn
	  (goto-char (next-overlay-change (marker-position egg-predict-start-position)))
	  (setq egg-predict-inline-pos 0))
      (goto-char pos)
      (setq egg-predict-inline-pos (1- egg-predict-inline-pos)))))

(defun egg-predict-select-inline ()
  (interactive)
  (let (start end kakutei-string result)
    (save-excursion
      (setq start (point))
      (setq end (next-overlay-change (point)))
      (setq kakutei-string (buffer-substring start end)))
    (setq result (wnn7-server-predict-selected-cand egg-predict-inline-pos))
    (when result
      (setq yosoku-kouho-len (+ yosoku-kouho-len result))
      (setq yosoku-select t) 
      (egg-predict-inc-kakutei-length) ;;;
      (egg-predict-clear-inline)
      (goto-char egg-predict-original-position)
      (setq egg-predict-candidate-inline nil)
      (egg:fence-face-off)
      (setq egg:*in-fence-mode* nil)
      (delete-region (- egg:*region-start* (length egg:*fence-open*)) 
		     egg:*region-start*)
      (delete-region egg:*region-start* egg:*region-end*)
      (delete-region egg:*region-end* (+ egg:*region-end* 
					 (length egg:*fence-close*)))
      (goto-char egg:*region-start*)
      (resume-undo-list)
      (insert kakutei-string)))
  (if its:*previous-map*
      (setq its:*current-map* its:*previous-map*
	    its:*previous-map* nil))
  (egg:quit-egg-mode))

(defun egg-predict-start-internal-inline (start end)
  (let (predict-string result st recenter-pos)
    (wnn7-server-set-rev nil)
    (if (null egg-predict-status) (wnn7-server-predict-init))
    (setq predict-string (buffer-substring start end))
    (setq result (wnn7-server-predict-start predict-string))
    (cond ((null result)
	   (egg-predict-clear-inline)
	   nil)
	  ((eq result -3011)
	   (if (not egg-predict-realtime)
	       (egg:error "%s" (wnn7rpc-get-error-message (- result)))))
	  (t
	   (egg-predict-clear-inline)
	   (save-excursion
	     (end-of-line)
	     (setq egg-predict-start-position (point-marker))
	     (set-marker-insertion-type egg-predict-start-position nil)
	     (insert "\n------------------------------------------------------------\n")
	     (while result
	       (setq st (point))
	       (insert (format "[%s]" (car result)))
	       (overlay-put (make-overlay (1+ st) (1- (point))) 'face egg-ud-face)
	       (setq result (cdr result)))
	     (insert "\n------------------------------------------------------------\n")
	     (setq recenter-pos (point))
	     (setq egg-predict-end-position (point-marker)))
	   (if (not (pos-visible-in-window-p recenter-pos))
	       (recenter))
	   t))))

(defun egg-predict-clear-inline ()
  (if (or egg-predict-start-position
	  egg-predict-end-position)
      (let ((pos (marker-position egg-predict-start-position))
	    overlay-list overlay)
	(while pos
	  (setq overlay-list (overlays-at pos))
	  (while overlay-list
	    (setq overlay (overlay-get (car overlay-list) 'face))
	    (setq pos (overlay-end (car overlay-list)))
	    (if (string= overlay 'egg-ud-face)
	(delete-overlay (car overlay-list)))
	    (setq overlay-list (cdr overlay-list)))
	  (if (= pos (next-overlay-change pos))
	      (setq pos nil)
	    (setq pos (next-overlay-change pos)))
	  (if (or (not pos) 
		  (not (marker-position egg-predict-end-position))
		  (<= (marker-position egg-predict-end-position) pos))
	      (setq pos nil)))
	(save-excursion 
	  (delete-region (marker-position egg-predict-start-position)
			 (marker-position egg-predict-end-position))
	  (setq egg-predict-start-position nil
		egg-predict-end-position nil)))))


;;;
;;; input efficiency  
;;;
;;;

(defun egg-predict-check-end ()
  (when (and egg-yosoku-mode
	     egg-predict-status)
    (egg-predict-check-end-input)
    (egg-predict-check-end-time)))

(defun egg-predict-check-start-time ()
  (let ((time (decode-time (current-time))))
    (setq yosoku-sec-start (+ (nth 0 time) (* 60 (nth 1 time))))
    (setq yosoku-select nil
	  through-yosoku nil
	  count-start t)))

(defun egg-predict-check-end-time ()
  (let ((time (decode-time (current-time)))
	endtime timediff)
    (setq endtime (+ (nth 0 time) (* 60 (nth 1 time))))
    (when count-start
      (if (< endtime yosoku-sec-start)
	  (setq endtime (+ endtime 3600)))
      (setq timediff (- endtime yosoku-sec-start))
      (if (> yosoku-kakutei 0)
	  (wnn7-server-predict-set-timeinfo (if yosoku-select 1 0)
					   (if through-yosoku 1 0)
					   timediff
					   yosoku-kakutei))
      (setq count-start nil))))

(defun egg-predict-check-start-input ()
  (setq yosoku-input 0
	yosoku-kakutei 0
	yosoku-kouho-len 0))

(defun egg-predict-check-end-input ()
  (when count-start
    (wnn7-server-predict-set-user-inputinfo yosoku-kakutei
					    yosoku-input 
					    yosoku-select)))

(defun egg-predict-inc-input-length ()
  (setq yosoku-input (1+ yosoku-input)))
			    
(defun egg-predict-inc-kakutei-length ()
  (if yosoku-select
      (setq yosoku-kakutei (+ yosoku-kakutei yosoku-kouho-len))
    (setq yosoku-kakutei yosoku-input)))



(defvar predict-average-mode-map nil "")
(if predict-average-mode-map
    ()
  (setq predict-average-mode-map (make-keymap))
  (suppress-keymap predict-average-mode-map t)
  (if (featurep 'xemacs)
      (define-key predict-average-mode-map "q" 'Buffer-menu-quit)
    (define-key predict-average-mode-map "q" 'quit-window)))

(defun predict-average-mode ()
  (kill-all-local-variables)
  (use-local-map predict-average-mode-map)
  (setq major-mode 'predict-average-mode)
  (setq mode-name "Input Efficiency")
  (setq buffer-read-only t))

(defun egg-show-predict-average ()
  (interactive)
  (let ((standard-output standard-output)
	status)
    (if (or (not (wnn7-p))
	    (not egg-yosoku-mode))
	(error (wnn7-msg-get 'no-predict))
      (save-excursion
	(set-buffer (get-buffer-create "*input efficiency*"))
	(setq buffer-read-only nil)
	(erase-buffer)
	(setq standard-output (current-buffer))
	(wnn7-server-set-rev nil)
	(if (null egg-predict-status) (wnn7-server-predict-init))
	(setq status (wnn7-server-predict-status))
	(when (vectorp status)
	  (princ (format "削減された入力キー数の割合           %d ％\n" 
			 (aref status 0)))
	  (princ (format "    （入力した全文章のキー数         %d ）\n"
			 (aref status 1)))
	  (princ (format "    （あなたが入力したキー数         %d ）\n"
			 (aref status 2)))
	  (princ (format "削減された時間の割合                 %d ％\n"
			 (aref status 3)))
	  (princ (format "    （全文章の推定入力時間           %d 秒）\n"
			 (aref status 4)))
	  (princ (format "    （あなたが入力した時間           %d 秒）\n"
			 (aref status 5)))
	  (princ (format "予測入力を使った割合                 %d ％\n"
			 (aref status 12)))
	  (princ (format "    （予測入力で入力した文のキー数   %d ）\n"
			 (aref status 13)))
	  (princ "\n---- 直前の確定した文のキー数 ----\n\n")
	  (princ (format "削減された入力キー数の割合           %d ％\n"
			 (aref status 14)))
	  (princ (format "    （確定文のキー数                 %d ）\n"
			 (aref status 15)))
	  (princ (format "    （あなたが入力したキー数         %d ）\n"
			 (aref status 16)))
	  (princ (format "削減された時間の割合                 %d ％\n"
			 (aref status 17)))
	  (princ (format "    （確定文の推定入力時間           %d ミリ秒）\n"
			 (aref status 18)))
	  (princ (format "    （あなたが入力した時間           %d ミリ秒）\n"
			 (aref status 19)))
	  (princ (format " <<あなたの１キーの推定入力時間      %d ミリ秒>>\n"
			 (aref status 20))))
	(predict-average-mode)
	(display-buffer (current-buffer))))))

;;
;; associate translation
;;
(defun wnn7-henkan-synonym ()
  (interactive)
  (let (kouho-number)
    (setq wnn7-rensou-touroku t)
    (setq kouho-number (wnn7-bunsetu-kouho-number *bunsetu-number* nil))
    (setq *zenkouho-offset* kouho-number)
    (if (wnn7-server-synonym *bunsetu-number* kouho-number egg:*dai*)
	(wnn7-henkan-select-kouho-dai)
      (notify (wnn7-msg-get 'no-rensou)))))

(provide 'wnn7egg-cnv)

;;; wnn7egg-cnv.el ends here


