;; Wnn7Egg is Egg modified for Wnn7, and the current maintainer 
;; is OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;;
;; This file is part of Wnn7Egg. 
;;  (base code is egg/wnn.el (eggV4) and wnnfns.c)
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

;;; wnn7egg-lib.el --- high level Interface with Wnn7 Jserver

;; Copyright (C) 2001 OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>

;; Author: OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;; Keywords: input method

;; This file is part of Wnn7Egg.
;; And this file is composed from egg/wnn.el (eggV4) and wnnfns.c (eggV3.09)
;; egg/wnn.el --- WNN Support (high level interface) in Egg
;;                Input Method Architecture
;; Copyright (C) 1999,2000 PFU LIMITED
;; Author: NIIBE Yutaka <gniibe@chroot.org>
;;         KATAYAMA Yoshio <kate@pfu.co.jp>
;; wnnfns.c --- Jserver Interface for Mule
;; Coded by Yutaka Ishikawa at ETL (yisikawa@etl.go.jp)
;;          Satoru Tomura   at ETL (tomura@etl.go.jp)

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the Free
;; Software Foundation Inc., 59 Temple Place - Suite 330, Boston,
;; MA 02111-1307, USA.

;;; Commentary:

;;; Change log:

;;; 2002/5/22 無変換辞書、文節切り辞書の追加処理の修正
;;; 2002/5/22 接頭語パラメータ prefix-flag の設定値の修正
;;; 2002/5/16 XEmacs でユーザ辞書の格納場所変更が正しく行なえない問題の対応
;;; 2002/5/16 ユーザ辞書のクライアント転送動作における不具合修正
;;; 2002/5/16 予測モード時に逆変換動作が正しく行なえない問題に対応
;;; 2001/9/30 v1.01 (bug fix)
;;; 2001/5/30 First Release

;;; Code:

;;; Last modified date: 2002/5/22

(require 'wnn7egg-edep)
(if (featurep 'xemacs)
    (require 'wnn7egg-rpcx21)
  (require 'wnn7egg-rpc))

(defun egg:error (form &rest mesg)
  (apply 'notify (or form "%s") mesg)
  (apply 'error (or form "%s") mesg))

(defvar wnn7-message-type 'japanese)
(defun wnn7-toggle-message-type ()
"Toggle whether wnn reports info in english or japanese."
  (interactive)
  (if (eq wnn7-message-type 'japanese)
      (setq wnn7-message-type 'english)
    (setq wnn7-message-type 'japanese)))

(defvar *wnn7-message-alist*
  '((english
     ((open-wnn "Connected with Wnn on host %s")
      (cannot-connect "Cannot connect with Wnn")
      (no-rcfile "No wnn7egg-startup-file on %s")
      (file-saved "Wnn dictionary and frequency data recorded.")
      (no-dir "directory %s missing. Create it? ")
      (fail-dir "failed to create directory %s")
      (create-dir "directory %s created")
      (no-dict1 "dictionary file %s is missing: %s")
      (no-dict2 "dictionary file %s is missing. Create it? ")
      (create-dict "dictionary file %s is created")
      (no-freq1 "frequency file %s is missing: %s")
      (no-freq2 "frequency file %s is missing. Create it? ")
      (create-freq "frequency file %s is created")
      (no-match "unmatch dictionary and freq. file %s. Re-create it? ")
      (re-create-freq "frequency file %s is re-created")
      (henkan-mode-indicator "漢")
      (begin-henkan "Fence starting character: ")
      (end-henkan "Fence ending character: ")
      (kugiri-dai "Large bunsetsu separator: ")
      (kugiri-sho "Small bunsetsu separator: ")
      (face-henkan "Face for conversion: ")
      (face-dai "Face for large bunsetsu: ")
      (face-sho "Face for small bunsetsu: ")
      (jikouho "Entries:")
      (off-msg "%s %s(%s:%s) turned off.")
      (henkan-help "Kanji conversion mode:
Bunsetsu motion commands
  \\[wnn7-henkan-first-bunsetu]\tFirst bunsetsu\t\\[wnn7-henkan-last-bunsetu]\tLast bunsetsu
  \\[wnn7-henkan-backward-bunsetu]\tPrevious bunsetsu\t\\[wnn7-henkan-forward-bunsetu]\tNext bunsetsu
Bunsetsu conversion commands
  \\[wnn7-henkan-next-kouho-dai]\tNext larger match\t\\[wnn7-henkan-next-kouho-sho]\tNext smaller match
  \\[wnn7-henkan-previous-kouho]\tPrevious match\t\\[wnn7-henkan-next-kouho]\tNext match
  \\[wnn7-henkan-bunsetu-nobasi-dai]\tExtend bunsetsu largest\t\\[wnn7-henkan-bunsetu-chijime-dai]\tShrink bunsetsu smallest
  \\[wnn7-henkan-bunsetu-nobasi-sho]\tExtend bunsetsu\t\\[wnn7-henkan-bunsetu-chijime-sho]\tShrink bunsetsu
  \\[wnn7-henkan-select-kouho-dai]\tMenu select largest match\t\\[wnn7-henkan-select-kouho-sho]\tMenu select smallest match
Conversion commands
  \\[wnn7-henkan-kakutei]\tComplete conversion commit\t\\[wnn7-henkan-kakutei-before-point]\tCommit before point
  \\[wnn7-henkan-quit]\tAbort conversion
")
      (hinsimei "Hinshi (product/noun) name:")
      (jishotouroku-yomi "Dictionary entry for『%s』 reading:")
      (touroku-jishomei "Name of dictionary:" )
      (registerd "Dictonary entry『%s』(%s: %s) registered in %s.")
      (yomi "Reading：")
      (no-yomi "No dictionary entry for 『%s』.")
      (jisho "Dictionary:")
      (hindo "Frequency:")
      (kanji "Kanji:")
      (no-predict "Not input-predict-mode.")
      (no-wnn7egg "Not wnn7egg.")
      (no-rensou "No association candidates.")
      (register-notify "Dictonary entry『%s』(%s: %s) registered in %s.")
      (cannot-remove "Cannot delete entry from system dictionary.")
      (enter-hindo "Enter frequency:")
      (remove-notify "Dictonary entry『%s』(%s) removed from %s.")
      (removed "Dictonary entry『%s』(%s) removed from %s.")
      (pseud-bunsetsu "pseud clause")
      (jishomei "Dictionary name:" )
      (comment "Comment:")
      (jisho-comment "Dictionary:%s: comment:%s")
      (param ("Ｎ ( 大 ) 文節解析のＮ"
	      "大文節中の小文節の最大数"
	      "幹語の頻度のパラメータ"
	      "小文節長のパラメータ"
	      "幹語長のパラメータ"
	      "今使ったよビットのパラメータ"
	      "辞書のパラメータ"
	      "小文節の評価値のパラメータ"
	      "大文節長のパラメータ"
	      "小文節数のパラメータ"
	      "疑似品詞 数字の頻度"
	      "疑似品詞 カナの頻度"
	      "疑似品詞 英数の頻度"
	      "疑似品詞 記号の頻度"
	      "疑似品詞 閉括弧の頻度"
	      "疑似品詞 付属語の頻度"
	      "疑似品詞 開括弧の頻度"))
      ))
    (japanese
     ((open-wnn "ホスト %s の Wnn を起動しました")
      (cannot-connect "Wnn と接続できませんでした")
      (no-rcfile "%s 上に wnn7egg-startup-file がありません。")
      (file-saved "Wnnの頻度情報・辞書情報を退避しました。")
      (no-dir "ディレクトリ %s がありません。作りますか? ")
      (fail-dir "ディレクトリ %s の作成に失敗しました")
      (create-dir "ディレクトリ %s を作りました")
      (no-dict1 "辞書ファイル %s がありません: %s")
      (no-dict2 "辞書ファイル %s がありません。作りますか? ")
      (create-dict "辞書ファイル %s を作りました")
      (no-freq1 "頻度ファイル %s がありません: %s")
      (no-freq2 "頻度ファイル %s がありません。作りますか? ")
      (create-freq "頻度ファイル %s を作りました")
      (no-match "辞書と頻度 %s の整合性がありません。作り直しますか? ")
      (re-create-freq "頻度ファイル %s を作り直しました")
      (henkan-mode-indicator "漢")
      (begin-henkan "変換開始文字列: ")
      (end-henkan "変換終了文字列: ")
      (kugiri-dai "大文節区切り文字列: ")
      (kugiri-sho "小文節区切り文字列: ")
      (face-henkan "変換区間表示属性: ")
      (face-dai "大文節区間表示属性: ")
      (face-sho "小文節区間表示属性: ")
      (jikouho "次候補:")
      (off-msg "%s %s(%s:%s)を off しました。")
      (henkan-help "漢字変換モード:
文節移動
  \\[wnn7-henkan-first-bunsetu]\t先頭文節\t\\[wnn7-henkan-last-bunsetu]\t後尾文節  
  \\[wnn7-henkan-backward-bunsetu]\t直前文節\t\\[wnn7-henkan-forward-bunsetu]\t直後文節
変換変更
  \\[wnn7-henkan-next-kouho-dai]\t大文節次候補\t\\[wnn7-henkan-next-kouho-sho]\t小文節次候補
  \\[wnn7-henkan-previous-kouho]\t前候補\t\\[wnn7-henkan-next-kouho]\t次候補    
  \\[wnn7-henkan-bunsetu-nobasi-dai]\t大文節伸し\t\\[wnn7-henkan-bunsetu-chijime-dai]\t大文節縮め  
  \\[wnn7-henkan-bunsetu-nobasi-sho]\t小文節伸し\t\\[wnn7-henkan-bunsetu-chijime-sho]\t小文節縮め  
  \\[wnn7-henkan-select-kouho-dai]\t大文節変換候補選択\t\\[wnn7-henkan-select-kouho-sho]\t小文節変換候補選択  
変換確定
  \\[wnn7-henkan-kakutei]\t全文節確定\t\\[wnn7-henkan-kakutei-before-point]\t直前文節まで確定  
  \\[wnn7-henkan-quit]\t変換中止    
")
      (hinsimei "品詞名:")
      (jishotouroku-yomi "辞書登録『%s』  読み :")
      (touroku-jishomei "登録辞書名:" )
      (registerd "辞書項目『%s』(%s: %s)を%sに登録しました。" )
      (yomi "よみ：")
      (no-yomi "辞書項目『%s』はありません。")
      (jisho "辞書：")
      (hindo " 頻度：")
      (kanji "漢字：")
      (no-predict "入力予測モードではありません。")
      (no-wnn7egg "使用中の input method は wnn7egg ではありません")
      (no-rensou "連想候補はありません。")
      (register-notify "辞書項目『%s』(%s: %s)を%sに登録します。")
      (cannot-remove "システム辞書項目は削除できません。")
      (enter-hindo "頻度を入れて下さい: ")
      (remove-notify "辞書項目『%s』(%s)を%sから削除します。")
      (removed "辞書項目『%s』(%s)を%sから削除しました。")
      (pseud-bunsetsu "疑似文節")
      (jishomei "辞書名:" )
      (comment "コメント: ")
      (jisho-comment "辞書:%s: コメント:%s")
      (param ("Ｎ ( 大 ) 文節解析のＮ"
	      "大文節中の小文節の最大数"
	      "幹語の頻度のパラメータ"
	      "小文節長のパラメータ"
	      "幹語長のパラメータ"
	      "今使ったよビットのパラメータ"
	      "辞書のパラメータ"
	      "小文節の評価値のパラメータ"
	      "大文節長のパラメータ"
	      "小文節数のパラメータ"
	      "疑似品詞 数字の頻度"
	      "疑似品詞 カナの頻度"
	      "疑似品詞 英数の頻度"
	      "疑似品詞 記号の頻度"
	      "疑似品詞 閉括弧の頻度"
	      "疑似品詞 付属語の頻度"
	      "疑似品詞 開括弧の頻度"))
      ))))

(defun wnn7-msg-get (message)
  (or
   (nth 1 (assoc message (nth 1 
			      (assoc wnn7-message-type *wnn7-message-alist*))))
   (format "No message. Check *wnn7-message-alist* %s %s"
	   wnn7-message-type message)))

;;;
;;; secure compatibility with eggV4 translation engine
;;;
(defcustom wnn-one-level-conversion nil
  "*Don't use major clause (dai bunsetu/da wenjie/dae munjeol), if non-NIL.")

(defcustom wnn-uniq-level 'wnn-uniq
  "Uniq level for candidate selection.
wnn-no-uniq:    Use all candidates.
wnn-uniq-entry: Use only one among same dictionary entry candidates.
wnn-uniq:       Use only one among same hinshi candidates. (default)
wnn-uniq-kanji: Use only one among same kanji candidates.")

(defcustom wnn-auto-save-dictionaries 0
  "*Save dictionaries automatically after N-th end conversion, if positive")

;; Retern value of system-name may differ from hostname.
(defconst wnn-system-name
  (or (with-temp-buffer
	(condition-case nil
	    (call-process "hostname"
			  nil `(,(current-buffer) nil) "hostname")
	  (error))
	(goto-char (point-min))
	(if (re-search-forward "[\0- ]" nil 0)
	    (goto-char (1- (point))))
	(if (> (point) 1)
	    (buffer-substring 1 (point))))
      (system-name)))

;;;
;;;
;;;
(defvar wnn7-process nil "Process Number to Wnn7 jserver")

(defvar wnn7-server-default-port 22273)
(defvar wnn7-server-proc-name "Wnn7")
(defvar wnn7-server-buffer-name "*Wnn7*")
(defvar wnn7-server-coding-system '(fixed-euc-jp fixed-euc-jp))

(defvar wnn7-active-server-name nil "connecting server host")
(defvar wnn7-active-server-port nil "connecting server port")

(defcustom wnn7-usr-dic-dir (concat "usr/" (user-login-name))
  "*Directory of user dictionary for Wnn.")

(defmacro WNN-const (c)
  (cond ((eq c 'BUN_SENTOU)    -1)
	((eq c 'NO_EXIST)       1)
	((eq c 'NO_MATCH)      10)
	((eq c 'IMA_OFF)       -4)
	((eq c 'IMA_ON)        -3)
	((eq c 'CONNECT)        1)
	((eq c 'CONNECT_BK)     1)
	((eq c 'HIRAGANA)      -1)
	((eq c 'KATAKANA)     -11)
	((eq c 'IKEIJI_ENTRY) -50)
	((eq c 'LEARNING_LEN)   3)
	((eq c 'MUHENKAN_DIC)  -3)
	((eq c 'HINDO_NOP)     -2)
	((eq c 'HINDO_INC)     -3)
	((eq c 'DIC_RW)         0)
	((eq c 'DIC_RDONLY)     1)
	((eq c 'DIC_GROUP)      3)
	((eq c 'DIC_MERGE)      4)
	((eq c 'NOTRANS_LEARN)  1)
	((eq c 'BMODIFY_LEARN)  2)
	((eq c 'WNN_REV_DICT)   3)
	((eq c 'WNN_FI_SYSTEM_DICT) 6)
	((eq c 'WNN_FI_USER_DICT) 7)
	((eq c 'WNN_GROUP_DICT)   9)
	((eq c 'WNN_MERGE_DICT)  10)
	((eq c 'WNNDS_FILE_READ_ERROR) 90)))
;;	((eq c 'DIC_NO_TEMPS)   #x3f))) ; cannot eval on xemacs

;; Retern value of system-name may differ from hostname.
(defconst wnn-system-name
  (or (with-temp-buffer
	(condition-case nil
	    (call-process "hostname"
			  nil `(,(current-buffer) nil) "hostname")
	  (error))
	(goto-char (point-min))
	(if (re-search-forward "[\0- ]" nil 0)
	    (goto-char (1- (point))))
	(if (> (point) 1)
	    (buffer-substring 1 (point))))
      (system-name)))

;;;
;;; environment information
;;;
(defvar wnn7-env-norm nil
  "Normal Dic-search Environment for Wnn7 conversion server")
(defvar wnn7-env-rev nil
  "Reverse Dic-search Environment for Wnn7 conversion server")
(defvar env-normal t
  "Select translation mode to normal if t")

(defun wnn7-env-create (proc env-id &optional name)
  (if name
      (set (setq name (make-symbol name)) (make-vector 5 nil)))
  (vector proc env-id name
	  (make-vector 2 (WNN-const DIC_RDONLY))))

(defsubst wnn7env-get-proc (env)      (aref env 0))
(defsubst wnn7env-get-env-id (env)    (aref env 1))
(defsubst wnn7env-get-hinshi (env h)  (or (get (aref env 2) h) -1))
(defsubst wnn7env-set-hinshi (env h v)(put (aref env 2) h v))
(defsubst wnn7env-get-auto-learn (env)(aref env 3))
(defsubst wnn7env-get-notrans (env)   (aref (wnn7env-get-auto-learn env) 0))
(defsubst wnn7env-get-bmodify (env)   (aref (wnn7env-get-auto-learn env) 1))
(defsubst wnn7env-set-notrans (env v) (aset (wnn7env-get-auto-learn env) 0 v))
(defsubst wnn7env-set-bmodify (env v) (aset (wnn7env-get-auto-learn env) 1 v))

(defun wnn7env-get-client-file (env name)
  (let ((hash (intern-soft name (symbol-value (aref env 2)))))
    (and hash (symbol-value hash))))

(defun wnn7env-set-client-file (env name)
  (set (intern (concat wnn-system-name "!" name) (symbol-value (aref env 2)))
       name))

(defun wnn7-set-hinshi (env sym name)
  (let ((hinshi (wnn7rpc-hinshi-number (wnn7env-get-proc env) name)))
    (if (>= hinshi 0)
	(wnn7env-set-hinshi env sym hinshi))))


;;;
;;; client information & bunsetsu information
;;;
;;;* 文節リスト。変換結果を受け取った形で小文節単位のリストになっている
(defvar wnn7-bun-list nil
  "Bunsetsu infomation for Wnn7 conversion server")

;; <wnn7-bunsetsu> ::= [ <env>
;;                      <jirilen> <dic-no> <entry> <freq> <right-now> <hinshi>
;;                     	<status> <status-backward> <kangovect> <evaluation>
;;                     	<converted> <yomi> <fuzokugo>
;;                     	<dai-evaluation> <dai-continue> <change-top>
;;                     	<zenkouho-info> <freq-down> <fi-rel> <context> ]
;;
;; <zenkouho-info> ::= [ <pos> <list> <converted> <dai> <prev-b> <nxet-b> ]
;;                    

(defsubst wnn7-bunsetsu-create (env jirilen dic-no entry freq right-now hinshi
			    status status-backward kangovect evaluation)
  (vector env jirilen dic-no entry freq right-now hinshi
	  status status-backward kangovect evaluation
	  nil nil nil nil nil nil nil nil nil nil))

(defsubst wnn7-bunsetsu-get-env (b)        (aref b 0))
(defsubst wnn7-bunsetsu-set-env (b env)    (aset b 0 env))
(defsubst wnn7-bunsetsu-get-jirilen (b)    (aref b 1))
(defsubst wnn7-bunsetsu-get-dic-no (b)     (aref b 2))
(defsubst wnn7-bunsetsu-set-dic-no (b dic) (aset b 2 dic))
(defsubst wnn7-bunsetsu-get-entry (b)      (aref b 3))
(defsubst wnn7-bunsetsu-set-entry (b ent)  (aset b 3 ent))
(defsubst wnn7-bunsetsu-get-freq (b)       (aref b 4))
(defsubst wnn7-bunsetsu-get-right-now (b)  (aref b 5))
(defsubst wnn7-bunsetsu-get-hinshi (b)     (aref b 6))
(defsubst wnn7-bunsetsu-get-status (b)     (aref b 7))
(defsubst wnn7-bunsetsu-get-status-backward (b)  (aref b 8))
(defsubst wnn7-bunsetsu-get-kangovect (b)  (aref b 9))
(defsubst wnn7-bunsetsu-get-evaluation (b) (aref b 10))

(defsubst wnn7-bunsetsu-get-converted (b)     (aref b 11))
(defsubst wnn7-bunsetsu-set-converted (b cvt) (aset b 11 cvt))

(defsubst wnn7-bunsetsu-get-yomi (b)       (aref b 12))
(defsubst wnn7-bunsetsu-set-yomi (b yomi)  (aset b 12 yomi))

(defsubst wnn7-bunsetsu-get-fuzokugo (b)          (aref b 13))
(defsubst wnn7-bunsetsu-set-fuzokugo (b fuzokugo) (aset b 13 fuzokugo))

(defsubst wnn7-bunsetsu-get-dai-evaluation (b)    (aref b 14))
(defsubst wnn7-bunsetsu-set-dai-evaluation (b de) (aset b 14 de))

(defsubst wnn7-bunsetsu-get-dai-continue (b)    (aref b 15))
(defsubst wnn7-bunsetsu-set-dai-continue (b dc) (aset b 15 dc))

(defsubst wnn7-bunsetsu-get-change-top (b)     (aref b 16))
(defsubst wnn7-bunsetsu-set-change-top (b top) (aset b 16 top))

(defsubst wnn7-bunsetsu-get-zenkouho (b)   (aref b 17))
(defsubst wnn7-bunsetsu-set-zenkouho (b z) (aset b 17 z))

(defsubst wnn7-bunsetsu-get-freq-down (b)    (aref b 18))
(defsubst wnn7-bunsetsu-set-freq-down (b fd) (aset b 18 fd))

(defsubst wnn7-bunsetsu-get-fi-rel (b)    (aref b 19))
(defsubst wnn7-bunsetsu-set-fi-rel (b fr) (aset b 19 fr))

(defsubst wnn7-bunsetsu-get-context (b)   (aref b 20))
(defsubst wnn7-bunsetsu-set-context (b c) (aset b 20 c))

(defsubst wnn7-zenkouho-create (pos list converted dai prev-b next-b)
  (vector pos list converted dai prev-b next-b))

(defsubst wnn7-bunsetsu-get-zenkouho-pos (b)
  (aref (wnn7-bunsetsu-get-zenkouho b) 0))
(defsubst wnn7-bunsetsu-set-zenkouho-pos (b p)
  (aset (wnn7-bunsetsu-get-zenkouho b) 0 p))

(defsubst wnn7-bunsetsu-get-zenkouho-list (b)
  (aref (wnn7-bunsetsu-get-zenkouho b) 1))
(defsubst wnn7-bunsetsu-get-zenkouho-converted (b)
  (aref (wnn7-bunsetsu-get-zenkouho b) 2))
(defsubst wnn7-bunsetsu-get-zenkouho-dai (b)
  (aref (wnn7-bunsetsu-get-zenkouho b) 3))
(defsubst wnn7-bunsetsu-get-zenkouho-prev-b (b)
  (aref (wnn7-bunsetsu-get-zenkouho b) 4))
(defsubst wnn7-bunsetsu-get-zenkouho-next-b (b)
  (aref (wnn7-bunsetsu-get-zenkouho b) 5))

(defsubst wnn7-bunsetsu-connect-prev (bunsetsu)
  (= (wnn7-bunsetsu-get-status bunsetsu) (WNN-const CONNECT)))
(defsubst wnn7-bunsetsu-connect-next (bunsetsu)
  (= (wnn7-bunsetsu-get-status-backward bunsetsu) (WNN-const CONNECT_BK)))

(defsubst wnn7-context-create (dic-no entry jirilen hinshi fuzokugo
			      converted freq right-now)
  (vector dic-no entry jirilen hinshi fuzokugo
	  converted freq right-now
	  (egg-chars-in-period converted 0 (length converted))))

(defsubst wnn7-context-dic-no (context)          (aref context 0))
(defsubst wnn7-context-entry (context)           (aref context 1))
(defsubst wnn7-context-jirilen (context)         (aref context 2))
(defsubst wnn7-context-hinshi (context)          (aref context 3))
(defsubst wnn7-context-fuzokugo (context)        (aref context 4))
(defsubst wnn7-context-converted (context)       (aref context 5))
(defsubst wnn7-context-freq (context)            (aref context 6))
(defsubst wnn7-context-set-freq (context f)      (aset context 6 f))
(defsubst wnn7-context-right-now (context)       (aref context 7))
(defsubst wnn7-context-set-right-now (context r) (aset context 7 r))
(defsubst wnn7-context-length (context)          (aref context 8))

(defun wnn7-null-context ()
  (list (wnn7-context-create -2 0 0 0 "" "" 0 0)
	(wnn7-context-create -2 0 0 0 "" "" 0 0)))

(defun wnn7-get-bunsetsu-converted (bunsetsu)
  (concat (wnn7-bunsetsu-get-converted bunsetsu)
	  (wnn7-bunsetsu-get-fuzokugo  bunsetsu)))

(defun wnn7-get-bunsetsu-source (bunsetsu)
  (concat (wnn7-bunsetsu-get-yomi bunsetsu)
	  (wnn7-bunsetsu-get-fuzokugo bunsetsu)))

(defun wnn7-get-major-bunsetsu-converted (bunsetsu)
  (mapconcat 'wnn7-get-bunsetsu-converted bunsetsu ""))

(defun wnn7-get-major-bunsetsu-source (bunsetsu) 
  (mapconcat 'wnn7-get-bunsetsu-source bunsetsu ""))

(defun wnn7-major-bunsetsu-set-context (bunsetsu-list context)
  (while bunsetsu-list
    (wnn7-bunsetsu-set-context (car bunsetsu-list) context)
    (setq bunsetsu-list (cdr bunsetsu-list))))

(defsubst wnn7-bunsetsu-equal (bunsetsu-1 bunsetsu-2)
  (and (= (wnn7-bunsetsu-get-dic-no bunsetsu-1)
	  (wnn7-bunsetsu-get-dic-no bunsetsu-2))
       (= (wnn7-bunsetsu-get-entry bunsetsu-1)
	  (wnn7-bunsetsu-get-entry bunsetsu-2))
       (= (wnn7-bunsetsu-get-kangovect bunsetsu-1)
	  (wnn7-bunsetsu-get-kangovect bunsetsu-2))
       (equal (wnn7-bunsetsu-get-converted bunsetsu-1)
	      (wnn7-bunsetsu-get-converted bunsetsu-2))
       (equal (wnn7-bunsetsu-get-fuzokugo bunsetsu-1)
	      (wnn7-bunsetsu-get-fuzokugo bunsetsu-2))))

(defun wnn7-bunsetsu-list-equal (b1 b2)
  (while (and b1 b2 (wnn7-bunsetsu-equal (car b1) (car b2)))
    (setq b1 (cdr b1)
	  b2 (cdr b2)))
  (and (null b1) (null b2)))

(defun wnn7-bunsetsu-list-copy (bunsetsu)
  (copy-sequence bunsetsu))

(defmacro wnn7-uniq-hash-string (uniq-level)
  `(mapconcat
    (lambda (b)
      (concat ,@(cond ((eq uniq-level 'wnn-uniq) 
		       '((number-to-string (wnn7-bunsetsu-get-hinshi b))))
		      ((eq uniq-level 'wnn-uniq-entry)
		       '((number-to-string (wnn7-bunsetsu-get-dic-no b))
			 "+"
			 (number-to-string (wnn7-bunsetsu-get-entry b)))))
	      "\0"
	      (wnn7-bunsetsu-get-converted b)
	      "\0"
	      (wnn7-bunsetsu-get-fuzokugo b)))
    bunsetsu "\0"))

(defun wnn7-uniq-hash (bunsetsu hash-table)
  (intern (cond ((eq wnn-uniq-level 'wnn-uniq)
		 (wnn7-uniq-hash-string wnn-uniq))
		((eq wnn-uniq-level 'wnn-uniq-entry)
		 (wnn7-uniq-hash-string wnn-uniq-entry))
		(t
		 (wnn7-uniq-hash-string nil)))
	  hash-table))

(defun wnn7-uniq-candidates (candidates)
  (if (eq wnn-uniq-level 'wnn-no-uniq)
      candidates
    (let ((hash-table (make-vector (length candidates) 0)))
      (delq nil (mapcar (lambda (b)
			  (let ((sym (wnn7-uniq-hash b hash-table)))
			    (if (null (boundp sym))
				(set sym b))))
			candidates)))))

(defun wnn7-server-zenkouho-bun-p (bunno)
  (let ((bunsetsu (nth bunno wnn7-bun-list)))
    (if (vectorp (wnn7-bunsetsu-get-zenkouho bunsetsu))
	t
      nil)))

(defun wnn7-get-major-bunsetsu (bunno)
  "get major bunsetsu of bunno position."
  (let ((bun (nth bunno wnn7-bun-list))
	bunsetsu)
    (while bun
      (setq bunsetsu (cons bun bunsetsu)
	    bunno (1+ bunno)
	    bun (and (wnn7-bunsetsu-get-dai-continue bun)
		     (nth bunno wnn7-bun-list))))
    (nreverse bunsetsu)))

(defun wnn7-get-minor-bunsetsu (bunno)
  "get minor bunsetsu of bunno positon."
  (list (nth bunno wnn7-bun-list)))

(defun wnn7-get-next-major-bunsetsu (bunno)
  "get all the major bunsetsu after bunno position."
  (let* ((bun1 (nth bunno wnn7-bun-list))
	 (bunno (1+ bunno))
	 (bun2 (nth bunno wnn7-bun-list))
	 bunsetsu)
    (while (and bun1 bun2)
      (if (null (wnn7-bunsetsu-get-dai-continue bun1))
	  (while bun2
	    (setq bunsetsu (cons bun2 bunsetsu)
		  bunno (1+ bunno)
		  bun2 (nth bunno wnn7-bun-list)))
	(setq bun1 (nth bunno wnn7-bun-list)
	      bunno (1+ bunno)
	      bun2 (nth bunno wnn7-bun-list))))
    (nreverse bunsetsu)))

(defun wnn7-get-pre-prev-bunsetsu (bunno)
  "get all bunsetsu before bunno position."
  (let (bunsetsu)
    (while (<= 0 bunno)
      (setq bunsetsu (cons (nth bunno wnn7-bun-list) bunsetsu)
	    bunno (1- bunno)))
    bunsetsu))
      
(defun wnn7-get-prev-major-bunsetsu (bunno)
  "get part of major bunsetsu before bunno position."
  (let* ((bunno (1- bunno))
	 (bun (if (< bunno 0) nil (nth bunno wnn7-bun-list)))
	 bunsetsu)
    (while bun
      (setq bunsetsu (cons bun bunsetsu)
	    bunno (1- bunno))
      (if (< bunno 0)
	  (setq bun nil)
	(setq bun (nth bunno wnn7-bun-list))
	(if (null (wnn7-bunsetsu-get-dai-continue bun))
	    (setq bun nil))))
    (cons bunsetsu (1+ bunno))))

(defun wnn7-get-prev-minor-bunsetsu (bunno)
  "get minor bunsetsu before bunno position."
  (let ((bunno (1- bunno)))
    (if (< bunno 0) 
	nil
      (list (nth bunno wnn7-bun-list)))))

;;;
;;; dictionary file information
;;;
(defsubst wnn7dic-get-id (dic) (aref dic 0))
(defsubst wnn7dic-get-comment (dic) (aref dic 8))
(defsubst wnn7dic-get-dictname (dic) (aref dic 9))

(defsubst wnn7-dicinfo-entry (info)       (aref info 0))
(defsubst wnn7-dicinfo-id (info freq)     (aref info (+ 1 freq)))
(defsubst wnn7-dicinfo-mode (info freq)   (aref info (+ 3 freq)))
(defsubst wnn7-dicinfo-enable (info)      (aref info 5))
(defsubst wnn7-dicinfo-nice (info)        (aref info 6))
(defsubst wnn7-dicinfo-reverse (info)     (aref info 7))
(defsubst wnn7-dicinfo-comment (info)     (aref info 8))
(defsubst wnn7-dicinfo-name (info freq)   (aref info (+ 9 freq)))
(defsubst wnn7-dicinfo-passwd (info freq) (aref info (+ 11 freq)))
(defsubst wnn7-dicinfo-type (info)        (aref info 13))
(defsubst wnn7-dicinfo-words (info)       (aref info 14))
(defsubst wnn7-dicinfo-local (info freq)  (aref info (+ 15 freq)))


(defsubst wnn7-filename (p)
  (substitute-in-file-name
   (if (consp p) (concat wnn7-usr-dic-dir "/" (car p)) p)))

(defsubst wnn7-client-file-p (filename)
  (and (stringp filename)
       (= (aref filename 0) ?!)))

(defsubst wnn7-client-filename (filename)
  (substitute-in-file-name 
   (expand-file-name (substring filename 1) "~")))

;;;-----------------------------------------------------------------------

;;;
;;; open, connect, close 
;;;
(defun wnn7-comm-sentinel (proc reason)
  (let ((inhibit-quit t))
    (if (string= (process-status proc) "closed")
	(kill-buffer (process-buffer proc))
      (progn
	(delete-process proc)
	(kill-buffer (process-buffer proc))))))

(defun wnn7-server-start (hname)
  (let ((save-inhibit-quit inhibit-quit)
	(inhibit-quit t)
	(proc nil)
	buf msg)
    (unwind-protect
	(progn
	  (setq buf (generate-new-buffer wnn7-server-buffer-name))
	  (save-excursion
	    (set-buffer buf)
	    (erase-buffer)
	    (buffer-disable-undo)
	    (set-buffer-multibyte nil)
	    (setq egg-fixed-euc wnn7-server-coding-system))
	  (setq msg (format "Wnn: connecting to jserver at %s(%d)..." 
			    hname wnn7-active-server-port))
	  (message "%s" msg)
	  (let ((inhibit-quit save-inhibit-quit))
	    (condition-case nil
		(setq proc (open-network-stream wnn7-server-proc-name
						buf hname
						wnn7-active-server-port))
	      ((error quit))))
	  (when proc
	    (process-kill-without-query proc)
	    (if (featurep 'xemacs)
		(set-process-coding-system proc 'binary 'binary)
	      (set-process-coding-system proc 'no-conversion 'no-conversion))
	    (set-process-sentinel proc 'wnn7-comm-sentinel)
	    (set-marker-insertion-type (process-mark proc) t))
	  proc)
      (if proc
	  (message (concat msg "done"))
	(if buf (kill-buffer buf))
	(setq proc nil)))))
    
(defun wnn7-server-open (proc hname lname)
  (let ((result (wnn7rpc-open proc hname lname)))
    (when (/= 0 result)
      (delete-process wnn7-process)
      (kill-buffer (process-buffer proc))
      (setq wnn7-process nil))
    result))

(defun wnn7-server-connect (proc lname &optional rev)
  (let ((envid (wnn7rpc-connect proc lname))
	(env nil))
    (if (< envid 0)
	(progn
	  (egg:error "%s" (wnn7rpc-get-error-message (- envid)))
	  envid)
      (setq env (wnn7-env-create proc envid lname))
      (wnn7-set-hinshi env 'noun "名詞")
      (wnn7-set-hinshi env 'settou "接頭語(お)")
      (wnn7-set-hinshi env 'rendaku "連濁")
      (if rev
	  (setq wnn7-env-rev env)
	(setq wnn7-env-norm env))
      envid)))

(defun wnn7-server-isconnect ()
  (let ((status))
    (if (and wnn7-process
	     (setq status (process-status wnn7-process)))
	(if (or (equal 'open status) (equal 'run status))
	    t
	  nil)
      nil)))

(defun wnn7-server-close ()
  "Close the connection to jserver, Dictionary and frequency files are not saved."
  (if wnn7-env-norm
      (wnn7rpc-disconnect wnn7-env-norm))
  (if wnn7-env-rev
      (wnn7rpc-disconnect wnn7-env-rev))
  (if (wnn7-server-isconnect)
      (wnn7rpc-close wnn7-process))
  (delete-process wnn7-process)
  (kill-buffer (process-buffer wnn7-process))
  (setq wnn7-process nil
	wnn7-env-norm nil
	wnn7-env-rev nil
	wnn7-bun-list nil))

(defun wnn7-server-set-rev (rev)
  (if (null rev)
      (progn
	;;(wnn7-bunsetsu-set-env wnn7-buf wnn7-env-norm)
	(setq env-normal t))
    ;;(wnn7-bunsetsu-set-env wnn7-buf wnn7-env-rev)
    (setq env-normal nil)))

;;;
;;;
;;; dictionary & hinshi
;;;
;;;

(defun wnn7-server-hinsi-name (no)
  (wnn7rpc-hinshi-name wnn7-process no))

(defun wnn7-server-dict-list ()
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev)))
    (wnn7-get-dictionary-list-with-environment env)))

(defun wnn7-get-dictionary-list-with-environment (env)
  (wnn7rpc-get-fi-dictionary-list-with-environment env wnn7-dic-no-temps))

(defun wnn7-server-dict-comment (env dicno comment)
 (let (dinfo fid)
   (setq dinfo (wnn7rpc-get-dictionary-info env dicno))
   (setq fid (wnn7-dicinfo-id dinfo 0))
   (wnn7rpc-set-file-comment env fid comment)))

(defun wnn7-file-loaded-client (env name fid)
  (let ((len (length wnn-system-name))
	local-name)
    (and (> (length name) len)
	 (equal (substring name 0 len) wnn-system-name)
	 (prog1
	     (wnn7-client-file-p (substring name len))
	   (setq local-name (wnn7-client-filename (substring name len))))
	 (= (wnn7rpc-file-loaded-local (wnn7env-get-proc env) local-name t) 
	    fid)
	 local-name)))

(defun wnn7-server-dict-save ()
  "Save all dictionaries and frequency files."
  (let* ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	 (dic-list (wnn7-get-dictionary-list-with-environment env))
	 info freq fid name local-name)
    (while dic-list
      (setq info (car dic-list)
	    dic-list (cdr dic-list)
	    freq 0)
      (while (<= freq 1)
	(setq fid (wnn7-dicinfo-id info freq)
	      name (wnn7-dicinfo-name info freq))
	(if (and (> fid 0) (= (wnn7-dicinfo-mode info freq) 0))
	    (cond
	     ((= (wnn7-dicinfo-local info freq) 1)
	      (wnn7rpc-write-file env fid name))
	     ((setq local-name (wnn7env-get-client-file env name))
	      (wnn7rpc-file-receive env fid local-name))
	     ((and (setq local-name (wnn7-file-loaded-client env name fid))
		   (file-writable-p local-name))
	      (wnn7rpc-file-receive env fid local-name))))
	(setq freq (1+ freq))))))

(defun wnn7-server-inspect (bunno)
  (let* ((bunsetsu (nth bunno wnn7-bun-list))
	 (env (wnn7-bunsetsu-get-env bunsetsu))
	 (converted (wnn7-get-bunsetsu-converted bunsetsu))
	 (yomi (wnn7-bunsetsu-get-yomi bunsetsu))
	 (fuzokugo (wnn7-bunsetsu-get-fuzokugo bunsetsu))
	 (hinshi-no (wnn7-bunsetsu-get-hinshi bunsetsu))
	 (dic-no (wnn7-bunsetsu-get-dic-no bunsetsu))
	 (entry (wnn7-bunsetsu-get-entry bunsetsu))
	 (now (wnn7-bunsetsu-get-right-now bunsetsu))
	 (freq (wnn7-bunsetsu-get-freq bunsetsu))
	 (evaluation (wnn7-bunsetsu-get-evaluation bunsetsu))
	 (evaluation-dai (or (wnn7-bunsetsu-get-dai-evaluation bunsetsu) 
			     "---"))
	 (kangovect (wnn7-bunsetsu-get-kangovect bunsetsu))
	 hinshi dic)
    (setq hinshi (wnn7rpc-hinshi-name (wnn7env-get-proc env) hinshi-no))
    (setq dic (if (>= dic-no 0)
		  (wnn7-dict-name (car (wnn7rpc-get-dictionary-info env dic-no)))
		(wnn7-msg-get 'pseud-bunsetsu)))
    (format "%s %s+%s(%s %s:%s Freq:%s%s) S:%s D:%s V:%s "
	     converted yomi fuzokugo hinshi dic entry
	     (if (= now 1) "*" " ") freq evaluation evaluation-dai kangovect)))

(defun wnn7-dict-name (dic-info)
  (let ((comment (wnn7dic-get-comment dic-info))
	(name (wnn7dic-get-dictname dic-info)))
    (cond ((null (string= comment "")) comment)
	  ((wnn7-client-file-p name) name)
	  (t (file-name-nondirectory name)))))

;;;
;;;
;;; dictionary file operation
;;;
;;;
(defun wnn7-server-fisys-dict-add (dname fname frw &optional fpass)
  (wnn7-server-dict-add-body t dname fname t nil frw nil fpass))

(defun wnn7-server-fiusr-dict-add (dname fname drw frw &optional dpass fpass)
  (wnn7-server-dict-add-body t dname fname nil drw frw dpass fpass))

(defun wnn7-server-dict-add (dname fname prior drw frw &optional dpass fpass)
  (wnn7-server-dict-add-body nil dname fname prior drw frw dpass fpass))

(defun wnn7-server-dict-add-body (fi dname fname prior drw frw dpass fpass)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(rev (if env-normal nil t))
	did fid result)
    (if (equal dname "") (setq dname nil))
    (if (equal fname "") (setq fname nil))
    (cond
     ((numberp (setq dpass (wnn7rpc-read-passwd-file dpass)))
      (message "%s" (wnn7rpc-get-error-message (- dpass)))
      nil)
     ((numberp (setq fpass (if fname (wnn7rpc-read-passwd-file fpass) "")))
      (message "%s" (wnn7rpc-get-error-message (- fpass)))
      nil)
     ((and (setq did (wnn7-open-dictionary env fi dname drw "" dpass fpass))
	   (setq fid (wnn7-open-frequency env fi did fname frw "" fpass)))
      (if fi
	  (setq result (wnn7rpc-set-fi-dictionary env did fid prior drw frw
						 dpass fpass))
	(setq drw (cond ((eq drw (WNN-const DIC_GROUP)) (WNN-const DIC_RW))
			((eq drw (WNN-const DIC_MERGE)) (WNN-const DIC_RDONLY))
			(t drw))
	      result (wnn7rpc-set-dictionary env did fid prior drw frw
					    dpass fpass rev)))
      (cond
       ((>= result 0) t)
       ((or (null frw) (/= result (- (WNN-const NO_MATCH))))
	(message "%s (%s): %s"
		 dname (if fname fname "")
		 (wnn7rpc-get-error-message (- result)))
	nil)
       ((and (y-or-n-p (format (wnn7-msg-get 'no-match) fname))
	     (>= (wnn7rpc-file-discard env fid) 0)
	     (wnn7-file-remove wnn7-process fname fpass)
	     (wnn7-create-frequency env fi did fname "" fpass))
	(message (wnn7-msg-get 're-create-freq) fname)
	(if fi
	    (setq prior (if prior
			    (wnn-const WNN_FI_SYSTEM_DICT)
			  (wnn-const WNN_FI_USER_DICT))))
	(and (>= (setq fid (wnn7-open-file env fname)) 0)
	     (>= (wnn7rpc-set-dictionary env 
					did fid prior drw frw
					dpass fpass rev)
		 0))))))))

(defun wnn7-file-remove (proc filename passwd)
  (let ((result (if (wnn7-client-file-p filename)
		    (wnn7rpc-file-remove-client
		     proc (wnn7-client-filename filename) passwd)
		  (wnn7rpc-file-remove proc (wnn7-filename filename) passwd))))
    (or (= result 0)
	(progn
	  (message (wnn7rpc-get-error-message (- result)))
	  nil))))

(defun wnn7-get-autolearning-dic-mode (env type)
  (let* ((dic (wnn7rpc-get-autolearning-dic env type))
	 (info (and (> dic 0) (wnn7rpc-get-dictionary-info env (1- dic)))))
    (if (vectorp (car-safe info))
	(wnn7-dicinfo-mode (car info) 0)
      (WNN-const DIC_RDONLY))))

(defun wnn7-server-bmodify-dict-add (dname prior drw &optional dpass)
  (let* ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	 (type (WNN-const BMODIFY_LEARN))
	 (did (wnn7rpc-get-autolearning-dic env type))
	 (param-list (wnn7-make-henkan-parameter))
	 (name 'bunsetsugiri)
	 mode vmask)
    (setq mode (wnn7-server-autolearn-dic-add type did dname prior drw dpass))
    (when mode
      (setq vmask (lsh 1 14))
      (aset param-list 14 (cond ((or (eq mode 0) (eq mode nil)) 0)
				((or (eq mode 1) (eq mode t))   1)
				(t (egg:error "%s: Wrong type argument" name))))
      (wnn7rpc-set-conversion-env-param env vmask param-list))
    (wnn7env-set-bmodify env (wnn7-get-autolearning-dic-mode
			     env (WNN-const BMODIFY_LEARN)))))

(defun wnn7-server-notrans-dict-add (dname prior drw &optional dpass)
  (let* ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	 (type (WNN-const NOTRANS_LEARN))
	 (did (wnn7rpc-get-autolearning-dic env type))
	 (param-list (wnn7-make-henkan-parameter))
	 (name 'muhenkan)
	 mode vmask)
    (setq mode (wnn7-server-autolearn-dic-add type did dname prior drw dpass))
    (when mode 
      (setq vmask (lsh 1 15))
      (aset param-list 15 (cond ((or (eq mode 0) (eq mode nil)) 0)
				((or (eq mode 1) (eq mode t))   1)
				(t (egg:error "%s: Wrong type argument" name))))
      (wnn7rpc-set-conversion-env-param env vmask param-list))
    (wnn7env-set-notrans env (wnn7-get-autolearning-dic-mode
			     env (WNN-const NOTRANS_LEARN)))))

(defun wnn7-temporary-dic-add (env rev)
  (let ((result (wnn7rpc-temporary-dic-loaded env)))
    (if (= result 0)
	(wnn7rpc-temporary-dic-add env rev)
      result)))

(defun wnn7-server-autolearn-dic-add (type did dname prior drw dpass)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(rev (if env-normal nil t))
	result)
    (or (numberp drw)
	(setq drw (if drw 0 1)))
    (cond
     ((< did 0)
      (message "%s" (wnn7rpc-get-error-message (- did)))
      nil)
     ((> did 0)
      (setq result (wnn7-temporary-dic-add env rev))
      (if (>= result 0)
	  drw
	(message "%s" (wnn7rpc-get-error-message (- result)))
	nil))
     ((numberp (setq dpass (wnn7rpc-read-passwd-file dpass)))
      (message "%s" (wnn7rpc-get-error-message (- dpass)))
      nil)
     ((setq did (wnn7-open-dictionary env nil dname t "" dpass "" nil))
      (if (and (>= (setq did (wnn7rpc-set-dictionary env did -1 prior drw drw
						    dpass "" rev))
		   0)
	       (>= (setq did (wnn7rpc-set-autolearning-dic env type did)) 0)
	       (>= (setq did (wnn7-temporary-dic-add env rev)) 0))
	  drw
	(message "%s" (wnn7rpc-get-error-message (- did)))
	nil)))))

(defun wnn7-server-fuzokugo-set (file)
  (let* ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	 fid result)
    (setq fid (wnn7-open-file env file))  
    (setq result (wnn7rpc-set-fuzokugo-file env fid))
    (if (< result 0)
	(message "%s" (wnn7rpc-get-error-message (- result))))
    result))

;;;
;;;
;;; parameter operation
;;;
;;;
;; henkan-parameter ::=[ <last-is-first> <complex> <okuri-learn>
;;                       <okuri> <prefix-learn> <prefix> <suffix-learn>
;;                       <common-learn> <freq-func> <numeric> <alphabet>
;;                       <symbol> <yuragi> <rendaku> <bunsetsugiri> 
;;                       <muhenkan> <fi-relation-learn> <fi-freq-func>
;;                       <yosoku-learn> <yosoku-max-disp>
;;                       <yosoku-last-is-first>
;;                       <boin-kabusoku> <shiin-choka> <n-choka>

(defun wnn7-make-henkan-parameter ()
  (make-vector 24 0))

(defmacro wnn7-make-henkan-parameter-list ()
  ''(last-is-first complex okuri-learn okuri
     prefix-learn prefix suffix-learn common-learn freq-func
     numeric alphabet symbol yuragi rendaku bunsetsugiri muhenkan
     fi-relation-learn fi-freq-func))

(defun wnn7-server-get-param ()
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev)))
    (wnn7rpc-get-conversion-parameter env)))

(defun wnn7-server-set-param (v)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev)))
    (wnn7rpc-set-conversion-parameter env v)))

(defun wnn7-server-set-last-is-first (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'last-is-first)
	vmask)
    (setq vmask (lsh 1 0))
    (aset param-list 0 (cond ((or (eq mode 0) (eq mode nil)) 0)
			     ((or (eq mode 1) (eq mode t))   1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-complex-conv-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'complex)
	vmask)
    (setq vmask (lsh 1 1))
    (aset param-list 1 (cond ((or (eq mode 0) (eq mode nil)) 0)
			     ((or (eq mode 1) (eq mode t))   1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-okuri-learn-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'okuri-learn)
	vmask)
    (setq vmask (lsh 1 2))
    (aset param-list 2 (cond ((or (eq mode 0) (eq mode nil)) 0)
			     ((or (eq mode 1) (eq mode t))   1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-okuri-flag (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'okuri)
	vmask)
    (setq vmask (lsh 1 3))
    (aset param-list 3 (cond ((or (eq mode -1) (eq mode 'regulation)) -1)
			     ((or (eq mode  0) (eq mode 'no))          0)
			     ((or (eq mode  1) (eq mode 'yes))         1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-prefix-learn-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'prefix-learn)
	vmask)
    (setq vmask (lsh 1 4))
    (aset param-list 4 (cond ((or (eq mode 0) (eq mode nil)) 0)
			     ((or (eq mode 1) (eq mode t))   1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-prefix-flag (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'prefix)
	vmask)
    (setq vmask (lsh 1 5))
    (aset param-list 5 (cond ((or (eq mode  0) (eq mode 'hiragana)) 0)
			     ((or (eq mode  1) (eq mode 'kanji))    1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-suffix-learn-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'suffix-learn)
	vmask)
    (setq vmask (lsh 1 6))
    (aset param-list 6 (cond ((or (eq mode 0) (eq mode nil)) 0)
			     ((or (eq mode 1) (eq mode t))   1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-common-learn-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'common-learn)
	vmask)
    (setq vmask (lsh 1 7))
    (aset param-list 7 (cond ((or (eq mode 0) (eq mode nil)) 0)
			     ((or (eq mode 1) (eq mode t))   1)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-freq-func-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'freq-func)
	vmask)
    (setq vmask (lsh 1 8))
    (aset param-list 8 (cond ((or (eq mode 0) (eq mode 'not))    0)
			     ((or (eq mode 1) (eq mode 'always)) 1)
			     ((or (eq mode 2) (eq mode 'high))   2)
			     ((or (eq mode 3) (eq mode 'normal)) 3)
			     ((or (eq mode 4) (eq mode 'low))    4)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-numeric-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'numeric)
	vmask)
    (setq vmask (lsh 1 9))
    (aset param-list 9 (cond ((or (eq mode  -2) (eq mode 'han))       -2)
			     ((or (eq mode -12) (eq mode 'zen))      -12)
			     ((or (eq mode -13) (eq mode 'kan))      -13)
			     ((or (eq mode -15) (eq mode 'kansuuji)) -15)
			     ((or (eq mode -16) (eq mode 'kanold))   -16)
			     ((or (eq mode -17) (eq mode 'hancan))   -17)
			     ((or (eq mode -18) (eq mode 'zencan))   -18)
			     (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-alphabet-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'alphabet)
	vmask)
    (setq vmask (lsh 1 10))
    (aset param-list 10 (cond ((or (eq mode  -4) (eq mode 'han))  -4)
			      ((or (eq mode -30) (eq mode 'zen)) -30)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-symbol-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'symbol)
	vmask)
    (setq vmask (lsh 1 11))
    (aset param-list 11 (cond ((or (eq mode  -5) (eq mode 'han))  -5)
			      ((or (eq mode -40) (eq mode 'jis)) -40)
			      ((or (eq mode -41) (eq mode 'asc)) -41)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-yuragi-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'yuragi)
	vmask)
    (setq vmask (lsh 1 12))
    (aset param-list 12 (cond ((or (eq mode 0) (eq mode nil)) 0)
			      ((or (eq mode 1) (eq mode t))   1)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-rendaku-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'rendaku)
	vmask)
    (setq vmask (lsh 1 13))
    (aset param-list 13 (cond ((or (eq mode 0) (eq mode nil)) 0)
			      ((or (eq mode 1) (eq mode t))   1)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-yosoku-learn-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'yosoku-learn)
	vmask)
    (setq vmask (lsh 1 22))
    (aset param-list 18 (cond ((or (eq mode 0) (eq mode nil)) 0)
			      ((or (eq mode 1) (eq mode t))   1)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))
  
(defun wnn7-server-set-yosoku-max-disp (max)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'yosoku-max-disp)
	vmask)
    (setq vmask (lsh 1 23))
    (aset param-list 19 (cond ((and (<= max 10) (>= max 1) max))
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-yosoku-last-is-first-mode (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'yosoku-last-is-first)
	vmask)
    (setq vmask (lsh 1 24))
    (aset param-list 20 (cond ((or (eq mode 0) (eq mode nil)) 0)
			      ((or (eq mode 1) (eq mode t))   1)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-boin-kabusoku (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'wnn7-set-boin-kabusoku)
	vmask)
    (setq vmask (lsh 1 26))
    (aset param-list 21 (cond ((or (eq mode 0) (eq mode nil)) 0)
			      ((or (eq mode 1) (eq mode t))   1)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-shiin-choka (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'wnn7-set-shiin-choka)
	vmask)
    (setq vmask (lsh 1 27))
    (aset param-list 22 (cond ((or (eq mode 0) (eq mode nil)) 0)
			      ((or (eq mode 1) (eq mode t))   1)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param env vmask param-list)))

(defun wnn7-server-set-n-choka (mode)
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(param-list (wnn7-make-henkan-parameter))
	(name 'wnn7-set-n-choka)
	vmaskh vmaskl)
    (setq vmaskh (lsh 1 12))
    (setq vmaskl 0)
    (aset param-list 23 (cond ((or (eq mode 0) (eq mode nil)) 0)
			      ((or (eq mode 1) (eq mode t))   1)
			      (t (egg:error "%s: Wrong type argument" name))))
    (wnn7rpc-set-conversion-env-param-highbit env vmaskh vmaskl param-list)))

(defconst HINSHI_NO_ATEJI 114)
(defconst HINSHI_NO_GOYOU 115)
(defconst HINSHI_NO_ATEJI_START 64946)
(defconst HINSHI_NO_ATEJI_END 64965)
(defconst HINSHI_NO_GOYOU_START 64925)
(defconst HINSHI_NO_GOYOU_END 64945)

(defun wnn7-server-set-nihongo-kosei (mode)
  ""
  (unless mode
    (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	  (hlist nil)
	  hend nhinshi)

      (setq hend HINSHI_NO_ATEJI_END)
      (setq hlist nil)
      (while (>= hend HINSHI_NO_ATEJI_START)
	(setq hlist (cons hend hlist)
	      hend (1- hend)))
      (setq hlist (cons HINSHI_NO_ATEJI hlist))
      (setq hlist (append hlist '(0)))
      (setq nhinshi (length hlist)
	    nhinshi (- nhinshi))
      (wnn7rpc-set-henkan-hinshi env 1 nhinshi hlist)

      (setq hend HINSHI_NO_GOYOU_END)
      (setq hlist nil)
      (while (>= hend HINSHI_NO_GOYOU_START)
	(setq hlist (cons hend hlist)
	      hend (1- hend)))
      (setq hlist (cons HINSHI_NO_GOYOU hlist))
      (setq hlist (append hlist '(0)))
      (setq nhinshi (length hlist)
	    nhinshi (- nhinshi))
      (wnn7rpc-set-henkan-hinshi env 1 nhinshi hlist)))
  0)

;;;
;;;
;;; file operation
;;;
;;;
(defun wnn7-open-file (env filename)
  "Open the file FILENAME on the environment ENV.
Return file ID.  NIL means NO-file.
On failure, return negative error code."
  (and filename
       (if (wnn7-client-file-p filename)
	   (wnn7rpc-file-send env (wnn7-client-filename filename))
	 (wnn7rpc-file-read env (wnn7-filename filename)))))

(defun wnn7-create-directory (env path noquery)
  "Create directory to the path.  Retun non-NIL value on success."
  (if (wnn7-client-file-p path)
      (let ((local-name (directory-file-name (file-name-directory
					      (wnn7-client-filename path)))))
	(cond
	 ((file-directory-p local-name) t)
	 ((or noquery
	      (y-or-n-p (format (wnn7-msg-get 'no-dir)
				(file-name-directory path))))
	  (make-directory local-name t)
	  ;; server 側のディレクトリも作成しておく
	  (wnn7-create-directory env (concat wnn7-usr-dic-dir "/foo") t)
	  (if (file-directory-p local-name)
	      (progn
		(message (wnn7-msg-get 'create-dir) path)
		t)
	    (message (wnn7-msg-get 'fail-dir) path)
	    nil))))
    (let ((name (directory-file-name (file-name-directory
				      (wnn7-filename path))))
	  create-list)
      (setq path name)
      (while (and name (/= (wnn7rpc-access env name 0) 0))
	(setq create-list (cons name create-list)
	      name (file-name-directory name)
	      name (and name (directory-file-name name))))
      (or (null create-list)
	  (if (or noquery
		  (y-or-n-p (format (wnn7-msg-get 'no-dir) path)))
	      (let ((result 0))
		(while (and (>= result 0) create-list)
		  (setq result (wnn7rpc-mkdir env (car create-list))
			create-list (cdr create-list)))
		(if (>= result 0)
		    (progn
		      (message (wnn7-msg-get 'create-dir) path)
		      t)
		  (message (wnn7-msg-get 'fail-dir) path)
		  nil)))))))
  
(defun wnn7-open-dictionary (env fi name rw comment dpasswd fpasswd
				 &optional noquery)
  (let ((dic-id (wnn7-open-file env name)))
    (cond
     ((null dic-id)
      (message "Wnn: cannot omit dictionary name")
      nil)
     ((>= dic-id 0) dic-id)
     ((or (null rw) (and (/= dic-id (- (WNN-const NO_EXIST)))
                        (/= dic-id (- (WNN-const WNNDS_FILE_READ_ERROR)))))
      (message (wnn7-msg-get 'no-dict1)
	       name (wnn7rpc-get-error-message (- dic-id)))
      nil)
     ((and (or noquery
	       (y-or-n-p (format (wnn7-msg-get 'no-dict2) name)))
	   (wnn7-create-directory env name noquery)
	   (wnn7-create-dictionary env name (wnn7rpc-writable-dic-type env fi rw)
				  comment dpasswd fpasswd))
      (message (wnn7-msg-get 'create-dict) name)
      (setq dic-id (wnn7-open-file env name))
      (if (>= dic-id 0)
	  dic-id
	(message "%s" (wnn7rpc-get-error-message (- dic-id)))
	nil)))))

(defun wnn7-create-dictionary (env name type comment dpasswd fpasswd)
  "Create a dictionary file on the server or the client depending on name."
  (let ((result (if (wnn7-client-file-p name)
		    (wnn7rpc-dic-file-create-client
		     env (wnn7-client-filename name) type
		     comment dpasswd fpasswd)
		  (wnn7rpc-dic-file-create
		   env (wnn7-filename name) type comment dpasswd fpasswd))))
    (or (= result 0)
	(progn
	  (message (wnn7rpc-get-error-message (- result)))
	  nil))))

(defun wnn7-open-frequency (env fi dic-id name rw comment passwd)
  (let ((freq-id (wnn7-open-file env name)))
    (cond
     ((null freq-id) -1)
     ((>= freq-id 0) freq-id)
     ((or (null rw) (and (/= freq-id (- (WNN-const NO_EXIST)))
			 (/= freq-id (- (WNN-const WNNDS_FILE_READ_ERROR)))))
      (message (wnn7-msg-get 'no-freq1)
	       name (wnn7rpc-get-error-message (- freq-id)))
      nil)
     ((and (y-or-n-p
	    (format (wnn7-msg-get 'no-freq2) name))
	   (wnn7-create-directory env name nil)
	   (wnn7-create-frequency env fi dic-id name comment passwd))
      (message (wnn7-msg-get 'create-freq) name)
      (setq freq-id (wnn7-open-file env name))
      (if (>= freq-id 0)
	  freq-id
	(message "%s" (wnn7rpc-get-error-message (- freq-id)))
	nil)))))

(defun wnn7-create-frequency (env fi dic-id name comment passwd)
  "Create a frequency file on the server or the client depending on name."
  (let ((result (if (wnn7-client-file-p name)
		    (wnn7rpc-hindo-file-create-client
		     env fi dic-id (wnn7-client-filename name) comment passwd)
		  (wnn7rpc-hindo-file-create
		   env fi dic-id (wnn7-filename name) comment passwd))))
    (or (= result 0)
	(progn
	  (message (wnn7rpc-get-error-message (- result)))
	  nil))))

;;;
;;; henkan 
;;;
(defun wnn7-server-henkan-begin (yomi)
  ;; bun_no = 0, bun_no2 = -1, USE_MAE  
  (let ((env (if env-normal wnn7-env-norm wnn7-env-rev))
	(hinshi (WNN-const BUN_SENTOU))
	(fuzokugo "")
	(v nil)
	result context)
    (setq context (wnn7-null-context)
	  result  (wnn7-renbunsetsu-conversion env yomi hinshi fuzokugo v
					       context))
    (if (numberp result)
	(progn
	  (egg:error "%s" (wnn7rpc-get-error-message (- result)))
	  nil)
      (if wnn-one-level-conversion
	  (while (consp result)
	    (wnn7-bunsetsu-set-dai-continue (car result) nil)
	    (setq result (cdr result))))
      (setq wnn7-bun-list result)
      (setq result (cons (length result) result)))))

(defun wnn7-server-bunsetu-kanji (bunno)
  (let* ((bunsetsu (nth bunno wnn7-bun-list))
	 (kanji (wnn7-get-bunsetsu-converted bunsetsu)))
    kanji))

(defun wnn7-server-bunsetu-yomi (bunno)
  (let* ((bunsetsu (nth bunno wnn7-bun-list))
	 (yomi (wnn7-get-bunsetsu-source bunsetsu)))
    yomi))

(defun wnn7-server-dai-top (bunno)
  "文節が大文節の先頭なら t"
  (let ((bun1 (nth bunno wnn7-bun-list))
	bun2)
    (if (< (setq bunno (1- bunno)) 0)
	t
      (setq bun2 (nth bunno wnn7-bun-list))
      (if (and (null (wnn7-bunsetsu-get-dai-continue bun2))
	       (or (wnn7-bunsetsu-get-dai-continue bun1)
		   (null (wnn7-bunsetsu-get-dai-continue bun1))))
	  t
	nil))))

(defun wnn7-server-dai-end (bunno)
   "次の大文節の文節番号を得る"
  (let ((bunlist (nthcdr bunno wnn7-bun-list)))
    (setq bunno (1+ bunno))
    (while (and (cdr bunlist)
		(wnn7-bunsetsu-get-dai-continue (car bunlist)))
      (setq bunno (1+ bunno))
      (setq bunlist (cdr bunlist)))
    bunno))

(defsubst wnn7-server-bunsetu-suu ()
  (length wnn7-bun-list))

(defun wnn7-get-bunsetsu-tail (b)
  (if b
      (nth (1- (length b)) b)
    nil))

(defun wnn7-get-bunsetsu-candidates (env yomi hinshi fuzokugo v major)
  (cond
   (wnn-one-level-conversion
    (let ((result (wnn7rpc-get-bunsetsu-candidates env yomi hinshi fuzokugo v)))
      (prog1
	  result
	(while (consp result)
	  (wnn7-bunsetsu-set-dai-continue (caar result) nil)
	  (setq result (cdr result))))))
   ((null major)
    (wnn7rpc-get-bunsetsu-candidates env yomi hinshi fuzokugo v))
   (t
    (wnn7rpc-get-daibunsetsu-candidates env yomi hinshi fuzokugo v))))

(defun wnn7-server-get-zenkouho (bunno)
  (let ((bunsetsu (nth bunno wnn7-bun-list)))
    (wnn7-bunsetsu-get-zenkouho-converted bunsetsu)))

(defun wnn7-get-candidates-converted (candidates)
  (mapcar 'wnn7-get-major-bunsetsu-converted candidates))

(defun wnn7-set-candidate-info (bunsetsu zenkouho)
  (wnn7-bunsetsu-set-zenkouho (car bunsetsu) zenkouho)
  (mapcar (lambda (b) (wnn7-bunsetsu-set-zenkouho b t)) (cdr bunsetsu)))

(defun wnn7-server-zenkouho (bunno major)
  "if dai is t, get daibunsetsu candidates"
  (let (bunsetsu head env yomi next-b prev-b hinshi 
		 fuzokugo converted cand pos v)
    (if major
	(setq bunsetsu (wnn7-get-major-bunsetsu bunno)
	      prev-b (car (wnn7-get-prev-major-bunsetsu bunno))
	      next-b (wnn7-get-next-major-bunsetsu bunno))
      (setq bunsetsu (wnn7-get-minor-bunsetsu bunno)
	    prev-b (wnn7-get-prev-minor-bunsetsu bunno)
	    next-b (if (nthcdr (1+ bunno) wnn7-bun-list)
		       (nthcdr (1+ bunno) wnn7-bun-list)
		     nil)))
    (setq head (car bunsetsu)
	  env (wnn7-bunsetsu-get-env head)
	  yomi (wnn7-get-major-bunsetsu-source bunsetsu))
    (if prev-b
	(setq prev-b (wnn7-get-bunsetsu-tail prev-b)
	      hinshi (wnn7-bunsetsu-get-hinshi prev-b)
	      fuzokugo (wnn7-bunsetsu-get-fuzokugo prev-b))
      (setq hinshi -1
	    fuzokugo ""))
    (if next-b
	(setq next-b (car next-b)
	      v (wnn7-bunsetsu-get-kangovect next-b)))
    (if (vectorp (wnn7-bunsetsu-get-zenkouho head))
	(setq pos (wnn7-bunsetsu-get-zenkouho-pos head)
	      cand (wnn7-bunsetsu-get-zenkouho-list head)))
    (if (and pos
	     (wnn7-bunsetsu-list-equal bunsetsu (nth pos cand))
	     (eq major (wnn7-bunsetsu-get-zenkouho-dai head))
	     (eq prev-b (wnn7-bunsetsu-get-zenkouho-prev-b head))
	     (eq next-b (wnn7-bunsetsu-get-zenkouho-next-b head)))
	(cons pos (wnn7-bunsetsu-get-zenkouho-converted head))
      (setq cand (wnn7-get-bunsetsu-candidates env yomi hinshi fuzokugo v major))
      (if (numberp cand)
	  (egg:error "%s" (wnn7rpc-get-error-message (- cand))))
      (setq pos (wnn7-candidate-pos bunsetsu cand))
      (cond ((< pos 0)
	     (setq cand (cons (wnn7-bunsetsu-list-copy bunsetsu) cand)))
	    ((and (> pos 0)
		  (null (eq (wnn7-bunsetsu-get-zenkouho head) t)))
	     (setq cand (cons (nth pos cand) (delq (nth pos cand) cand)))))
      (setq cand (wnn7-uniq-candidates cand)
	    pos (wnn7-candidate-pos bunsetsu cand)
	    converted (wnn7-get-candidates-converted cand))
      (wnn7-set-candidate-info bunsetsu
			      (wnn7-zenkouho-create pos cand converted
						   major prev-b next-b))
      (wnn7-add-freq-down head cand)
      (cons pos converted))))
      
(defsubst wnn7-uniq-bunsetsu-equal (bunsetsu-1 bunsetsu-2)
  (and (or (eq wnn-uniq-level 'wnn-uniq-kanji)
	   (and (eq wnn-uniq-level 'wnn-uniq)
		(= (wnn7-bunsetsu-get-hinshi bunsetsu-1)
		   (wnn7-bunsetsu-get-hinshi bunsetsu-2)))
	   (and (= (wnn7-bunsetsu-get-dic-no bunsetsu-1)
		   (wnn7-bunsetsu-get-dic-no bunsetsu-2))
		(= (wnn7-bunsetsu-get-entry bunsetsu-1)
		   (wnn7-bunsetsu-get-entry bunsetsu-2))
		(or (eq wnn-uniq-level 'wnn-uniq-entry)
		    (= (wnn7-bunsetsu-get-kangovect bunsetsu-1)
		       (wnn7-bunsetsu-get-kangovect bunsetsu-2)))))
       (equal (wnn7-bunsetsu-get-converted bunsetsu-1)
	      (wnn7-bunsetsu-get-converted bunsetsu-2))
       (equal (wnn7-bunsetsu-get-fuzokugo bunsetsu-1)
	      (wnn7-bunsetsu-get-fuzokugo bunsetsu-2))))

(defun wnn7-uniq-bunsetsu-list-equal (b1 b2)
  (while (and b1 b2 (wnn7-uniq-bunsetsu-equal (car b1) (car b2)))
    (setq b1 (cdr b1)
	  b2 (cdr b2)))
  (and (null b1) (null b2)))

(defun wnn7-candidate-pos (bunsetsu candidates)
  (let ((n 0)
	pos)
    (while (and (null pos) candidates)
      (if (wnn7-uniq-bunsetsu-list-equal (car candidates) bunsetsu)
	  (setq pos n)
	(setq candidates (cdr candidates)
	      n (1+ n))))
    (or pos -1)))


;;;
;;;
;;; frequency and flag operation
;;;
;;;
(defvar wnn-auto-save-dic-count 0)

(defun wnn7-server-hindo-update ()
  (let* ((head (car wnn7-bun-list))
	 (env (wnn7-bunsetsu-get-env head)))
    (prog1
	(progn
	  (wnn7-clear-now-flag wnn7-bun-list)
	  (wnn7-merge-fi-rel head (cdr wnn7-bun-list))
	  (wnn7rpc-set-fi-priority env (wnn7-bunsetsu-get-fi-rel head))
	  (wnn7-optimize-in-local wnn7-bun-list)
	  (wnn7-optimize-in-server wnn7-bun-list))
      (setq wnn-auto-save-dic-count (1+ wnn-auto-save-dic-count))
      (when (eq wnn-auto-save-dic-count wnn-auto-save-dictionaries)
	(wnn7-server-dict-save)
	(setq wnn-auto-save-dic-count 0)))))

(defun wnn7-clear-now-flag (bunsetsu-list)
  (let ((env (wnn7-bunsetsu-get-env (car bunsetsu-list)))
	fd)
    (while bunsetsu-list
      (setq fd (wnn7-bunsetsu-get-freq-down (car bunsetsu-list))
	    bunsetsu-list (cdr bunsetsu-list))
      (while fd
	(wnn7rpc-set-frequency env (caar fd) (cdar fd)
			       (WNN-const IMA_OFF) (WNN-const HINDO_NOP))
	(setq fd (cdr fd))))))

(defun wnn7-add-freq-down (bunsetsu down-list)
  (let ((freq-down (wnn7-bunsetsu-get-freq-down bunsetsu))
	b-list b pair)
    (while down-list
      (setq b-list (car down-list)
	    down-list (cdr down-list))
      (while b-list
	(setq b (car b-list)
	      b-list (cdr b-list)
	      pair (cons (wnn7-bunsetsu-get-dic-no b)
			 (wnn7-bunsetsu-get-entry b)))
	(if (and (/= (wnn7-bunsetsu-get-right-now b) 0)
		 (/= (car pair) -1)
		 (null (member pair freq-down)))
	    (setq freq-down (cons pair freq-down)))))
    (wnn7-bunsetsu-set-freq-down bunsetsu freq-down)))

(defun wnn7-merge-freq-down (bunsetsu b-list)
  (let ((freq-down0 (wnn7-bunsetsu-get-freq-down bunsetsu))
	freq-down1)
    (while b-list
      (setq freq-down1 (wnn7-bunsetsu-get-freq-down (car b-list))
	    b-list (cdr b-list))
      (while freq-down1
	(if (null (member (car freq-down1) freq-down0))
	    (setq freq-down0 (cons (car freq-down1) freq-down0)))
	(setq freq-down1 (cdr freq-down1)))
    (wnn7-bunsetsu-set-freq-down bunsetsu freq-down0))))

(defun wnn7-merge-fi-rel (bunsetsu b-list)
  (let ((fi-rel (cons nil (wnn7-bunsetsu-get-fi-rel bunsetsu))))
    (if (eq bunsetsu (car b-list))
	(setq b-list (cdr b-list)))
    (while b-list
      (nconc fi-rel (wnn7-bunsetsu-get-fi-rel (car b-list)))
      (wnn7-bunsetsu-set-fi-rel (car b-list) nil)
      (setq b-list (cdr b-list)))
    (wnn7-bunsetsu-set-fi-rel bunsetsu (cdr fi-rel))))

(defun wnn7-optimize-in-local (bunsetsu-list)
  (let ((env (wnn7-bunsetsu-get-env (car bunsetsu-list)))
	b prev-b next-b major-top entry hinshi)
    (setq next-b (car bunsetsu-list)
	  bunsetsu-list (cdr bunsetsu-list))
    (while next-b
      (setq major-top (null (and b (wnn7-bunsetsu-get-dai-continue b)))
	    prev-b b
	    b next-b
	    next-b (car bunsetsu-list)
	    bunsetsu-list (cdr bunsetsu-list)
	    hinshi (wnn7-bunsetsu-get-hinshi b))
      (when (or
	     (and (/= (wnn7env-get-notrans env) (WNN-const DIC_RDONLY))
		  (= (wnn7-bunsetsu-get-dic-no b) -1)
		  (or (= (wnn7-bunsetsu-get-entry b) (WNN-const HIRAGANA))
		      (= (wnn7-bunsetsu-get-entry b) (WNN-const KATAKANA)))
		  (>= (wnn7-bunsetsu-get-jirilen b) (WNN-const LEARNING_LEN)))
	     (= (wnn7-bunsetsu-get-entry b) (WNN-const IKEIJI_ENTRY)))
	(setq entry (wnn7-notrans-auto-learning b))
	(when (/= entry -1)
	  (wnn7-bunsetsu-set-dic-no b (WNN-const MUHENKAN_DIC))
	  (wnn7-bunsetsu-set-entry b entry)))
      (cond
       ((and next-b
	     major-top
	     (wnn7-bunsetsu-get-dai-continue b))
	(wnn7-adjacent-learning b next-b))
       ((and prev-b
	     (= hinshi (wnn7env-get-hinshi env 'rendaku))
	     (equal (wnn7-bunsetsu-get-fuzokugo prev-b) ""))
	(wnn7-adjacent-learning prev-b b))
       ((and next-b
	     (= hinshi (wnn7env-get-hinshi env 'settou)))
	(wnn7-adjacent-learning b next-b))
       ((and (/= (wnn7env-get-bmodify env) (WNN-const DIC_RDONLY))
	     (wnn7-bunsetsu-get-change-top b)
	     next-b
	     (/= (wnn7-bunsetsu-get-hinshi next-b)
		 (wnn7env-get-hinshi env 'rendaku))
	     (/= hinshi (wnn7env-get-hinshi env 'settou)))
	(wnn7-bmodify-learning b next-b))))))

(defun wnn7-notrans-auto-learning (bunsetsu)
  (let ((env (wnn7-bunsetsu-get-env bunsetsu)))
    (wnn7rpc-auto-learning env (WNN-const NOTRANS_LEARN)
			  (wnn7-bunsetsu-get-yomi bunsetsu)
			  (wnn7-bunsetsu-get-converted bunsetsu)
			  ""
			  (if (= (wnn7-bunsetsu-get-entry bunsetsu)
				 (WNN-const IKEIJI_ENTRY))
			      (wnn7-bunsetsu-get-hinshi bunsetsu)
			    (wnn7env-get-hinshi env 'noun))
			  0)))

(defun wnn7-adjacent-learning (bunsetsu1 bunsetsu2)
  (let* ((env (wnn7-bunsetsu-get-env bunsetsu1))
	 (yomi (concat (wnn7-bunsetsu-get-yomi bunsetsu1)
		       (wnn7-bunsetsu-get-yomi bunsetsu2)))
	 (kanji (concat (wnn7-bunsetsu-get-converted bunsetsu1)
			(wnn7-bunsetsu-get-converted bunsetsu2)))
	 (hinshi (wnn7env-get-hinshi env 'noun)))
    (if (= (wnn7env-get-bmodify env) (WNN-const DIC_RW))
	(wnn7rpc-auto-learning env (WNN-const BMODIFY_LEARN)
			      yomi kanji "" hinshi 0)
      (wnn7rpc-temporary-learning env yomi kanji "" hinshi 0))))

(defun wnn7-bmodify-learning (bunsetsu1 bunsetsu2)
  (let ((env (wnn7-bunsetsu-get-env bunsetsu1))
	(yomi (concat (wnn7-bunsetsu-get-yomi bunsetsu1)
		      (wnn7-bunsetsu-get-fuzokugo bunsetsu1)
		      (wnn7-bunsetsu-get-yomi bunsetsu2)))
	(kanji (concat (wnn7-bunsetsu-get-converted bunsetsu1)
		       (wnn7-bunsetsu-get-fuzokugo bunsetsu1)
		       (wnn7-bunsetsu-get-converted bunsetsu2)))
	(hinshi (wnn7-bunsetsu-get-hinshi bunsetsu2)))
    (wnn7rpc-auto-learning env (WNN-const BMODIFY_LEARN)
			  yomi kanji "" hinshi 0)))

(defun wnn7-optimize-in-server (bunsetsu-list)
  (let ((env (wnn7-bunsetsu-get-env (car bunsetsu-list)))
	(context (wnn7-bunsetsu-get-context (car bunsetsu-list)))
	b)
    (wnn7-context-set-right-now (car context) (WNN-const HINDO_NOP))
    (wnn7-context-set-freq (car context) (WNN-const HINDO_NOP))
    (wnn7-context-set-right-now (nth 1 context) (WNN-const HINDO_NOP))
    (wnn7-context-set-freq (nth 1 context) (WNN-const HINDO_NOP))
    (while bunsetsu-list
      (setq b (car bunsetsu-list)
	    bunsetsu-list (cdr bunsetsu-list)
	    context (cons (wnn7-context-create (wnn7-bunsetsu-get-dic-no b)
					      (wnn7-bunsetsu-get-entry b)
					      (wnn7-bunsetsu-get-jirilen b)
					      (wnn7-bunsetsu-get-hinshi b)
					      (wnn7-bunsetsu-get-fuzokugo b)
					      (wnn7-bunsetsu-get-converted b)
					      (WNN-const IMA_ON)
					      (WNN-const HINDO_INC))
			  context)))
    (prog1
	(list (car context) (nth 1 context))
      (wnn7rpc-optimize-fi env (nreverse context)))))

(defun wnn7-server-henkan-kakutei (bunno pos)
  (let* ((bunsetsu (wnn7-get-major-bunsetsu bunno))
	 (head (car bunsetsu))
	 (next-b (wnn7-get-next-major-bunsetsu bunno))
	 (prev-b (car (wnn7-get-prev-major-bunsetsu bunno)))
	 (cand-list (wnn7-bunsetsu-get-zenkouho-list head))
	 (cand (nth pos cand-list))
	 (c-head (car cand)) 
	 top bunno2)
    (setq bunno2 (cdr (wnn7-get-prev-major-bunsetsu bunno))
	  top (wnn7-get-pre-prev-bunsetsu (1- bunno2)))
    (wnn7-bunsetsu-set-zenkouho-pos head pos)
    (wnn7-bunsetsu-set-change-top c-head (wnn7-bunsetsu-get-change-top head))
    (wnn7-bunsetsu-set-freq-down c-head (wnn7-bunsetsu-get-freq-down head))
    (wnn7-merge-fi-rel c-head bunsetsu)
    (wnn7-major-bunsetsu-set-context cand (wnn7-bunsetsu-get-context head))
    (wnn7-set-candidate-info cand (wnn7-bunsetsu-get-zenkouho head))
    (if (and prev-b (null wnn-one-level-conversion))
	(progn
	  (wnn7-bunsetsu-set-dai-continue (wnn7-get-bunsetsu-tail prev-b)
					 (wnn7-bunsetsu-connect-prev c-head))))
    (setq wnn7-bun-list (append top prev-b cand next-b))))

(defun wnn7-server-henkan-kakutei-sho (bunno pos)
  (let* ((bunsetsu (wnn7-get-minor-bunsetsu bunno))
	 (head (car bunsetsu))
	 (next-b (nthcdr (1+ bunno) wnn7-bun-list))
	 (prev-b (wnn7-get-pre-prev-bunsetsu (1- bunno)))
	 (cand-list (wnn7-bunsetsu-get-zenkouho-list head))
	 (cand (nth pos cand-list))
	 (c-head (car cand)) 
	 top bunno2)
    ;;(setq bunno2 (wnn7-get-prev-minor-bunsetsu bunno)
	;;  top (wnn7-get-pre-prev-bunsetsu (1- bunno2)))
    (wnn7-bunsetsu-set-zenkouho-pos head pos)
    (wnn7-bunsetsu-set-change-top c-head (wnn7-bunsetsu-get-change-top head))
    (wnn7-bunsetsu-set-freq-down c-head (wnn7-bunsetsu-get-freq-down head))
    (wnn7-merge-fi-rel c-head bunsetsu)
    (wnn7-major-bunsetsu-set-context cand (wnn7-bunsetsu-get-context head))
    (wnn7-set-candidate-info cand (wnn7-bunsetsu-get-zenkouho head))
;;    (if (and prev-b (null wnn-one-level-conversion))
;;	(progn
;;	  (wnn7-bunsetsu-set-dai-continue (wnn7-get-bunsetsu-tail prev-b)
;;					 (wnn7-bunsetsu-connect-prev c-head))))
    (setq wnn7-bun-list (append top prev-b cand next-b))))

(defun wnn7-server-bunsetu-henkou (bunno len major)
  (let (bunsetsu next-b prev-b tail env yomi context yomi1 
		 yomi2 hinshi fuzokugo new tmplen)
    (if major
	(setq bunsetsu (wnn7-get-major-bunsetsu bunno)
	      prev-b (wnn7-get-pre-prev-bunsetsu (1- bunno))
	      next-b (wnn7-get-next-major-bunsetsu bunno))
      (setq bunsetsu (wnn7-get-minor-bunsetsu bunno)
	    prev-b (wnn7-get-pre-prev-bunsetsu (1- bunno))
	    next-b (list (nthcdr (1+ bunno) wnn7-bun-list))))
    (setq tmplen (length (wnn7-get-major-bunsetsu-source bunsetsu)))
    (when (< tmplen len)
      (nconc bunsetsu (list (car next-b)))
      (setq next-b (cdr next-b)))
    (setq tail (wnn7-get-bunsetsu-tail prev-b)
	  env (wnn7-bunsetsu-get-env (car bunsetsu))
	  yomi (wnn7-get-major-bunsetsu-source bunsetsu)
	  context (wnn7-bunsetsu-get-context (car bunsetsu)))

    (if tail
	(setq hinshi (wnn7-bunsetsu-get-hinshi tail)
	      fuzokugo (wnn7-bunsetsu-get-fuzokugo tail))
      (setq hinshi -1
	    fuzokugo ""))
    (setq yomi1 (substring yomi 0 len)
	  yomi2 (concat (substring yomi len)
			(wnn7-get-major-bunsetsu-source next-b)))
    (setq new (wnn7-tanbunsetsu-conversion env yomi1 hinshi fuzokugo nil major))
    (if (numberp new)
	(egg:error "%s" (wnn7rpc-get-error-message (- new))))
    (if (and prev-b (null wnn-one-level-conversion))
	(wnn7-bunsetsu-set-dai-continue tail
				       (wnn7-bunsetsu-connect-prev (car new))))
    (wnn7-bunsetsu-set-change-top (car new) t)
    (wnn7-merge-freq-down (car new) bunsetsu)
    (wnn7-merge-fi-rel (car new) bunsetsu)
    (wnn7-merge-fi-rel (car new) next-b)
    (wnn7-major-bunsetsu-set-context new context)
    (if (= (length yomi2) 0)
	(setq next-b nil)
      (setq tail (wnn7-get-bunsetsu-tail new)
	    next-b (wnn7-renbunsetsu-conversion env yomi2
					       (wnn7-bunsetsu-get-hinshi tail)
					       (wnn7-bunsetsu-get-fuzokugo tail)
					       nil context))
      (if (numberp next-b)
	  (egg:error "%s" (wnn7rpc-get-error-message (- next-b))))
      (if (and (null major) (null wnn-one-level-conversion))
	  (wnn7-bunsetsu-set-dai-continue
	   tail
	   (wnn7-bunsetsu-connect-prev (car next-b)))))
    (setq new (append prev-b new next-b))
    (cons (length new) new))) ;; new-bunsetsu-list

(defun wnn7-renbunsetsu-conversion (env yomi hinshi fuzokugo v context)
  (let ((result (wnn7rpc-fi-renbunsetsu-conversion env yomi hinshi fuzokugo v
						  context)))
    (prog1
	result
      (if wnn-one-level-conversion
	  (while (consp result)
	    (wnn7-bunsetsu-set-dai-continue (car result) nil)
	    (setq result (cdr result)))))))

(defun wnn7-tanbunsetsu-conversion (env yomi hinshi fuzokugo v major)
  (if (or (null major)
	  wnn-one-level-conversion)
      (wnn7rpc-tanbunsetsu-conversion env yomi hinshi fuzokugo v)
    (wnn7rpc-daibunsetsu-conversion env yomi hinshi fuzokugo v)))

(defun wnn7-server-synonym (bunno pos major)
  (let (bunsetsu head env yomi yomi_org next-b prev-b hinshi 
		 fuzokugo converted cand cand-list c-head v)
    (if major
	(setq bunsetsu (wnn7-get-major-bunsetsu bunno)
	      prev-b (car (wnn7-get-prev-major-bunsetsu bunno))
	      next-b (wnn7-get-next-major-bunsetsu bunno))
      (setq bunsetsu (wnn7-get-minor-bunsetsu bunno)
	    prev-b (wnn7-get-prev-minor-bunsetsu bunno)
	    next-b (list (nthcdr (1+ bunno) wnn7-bun-list))))

    (setq head (car bunsetsu)
	  env (wnn7-bunsetsu-get-env head)
	  cand-list (wnn7-bunsetsu-get-zenkouho-list head)
	  cand (nth pos cand-list)
	  c-head (car cand) 
	  yomi (wnn7-get-bunsetsu-converted c-head)
	  yomi_org (wnn7-get-bunsetsu-source c-head))
    (if prev-b
	(setq prev-b (wnn7-get-bunsetsu-tail prev-b)
	      hinshi (wnn7-bunsetsu-get-hinshi prev-b)
	      fuzokugo (wnn7-bunsetsu-get-fuzokugo prev-b))
      (setq hinshi -1
	    fuzokugo ""))
    (if next-b
	(setq next-b (car next-b)
	      v (wnn7-bunsetsu-get-kangovect next-b)))
    (if (vectorp (wnn7-bunsetsu-get-zenkouho head))
	(setq pos (wnn7-bunsetsu-get-zenkouho-pos head)
	      cand (wnn7-bunsetsu-get-zenkouho-list head)))
    (setq cand (wnn7rpc-assoc-with-data env 
	     yomi
	     hinshi
	     fuzokugo
	     v
	     (wnn7-bunsetsu-get-hinshi c-head) ;; jirihin
	     yomi_org
	     (wnn7-bunsetsu-get-jirilen c-head); jirilen
	     (length (wnn7-get-bunsetsu-source c-head)); yomilen*
	     (length (wnn7-get-bunsetsu-converted c-head)); kanjilen*
	     (length (wnn7-bunsetsu-get-converted c-head)))); real_kanjilen
    (if (numberp cand)
	(egg:error "%s" (wnn7rpc-get-error-message (- cand)))
      (if cand
	  (progn
	    (setq cand (wnn7-uniq-candidates cand)
		  pos 0
		  converted (wnn7-get-candidates-converted cand))
	    (wnn7-set-candidate-info bunsetsu
				     (wnn7-zenkouho-create pos cand 
							   converted
							   major 
							   prev-b next-b))
	    (wnn7-add-freq-down head cand)
	    (cons pos converted))
	nil))))

;;;
;;;
;;; predictive input 
;;;
;;;
(defvar egg-predict-status nil)

(defun wnn7-server-predict-init ()
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-init env)))
    (if (= result 0)
	(progn
	  (wnn7rpc-yosoku-init-time-keydata env)
	  (wnn7rpc-yosoku-init-inputinfo env)
	  (setq egg-predict-status t))
      (if (= result -16)
	  (egg:error "%s" "システム予測辞書ファイルが見つかりません")
	(egg:error "%s" (wnn7rpc-get-error-message (- result))))
      nil)))

(defun wnn7-server-predict-free ()
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-free env)))
    (setq egg-predict-status nil)
    (if (= result 0)
	t
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))

(defun wnn7-server-predict-start (str)
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-yosoku env str)))
    (if (numberp result)
	(if (= result -3011)
	    result
	  (egg:error "%s" (wnn7rpc-get-error-message (- result)))
	  nil)
      result)))

(defun wnn7-server-predict-toroku (&optional kakutei-str)
  (when env-normal
    (let* ((bunlist wnn7-bun-list)
	   (head (car bunlist))
	   (env wnn7-env-norm)
	   ykouho yklist result)
      (if kakutei-str
	  ;; before convert
	  (setq ykouho (vector kakutei-str
			       (length (encode-coding-string  
					(comm-format-truncate-after-null 
					 kakutei-str) egg-mb-euc))
			       kakutei-str
			       (length (encode-coding-string  
					(comm-format-truncate-after-null 
					 kakutei-str) egg-mb-euc))
			       0)
		yklist (cons ykouho yklist))
	;; after convert
	;;(setq env (wnn7-bunsetsu-get-env head))
	(let (bun bunsetsu)
	  (while bunlist
	    (setq bun (car bunlist)
		  bunsetsu nil)
	    (while bun
	      (setq bunsetsu (cons bun bunsetsu)
		    bunlist (cdr bunlist)
		    bun (and (wnn7-bunsetsu-get-dai-continue bun)
			     bunlist
			     (car bunlist))))
	    (setq bunsetsu (nreverse bunsetsu))
	    (when bunsetsu
	      (setq ykouho (vector (wnn7-get-major-bunsetsu-source bunsetsu)
				   (length (encode-coding-string  
					    (comm-format-truncate-after-null 
					     (mapconcat 'wnn7-bunsetsu-get-yomi 
							bunsetsu ""))
					    egg-mb-euc))
				   (wnn7-get-major-bunsetsu-converted bunsetsu)
				   (length (encode-coding-string  
					    (comm-format-truncate-after-null
					     (mapconcat 'wnn7-bunsetsu-get-converted 
							bunsetsu ""))
					    egg-mb-euc))
				   (wnn7-bunsetsu-get-hinshi (car (nreverse bunsetsu))))
		    yklist (cons ykouho yklist)))))
	(setq yklist (nreverse yklist)))
      (if (= (setq result (wnn7rpc-yosoku-toroku env (length yklist) yklist)) 0)
	  t
	(if (not (eq result -3011))
	    (egg:error "%s" (wnn7rpc-get-error-message (- result))))
	nil))))
      
(defun wnn7-server-predict-selected-cand (pos)
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-selected-cand env pos)))
    (if (>= result 0)
	result
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))
  
(defun wnn7-server-predict-delete-cand (pos)
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-delete-cand env pos)))
    (if (= result 0)
	t
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))
  
(defun wnn7-server-predict-cancel-toroku ()
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-cancel-latest-toroku env)))
    (if (= result 0)
	t
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))
  
(defun wnn7-server-predict-reset-connective ()
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-reset-pre-yosoku env)))
    (if (= result 0)
	t
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))
	
(defun wnn7-server-predict-save-data ()
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-save-datalist env)))
    (if (= result 0)
	t
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))

(defun wnn7-server-predict-set-timeinfo (yosokuselect throughyosoku inputtime keylen)
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-set-timeinfo env yosokuselect 
					      throughyosoku inputtime keylen)))
    (if (= result 0)
	t
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))

(defun wnn7-server-predict-set-user-inputinfo (allkey userkey yosokuselect)
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-set-user-inputinfo env allkey userkey
						    yosokuselect)))
    (if (= result 0)
	t
      (egg:error "%s" (wnn7rpc-get-error-message (- result)))
      nil)))

(defun wnn7-server-predict-status ()
  (let* ((env wnn7-env-norm)
	 (result (wnn7rpc-yosoku-status env)))
    result))
  
(provide 'wnn7egg-lib)

;;; wnn7egg-lib.el ends here
