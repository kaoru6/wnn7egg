;; Wnn7Egg is Egg modified for Wnn7, and the current maintainer 
;; is OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;;
;; This file is part of Wnn7Egg. (base code is egg.el (eggV3.09))
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

;; Japanese Character Input Package for Egg
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

;; This file is part of Egg on Mule (Multilingal Environment)

;; Egg is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; Egg is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 59 Temple Place - Suite 330, Boston, 
;; MA 02111-1307, USA.

;;;==================================================================
;;;
;;; 日本語環境 「たまご」 第３版    
;;;
;;;=================================================================== 

;;;
;;;「たまご」はネットワークかな漢字変換サーバを利用し、Mule での日本
;;; 語環境を提供するシステムです。「たまご」第２版では Wnn V3 および 
;;; Wnn V4 のかな漢字変換サーバを使用しています。
;;;

;;; 名前は 「沢山/待たせて/ごめんなさい」の各文節の先頭１音である「た」
;;; と「ま」と「ご」を取って、「たまご」と言います。電子技術総合研究所
;;; の錦見 美貴子氏の命名に依るものです。egg は「たまご」の英訳です。

;;;
;;; 使用法は info/egg-jp を見て下さい。
;;;

;;;
;;; 「たまご」に関する提案、虫情報は tomura@etl.go.jp にお送り下さい。
;;;

;;;
;;;                      〒 305 茨城県つくば市梅園1-1-4
;;;                      通産省工業技術院電子技術総合研究所
;;;                      情報アーキテクチャ部言語システム研究室
;;;
;;;                                                     戸村 哲  

;;;
;;; (注意)このファイルは漢字コードを含んでいます。 
;;;
;;;   第３版  １９９１年２月  ４日
;;;   第２版  １９８９年６月  １日
;;;   第１版  １９８８年７月１４日
;;;   暫定版  １９８８年６月２４日

;;;=================================================================== 
;;;
;;; (eval-when (load) (require 'wnn-client))
;;;

(defvar egg-version "3.11 wnn7" "Version number of this version of Egg. ")
;;; Last modified date: Sun Sep 30 00:00:00 2001

;;;;  修正要求リスト

;;;;  read-hiragana-string, read-kanji-string で使用する平仮名入力マップを roma-kana に固定しないで欲しい．

;;;;  修正メモ

;;; 01.9.30 modified by OMRON SOFTWARE Co.,Ltd.
;;; ヘルプモードとリージョン指定の関数名の修正

;;; 01.5.30 modified by OMRON SOFTWARE Co., Ltd.
;;; Wnn7 接続の為の機能追加（入力予測＆連想変換）
;;; XEmacs 使用および egg v3.10 との共存のための一部修正

;;; 95.6.5 modified by S.Tomura <tomura@etl.go.jp>
;;; 変換直後に連続して変換する場合を認識するために、"-in-cont" に関連した
;;; 部分を追加した。（この部分は将来再修正する予定。）

;;; 93.6.19  modified by T.Shingu <shingu@cpr.canon.co.jp>
;;; egg:*in-fence-mode* should be buffer local.

;;; 93.6.4   modified by T.Shingu <shingu@cpr.canon.co.jp>
;;; In its-defrule**, length is called instead of chars-in-string.

;;; 93.3.15  modified by T.Enami <enami@sys.ptg.sony.co.jp>
;;; egg-self-insert-command simulates the original more perfectly.

;;; 92.12.20 modified by S.Tomura <tomura@etl.go.jp>
;;; In its:simulate-input, sref is called instead of aref.

;;; 92.12.20 modified by T.Enami <enami@sys.ptg.sony.co.jp>
;;; egg-self-insert-command calls cancel-undo-boundary to simulate original.

;;; 92.11.4 modified by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
;;; read-hiragana-string sets minibuffer-preprompt correctly.

;;; 92.10.26, 92.10.30 modified by T.Saneto sanewo@pdp.crl.sony.co.jp
;;; typo fixed.

;;; 92.10.18 modified by K. Handa <handa@etl.go.jp>
;;; special-symbol-input 用のテーブルを autoload に。
;;; busyu.el の autoload の指定を mule-init.el から egg.el に移す。

;;;  92.9.20 modified by S. Tomura
;;;; hiragana-region の虫の修正

;;;; 92.9.19 modified by Y. Kawabe
;;;; some typos

;;;; 92.9.19 modified by Y. Kawabe<kawabe@sramhc.sra.co.jp>
;;;; menu の表示関係の lenght を string-width に置き換える．

;;; 92.8.19 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;; menu:select-from-menu calls string-width instead of length.

;;;; 92.8.1 modified by S. Tomura
;;;; internal mode を追加．its:*internal-mode-alist* 追加．

;;;; 92.7.31 modified by S. Tomura
;;;; its-mode-map が super mode map を持つように変更した．これにより 
;;;; mode map が共有できる． its-define-mode, get-next-map などを変更． 
;;;; get-next-map-locally を追加．its-defrule** を変更．

;;;; 92.7.31 modified by S. Tomura
;;;; its:make-kanji-buffer , its:*kanji* 関連コードを削除した．

;;;; 92.7.31 modified by S. Tomura
;;;;  egg:select-window-hook を修正し，minibuffer から exit するときに， 
;;;; 各種変数を default-value に戻すようにした．これによって 
;;;; minibufffer に入る前に各種設定が可能となる．

;;; 92.7.14  modified for Mule Ver.0.9.5 by T.Ito <toshi@his.cpl.melco.co.jp>
;;;	Attribute bold can be used.
;;;	Unnecessary '*' in comments of variables deleted.
;;; 92.7.8   modified for Mule Ver.0.9.5 by Y.Kawabe <kawabe@sra.co.jp>
;;;	special-symbol-input keeps the position selected last.
;;; 92.7.8   modified for Mule Ver.0.9.5 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	busyu-input and kakusuu-input are added in *symbol-input-menu*.
;;; 92.7.7   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	In egg:quit-mode, overwrite-mode is supported correctly.
;;;	egg:*overwrite-mode-deleted-chars* is not used now.
;;; 92.6.26  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Funtion dump-its-mode-map gets obsolete.
;;; 92.6.26  modified for Mule Ver.0.9.5 by M.Shikida <shikida@cs.titech.ac.jp>
;;;	Backquote ` is registered in *hankaku-alist* and *zenkaku-alist*.
;;; 92.6.17  modified for Mule Ver.0.9.5 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	Bug in make-jis-second-level-code-alist fixed.
;;; 92.6.14  modified for Mule Ver.0.9.5 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	menu:select-from-menu is replaced with new version.
;;; 92.5.18  modified for Mule Ver.0.9.4 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	lisp/wnn-egg.el is devided into two parts: this file and wnn*-egg.el.

;;;;
;;;; Mule Ver.0.9.3 以前
;;;;

;;;; April-15-92 for Mule Ver.0.9.3
;;;;	by T.Enami <enami@sys.ptg.sony.co.jp> and K.Handa <handa@etl.go.jp>
;;;;	notify-internal calls 'message' with correct argument.

;;;; April-11-92 for Mule Ver.0.9.3
;;;;	by T.Enami <enami@sys.ptg.sony.co.jp> and K.Handa <handa@etl.go.jp>
;;;;	minibuffer から抜ける時 egg:select-window-hook で egg:*input-mode* を
;;;;	t にする。hook の形を大幅修正。

;;;; April-3-92 for Mule Ver.0.9.2 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;; minibuffer から抜ける時 egg:select-window-hook が new-buffer の
;;;; egg:*mode-on* などを nil にしているのを修正。

;;;; Mar-22-92 by K.Handa
;;;; etags が作る TAGS に不必要なものを入れないようにするため関数名変更
;;;; define-its-mode -> its-define-mode, defrule -> its-defrule

;;;; Mar-16-92 by K.Handa
;;;; global-map への define-key を mule-keymap に変更。

;;;; Mar-13-92 by K.Handa
;;;; Language specific part を japanese.el,... に移した。

;;;; Feb-*-92 by K. Handa
;;;; nemacs 4 では minibuffer-window-selected が廃止になり，関連するコードを削除した．

;;;; Jan-13-92 by S. Tomura
;;;; mc-emacs or nemacs 4 対応作業開始．

;;;; Aug-9-91 by S. Tomura
;;;; ?\^ を ?^ に修正．

;;;;  menu を key map を見るようにする．

;;;;  Jul-6-91 by S. Tomura
;;;;  setsysdict の error メッセージを変更．

;;;;  Jun-11-91 by S. Tomura
;;;;  its:*defrule-verbose* を追加．
;;;;

;;;;  Mar-25-91 by S. Tomura
;;;;  reset-its-mode を廃止

;;;;  Mar-23-91 by S. Tomura
;;;;  read-hiragana-string を修正， read-kanji-string を追加，
;;;;  isearch:read-kanji-string を設定．

;;;;  Mar-22-91 by S. Tomura
;;;;  defrule-conditional, defrule-select-mode-temporally を追加。
;;;;  for-each の簡易版として dolist を追加。
;;;;  enable-double-n-syntax を活用．ほかに use-kuten-for-comma, use-touten-for-period を追加

;;;;  Mar-5-91 by S. Tomura
;;;;  roma-kana-word, henkan-word, roma-kanji-word を追加した．

;;;;  Jan-14-91 by S. Tomura
;;;;  入力文字変換系 ITS(Input character Translation System) を改造する．
;;;;  変換は最左最長変換を行ない，変換のないものはもとのままとなる．
;;;;  改造の動機は立木＠慶応さんのハングル文字の入力要求である．
;;;;  its:* を追加した．また従来 fence-self-insert-command と roma-kana-region 
;;;;  二箇所にわかれていたコードを its:translate-region によって一本化した．

;;;;  July-30-90 by S. Tomura
;;;;  henkan-region をoverwrite-mode に対応させる．変数 
;;;;  egg:*henkan-fence-mode*, egg:*overwrite-mode-deleted-chars*
;;;;  を追加し，henkan-fence-region, henkan-region-internal, 
;;;;  quit-egg-mode を変更する．

;;;;  Mar-4-90 by K.Handa
;;;;  New variable alphabet-mode-indicator, transparent-mode-indicator,
;;;;  and henkan-mode-indicator.

;;;;  Feb-27-90 by enami@ptgd.sony.co.jp
;;;;  menu:select-from-menu で２箇所ある ((and (<= ?0 ch) (<= ch ?9)...
;;;;  の一方を ((and (<= ?0 ch) (<= ch ?9)... に修正

;;;;  Feb-07-89
;;;;  bunsetu-length-henko の中の egg:*attribute-off の位置を KKCP を呼ぶ前に
;;;;  変更する。 wnn-client では KKCP を呼ぶと文節情報が変化する。

;;;;  Feb-01-89
;;;;  henkan-goto-kouho の egg:set-bunsetu-attribute の引数
;;;;  の順番が間違っていたのを修正した。（toshi@isvax.isl.melco.co.jp
;;;;  (Toshiyuki Ito)の指摘による。）

;;;;  Dec-25-89
;;;;  meta-flag t の場合の対応を再修正する。
;;;;  overwrite-mode での undo を改善する。

;;;;  Dec-21-89
;;;;  bug fixed by enami@ptdg.sony.co.jp
;;;;     (fboundp 'minibuffer-window-selected )
;;;;  -->(boundp  'minibuffer-window-selected )
;;;;  self-insert-after-hook を buffer local にして定義を kanji.el へ移動。

;;;;  Dec-15-89
;;;;  kill-all-local-variables の定義を kanji.el へ移動する。

;;;;  Dec-14-89
;;;;  meta-flag t の場合の処理を修正する
;;;;  overwrite-mode に対応する。

;;;;  Dec-12-89
;;;;  egg:*henkan-open*, egg:*henkan-close* を追加。
;;;;  egg:*henkan-attribute* を追加
;;;;  set-egg-fence-mode-format, set-egg-henkan-mode-format を追加

;;;;  Dec-12-89
;;;;  *bunpo-code* に 1000: "その他" を追加

;;;;  Dec-11-89
;;;;  egg:*fence-attribute* を新設
;;;;  egg:*bunsetu-attribute* を新設

;;;;  Dec-11-89
;;;;  attribute-*-region を利用するように変更する。
;;;;  menu:make-selection-list は width が小さい時にloop する。これを修正した。

;;;;  Dec-10-89
;;;;  set-marker-type を利用する方式に変更。

;;;;  Dec-07-89
;;;;  egg:search-path を追加。
;;;;  egg-default-startup-file を追加する。

;;;;  Nov-22-89
;;;;  egg-startup-file を追加する。
;;;;  eggrc-search-path を egg-startup-file-search-path に名前変更。

;;;;  Nov-21-89
;;;;  Nemacs 3.2 に対応する。kanji-load* を廃止する。
;;;;  wnnfns.c に対応した修正を加える。
;;;;  *Notification* buffer を見えなくする。

;;;;  Oct-2-89
;;;;  *zenkaku-alist* の 文字定数の書き方が間違っていた。

;;;;  Sep-19-89
;;;;  toggle-egg-mode の修正（kanji-flag）
;;;;  egg-self-insert-command の修正 （kanji-flag）

;;;;  Sep-18-89
;;;;  self-insert-after-hook の追加

;;;;  Sep-15-89
;;;;  EGG:open-wnn bug fix
;;;;  provide wnn-egg feature

;;;;  Sep-13-89
;;;;  henkan-kakutei-before-point を修正した。
;;;;  enter-fence-mode の追加。
;;;;  egg-exit-hook の追加。
;;;;  henkan-region-internal の追加。henkan-regionは point をmark する。
;;;;  eggrc-search-path の追加。

;;;;  Aug-30-89
;;;;  kanji-kanji-1st を訂正した。

;;;;  May-30-89
;;;;  EGG:open-wnn は get-wnn-host-name が nil の場合、(system-name) を使用する。

;;;;  May-9-89
;;;;  KKCP:make-directory added.
;;;;  KKCP:file-access bug fixed.
;;;;  set-default-usr-dic-directory modified.

;;;;  Mar-16-89
;;;;  minibuffer-window-selected を使って minibuffer の egg-mode表示機能追加

;;;;  Mar-13-89
;;;;   mode-line-format changed. 

;;;;  Feb-27-89
;;;;  henkan-saishou-bunsetu added
;;;;  henkan-saichou-bunsetu added
;;;;  M-<    henkan-saishou-bunsetu
;;;;  M->    henkan-saichou-bunsetu

;;;;  Feb-14-89
;;;;   C-h in henkan mode: help-command added

;;;;  Feb-7-89
;;;;   egg-insert-after-hook is added.

;;;;   M-h   fence-hiragana
;;;;   M-k   fence-katakana
;;;;   M->   fence-zenkaku
;;;;   M-<   fence-hankaku

;;;;  Dec-19-88 henkan-hiragana, henkan-katakaraを追加：
;;;;    M-h     henkan-hiragana
;;;;    M-k     henkan-katakana

;;;;  Ver. 2.00 kana2kanji.c を使わず wnn-client.el を使用するように変更。
;;;;            関連して一部関数を変更

;;;;  Dec-2-88 special-symbol-input を追加；
;;;;    C-^   special-symbol-input

;;;;  Nov-18-88 henkan-mode-map 一部変更；
;;;;    M-i  henkan-inspect-bunsetu
;;;;    M-s  henkan-select-kouho
;;;;    C-g  henkan-quit

;;;;  Nov-18-88 jserver-henkan-kakutei の仕様変更に伴い、kakutei のコー
;;;;  ドを変更した。

;;;;  Nov-17-88 kakutei-before-point で point 以降の間違った部分の変換
;;;;  が頻度情報に登録されないように修正した。これにはKKCC:henkan-end 
;;;;  の一部仕様と対応するkana2kanji.cも変更した。

;;;;  Nov-17-88 henkan-inspect-bunsetu を追加した。

;;;;  Nov-17-88 新しい kana2kanji.c に変更する。

;;;;  Sep-28-88 defruleが値としてnilを返すように変更した。

;;;;  Aug-25-88 変換学習を正しく行なうように変更した。
;;;;  KKCP:henkan-kakuteiはKKCP:jikouho-listを呼んだ文節に対してのみ適
;;;;  用でき、それ以外の場合の結果は保証されない。この条件を満たすよう
;;;;  にKKCP:jikouho-listを呼んでいない文節に対しては
;;;;  KKCP:henkan-kakuteiを呼ばないようにした。

;;;;  Aug-25-88 egg:do-auto-fill を修正し、複数行にわたるauto-fillを正
;;;;  しく行なうように修正した。

;;;;  Aug-25-88 menu commandに\C-l: redraw を追加した。

;;;;  Aug-25-88 toroku-regionで登録する文字列からno graphic characterを
;;;;  自動的に除くことにした。

(eval-when-compile (require 'wnn7egg-jsymbol))

;;;----------------------------------------------------------------------
;;;
;;; Utilities
;;;
;;;----------------------------------------------------------------------

;;; 
;;;;

(if (and (featurep 'xemacs)
	 (not (fboundp 'overlayp)))
    (require 'overlay))

(if (not (featurep 'xemacs))
    (defun characterp (form)
      (numberp form))
  ;; 97.2.4 Created by J.Hein to simulate Mule-2.3
  (defun egg-read-event ()
    "FSFmacs event emulator that shoves non key events into
unread-command-events to facilitate translation from Mule-2.3"
    (let ((event (make-event))
	  ch key)
      (next-command-event event)
      (setq key (event-key event))
      (if (and (key-press-event-p event) 
	       (not (event-matches-key-specifier-p event 'backspace)))
	  (if (eq 0 (event-modifier-bits event))
	      (setq ch (or (event-to-character event) key))
	    (if (eq 1 (event-modifier-bits event))
		(setq ch
		      (if (characterp key)
			  (or (int-to-char (- (char-to-int key) 96))
			      (int-to-char (- (char-to-int key) 64)))
			(event-to-character event)))
	      (setq unread-command-events (list event))))
	(setq unread-command-events (list event)))
      ch)))

(defun coerce-string (form)
  (cond((stringp form) form)
       ((characterp form) (char-to-string form))))

(defun coerce-internal-string (form)
  (cond((stringp form)
	(if (= (length form) 1) 
	    (string-to-char form)
	  form))
       ((characterp form) form)))

;;; kill-all-local-variables から保護する local variables を指定できる
;;; ように変更する。
(put 'egg:*input-mode* 'permanent-local t)
(put 'egg:*mode-on* 'permanent-local t)
(put 'its:*current-map* 'permanent-local t)
(put 'mode-line-egg-mode 'permanent-local t)

;; undo functions.
(make-variable-buffer-local
 (defvar egg-buffer-undo-list nil))
(make-variable-buffer-local
 (defvar egg-buffer-modified-flag nil))

(defun suspend-undo ()
  (setq egg-buffer-undo-list buffer-undo-list
	egg-buffer-modified-flag (buffer-modified-p)))

(defun resume-undo-list ()
  (setq buffer-undo-list egg-buffer-undo-list)
  (if (not egg-buffer-modified-flag)
      (let ((time (visited-file-modtime)))
	(if (eq time 0) (setq time '(0 . 0)))
	(set 'buffer-undo-list
	     (cons (cons t time)
		   buffer-undo-list)))))

;;;----------------------------------------------------------------------
;;;
;;; 16進表現のJIS 漢字コードを minibuffer から読み込む
;;;
;;;----------------------------------------------------------------------

;;;
;;; User entry:  jis-code-input
;;;

(defun jis-code-input ()
  (interactive)
  (insert-jis-code-from-minibuffer "JIS 漢字コード(16進数表現): "))

(defun insert-jis-code-from-minibuffer (prompt)
  (let ((str (read-from-minibuffer prompt)) val)
    (while (null (setq val (read-jis-code-from-string str)))
      (beep)
      (setq str (read-from-minibuffer prompt str)))
    (if (featurep 'xemacs)
	(insert (make-char (find-charset 'japanese-jisx0208) (car val) (cdr val)))
      (insert (make-char 'japanese-jisx0208 (car val) (cdr val))))))

(defun hexadigit-value (ch)
  (cond((and (<= ?0 ch) (<= ch ?9))
	(- ch ?0))
       ((and (<= ?a ch) (<= ch ?f))
	(+ (- ch ?a) 10))
       ((and (<= ?A ch) (<= ch ?F))
	(+ (- ch ?A) 10))))

(defun read-jis-code-from-string (str)
  (if (and (= (length str) 4)
	   (<= 2 (hexadigit-value (aref str 0)))
	   (hexadigit-value (aref str 1))
	   (<= 2 (hexadigit-value (aref str 2)))
	   (hexadigit-value (aref str 3)))
  (cons (+ (* 16 (hexadigit-value (aref str 0)))
	       (hexadigit-value (aref str 1)))
	(+ (* 16 (hexadigit-value (aref str 2)))
	   (hexadigit-value (aref str 3))))))

;;;----------------------------------------------------------------------
;;;
;;; 「たまご」 Notification System
;;;
;;;----------------------------------------------------------------------

(defconst *notification-window* " *Notification* ")

;;;(defmacro notify (str &rest args)
;;;  (list 'notify-internal
;;;	(cons 'format (cons str args))))

(defun notify (str &rest args)
  (notify-internal (apply 'format (cons str args))))

(defun notify-internal (message &optional noerase)
  (save-excursion
    (set-buffer (get-buffer-create *notification-window*))
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (substring (current-time-string) 4 19) ":: " message ?\n )
    (setq buffer-read-only t)
    (save-window-excursion
      (bury-buffer (current-buffer))))
  (message "%s" message)		; 92.4.15 by T.Enami
  (if noerase
      nil
    (let ((focus-follows-mouse t))
      (sleep-for 1))
    (message "")))

;;;(defmacro notify-yes-or-no-p (str &rest args)
;;;  (list 'notify-yes-or-no-p-internal 
;;;	(cons 'format (cons str args))))

(defun notify-yes-or-no-p (str &rest args)
  (notify-yes-or-no-p-internal (apply 'format (cons str args))))

(defun notify-yes-or-no-p-internal (message)
  (save-window-excursion
    (pop-to-buffer *notification-window*)
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (substring (current-time-string) 4 19) ":: " message ?\n )
    (setq buffer-read-only t)
    (yes-or-no-p "いいですか？")))

(defun notify-y-or-n-p (str &rest args)
  (notify-y-or-n-p-internal (apply 'format (cons str args))))

(defun notify-y-or-n-p-internal (message)
  (save-window-excursion
    (pop-to-buffer *notification-window*)
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (substring (current-time-string) 4 19) ":: " message ?\n )
    (setq buffer-read-only t)
    (y-or-n-p "いいですか？")))

(defun select-notification ()
  (interactive)
  (pop-to-buffer *notification-window*)
  (setq buffer-read-only t))

;;;----------------------------------------------------------------------
;;;
;;; Minibuffer Menu System
;;;
;;;----------------------------------------------------------------------

;;; user-customizable variables
(defvar menu:*display-item-value* nil
  "*Non-nil means values of items are displayed in minibuffer menu")

;;; The following will be localized, added only to pacify the compiler.
(defvar menu:*cur-menu*)
(defvar menu:*cur-selection*)
(defvar menu:*cur-selections*)
(defvar menu:*cur-element-no*)
(defvar menu:*cur-selection-no*)
(defvar menu:*cur-element-points*)
(defvar menu:*menu-stack*)

(defvar minibuffer-local-menu-map (make-sparse-keymap))
(if (featurep 'xemacs)
    (set-keymap-default-binding minibuffer-local-menu-map 'undefined))

(mapcar
 (lambda (elem)
   (define-key minibuffer-local-menu-map
     (car elem) (intern (format "menu:%s" (cdr elem)))))
 '(
   (" "		. next-element)
   ("\C-a"	. beginning-of-selection)
   ("\C-b"	. previous-element)
   ("\C-d"	. previous-element)
   ("\C-e"	. end-of-selection)
   ("\C-f"	. next-element)
   ("\C-g"	. quit)
   ("\C-h"	. previous-element)
   ("\C-i"	. next-element)
   ("\C-j"	. select)
   ("\C-l"	. refresh)
   ("\C-m"	. select)
   ("\C-n"	. next-selection)
   ("\C-p"	. previous-selection)
   ([backspace]	. previous-element)
   ([clear]	. quit)
   ([delete]	. previous-element)
   ([down]	. next-selection)
   ([kp-down]	. next-selection)
   ([kp-enter]	. select)
   ([kp-left]	. previous-element)
   ([kp-right]	. next-element)
   ([kp-tab]	. next-element)
   ([kp-up]	. previous-selection)
   ([left]	. previous-element)
   ([next]	. next-selection)
   ([prior]	. previous-selection)
   ([return]	. select)
   ([right]	. next-element)
   ([tab]	. next-element)
   ([up]	. previous-selection)
   ))

;;; 0 .. 9 A .. Z a .. z  and kp
(if (featurep 'xemacs)
    (progn
      (mapcar
       (lambda (char)
	 (define-key minibuffer-local-menu-map (char-to-string char)
	   'menu:goto-nth-element))
       "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")

      ;; kp-0 .. kp-9
      (mapcar
       (lambda (key)
	 (define-key minibuffer-local-menu-map key 'menu:goto-nth-element))
       (list [kp-0] [kp-1] [kp-2] [kp-3] [kp-4] [kp-5] [kp-6] [kp-7] [kp-8] [kp-9])))
  (mapcar
   (lambda (char)
     (define-key minibuffer-local-menu-map (vector char)
       'menu:goto-nth-element))
   "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"))

;;;
;;; predicates and selectors for menu
;;;
;; <menu> ::= ( menu <prompt string> <items> )
;; <items> ::= ( <item> ... )
;; <item> ::= ( <string> . <value> ) | <string>
;;         |  ( <char>   . <value> ) | <char>
;; <value> :: = <menu> | <other object>
;;
(defun menu:menup (value)
  (and (listp value)
       (eq (car value) 'menu)))

(defun menu:menu-prompt (&optional menu)
  (car (cdr (or menu menu:*cur-menu*))))

(defun menu:menu-items (&optional menu)
  (car (cdr (cdr (or menu menu:*cur-menu*)))))

(defun menu:menu-nth-item (n &optional menu)
  (nth n (menu:menu-items menu)))

(defun menu:item-string (item)
  (cond ((stringp item) item)
	((characterp item) (char-to-string item))
	((consp item)
	 (let ((str (cond ((stringp (car item)) (car item))
			  ((characterp (car item)) (char-to-string (car item)))
			  (t ""))))
	   (if menu:*display-item-value*
	       (format "%s [%s]" str (cdr item))
	     str)))
	(t "")))

(defun menu:item-value (item)
  (cond ((stringp item) item)
	((characterp item) (char-to-string item))
	((consp item) (cdr item))
	(t "")))

(defun menu:select-submenu (submenu)
  "Save the current selection state, and select a new menu."
  (setq menu:*menu-stack*
	(cons (list menu:*cur-selection* menu:*cur-selections*
		    menu:*cur-element-no* menu:*cur-selection-no*
		    menu:*cur-menu* menu:*cur-element-points*)
	      menu:*menu-stack*))
  (setq menu:*cur-menu* submenu))

(defun menu:select-saved-menu ()
  "Restore the most recently stored selection state."
  (let ((save (car menu:*menu-stack*)))
    (setq menu:*menu-stack*
	  (cdr menu:*menu-stack*))
    (setq menu:*cur-selection*		(nth 0 save);92.10.26 by T.Saneto
	  menu:*cur-selections*		(nth 1 save)
	  menu:*cur-element-no*		(nth 2 save)
	  menu:*cur-selection-no*	(nth 3 save)
	  menu:*cur-menu*		(nth 4 save)
	  menu:*cur-element-points*	(nth 5 save))))

;;;
;;; constructors and selector for selection
;;;
;; <selection> ::= ( <pos> . <elements> )
;;	<pos> ... integer that means the absolute position in menu items
;; <elements> ::= ( <element string> ... )
;;
(defsubst menu:make-selection (pos elements)
  (cons pos elements))

(defsubst menu:selection-pos (&optional selection)
  (car (or selection menu:*cur-selection*)))

(defsubst menu:selection-elements (&optional selection)
  (cdr (or selection menu:*cur-selection*)))

(defsubst menu:selection-nth-element (&optional n selection)
  (nth (or n menu:*cur-element-no*)
       (menu:selection-elements selection)))

(defsubst menu:selection-element-length (&optional selection)
  (length (menu:selection-elements selection)))

(defun menu:make-selections (items width)
  "Make selection list from ITEMS so that each selection can fit with WIDTH."
  (let ((headpos 0) (pos 0) (size 0)
	revselections revelems
	item-string item-width)
    (while items
      (setq item-string (menu:item-string (car items)))
      (setq item-width (string-width item-string))
      ;;; 92.9.19 by Y. Kawabe
      (cond ((and revelems (<= width (+ size 4 item-width)))
	     (setq revselections
		   (cons (menu:make-selection headpos (nreverse revelems))
			 revselections))
	     (setq revelems nil)
	     (setq size 0)
	     (setq headpos pos))
	    ((or (null (cdr items)) (<= width (+ size 4 item-width)))
	     (setq revselections
		   (cons
		    (menu:make-selection
		     headpos (nreverse (cons item-string revelems)))
		    revselections))
	     (setq size 0)
	     (setq headpos pos)
	     (setq items (cdr items))
	     (setq pos (1+ pos)))
	    (t
	     ;;; 92.9.19 by Y. Kawabe
	     (setq revelems (cons item-string revelems))
	     (setq size (+ size 4 item-width))
	     (setq items (cdr items))
	     (setq pos (1+ pos)))))
    (nreverse revselections)))

(defun menu:setup-selections (window-width initpos)
  (setq menu:*cur-selections*
	(menu:make-selections (menu:menu-items)
			      (- window-width
				 ;;; 92.8.19 by K.Handa
				 (string-width
				  (menu:menu-prompt)))))
  (if initpos
      (let ((selections menu:*cur-selections*))
	(setq menu:*cur-selection-no* 0)
	(while (and (cdr selections)
		    (< (menu:selection-pos (car (cdr selections)))
		       initpos))
	  (setq menu:*cur-selection-no* (1+ menu:*cur-selection-no*))
	  (setq selections (cdr selections)))
	(setq menu:*cur-element-no*
	      (- initpos (menu:selection-pos (car selections)))))))

;;; utility
(defun menu:check-number-range (i min max)
  (cond ((eq i 'max) max)
	((eq i 'min) min)
	((< i min) max)
        ((< max i) min)
        (t i)))

;;;
;;; main part of menu
;;;
(defun menu:select-from-menu (menu &optional initial position)
  "Display menu in minibuffer and return the selected value.
If INITIAL is non-nil integer list, it behaves as menu is selected 
using the path specified by INITIAL in advance.
If POSITION is non-nil value, return value is a pair of the selected
value and the chosen path (represented by an integer list)."
  (let ((menu:*cur-menu* menu)
	(menu:*window-width* (window-width (minibuffer-window)))
	menu:*cur-selection* menu:*cur-selections*
	menu:*cur-element-no*
	menu:*cur-selection-no*
	menu:*cur-element-points*
	menu:*menu-stack* menu:*select-positions*
	(pos 0) value finished)
    (if initial
	(progn
	  (if (numberp initial)
	      (setq initial (list initial)))
	  (while (cdr initial)
	    (setq value (menu:item-value (menu:menu-nth-item (car initial))))
	    (if (menu:menup value)
		(progn
		  (menu:setup-selections menu:*window-width* (car initial))
		  (menu:select-submenu value)))
	    (setq menu:*select-positions*
		  (cons (car initial) menu:*select-positions*))
	    (setq initial (cdr initial)))
	  (setq pos (car initial))))
    (while (not finished)
      (menu:setup-selections menu:*window-width* pos)
      (add-hook 'minibuffer-setup-hook 'menu:minibuffer-setup)
      (unwind-protect
	  (setq pos (read-from-minibuffer "" nil minibuffer-local-menu-map
					  t 'menu:*select-positions*))
	(remove-hook 'minibuffer-setup-hook 'menu:minibuffer-setup)
	(if quit-flag
	    (setq pos nil
		  quit-flag nil)))
      (cond (pos			; element selected
	     (setcar menu:*select-positions* pos)
	     (setq value (menu:item-value (menu:menu-nth-item pos)))
	     (if (menu:menup value)
		 (progn (menu:select-submenu value)
			(setq pos 0))
	       (setq finished t)))
	    (menu:*menu-stack*		; quit (restore menu)
	     (if (not (car menu:*select-positions*))
		 (setq menu:*select-positions* (cdr menu:*select-positions*)))
	     (setq menu:*select-positions* (cdr menu:*select-positions*))
	     (menu:select-saved-menu))
	    (t				; really quit
	     (setq quit-flag t)
	     (setq menu:*select-positions* nil)
	     (setq finished t))))
    (if position
	(cons value (nreverse menu:*select-positions*))
      value)))

(defalias 'menu:minibuffer-setup 'menu:goto-selection)

(defun menu:goto-selection (&optional sel-no elem-no)
  (setq menu:*cur-selection-no*
	(menu:check-number-range (or sel-no menu:*cur-selection-no*)
				 0 (1- (length menu:*cur-selections*))))
  (setq menu:*cur-selection*
	(nth menu:*cur-selection-no* menu:*cur-selections*))
  (erase-buffer)
  (insert (menu:menu-prompt))
  (let ((elements (menu:selection-elements))
	(i 0)
	revpoints)
    (while elements
      (setq revpoints (cons (+ (point) 2) revpoints))
      (insert (if (<= i 9) (format "  %d." i)
		(format "  %c." (+ (- i 10) ?a)))
	      (car elements))
      (setq elements (cdr elements)
	    i (1+ i)))
    (setq menu:*cur-element-points* (nreverse revpoints)))
  (menu:goto-element elem-no))

(defun menu:goto-element (&optional elem-no)
  (setq menu:*cur-element-no*
	(menu:check-number-range (or elem-no menu:*cur-element-no*)
				 0 (1- (menu:selection-element-length))))
  (goto-char (nth menu:*cur-element-no* menu:*cur-element-points*)))

(defun menu:beginning-of-selection ()
  (interactive)
  (menu:goto-element 0))

(defun menu:end-of-selection ()
  (interactive)
  (menu:goto-element (1- (menu:selection-element-length))))

(defun menu:next-selection ()
  (interactive)
  (menu:goto-selection (1+ menu:*cur-selection-no*)))

(defun menu:previous-selection ()
  (interactive)
  (menu:goto-selection (1- menu:*cur-selection-no*)))

(defun menu:next-element ()
  (interactive)
  (if (< menu:*cur-element-no* (1- (menu:selection-element-length)))
      (menu:goto-element (1+ menu:*cur-element-no*))
    (menu:goto-selection (1+ menu:*cur-selection-no*) 0)))

(defun menu:previous-element ()
  (interactive)
  (if (< 0 menu:*cur-element-no*)
      (menu:goto-element (1- menu:*cur-element-no*))
    (menu:goto-selection (1- menu:*cur-selection-no*) 'max)))

(defun menu:goto-nth-element ()
  (interactive)
  (let ((ch (if (featurep 'xemacs)
		(event-to-character last-command-event)
	      (if (integerp last-command-event)
		  last-command-event
		(get last-command-event 'ascii-character))))
	(elem-no-max (1- (menu:selection-element-length))))
    (if ch
	(cond
	 ((and (<= ?0 ch) (<= ch ?9)
	       (<= ch (+ ?0 elem-no-max)))
	  (menu:goto-element (- ch ?0)))
	 ((and (<= ?a ch) (<= ch ?z)
	       (<= (+ 10 ch) (+ ?a elem-no-max)))
	  (menu:goto-element (+ 10 (- ch ?a))))
	 ((and (<= ?A ch) (<= ch ?Z)
	       (<= (+ 10 ch) (+ ?A elem-no-max)))
	  (menu:goto-element (+ 10 (- ch ?A))))))))

(defun menu:refresh ()
  (interactive)
  (menu:goto-selection))

(defun menu:select ()
  (interactive)
  (erase-buffer)
  (prin1 (+ (menu:selection-pos) menu:*cur-element-no*) (current-buffer))
  (exit-minibuffer))

(defun menu:quit ()
  (interactive)
  (erase-buffer)
  (prin1 nil (current-buffer))
  (exit-minibuffer))

;;;----------------------------------------------------------------------
;;;
;;;  一括型変換機能
;;;
;;;----------------------------------------------------------------------

;;;
;;; ひらがな変換
;;;

(defun hiragana-paragraph ()
  "hiragana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (japanese-hiragana-region (point) end))))

(defun hiragana-sentence ()
  "hiragana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (japanese-hiragana-region (point) end))))

;;;
;;; カタカナ変換
;;;

(defun katakana-paragraph ()
  "katakana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (japanese-katakana-region (point) end))))

(defun katakana-sentence ()
  "katakana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (japanese-katakana-region (point) end))))

;;;
;;; 半角変換
;;; 

(defun hankaku-paragraph ()
  "hankaku  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (japanese-hankaku-region (point) end 'ascii-only))))

(defun hankaku-sentence ()
  "hankaku  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (japanese-hankaku-region (point) end 'ascii-only))))

(defun hankaku-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (japanese-hankaku-region start (point) 'ascii-only)))

;;;
;;; 全角変換
;;;

(defun zenkaku-paragraph ()
  "zenkaku  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (japanese-zenkaku-region (point) end))))

(defun zenkaku-sentence ()
  "zenkaku  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (japanese-zenkaku-region (point) end))))

(defun zenkaku-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (japanese-zenkaku-region start (point))))

;;;
;;; ローマ字かな変換
;;;

(defun roma-kana-region (start end )
  (interactive "r")
  (its:translate-region start end nil (its:get-mode-map "roma-kana")))

(defun roma-kana-paragraph ()
  "roma-kana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (roma-kana-region (point) end ))))

(defun roma-kana-sentence ()
  "roma-kana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (roma-kana-region (point) end ))))

(defun roma-kana-word ()
  "roma-kana word at or after point."
  (interactive)
  (save-excursion
    (re-search-backward "\\b\\w" nil t)
    (let ((start (point)))
      (re-search-forward "\\w\\b" nil t)
      (roma-kana-region start (point)))))

;;;
;;; ローマ字漢字変換
;;;

(defun roma-kanji-region (start end)
  (interactive "r")
  (roma-kana-region start end)
  (save-restriction
    (narrow-to-region start (point))
    (goto-char (point-min))
    (replace-regexp "\\(　\\| \\)" "")
    (goto-char (point-max)))
  (if (wnn7-p)
      (wnn7-henkan-region-internal start (point))
    (henkan-region-internal start (point))))

(defun roma-kanji-paragraph ()
  "roma-kanji  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (roma-kanji-region (point) end ))))

(defun roma-kanji-sentence ()
  "roma-kanji  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (roma-kanji-region (point) end ))))

(defun roma-kanji-word ()
  "roma-kanji word at or after point."
  (interactive)
  (save-excursion
    (re-search-backward "\\b\\w" nil t)
    (let ((start (point)))
      (re-search-forward "\\w\\b" nil t)
      (roma-kanji-region start (point)))))


;;;----------------------------------------------------------------------
;;;
;;; 「たまご」入力文字変換系 ITS
;;; 
;;;----------------------------------------------------------------------

(defun egg:member (elt list)
  (while (not (or (null list) (equal elt (car list))))
    (setq list (cdr list)))
  list)

;;;
;;; Mode name --> map
;;;
;;; ITS mode name: string

(defvar its:*mode-alist* nil)
(defvar its:*internal-mode-alist* nil)

(defun its:get-mode-map (name)
  (let ((map-pair (or (assoc name its:*mode-alist*)
		      (assoc name its:*internal-mode-alist*))))
    (cond ((null (cdr map-pair)) nil)
	  ((stringp (cdr map-pair))
	   (let ((file (cdr map-pair)) (map its:*mode-alist*))
	     (while map
	       (if (and (stringp (cdar map))
			(string= (cdar map) file))
		   (setcdr (car map) nil))
	       (setq map (cdr map)))
	     (load file)
	     (cdr (assoc name its:*mode-alist*))))
	  (t (cdr map-pair)))))

(defun its:set-mode-map (name map &optional internalp)
  (let ((place (assoc name 
		      (if internalp its:*internal-mode-alist*
			its:*mode-alist*))))
    (if place (let ((mapplace (cdr place)))
		(if mapplace
		    (progn (setcar mapplace (car map))
			   (setcdr mapplace (cdr map)))
		  ;; map を分解して cons する必要があるのかどうか
		  ;; 分からないが上と同じようにしている．katsuya
		  (setcdr place (cons (car map) (cdr map)))))
      (setq place (cons name map))
      (if internalp
	  (setq its:*internal-mode-alist*
		(append its:*internal-mode-alist* (list place)))
	(setq its:*mode-alist*
	      (append its:*mode-alist* (list place)))))))

;;;
;;; ITS mode indicators
;;; Mode name --> indicator
;;;

(defun its:get-mode-indicator (name)
  (let ((map (its:get-mode-map name)))
    (if map (map-indicator map)
      name)))

(defun its:set-mode-indicator (name indicator)
  (let ((map (its:get-mode-map name)))
    (if map
	(map-set-indicator map indicator)
      (its-define-mode name indicator))))

;;;
;;; ITS mode declaration
;;;

(defvar its:*processing-map* nil)

(defun its-define-mode (name &optional indicator reset supers internalp) 
  "its-mode NAME を定義選択する．他の its-mode が選択されるまでは 
its-defrule などは NAME に対して規則を追加する．INDICATOR が non-nil 
の時には its-mode NAME を選択すると mode-line に表示される．RESET が 
non-nil の時には its-mode の定義が空になる．SUPERS は上位の its-mode 
名をリストで指定する．INTERNALP は mode name を内部名とする．
its-defrule, its-defrule-conditional, defule-select-mode-temporally を
参照"

  (if (null(its:get-mode-map name))
      (progn 
	(setq its:*processing-map* 
	      (make-map nil (or indicator name) nil (mapcar 'its:get-mode-map supers)))
	(its:set-mode-map name its:*processing-map* internalp)
	)
    (progn (setq its:*processing-map* (its:get-mode-map name))
	   (if indicator
	       (map-set-indicator its:*processing-map* indicator))
	   (if reset
	       (progn
		 (map-set-state its:*processing-map* nil)
		 (map-set-alist its:*processing-map* nil)
		 ))
	   (if supers
	       (progn
		 (map-set-supers its:*processing-map* (mapcar 'its:get-mode-map supers))))))
  nil)

(defun its-autoload-mode-map (name file)
  (setq its:*mode-alist*
	(append its:*mode-alist* (list (cons name file)))))

;;;
;;; defrule related utilities
;;;

(put 'for-each 'lisp-indent-hook 1)

(defmacro for-each (vars &rest body)
  "(for-each ((VAR1 LIST1) ... (VARn LISTn)) . BODY) は変数 VAR1 の値
をリスト LIST1 の要素に束縛し，．．．変数 VARn の値をリスト LISTn の要
素に束縛して BODY を実行する．"

  (for-each* vars (cons 'progn body)))

(defun for-each* (vars body)
  (cond((null vars) body)
       (t (let((tvar (make-symbol "temp"))
	       (var  (car (car vars)))
	       (val  (car (cdr (car vars)))))
	    (list 'let (list (list tvar val)
			     var)
		  (list 'while tvar
			(list 'setq var (list 'car tvar))
			(for-each* (cdr vars) body)
			(list 'setq tvar (list 'cdr tvar))))))))
			     
(eval-when-compile (require 'cl)) ;; dolist

;;;
;;; defrule
;;; 

(defun its:make-standard-action (output next)
  "OUTPUT と NEXT からなる standard-action を作る．"

  (if (and (stringp output) (string-equal output ""))
      (setq output nil))
  (if (and (stringp next)   (string-equal next   ""))
      (setq next nil))
  (cond((null output)
	(cond ((null next) nil)
	      (t (list nil next))))
       ((consp output)
	;;; alternative output
	(list (cons 0 output) next))
       ((null next) output)
       (t
	(list output next))))

(defun its:standard-actionp (action)
  "ACITION が standard-action であるかどうかを判定する．"
  (or (stringp action)
      (and (consp action)
	   (or (stringp (car action))
	       (and (consp (car action))
		    (characterp (car (car action))))
	       (null (car action)))
	   (or (null (car (cdr action)))
	       (stringp (car (cdr action)))))))

(defvar its:make-terminal-state 'its:default-make-terminal-state 
  "終端の状態での表示を作成する関数を指定する. 関数は map input
action state を引数として呼ばれ，状態表示の文字列を返す．")

(defun its:default-make-terminal-state (map input action state)
  (cond(state state)
       (t input)))

(defun its:make-terminal-state-hangul (map input action state)
  (cond((its:standard-actionp action) (action-output action))
       (t nil)))

(defvar its:make-non-terminal-state 'its:default-make-standard-non-terminal-state
  "非終端の状態での表示を作成する関数を指定する．関数は map input を
引数として呼ばれ，状態表示の文字列を返す" )

(defun its:default-make-standard-non-terminal-state (map input)
  " ****"
  (concat
   (map-state-string map)
   (char-to-string (aref input (1- (length input))))))

(defun its-defrule (input output &optional next state map) 

  "INPUT が入力されると OUTPUT に変換する．NEXT が nil でないときは変
換した後に NEXT が入力されたように変換を続ける．INPUTが入力された時点
で変換が確定していない時は STATE をフェンス上に表示する．変換が確定し
ていない時に表示する文字列は変数 its:make-terminal-state および 変数 
its:make-non-terminal-state に指示された関数によって生成される．変換規
則は MAP で指定された変換表に登録される．MAP が nil の場合はもっとも最
近に its-define-mode された変換表に登録される．なお OUTPUT が nil の場
合は INPUT に対する変換規則が削除される．"

  (its-defrule* input
    (its:make-standard-action output next) state 
    (if (stringp map) map
      its:*processing-map*)))

(defmacro its-defrule-conditional (input &rest conds)
  "(its-defrule-conditional INPUT ((COND1 OUTPUT1) ... (CONDn OUTPUTn)))は 
INPUT が入力された時に条件 CONDi を順次調べ，成立した時には OUTPUTi を
出力する．"
  (list 'its-defrule* input (list 'quote (cons 'cond conds))))

(defmacro its-defrule-conditional* (input state map &rest conds)
  "(its-defrule-conditional INPUT STATE MAP ((COND1 OUTPUT1) ... (CONDn
OUTPUTn)))は INPUT が入力された時に状態 STATE を表示し，条件 CONDi を
順次調べ，成立した時には OUTPUTi を出力する．"
  (list 'its-defrule* input (list 'quote (cons 'cond conds)) state map))

(defun its-defrule-select-mode-temporally (input name)
  "INPUT が入力されると temporally-mode として NAME が選択される．"

  (its-defrule* input (list 'quote (list 'its:select-mode-temporally name))))

(defun its-defrule* (input action &optional state map)
  (its:resize (length input))
  (setq map (cond((stringp map) (its:get-mode-map map))
		 ((null map) its:*processing-map*)
		 (t map)))
  (its-defrule** 0 input action state map)
  map)

(defvar its:*defrule-verbose* t "nilの場合, its-defrule の警告を抑制する")

(defun its-defrule** (i input action state map)
  (cond((= (length input) i)		;93.6.4 by T.Shingu
	(map-set-state
	 map 
	 (coerce-internal-string 
	  (funcall its:make-terminal-state map input action state)))
	(if (and its:*defrule-verbose* (map-action map))
	    (if action
		(notify "(its-defrule \"%s\" \"%s\" ) を再定義しました．"
			input action)
	      (notify "(its-defrule \"%s\" \"%s\" )を削除しました．"
		      input (map-action map))))
	(if (and (null action) (map-terminalp map)) nil
	  (progn (map-set-action map action)
		 map)))
       (t
	(if (featurep 'xemacs)
	    (let((newmap
		  (or (get-next-map-locally map (aref input i))
		      (make-map (funcall its:make-non-terminal-state
					 map
					 (substring input 0 (+ i (char-bytes (aref input i)))))))))
	      (set-next-map map (aref input i) 
			    (its-defrule** (+ i (char-bytes (aref input i))) input action state newmap)))
	  (let((newmap
		(or (get-next-map-locally map (aref input i))
		    (make-map (funcall its:make-non-terminal-state
				       map
				       (substring input 0 (1+ i)))))))
	    (set-next-map map (aref input i) 
			  (its-defrule** (1+ i) input action state newmap))))
	(if (and (null (map-action map))
		 (map-terminalp map))
	    nil
	  map))))

;;;
;;; map: 
;;;
;;; <map-alist> ::= ( ( <char> . <map> ) ... )
;;; <topmap> ::= ( nil <indicator> <map-alist>  <supers> )
;;; <supers> ::= ( <topmap> .... )
;;; <map>    ::= ( <state> <action>    <map-alist> )
;;; <action> ::= <output> | ( <output> <next> ) ....

(defun make-map (&optional state action alist supers)
  (list state action alist supers))

(defun map-topmap-p (map)
  (null (map-state map)))

(defun map-supers (map)
  (nth 3 map))

(defun map-set-supers (map val)
  (setcar (nthcdr 3 map) val))

(defun map-terminalp (map)
  (null (map-alist map)))

(defun map-state (map)
  (nth 0 map))

(defun map-state-string (map)
  (coerce-string (map-state map)))

(defun map-set-state (map val)
  (setcar (nthcdr 0 map) val))

(defun map-indicator (map)
  (map-action map))
(defun map-set-indicator (map indicator)
  (map-set-action map indicator))

(defun map-action (map)
  (nth 1 map))
(defun map-set-action (map val)
  (setcar (nthcdr 1 map) val))

(defun map-alist (map)
  (nth 2 map))

(defun map-set-alist (map alist)
  (setcar (nthcdr 2 map) alist))

(defun get-action (map)
  (if (null map) nil
    (let ((action (map-action map)))
      (cond((its:standard-actionp action)
	    action)
	   ((symbolp action) (condition-case nil
				 (funcall action)
			       (error nil)))
	   (t (condition-case nil
		  (eval action)
		(error nil)))))))

(defun action-output (action)
  (cond((stringp action) action)
       (t (car action))))

(defun action-next (action)
  (cond((stringp action) nil)
       (t (car (cdr action)))))

(defun get-next-map (map ch)
  (or (cdr (assq ch (map-alist map)))
      (if (map-topmap-p map)
	  (let ((supers (map-supers map))
		(result nil))
	    (while supers
	      (setq result (get-next-map (car supers) ch))
	      (if result
		  (setq supers nil)
		(setq supers (cdr supers))))
	    result))))

(defun get-next-map-locally (map ch)
  (cdr (assq ch (map-alist map))))
  
(defun set-next-map (map ch val)
  (let ((place (assq ch (map-alist map))))
    (if place
	(if val
	    (setcdr place val)
	  (map-set-alist map (delq place (map-alist map))))
      (if val
	  (map-set-alist map (cons (cons ch val)
				   (map-alist map)))
	val))))

(defun its:simple-actionp (action)
  (stringp action))

(defun collect-simple-action (map)
  (if (map-terminalp map)
      (if (its:simple-actionp (map-action map))
	  (list (map-action map))
	nil)
    (let ((alist (map-alist map))
	  (result nil))
      (while alist
	(setq result 
	      ;;; 92.9.19 by Y. Kawabe
	      (append (collect-simple-action (cdr (car alist)))
		      result))
	(setq alist (cdr alist)))
      result)))

;;;----------------------------------------------------------------------
;;;
;;; Runtime translators
;;;
;;;----------------------------------------------------------------------
      
(defun its:simulate-input (i j  input map)
  (if (featurep 'xemacs)
      (while (<= i j)
	(setq map (get-next-map map (aref input i))) ;92.12.26 by S.Tomura
	(setq i (+ i (char-bytes (aref input i)))))	;92.12.26 by S.Tomura
    (while (<= i j)
      (setq map (get-next-map map (aref input i))) ;92.12.26 by S.Tomura
      (setq i (1+ i))))	;92.12.26 by S.Tomura
  map)

;;; meta-flag が on の時には、入力コードに \200 を or したものが入力さ
;;; れる。この部分の指摘は東工大の中川 貴之さんによる。
;;; pointted by nakagawa@titisa.is.titech.ac.jp Dec-11-89
;;;
;;; emacs では 文字コードは 0-127 で扱う。
;;;

(defvar its:*buff-s* (make-marker))
(defvar its:*buff-e* (make-marker))
(set-marker-insertion-type its:*buff-e* t)

;;;    STATE     unread
;;; |<-s   p->|<-    e ->|
;;; s  : ch0  state0  map0
;;;  +1: ch1  state1  map1
;;; ....
;;; (point):

;;; longest matching region : [s m]
;;; suspending region:        [m point]
;;; unread region          :  [point e]


(defvar its:*maxlevel* 10)
(defvar its:*maps*   (make-vector its:*maxlevel* nil))
(defvar its:*actions* (make-vector its:*maxlevel* nil))
(defvar its:*inputs* (make-vector its:*maxlevel* 0))
(defvar its:*level* 0)

(defun its:resize (size)
  (if (<= its:*maxlevel* size)
      (setq its:*maxlevel* size
	    its:*maps*    (make-vector size nil)
	    its:*actions* (make-vector size nil)
	    its:*inputs*  (make-vector size 0))))

(defun its:reset-maps (&optional init)
  (setq its:*level* 0)
  (if init
      (aset its:*maps* its:*level* init)))

(defun its:current-map () (aref its:*maps* its:*level*))
(defun its:previous-map () (aref its:*maps* (max 0 (1- its:*level*))))

(defun its:level () its:*level*)

(defun its:enter-newlevel (map ch output)
  (setq its:*level* (1+ its:*level*))
  (aset its:*maps* its:*level* map)
  (aset its:*inputs* its:*level* ch)
  (aset its:*actions* its:*level* output))

(defvar its:*char-from-buff* nil)
(defvar its:*interactive* t)

(defun its:reset-input ()
  (setq its:*char-from-buff* nil))

(defun its:flush-input-before-point (from)
  (save-excursion
    (while (<= from its:*level*)
      (its:insert-char (aref its:*inputs* from))
      (setq from (1+ from)))))

(if (featurep 'xemacs)
    (progn
      (defun its:peek-char ()
	(if (= (point) its:*buff-e*)
	    (if its:*interactive*
		(let ((ch (egg-read-event)))
		  (if ch
		      (progn
			(setq unread-command-events (list (character-to-event ch)))
			ch)
		    nil))
	      nil)
	  (char-after (point))))
      
      (defun its:read-char ()
	(if (= (point) its:*buff-e*)
	    (progn 
	      (setq its:*char-from-buff* nil)
	      (if its:*interactive*
		  (egg-read-event)
		nil))
	  (let ((ch (char-after (point))))
	    (setq its:*char-from-buff* t)
	    (delete-char 1)
	    ch)))
      
      (defun its:push-char (ch)
	(if its:*char-from-buff*
	    (save-excursion
	      (its:insert-char ch))
	  (if ch (setq unread-command-events (list (character-to-event ch))))))

      (defun its:insert-char (ch)
	(insert ch))
      
      (defun its:ordinal-charp (ch)
	(and (characterp ch) (<= ch 127)
	     (eq (lookup-key fence-mode-map (char-to-string ch)) 'fence-self-insert-command)))
      
      (defun its:delete-charp (ch)
	(and (characterp ch) (<= ch 127)
	     (eq (lookup-key fence-mode-map (char-to-string ch)) 'fence-backward-delete-char)))
      
      (defun its:tabp (ch)
	(and (characterp ch) (<= ch 127)
	     (eq (lookup-key fence-mode-map (char-to-string ch)) 'egg-predict-start-parttime)))

      (defvar egg:fence-buffer nil "Buffer fence is active in")
      
      (defun fence-self-insert-command ()
	(interactive)
	(if (not (eq (current-buffer) egg:fence-buffer))
	    nil	;; #### This is to bandaid a deep event-handling bug
	  (let ((ch (event-to-character last-command-event)))
	    (cond((or (not egg:*input-mode*)
		      (null (get-next-map its:*current-map* ch)))
		  (insert ch))
		 (t
		  (insert ch)
		  (its:translate-region (1- (point)) (point) t))))))
      )

  (defun its:peek-char ()
    (if (= (point) its:*buff-e*)
	(if its:*interactive*
	    (setq unread-command-events (list (read-event)))
	  nil)
      (following-char)))
  
  (defun its:read-char ()
    (if (= (point) its:*buff-e*)
	(progn 
	  (setq its:*char-from-buff* nil)
	  (if its:*interactive*
	      (read-char-exclusive)
	    nil))
      (let ((ch (following-char)))
	(setq its:*char-from-buff* t)
	(delete-char 1)
	ch)))
  
  (defun its:push-char (ch)
    (if its:*char-from-buff*
	(save-excursion
	  (its:insert-char ch))
      (if ch (setq unread-command-events (list ch)))))

  (defun its:insert-char (ch)
    (insert ch))
  
  (defun its:ordinal-charp (ch)
    (and (numberp ch) (<= 0 ch) (<= ch 127)
	 (eq (lookup-key fence-mode-map (char-to-string ch)) 'fence-self-insert-command)))
  
  (defun its:delete-charp (ch)
    (and (numberp ch) (<= 0 ch) (<= ch 127)
	 (eq (lookup-key fence-mode-map (char-to-string ch)) 'fence-backward-delete-char)))
    
  (defun its:tabp (ch)
    (and (numberp ch) (<= 0 ch) (<= ch 127)
	 (eq (lookup-key fence-mode-map (char-to-string ch)) 'egg-predict-start-parttime)))

  (defun fence-self-insert-command ()
    (interactive)
    (cond((or (not egg:*input-mode*)
	      (null (get-next-map its:*current-map* last-command-event)))
	  (insert last-command-event)(beep))
	 (t
	  (insert last-command-event)
	  (its:translate-region (1- (point)) (point) t))))
  )

;;;
;;; its: completing-read system
;;;

(defun its:all-completions (string alist &optional pred)
  "A variation of all-completions.\n\
Arguments are STRING, ALIST and optional PRED. ALIST must be no obarray."
  (let ((tail alist) (allmatches nil))
    (while tail
      (let* ((elt (car tail))
	     (eltstring (car elt)))
	(setq tail (cdr tail))
	(if (and (stringp eltstring)
		 (<= (length string) (length eltstring))
		 ;;;(not (= (aref eltstring 0) ? ))
		 (string-equal string (substring eltstring 0 (length string))))
	    (if (or (and pred
			 (if (if (eq pred 'commandp)
				 (commandp elt)
			       (funcall pred elt))))
		    (null pred))
		(setq allmatches (cons elt allmatches))))))
    (nreverse allmatches)))

(defun its:temp-echo-area-contents (message)
  (let ((inhibit-quit inhibit-quit)
	(point-max (point-max)))
    (goto-char point-max)
    (insert message)
    (goto-char point-max)
    (setq inhibit-quit t)
    (sit-for 2 nil)
    ;;; 92.9.19 by Y. Kawabe, 92.10.30 by T.Saneto
    (delete-region (point) (point-max))
    (if quit-flag
	(progn
	  (setq quit-flag nil)
	  (if (featurep 'xemacs)
	      (setq unread-command-events (list (character-to-event ?\^G)))
	    (setq unread-command-events (list ?\^G)))))))

(defun car-string-lessp (item1 item2)
  (string-lessp (car item1) (car item2)))

(defun its:minibuffer-completion-help ()
    "Display a list of possible completions of the current minibuffer contents."
    (interactive)
    (let ((completions))
      (message "Making completion list...")
      (setq completions (its:all-completions (buffer-string)
					 minibuffer-completion-table
					 minibuffer-completion-predicate))
      (if (null completions)
	  (progn
	    ;;; 92.9.19 by Y. Kawabe
	    (beep)
	    (its:temp-echo-area-contents " [No completions]"))
	(with-output-to-temp-buffer "*Completions*"
	  (display-completion-list
	   (sort completions 'car-string-lessp))))
      nil))

(defconst its:minibuffer-local-completion-map 
  (copy-keymap minibuffer-local-completion-map))
(define-key its:minibuffer-local-completion-map "?" 'its:minibuffer-completion-help)
(define-key its:minibuffer-local-completion-map " " 'its:minibuffer-completion-help)

(defconst its:minibuffer-local-must-match-map
  (copy-keymap minibuffer-local-must-match-map))
(define-key its:minibuffer-local-must-match-map "?" 'its:minibuffer-completion-help)
(define-key its:minibuffer-local-must-match-map " " 'its:minibuffer-completion-help)

(fset 'si:all-completions (symbol-function 'all-completions))
(fset 'si:minibuffer-completion-help (symbol-function 'minibuffer-completion-help))

(defun its:completing-read (prompt table &optional predicate require-match initial-input)
  "See completing-read"
  (let ((minibuffer-local-completion-map its:minibuffer-local-completion-map)
	(minibuffer-local-must-match-map its:minibuffer-local-must-match-map)
	(completion-auto-help nil))
    (completing-read prompt table predicate t initial-input)))

(defvar its:*completing-input-menu* '(menu "Which?" nil)) ;92.10.26 by T.Saneto

(defun its:completing-input (map)
  ;;; 
  (let ((action (get-action map)))
    (cond((and (null action)
	       (= (length (map-alist map)) 1))
	  (its:completing-input (cdr (nth 0 (map-alist map)))))
	 (t
	  (setcar (nthcdr 2 its:*completing-input-menu*)
		  (map-alist map))
	  (let ((values
		 (menu:select-from-menu its:*completing-input-menu*
					0 t)))
	    (cond((consp values)
		  ;;; get input char from menu
		  )
		 (t
		  (its:completing-input map))))))))

(defvar its:*make-menu-from-map-result* nil)

(defun its:make-menu-from-map (map)
  (let ((its:*make-menu-from-map-result* nil))
    (its:make-menu-from-map* map "")
    (list 'menu "Which?"  (reverse its:*make-menu-from-map-result*) )))

(defun its:make-menu-from-map* (map string)
  (let ((action (get-action map)))
    (if action
	(setq its:*make-menu-from-map-result*
	      (cons (format "%s[%s]" string (action-output action))
		    its:*make-menu-from-map-result*)))
    (let ((alist (map-alist map)))
      (while alist
	(its:make-menu-from-map* 
	 (cdr (car alist))
	 (concat string (char-to-string (car (car alist)))))
	(setq alist (cdr alist))))))

(defvar its:*make-alist-from-map-result* nil)

(defun its:make-alist-from-map (map &optional string)
  (let ((its:*make-alist-from-map-result* nil))
    (its:make-alist-from-map* map (or string ""))
    (reverse its:*make-alist-from-map-result*)))

(defun its:make-alist-from-map* (map string)
  (let ((action (get-action map)))
    (if action
	(setq its:*make-alist-from-map-result*
	      (cons (list string 
			  (let ((action-output (action-output action)))
			    (cond((and (consp action-output)
				       (characterp (car action-output)))
				  (format "%s..."
				  (nth (car action-output) (cdr action-output))))
				 ((stringp action-output)
				  action-output)
				 (t
				  (format "%s" action-output)))))
		    its:*make-alist-from-map-result*)))
    (let ((alist (map-alist map)))
      (while alist
	(its:make-alist-from-map* 
	 (cdr (car alist))
	 (concat string (char-to-string (car (car alist)))))
	(setq alist (cdr alist))))))

(defvar its:*select-alternative-output-menu* '(menu "Which?" nil))

(defun its:select-alternative-output (action-output)
  ;;;; action-output : (pos item1 item2 item3 ....)
  (let ((point (point))
	(output (cdr action-output))
	(ch 0))
    (while (not (eq ch ?\^L))
      (insert "<" (nth (car action-output)output) ">")
      (setq ch (if (featurep 'xemacs)
		   (egg-read-event)
		 (read-event)))
      (cond ((eq ch ?\^N)
	     (setcar action-output
		     (mod (1+ (car action-output)) (length output))))
	    ((eq ch ?\^P)
	     (setcar action-output
		     (if (= 0 (car action-output))
			 (1- (length output))
		       (1- (car action-output)))))
	    ((eq ch ?\^M)
	     (setcar (nthcdr 2 its:*select-alternative-output-menu* )
		     output)
	     (let ((values 
		    (menu:select-from-menu its:*select-alternative-output-menu*
					   (car action-output)
					   t)))
	       (cond((consp values)
		     (setcar action-output (nth 1 values))
		     (setq ch ?\^L)))))
	    ((eq ch ?\^L)
	     )
	    (t
	     (beep)
	     ))
      (delete-region point (point)))
    (if its:*insert-output-string*
	(funcall its:*insert-output-string* (nth (car action-output) output))
      (insert (nth (car action-output) output)))))
      
    

;;; translate until 
;;;      interactive --> not ordinal-charp
;;; or
;;;      not interactive  --> end of input

(defvar its:*insert-output-string* nil)
(defvar its:*display-status-string* nil)

(defun its:translate-region (start end its:*interactive* &optional topmap)
  (set-marker its:*buff-s* start)
  (set-marker its:*buff-e* end)
  (its:reset-input)
  (goto-char its:*buff-s*)
  (let ((topmap (or topmap its:*current-map*))
	(map nil)
	(ch nil)
	(action nil)
	(newmap nil)
	(inhibit-quit t)
	(its-quit-flag nil)
	(echo-keystrokes 0))
    (setq map topmap)
    (its:reset-maps topmap)
    (while (not its-quit-flag)
      (setq ch (its:read-char))
      (when (wnn7-p)	  ; input efficiency 
	(egg-predict-inc-input-length)) ; key input count
      (setq newmap (get-next-map map ch))
      (setq action (get-action newmap))

      (cond
       ((and its:*interactive* (not its:*char-from-buff*) (characterp ch) (= ch ?\^@))
	(delete-region its:*buff-s* (point))
	(let ((i 1))
	  (while (<= i its:*level*)
	    (insert (aref its:*inputs* i))
	    (setq i (1+ i))))
	(let ((inputs (its:completing-read "ITS:>" 
					   (its:make-alist-from-map topmap)
					   nil
					   t
					   (buffer-substring its:*buff-s* (point)))))
	  (delete-region its:*buff-s* (point))
	  (save-excursion (insert inputs))
	  (its:reset-maps)
	  (setq map topmap)
	  ))
       ((or (null newmap)
	    (and (map-terminalp newmap)
		 (null action)))

	(cond((and its:*interactive* (its:delete-charp ch))
	      (delete-region its:*buff-s* (point))
	      (cond((= its:*level* 0)
		    (setq its-quit-flag t))
		   ((= its:*level* 1)
		    (its:insert-char (aref its:*inputs* 1))
		    (setq its-quit-flag t))
		   (t
		    (its:flush-input-before-point (1+ its:*level*))
		    (setq its:*level* (1- its:*level*))
		    (setq map (its:current-map))
		    (if (and its:*interactive*
			     its:*display-status-string*)
			(funcall its:*display-status-string* (map-state map))
		      (insert (map-state map)))
		    )))
	     ((and its:*interactive* (its:tabp ch)) ;
	      (setq its-quit-flag t)) ;
	     (t
	      (let ((output nil))
		(let ((i its:*level*) (newlevel (1+ its:*level*)))
		  (aset its:*inputs* newlevel ch)
		  (while (and (< 0 i) (null output))
		    (if (and (aref its:*actions* i)
			     (its:simulate-input (1+ i) newlevel its:*inputs* topmap))
			(setq output i))
		    (setq i (1- i)))
		  (if (null output)
		      (let ((i its:*level*))
			(while (and (< 0 i) (null output))
			  (if (aref its:*actions* i)
			      (setq output i))
			  (setq i (1- i)))))

		  (cond(output 
			(delete-region its:*buff-s* (point))
			(cond((its:standard-actionp (aref its:*actions* output))
			      (let ((action-output (action-output (aref its:*actions* output))))
				(if (and (not its:*interactive*)
					 (consp action-output))
				    (setq action-output (nth (car action-output) (cdr action-output))))
				(cond((stringp action-output)
				      (if (and its:*interactive* 
					       its:*insert-output-string*)
					  (funcall its:*insert-output-string* action-output)
					(insert action-output)))
				     ((consp action-output)
				      (its:select-alternative-output action-output)
				      )
				     (t
				      (beep) (beep)
				      )))
			      (set-marker its:*buff-s* (point))
			      (its:push-char ch)
			      (its:flush-input-before-point (1+ output))
			      (if (action-next (aref its:*actions* output))
				  (save-excursion
				    (insert (action-next (aref its:*actions* output)))))
			      )
			     ((symbolp (aref its:*actions* output))
			      (its:push-char ch)
			      (funcall (aref its:*actions* output))
			      (its:reset-maps its:*current-map*)
			      (setq topmap its:*current-map*)
			      (set-marker its:*buff-s* (point)))
			     (t 
			      (its:push-char ch)
					;92.10.26 by T.Saneto
			      (eval (aref its:*actions* output))
			      (its:reset-maps its:*current-map*)
			      (setq topmap its:*current-map*)
			      (set-marker its:*buff-s* (point))
			      ))
			)
		       ((= 0 its:*level*)
			(cond ((or (its:ordinal-charp ch)
				   its:*char-from-buff*)
			       (its:insert-char ch))
			      (t (setq its-quit-flag t))))

		       ((< 0 its:*level*)
			(delete-region its:*buff-s* (point))
			(its:insert-char (aref its:*inputs* 1))
			(set-marker its:*buff-s* (point))
			(its:push-char ch)
			(its:flush-input-before-point 2)))))
		    
	      (cond((null ch)
		    (setq its-quit-flag t))
		   ((not its-quit-flag)
		    (its:reset-maps)
		    (set-marker its:*buff-s* (point))
		    (setq map topmap))))))
	       
       ((map-terminalp newmap)
	(its:enter-newlevel (setq map newmap) ch action)
	(delete-region its:*buff-s* (point))
	(let ((output nil) (m nil) (i (1- its:*level*)))
	  (while (and (< 0 i) (null output))
	    (if (and (aref its:*actions* i)
		     (setq m (its:simulate-input (1+ i) its:*level* its:*inputs* topmap))
		     (not (map-terminalp m)))
		(setq output i))
	    (setq i (1- i)))

	  (cond((null output)
		(cond ((its:standard-actionp action)
		       (let ((action-output (action-output action)))
			 (if (and (not its:*interactive*)
				  (consp action-output))
			     (setq action-output (nth (car action-output) (cdr action-output))))
			 (cond((stringp action-output)
			       (if (and its:*interactive* 
					its:*insert-output-string*)
				   (funcall its:*insert-output-string* action-output)
				 (insert action-output)) ;
			       (if (and (wnn7-p)
					(egg-predict-realtime-p)) ;
				   (egg-predict-start-realtime))) ;
			      ((consp action-output)
			       (its:select-alternative-output action-output)
			       )
			      (t
			       (beep) (beep)
			       )))
		       (cond((null (action-next action))
			     (cond ((and (= (point) its:*buff-e*)
					 its:*interactive*
					 (its:delete-charp (its:peek-char)))
				    nil)
				   (t
				    (set-marker its:*buff-s* (point))
				    (its:reset-maps)
				    (setq map topmap)
				    )))
			    (t
			     (save-excursion (insert (action-next action)))
			     (set-marker its:*buff-s* (point))
			     (its:reset-maps)
			     (setq map topmap))))
		      ((symbolp action)
		       (funcall action)
		       (its:reset-maps its:*current-map*)
		       (setq topmap its:*current-map*)
		       (setq map topmap)
		       (set-marker its:*buff-s* (point)))
		      (t 
		       (eval action)
		       (its:reset-maps its:*current-map*)
		       (setq topmap its:*current-map*)
		       (setq map topmap)
		       (set-marker its:*buff-s* (point)))))
	       (t
		(if (and its:*interactive* 
			 its:*display-status-string*)
		    (funcall its:*display-status-string* (map-state map))
		  (insert (map-state map)))))))

       ((null action)
	(delete-region its:*buff-s* (point))
	(if (and its:*interactive* 
		 its:*display-status-string*)
	    (funcall its:*display-status-string* (map-state newmap))
	  (insert (map-state newmap))) ;
	(if (and (wnn7-p)
		 (egg-predict-realtime-p)) ;
	    (egg-predict-start-realtime)) ;
	(its:enter-newlevel (setq map newmap)
			    ch action))

       (t
	(its:enter-newlevel (setq map newmap) ch action)
	(delete-region its:*buff-s* (point))
	(if (and its:*interactive* 
		 its:*display-status-string*)
	    (funcall its:*display-status-string* (map-state map))
	  (insert (map-state map)))
	(if (and (wnn7-p) 
		 (egg-predict-realtime-p)) ;
	    (egg-predict-start-realtime)) ;
	)))

    (set-marker its:*buff-s* nil)
    (set-marker its:*buff-e* nil)
    (if (featurep 'xemacs)
	(if (and its:*interactive* ch) (setq unread-command-events (list (character-to-event ch))))
      (if (and its:*interactive* ch) (setq unread-command-events (list ch))))
    ))

;;;----------------------------------------------------------------------
;;; 
;;; ITS-map dump routine:
;;;
;;;----------------------------------------------------------------------

;;;;;
;;;;; User entry: dump-its-mode-map
;;;;;

;; 92.6.26 by K.Handa
(defun dump-its-mode-map (name filename)
  "Obsolete."
  (interactive)
  (message "This function is obsolete in the current version of Mule."))
;;;
;;; EGG mode variables
;;;

(defvar egg:*mode-on* nil "T if egg mode is on.")
(make-variable-buffer-local 'egg:*mode-on*)
(set-default 'egg:*mode-on* nil)

(defvar egg:*input-mode* t "T if egg map is active.")
(make-variable-buffer-local 'egg:*input-mode*)
(set-default 'egg:*input-mode* t)

(defvar egg:*in-fence-mode* nil "T if in fence mode.")
(make-variable-buffer-local 'egg:*in-fence-mode*)
(set-default 'egg:*in-fence-mode* nil)

(defvar its:*current-map* nil)
;;(setq-default its:*current-map* (its:get-mode-map "roma-kana"))
(make-variable-buffer-local 'its:*current-map*)

(defvar its:*previous-map* nil)
(make-variable-buffer-local 'its:*previous-map*)
(setq-default its:*previous-map* nil)

;;;----------------------------------------------------------------------
;;;
;;; Mode line control functions;
;;;
;;;----------------------------------------------------------------------

(defconst mode-line-egg-mode "--")
(make-variable-buffer-local 'mode-line-egg-mode)

(defvar   mode-line-egg-mode-in-minibuffer "--" "global variable")

(defun egg:find-symbol-in-tree (item tree)
  (if (consp tree)
      (or (egg:find-symbol-in-tree item (car tree))
	  (egg:find-symbol-in-tree item (cdr tree)))
    (equal item tree)))

;;;
;;; nemacs Ver. 3.0 では Fselect_window が変更になり、minibuffer-window
;;; 他の window との間で出入りがあると、mode-line の更新を行ない、変数 
;;; minibuffer-window-selected の値が更新される
;;;

;;; nemacs Ver. 4 では Fselect_window が変更になり，select-window-hook 
;;; が定義された．これにともない従来，再定義していた select-window,
;;; other-window, keyborad-quit, abort-recursive-edit, exit-minibuffer 
;;; を削除した．

(defconst display-minibuffer-mode-in-minibuffer t)
(defconst display-minibuffer-mode nil)
(defvar minibuffer-preprompt nil)
(defvar minibuffer-window-selected nil)

(defun egg:select-window-hook (old new)
  (if (and (eq old (minibuffer-window))
           (not (eq new (minibuffer-window))))
      (save-excursion
	(set-buffer (window-buffer (minibuffer-window)))
	(if (featurep 'xemacs)
	    (set-minibuffer-preprompt nil)
	  (setq minibuffer-preprompt nil))
	(setq egg:*mode-on* (default-value 'egg:*mode-on*)
	      egg:*input-mode* (default-value 'egg:*input-mode*)
	      egg:*in-fence-mode* (default-value 'egg:*in-fence-mode*))))
  (if (eq new (minibuffer-window))
      (setq minibuffer-window-selected t)
    (setq minibuffer-window-selected nil)))

(defun egg:minibuffer-entry-hook ()
  (setq minibuffer-window-selected t))
      
(defun egg:minibuffer-exit-hook ()
  "Call upon exit from minibuffer"
  (if (featurep 'xemacs)
      (set-minibuffer-preprompt nil)
    (setq minibuffer-preprompt nil))
  (setq minibuffer-window-selected nil)
  (save-excursion
    (set-buffer (window-buffer (minibuffer-window)))
    (setq egg:*mode-on* (default-value 'egg:*mode-on*)
	  egg:*input-mode* (default-value 'egg:*input-mode*)
	  egg:*in-fence-mode* (default-value 'egg:*in-fence-mode*))))

;;;
;;;
;;;

(defvar its:*reset-modeline-format* nil)

;;;
;;; minibuffer でのモード表示をするために nemacs 4 で定義された 
;;; minibuffer-preprompt を利用する．
;;;

(defconst egg:minibuffer-preprompt '("[" nil "]"))
(defvar egg-yosoku-mode nil "入力予測モード")

(defun mode-line-egg-mode-update (str)
  (if (and (wnn7-p)
	   egg-yosoku-mode
	   egg:*mode-on*
	   egg:*input-mode*)
      (setq str (concat str "予")))
  (if (eq (current-buffer) (window-buffer (minibuffer-window)))
      (if display-minibuffer-mode-in-minibuffer
	  (progn
	    (aset (nth 0 egg:minibuffer-preprompt) 0
		  (if its:*previous-map* ?\< ?\[))
	    (setcar (nthcdr 1 egg:minibuffer-preprompt)
		    str)
	    (aset (nth 2 egg:minibuffer-preprompt) 0
		  (if its:*previous-map* ?\> ?\]))
	    (if (featurep 'xemacs)
		(set-minibuffer-preprompt (concat
					   (car egg:minibuffer-preprompt)
					   (car (nthcdr 1 egg:minibuffer-preprompt))
					   (car (nthcdr 2 egg:minibuffer-preprompt))))
	      (setq minibuffer-preprompt
		    egg:minibuffer-preprompt)))
	(setq display-minibuffer-mode t
	      mode-line-egg-mode-in-minibuffer str))
    (setq display-minibuffer-mode nil
	  mode-line-egg-mode str))
  (if (featurep 'xemacs)
      (redraw-modeline t)
    ;; nemacs 4 only(update-mode-lines)
    (set-buffer-modified-p (buffer-modified-p))))

;;(mode-line-egg-mode-update mode-line-egg-mode)

;;;
;;; egg mode line display
;;;

(defvar alphabet-mode-indicator "aA")
(defvar transparent-mode-indicator "--")

(defun egg:mode-line-display ()
  (mode-line-egg-mode-update 
   (cond((and egg:*in-fence-mode* (not egg:*input-mode*))
	 alphabet-mode-indicator)
	((and egg:*mode-on* egg:*input-mode*)
	 (map-indicator its:*current-map*))
	(t transparent-mode-indicator))))

(defun egg:toggle-egg-mode-on-off ()
  (interactive)
  (setq egg:*mode-on* (not egg:*mode-on*))
  (egg:mode-line-display))

(defun its:select-mode (name)
  (interactive (list (completing-read "ITS mode: " its:*mode-alist*)))
  (if (its:get-mode-map name)
      (progn
	(setq its:*current-map* (its:get-mode-map name))
	(egg:mode-line-display))
    (beep)))

(defvar its:*select-mode-menu* '(menu "Mode:" nil))

(defun its:select-mode-from-menu ()
  (interactive)
  (setcar (nthcdr 2 its:*select-mode-menu*) its:*mode-alist*)
  (setq its:*current-map* (menu:select-from-menu its:*select-mode-menu*))
  (egg:mode-line-display))

(defvar its:*standard-modes* nil)
;;  (list (its:get-mode-map "roma-kana")
;;	(its:get-mode-map "roma-kata")
;;	(its:get-mode-map "downcase")
;;	(its:get-mode-map "upcase")
;;	(its:get-mode-map "zenkaku-downcase")
;;	(its:get-mode-map "zenkaku-upcase"))
;;  "List of standard mode-map of EGG.")

(defun its:find (map list)
  (let ((n 0))
    (while (and list (not (eq map (car list))))
      (setq list (cdr list)
	    n    (1+ n)))
    (if list n nil)))

(defun its:next-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (% (1+ pos) (length its:*standard-modes*))
	       its:*standard-modes*))
    (egg:mode-line-display)))

(defun its:previous-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (1- (if (= pos 0) (length its:*standard-modes*) pos))
	       its:*standard-modes*))
    (egg:mode-line-display)))

(defun its:select-hiragana () (interactive) (its:select-mode "roma-kana"))
(defun its:select-katakana () (interactive) (its:select-mode "roma-kata"))
(defun its:select-downcase () (interactive) (its:select-mode "downcase"))
(defun its:select-upcase   () (interactive) (its:select-mode "upcase"))
(defun its:select-zenkaku-downcase () (interactive) (its:select-mode "zenkaku-downcase"))
(defun its:select-zenkaku-upcase   () (interactive) (its:select-mode "zenkaku-upcase"))

(defun its:select-mode-temporally (name)
  (interactive (list (completing-read "ITS mode: " its:*mode-alist*)))
  (let ((map (its:get-mode-map name)))
    (if map
	(progn
	  (if (null its:*previous-map*)
	      (setq its:*previous-map* its:*current-map*))
	  (setq its:*current-map*  map)
	  (egg:mode-line-display))
      (beep))))

(defun its:select-previous-mode ()
  (interactive)
  (if (null its:*previous-map*)
      (beep)
    (setq its:*current-map* its:*previous-map*
	  its:*previous-map* nil)
    (egg:mode-line-display)))
	  

(defun toggle-egg-mode ()
  (interactive)
  (if egg:*mode-on* (fence-toggle-egg-mode)
    (progn
      (setq egg:*mode-on* t)
      (egg:mode-line-display))))

(defun fence-toggle-egg-mode ()
  (interactive)
  (if its:*current-map*
      (progn
	(setq egg:*input-mode* (not egg:*input-mode*))
	(egg:mode-line-display))
    (beep)))

;;;
;;; Changes on Global map 
;;;

(defvar si:*global-map* (copy-keymap global-map))

(substitute-key-definition 'self-insert-command
			   'egg-self-insert-command
			   global-map)

;; 入力予測直前登録削除用の対応
(substitute-key-definition 'delete-backward-char 
			   'egg-delete-backward-char
			   global-map)
(substitute-key-definition 'backward-delete-char-untabify
			   'egg-backward-delete-char-untabify
			   global-map)

(if (featurep 'xemacs)
    ;; wire us into pending-delete
    (put 'egg-self-insert-command 'pending-delete t))
 
;;;
;;; Currently entries C-\ and C-^ at global-map are undefined.
;;;

;; Make this no-op if LEIM interface is used.
(cond ((featurep 'wnn7egg-leim) t)
      (t (define-key global-map "\C-\\" 'toggle-egg-mode)) )
;; #### Should hide bindings like this, too?  However, `convert-region'
;;      probably isn't going to be a LEIM feature, it's really pretty
;;      Japanese and Korean specific.
(define-key global-map "\C-x " 'wnn7-henkan-region)

;; 92.3.16 by K.Handa
;; global-map => mule-keymap
(define-key mule-keymap "m" 'its:select-mode-from-menu)
(define-key mule-keymap ">" 'its:next-mode)
(define-key mule-keymap "<" 'its:previous-mode)
(define-key mule-keymap "h" 'its:select-hiragana)
(define-key mule-keymap "k" 'its:select-katakana)
(define-key mule-keymap "q" 'its:select-downcase)
(define-key mule-keymap "Q" 'its:select-upcase)
(define-key mule-keymap "z" 'its:select-zenkaku-downcase)
(define-key mule-keymap "Z" 'its:select-zenkaku-upcase)

;;;
;;; auto fill controll
;;;

(defun egg:do-auto-fill ()
  (if (and auto-fill-function (not buffer-read-only)
	   (> (current-column) fill-column))
      (let ((ocolumn (current-column)))
	(funcall auto-fill-function)
	(while (and (< fill-column (current-column))
		    (< (current-column) ocolumn))
  	  (setq ocolumn (current-column))
	  (funcall auto-fill-function)))))

;;;----------------------------------------------------------------------
;;;
;;;  Egg fence mode
;;;
;;;----------------------------------------------------------------------

(defvar egg:*fence-open*   "|" "*フェンスの始点を示す文字列")
(defvar egg:*fence-close*  "|" "*フェンスの終点を示す文字列")
(defvar egg:*fence-face* nil  "*フェンス表示に用いる face または nil")
(if (featurep 'xemacs)
    (make-variable-buffer-local
     (defvar egg:*fence-extent* nil "フェンス表示用 extent"))
  (make-variable-buffer-local
   (defvar egg:*fence-overlay* nil "フェンス表示用 overlay")))

(defvar egg:*face-alist*
  '(("nil" . nil)
    ("highlight" . highlight) ("modeline" . modeline)
    ("inverse" . modeline) ("underline" . underline) ("bold" . bold)
    ("region" . region)))

(defun set-egg-fence-mode-format (open close &optional face)
  "fence mode の表示方法を設定する。OPEN はフェンスの始点を示す文字列または nil。\n\
CLOSEはフェンスの終点を示す文字列または nil。\n\
第3引数 FACE が指定されて nil でなければ、フェンス区間の表示にそれを使う。"
  (interactive (list (read-string "フェンス開始文字列: ")
		     (read-string "フェンス終了文字列: ")
		     (cdr (assoc (completing-read "フェンス表示属性: " egg:*face-alist*)
				 egg:*face-alist*))))

  (if (and (or (stringp open) (null open))
	   (or (stringp close) (null close))
	   (or (null face) (memq face (face-list))))
      (progn
	(setq egg:*fence-open* (or open "")
	      egg:*fence-close* (or close "")
	      egg:*fence-face* face)
	(if (featurep 'xemacs)
	    (if (extentp egg:*fence-extent*)
		(set-extent-property egg:*fence-extent* 
				     'face egg:*fence-face*))
	  (if (overlayp egg:*fence-overlay*)
	      (overlay-put egg:*fence-overlay* 'face egg:*fence-face*)))
	t)
    (error "Wrong type of argument: %s %s %s" open close face)))

(defvar egg:*region-start* nil)
(make-variable-buffer-local 'egg:*region-start*)
(set-default 'egg:*region-start* nil)
(defvar egg:*region-end* nil)
(make-variable-buffer-local 'egg:*region-end*)
(set-default 'egg:*region-end* nil)
;;(defvar egg:*global-map-backup* nil)
;;(defvar egg:*local-map-backup*  nil)


;;; Moved to kanji.el
;;; (defvar self-insert-after-hook nil
;;;  "Hook to run when extended self insertion command exits. Should take
;;; two arguments START and END correspoding to character position.")
(defvar self-insert-after-hook nil
 "Hook to run when extended self insertion command exits. Should take
two arguments START and END correspoding to character position.")

(defvar egg:*self-insert-non-undo-count* 0
  "counter to hold repetition of egg-self-insert-command.")

(defvar egg-insert-after-hook nil)
(make-variable-buffer-local 'egg-insert-after-hook)


(defun egg:cancel-undo-boundary ()
  "Cancel undo boundary for egg-self-insert-command"
  (if (eq last-command 'egg-self-insert-command)
      (if (and (consp buffer-undo-list)
	       ;; if car is nil.
	       (null (car buffer-undo-list))
	       (< egg:*self-insert-non-undo-count* 20))
      ;; treat consecutive 20 self-insert commands as a single undo chunk.
      ;; `20' is a magic number copied from keyboard.c
	  (setq buffer-undo-list (cdr buffer-undo-list)
		egg:*self-insert-non-undo-count*
		(1+ egg:*self-insert-non-undo-count*))
	(setq egg:*self-insert-non-undo-count* 1))))

(if (featurep 'xemacs)
    (defun egg-self-insert-command (arg)
      (interactive "p")
      (if (and (not buffer-read-only)
	       egg:*mode-on* egg:*input-mode* 
	       (not egg:*in-fence-mode*) ;;; inhibit recursive fence mode
	       (not (= (event-to-character last-command-event) ? )))
	  (progn
	    (if (wnn7-p); 予測直前登録削除 & 予測前後情報クリア
		(egg-predict-check-reset-connective))
	    (egg:enter-fence-mode-and-self-insert))
	(progn
	  ;; treat continuous 20 self insert as a single undo chunk.
	  ;; `20' is a magic number copied from keyboard.c
	  (if (or				;92.12.20 by T.Enami
	       (not (eq last-command 'egg-self-insert-command))
	       (>= egg:*self-insert-non-undo-count* 20))
	      (setq egg:*self-insert-non-undo-count* 1)
	    (cancel-undo-boundary)
	    (setq egg:*self-insert-non-undo-count*
		  (1+ egg:*self-insert-non-undo-count*)))
	  (self-insert-command arg)
	  (if egg-insert-after-hook
	      (run-hooks 'egg-insert-after-hook))
	  (if self-insert-after-hook
	      (if (<= 1 arg)
		  (funcall self-insert-after-hook
			   (- (point) arg) (point)))
	    (if (= (event-to-character last-command-event) ? ) (egg:do-auto-fill))))))
  
  (defun egg-self-insert-command (arg)
    (interactive "p")
    (if (and (not buffer-read-only)
	     egg:*mode-on* egg:*input-mode* 
	     (not egg:*in-fence-mode*) ;;; inhibit recursive fence mode
	     (not (= last-command-event  ? )))
	(progn
	  (if (wnn7-p); 予測直前登録削除 & 予測前後情報クリア
	      (egg-predict-check-reset-connective))
	  (egg:enter-fence-mode-and-self-insert))
      (progn
	(if (and (eq last-command 'egg-self-insert-command)
		 (> last-command-char ? ))
	    (egg:cancel-undo-boundary))
	(self-insert-command arg)
	(if egg-insert-after-hook
	    (run-hooks 'egg-insert-after-hook))
	(if self-insert-after-hook
	    (if (<= 1 arg)
		(funcall self-insert-after-hook
			 (- (point) arg) (point)))
	  (if (= last-command-event ? ) (egg:do-auto-fill)))))))

;;
;; 前確定変換処理関数 
;;
(defvar egg:*fence-open-backup* nil)
(defvar egg:*fence-close-backup* nil)
(defvar egg:*fence-face-backup* nil)

(defconst egg:*fence-open-in-cont* "+" "*前確定状態での *fence-open*")
(defconst egg:*fence-close-in-cont* t "*前確定状態での *fence-close*")
(defconst egg:*fence-face-in-cont* t
  "*前確定状態での *fence-face*")

(defun set-egg-fence-mode-format-in-cont (open close face)
  "前確定状態での fence mode の表示方法を設定する。OPEN はフェンスの始点を示す文
字列、t または nil。\n\
CLOSEはフェンスの終点を示す文字列、t または nil。\n\
FACE は nil でなければ、フェンス区間の表示にそれを使う。\n\
それぞれの値が t の場合、通常の egg:*fence-open* 等の値を引き継ぐ。"
  (interactive (list (read-string "フェンス開始文字列: ")
                     (read-string "フェンス終了文字列: ")
                     (cdr (assoc (completing-read "フェンス表示属性: " egg:*face
-alist*)
                                 egg:*face-alist*))))

  (if (and (or (stringp open) (eq open t) (null open))
           (or (stringp close) (eq close t) (null close))
           (or (null face) (eq face t) (memq face (face-list))))
      (progn
        (setq egg:*fence-open-in-cont* (or open "")
              egg:*fence-close-in-cont* (or close "")
              egg:*fence-face-in-cont* face)
	(if (featurep 'xemacs)
	    (if (extentp egg:*fence-extent*)
		(set-extent-property egg:*fence-extent* 
				     'face egg:*fence-face*))
	  (if (overlayp egg:*fence-overlay*)
	      (overlay-put egg:*fence-overlay* 'face egg:*fence-face*)))
        t)
    (error "Wrong type of argument: %s %s %s" open close face)))

(defvar *in-cont-flag* nil
 "直前に変換した直後の入力かどうかを示す。")

(defvar *in-cont-backup-flag* nil)

(defun egg:check-fence-in-cont ()
  (if *in-cont-flag*
      (progn
	(setq *in-cont-backup-flag* t)
	(setq egg:*fence-open-backup* egg:*fence-open*)
	(setq egg:*fence-close-backup* egg:*fence-close*)
	(setq egg:*fence-face-backup* egg:*fence-face*)
        (or (eq egg:*fence-open-in-cont* t)
            (setq egg:*fence-open* egg:*fence-open-in-cont*))
        (or (eq egg:*fence-close-in-cont* t)
            (setq egg:*fence-close* egg:*fence-close-in-cont*))
        (or (eq egg:*fence-face-in-cont* t)
            (setq egg:*fence-face* egg:*fence-face-in-cont*)))))

(defun egg:restore-fence-in-cont ()
  "Restore egg:*fence-open* and egg:*fence-close*"
  (if *in-cont-backup-flag* 
      (progn
	(setq egg:*fence-open* egg:*fence-open-backup*)
	(setq egg:*fence-close* egg:*fence-close-backup*)
	(setq egg:*fence-face* egg:*fence-face-backup*)))
  (setq *in-cont-backup-flag* nil)
  )

(defun egg:enter-fence-mode-and-self-insert () 
  (if (wnn7-p)
      (setq *in-cont-flag*
	    (memq last-command 
		  '(wnn7-henkan-kakutei wnn7-henkan-kakutei-and-self-insert)))
    (setq *in-cont-flag*
	  (memq last-command 
		'(henkan-kakutei henkan-kakutei-and-self-insert))))
  (enter-fence-mode)
  (setq unread-command-events (list last-command-event)))

(defun egg:fence-face-on ()
  (if egg:*fence-face*
      (if (featurep 'xemacs)
	  (progn
	    (if (extentp egg:*fence-extent*)
		(set-extent-endpoints egg:*fence-extent* 
				      egg:*region-start* egg:*region-end*)
	      (setq egg:*fence-extent* (make-extent egg:*region-start* 
						    egg:*region-end*))
	      (set-extent-property egg:*fence-extent* 'start-open nil)
	      (set-extent-property egg:*fence-extent* 'end-open nil)
	      (set-extent-property egg:*fence-extent* 'detachable nil))
	    (set-extent-face egg:*fence-extent* egg:*fence-face*))
	(progn
	  (or (overlayp egg:*fence-overlay*)
	      (setq egg:*fence-overlay* (make-overlay 1 1 nil nil t)))
	  (if egg:*fence-face* 
	      (or (eq egg:*fence-face* 
		      (overlay-get egg:*fence-overlay* 'face))
		  (overlay-put egg:*fence-overlay* 'face egg:*fence-face*)))
	  (move-overlay egg:*fence-overlay* egg:*region-start* 
			egg:*region-end*)))))

(defun egg:fence-face-off ()
  (if (featurep 'xemacs)
      (and egg:*fence-face*
	   (extentp egg:*fence-extent*)
	   (detach-extent egg:*fence-extent*))
    (and egg:*fence-face*
	 (overlayp egg:*fence-overlay*)
	 (delete-overlay egg:*fence-overlay*))))

(defun enter-fence-mode ()
  ;;;(buffer-flush-undo (current-buffer))
  (suspend-undo)
  ;;;(and (boundp 'disable-undo) (setq disable-undo t))
  (if (featurep 'xemacs)
      (setq egg:*in-fence-mode* t
	    egg:fence-buffer (current-buffer))
    (setq egg:*in-fence-mode* t))
  (when (wnn7-p)	  ; input efficiency 
    (egg-predict-check-start-time)
    (egg-predict-check-start-input))
  (egg:mode-line-display)
  (egg:check-fence-in-cont)            ; for Wnn6
  (insert egg:*fence-open*)
  (or (markerp egg:*region-start*) (setq egg:*region-start* (make-marker)))
  (set-marker egg:*region-start* (point))
  (insert egg:*fence-close*)
  (or (markerp egg:*region-end*) (set-marker-insertion-type (setq egg:*region-end* (make-marker)) t))
  (set-marker egg:*region-end* egg:*region-start*)
  (egg:fence-face-on)
  (goto-char egg:*region-start*)
  )

(defun henkan-fence-region-or-single-space ()
  (interactive)
  (if egg:*input-mode*   
      (henkan-fence-region)
    (insert ? )))

(defvar egg:*henkan-fence-mode* nil)

(defun henkan-fence-region ()
  (interactive)
  (setq egg:*henkan-fence-mode* t)
  (egg:fence-face-off)
  (if (wnn7-p)
      (progn
	(when egg-predict-status
	  (egg-predict-clear))
	(wnn7-henkan-region-internal egg:*region-start* egg:*region-end* ))
    (henkan-region-internal egg:*region-start* egg:*region-end* )))

(defun fence-katakana  ()
  (interactive)
  (japanese-katakana-region egg:*region-start* egg:*region-end*))

(defun fence-hiragana  ()
  (interactive)
  (japanese-hiragana-region egg:*region-start* egg:*region-end*))

(defun fence-hankaku  ()
  (interactive)
  (japanese-hankaku-region egg:*region-start* egg:*region-end* 'ascii-only))

(defun fence-zenkaku  ()
  (interactive)
  (japanese-zenkaku-region egg:*region-start* egg:*region-end*))

(defun fence-backward-char ()
  (interactive)
  (if (< egg:*region-start* (point))
      (backward-char)
    (beep)))

(defun fence-forward-char ()
  (interactive)
  (if (< (point) egg:*region-end*)
      (forward-char)
    (beep)))

(defun fence-beginning-of-line ()
  (interactive)
  (goto-char egg:*region-start*))

(defun fence-end-of-line ()
  (interactive)
  (goto-char egg:*region-end*))

(defun fence-transpose-chars (arg)
  (interactive "P")
  (if (and (< egg:*region-start* (point))
	   (< (point) egg:*region-end*))
      (transpose-chars arg)
    (beep)))

(defun egg:exit-if-empty-region ()
  (if (= egg:*region-start* egg:*region-end*)
      (fence-exit-mode)))

(defun fence-delete-char ()
  (interactive)
  (if (< (point) egg:*region-end*)
      (progn
	(delete-char 1)
	(egg:exit-if-empty-region))
    (beep)))

(defun fence-backward-delete-char ()
  (interactive)
  (if (< egg:*region-start* (point))
      (progn
	(delete-char -1)
	(if (and (wnn7-p)
		 (egg-predict-realtime-p))
	    (egg-predict-start-realtime))
	(egg:exit-if-empty-region))
    (beep)))

(defun fence-kill-line ()
  (interactive)
  (delete-region (point) egg:*region-end*)
  (egg:exit-if-empty-region))

(defun fence-exit-mode ()
  (interactive)
  ;; "aA" の状態から "--" の状態に戻ると（fence-toggle-egg-mode が行われて
  ;; transparent-mode に戻ると）input-method の status と矛盾してしまう。
  ;; そこで、alphabet-mode の後は、transparent-mode に戻らないように
  ;; input-mode フラグを戻す
  (if (equal mode-line-egg-mode "aA")
      (setq egg:*input-mode* t)) 
  (egg:fence-face-off)
  (setq egg:*in-fence-mode* nil)
  (let ((kakutei-string (buffer-substring 
			 egg:*region-start* egg:*region-end*)))
    (delete-region (- egg:*region-start* (length egg:*fence-open*)) 
		   egg:*region-start*)
    (delete-region egg:*region-start* egg:*region-end*)
    (delete-region egg:*region-end* 
		   (+ egg:*region-end* (length egg:*fence-close*)))
    (goto-char egg:*region-start*)
    (when (wnn7-p)
      (egg-predict-clear))
    (resume-undo-list)
    (insert kakutei-string)
    (when (wnn7-p)
      (if (> (length kakutei-string) 0)
	  (progn
	    (egg-predict-inc-kakutei-length) ;;;
	    (egg-predict-toroku kakutei-string)))))
  (if its:*previous-map*
      (setq its:*current-map* its:*previous-map*
	    its:*previous-map* nil))
  (egg:quit-egg-mode))

(if (not (featurep 'xemacs))
    (defun delete-text-in-column (from to)
      "Delete the text between column FROM and TO (exclusive) of the current line.
Nil of FORM or TO means the current column.
If there's a charcter across the borders, the character is replaced with
the same width of spaces before deleting."
      (save-excursion
	(let (p1 p2)
	  (if from
	      (progn
		(setq p1 (move-to-column from))
		(if (> p1 from)
		    (progn
		      (delete-char -1)
		      (insert-char ?  (- p1 (current-column)))
		      (forward-char (- from p1))))))
	  (setq p1 (point))
	  (if to
	      (progn
		(setq p2 (move-to-column to))
		(if (> p2 to)
		    (progn
		      (delete-char -1)
		      (insert-char ?  (- p2 (current-column)))
		      (forward-char (- to p2))))))
	  (setq p2 (point))
	  (delete-region p1 p2)))))

(defvar egg-exit-hook nil
  "Hook to run when egg exits. Should take two arguments START and END
correspoding to character position.")

(defun egg:quit-egg-mode ()
  (egg:mode-line-display)
  (if overwrite-mode
      (let ((str (buffer-substring egg:*region-end* egg:*region-start*)))
	(delete-text-in-column nil (+ (current-column) (string-width str)))))
  (egg:restore-fence-in-cont)               ; for Wnn6
  (setq egg:*henkan-fence-mode* nil)
  (if self-insert-after-hook
      (funcall self-insert-after-hook egg:*region-start* egg:*region-end*)
    (if egg-exit-hook
	(funcall egg-exit-hook egg:*region-start* egg:*region-end*)
      (if (not (= egg:*region-start* egg:*region-end*))
	  (egg:do-auto-fill))))
  (set-marker egg:*region-start* nil)
  (set-marker egg:*region-end*   nil)
  (when (wnn7-p)
    (egg-predict-check-end))
  (if egg-insert-after-hook
      (run-hooks 'egg-insert-after-hook))
  )

(defun fence-cancel-input ()
  (interactive)
  (delete-region egg:*region-start* egg:*region-end*)
  (fence-exit-mode))

(defun egg-lang-switch-callback ()
  "Do whatever processing is necessary when the language-environment changes."
  (if egg:*in-fence-mode*
      (progn
	(its:reset-input)
	(fence-kill-operation)))
;;  (let ((func (get current-language-environment 'set-egg-environ)))
;;    (if (not (null func))
;;      (funcall func)))
  (egg:mode-line-display))

(if (featurep 'xemacs)
    (defun fence-mode-help-command ()
      "Display fence mode help"
      (interactive "_")
      (let ((w (selected-window)))
	(describe-function 'wnn7-egg-mode)
	(ding)
	(select-window w)))
  (defun fence-mode-help-command ()
    "Display fence mode help"
    (interactive)
    (let ((w (selected-window)))
      (describe-function 'wnn7-egg-mode)
      (ding)
      (select-window w))))

(if (featurep 'xemacs)
    (defvar fence-mode-map (make-sparse-keymap))
  (defvar fence-mode-map (append '(keymap (t . undefined)
					  (?\C-x keymap (t . undefined)))
				 function-key-map))
  (defvar fence-mode-esc-map nil)
  (define-prefix-command 'fence-mode-esc-map)
  (define-key fence-mode-map "\e" fence-mode-esc-map)
  (define-key fence-mode-map [escape] fence-mode-esc-map)
  (define-key fence-mode-esc-map [t]  'undefined))

(substitute-key-definition 'egg-self-insert-command
			   'fence-self-insert-command
			   fence-mode-map global-map)

(if (featurep 'xemacs)
    (set-keymap-default-binding fence-mode-map 'undefined))

(define-key fence-mode-map "\eh"  'fence-hiragana)
(define-key fence-mode-map "\ek"  'fence-katakana)
(define-key fence-mode-map "\e<"  'fence-hankaku)
(define-key fence-mode-map "\e>"  'fence-zenkaku)
(define-key fence-mode-map "\e\C-h" 'its:select-hiragana)
(define-key fence-mode-map "\e\C-k" 'its:select-katakana)
(define-key fence-mode-map "\eq"    'its:select-downcase)
(define-key fence-mode-map "\eQ"    'its:select-upcase)
(define-key fence-mode-map "\ez"    'its:select-zenkaku-downcase)
(define-key fence-mode-map "\eZ"    'its:select-zenkaku-upcase)
(define-key fence-mode-map " "    'henkan-fence-region-or-single-space)
(define-key fence-mode-map "\C-@" 'henkan-fence-region)
;;(define-key fence-mode-map [(control \ )] 'henkan-fence-region)
(define-key fence-mode-map "\C-\ " 'henkan-fence-region)
(define-key fence-mode-map "\C-a" 'fence-beginning-of-line)
(define-key fence-mode-map "\C-b" 'fence-backward-char)
(define-key fence-mode-map "\C-c" 'fence-cancel-input)
(define-key fence-mode-map "\C-d" 'fence-delete-char)
(define-key fence-mode-map "\C-e" 'fence-end-of-line)
(define-key fence-mode-map "\C-f" 'fence-forward-char)
(define-key fence-mode-map "\C-g" 'fence-cancel-input)
(define-key fence-mode-map "\C-h" 'fence-mode-help-command)
(define-key fence-mode-map "\C-i" 'egg-predict-start-parttime); for wnn7
(define-key fence-mode-map "\C-k" 'fence-kill-line)
(define-key fence-mode-map "\C-l" 'fence-exit-mode)
(define-key fence-mode-map "\C-m" 'fence-exit-mode)  ;;; RET
(define-key fence-mode-map "\C-q" 'its:select-previous-mode)
(define-key fence-mode-map "\C-t" 'fence-transpose-chars)
(define-key fence-mode-map "\C-w" 'henkan-fence-region)
(define-key fence-mode-map "\C-z" 'eval-expression)
(define-key fence-mode-map "\C-\\" 'fence-toggle-egg-mode)
(define-key fence-mode-map "\C-_" 'jis-code-input)
(define-key fence-mode-map "\177" 'fence-backward-delete-char)
(define-key fence-mode-map [backspace] 'fence-backward-delete-char)
(define-key fence-mode-map [clear]     'fence-cancel-input)
(define-key fence-mode-map [delete]    'fence-backward-delete-char)
(define-key fence-mode-map [help]      'fence-mode-help-command)
(when (featurep 'xemacs)
  (define-key fence-mode-map [kp-enter]  'fence-exit-mode)
  (define-key fence-mode-map [kp-left]   'fence-backward-char)
  (define-key fence-mode-map [kp-right]  'fence-forward-char))
(define-key fence-mode-map [left]      'fence-backward-char)
(define-key fence-mode-map [return]    'fence-exit-mode)
(define-key fence-mode-map [right]     'fence-forward-char)

(unless (assq 'egg:*in-fence-mode* minor-mode-map-alist)
  (setq minor-mode-map-alist
	(cons (cons 'egg:*in-fence-mode* fence-mode-map)
	      minor-mode-map-alist)))

;;;----------------------------------------------------------------------
;;;
;;; Read hiragana from minibuffer
;;;
;;;----------------------------------------------------------------------

(defvar egg:*minibuffer-local-hiragana-map* (copy-keymap minibuffer-local-map))

(substitute-key-definition 'egg-self-insert-command
			   'fence-self-insert-command
			   egg:*minibuffer-local-hiragana-map*
			   global-map)

(defun read-hiragana-string (prompt &optional initial-input)
  (save-excursion
    (let ((minibuff (window-buffer (minibuffer-window))))
      (set-buffer minibuff)
      (setq egg:*input-mode* t
	    egg:*mode-on*    t
	    its:*current-map* (its:get-mode-map "roma-kana"))
      (mode-line-egg-mode-update (its:get-mode-indicator its:*current-map*))))
  (read-from-minibuffer prompt initial-input
		       egg:*minibuffer-local-hiragana-map*))

(defun read-kanji-string (prompt &optional initial-input)
  (save-excursion
    (let ((minibuff (window-buffer (minibuffer-window))))
      (set-buffer minibuff)
      (setq egg:*input-mode* t
	    egg:*mode-on*    t
	    its:*current-map* (its:get-mode-map "roma-kana"))
      (mode-line-egg-mode-update (its:get-mode-indicator "roma-kana"))))
  (read-from-minibuffer prompt initial-input))

(defconst isearch:read-kanji-string 'read-kanji-string)

;;; 記号入力

(defvar special-symbol-input-point nil)

(defun special-symbol-input ()
  (interactive)
  (require 'wnn7egg-jsymbol)
  ;; 92.7.8 by Y.Kawabe
  (let ((item (menu:select-from-menu
	       *symbol-input-menu* special-symbol-input-point t))
	(code t))
    (and (listp item)
	 (setq code (car item) special-symbol-input-point (cdr item)))
    ;; end of patch
    (cond((stringp code) (insert code))
	 ((consp code) (eval code))
	 )))

;;(autoload 'busyu-input "busyu" nil t)	;92.10.18 by K.Handa
;;(autoload 'kakusuu-input "busyu" nil t)	;92.10.18 by K.Handa


(its-autoload-mode-map "roma-kana" "its-v309/hira.el")
(its-autoload-mode-map "roma-kata" "its-v309/kata.el")
(its-autoload-mode-map "downcase" "its-v309/hankaku.el")
(its-autoload-mode-map "upcase" "its-v309/hankaku.el")
(its-autoload-mode-map "zenkaku-downcase" "its-v309/zenkaku.el")
(its-autoload-mode-map "zenkaku-upcase" "its-v309/zenkaku.el")
(setq-default its:*current-map* (its:get-mode-map "roma-kana"))
(setq its:*standard-modes*
      (append
       (list (its:get-mode-map "roma-kana")
	     (its:get-mode-map "roma-kata")
	     (its:get-mode-map "downcase")
	     (its:get-mode-map "upcase")
	     (its:get-mode-map "zenkaku-downcase")
	     (its:get-mode-map "zenkaku-upcase"))
       its:*standard-modes*))

(defun wnn7-egg-mode ()
  "Install and start the egg input method.
The keys that are defined for the fence mode (which is the translation
part of egg) are:\\{fence-mode-map}"
  (interactive)
  (define-key global-map "\C-^"  'special-symbol-input)
  (let ((newmodeline 
	 (list 'display-minibuffer-mode-in-minibuffer
	       ;; minibuffer mode in minibuffer
	       (list 
		(list 'its:*previous-map* "<" "[")
		'mode-line-egg-mode
		(list 'its:*previous-map* ">" "]")
		)
	       ;; minibuffer mode in mode line
	       (list 
		(list 'minibuffer-window-selected
		      (list 'display-minibuffer-mode
			    "m"
			    " ")
		      " ")
		(list 'its:*previous-map* "<" "[")
		(list 'minibuffer-window-selected
		      (list 'display-minibuffer-mode
			    'mode-line-egg-mode-in-minibuffer
			    'mode-line-egg-mode)
		      'mode-line-egg-mode)
		(list 'its:*previous-map* ">" "]")
		))))
    (if (featurep 'xemacs)
	(if (not (egg:find-symbol-in-tree 'mode-line-egg-mode modeline-format))
	    (setq-default modeline-format (cons newmodeline
						modeline-format)))
      (if (not (egg:find-symbol-in-tree 'mode-line-egg-mode mode-line-format))
	  (setq-default mode-line-format (cons newmodeline
					      mode-line-format))))
    (if (featurep 'xemacs)
      (progn
	;; put us into the modeline of all existing buffers
	(mapc (lambda (buf)
		(save-excursion
		  (set-buffer buf)
		  (if (not (egg:find-symbol-in-tree 'mode-line-egg-mode modeline-format))
		      (setq modeline-format
			    (cons newmodeline
				  modeline-format)))))
	      (buffer-list)))))
  (if (boundp 'select-window-hook)
      (add-hook 'select-window-hook 'egg:select-window-hook)
    (add-hook 'minibuffer-exit-hook 'egg:minibuffer-exit-hook)
    (add-hook 'minibuffer-entry-hook 'egg:minibuffer-entry-hook))
  (mode-line-egg-mode-update mode-line-egg-mode)
  (if its:*reset-modeline-format*
      (if (featurep 'xemacs)
	  (setq-default modeline-format (cdr modeline-format))
	(setq-default mode-line-format (cdr mode-line-format))))
  ;; if set-lang-environment has already been called,
  ;; call egg-lang-switch-callback
  (if (not (null current-language-environment))
      (egg-lang-switch-callback))

  )

;;(defun wnn7-p ()
;;  (if current-input-method
;;      (string-match "japanese-egg-wnn7" current-input-method)))


(provide 'wnn7egg)

;;; wnn7egg.el ends here
