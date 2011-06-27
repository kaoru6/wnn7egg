;;; wnn7egg-leim.el --- Egg/Wnn-related code for LEIM
;; Copyright (C) 2001 OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>

;; Shamelessly ripped off from
;;
;; egg-leim.el --- Egg-related code for LEIM
;; Copyright (C) 1997 Stephen Turnbull <turnbull@sk.tsukuba.ac.jp>
;; Copyright (C) 1997 Free Software Foundation, Inc.
;;
;; Shamelessly ripped off from
;;
;; skk-leim.el --- SKK related code for LEIM
;; Copyright (C) 1997
;; Murata Shuuichirou <mrt@mickey.ai.kyutech.ac.jp>
;;
;; Author: OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;; Keywords: japanese, input method, LEIM, Wnn7
;; Last Modified: 2001/5/30 00:00:00

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either versions 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with XEmacs, see the file COPYING.  If not, write to the Free
;; Software Foundation Inc., 59 Temple Place - Suite 330, Boston,
;; MA 02111-1307, USA.

;;; TODO
;;
;;  Add pointers to Egg documentation in LEIM format

(defvar wnn7-activate nil "T if wnn7egg is activeate.")
(make-variable-buffer-local 'wnn7-activate)
(set-default 'wnn7-activate nil)

(if (featurep 'xemacs)
    (if (fboundp 'set-input-method)
	(defun select-input-method (lang)
	  (set-input-method lang))))

(defun wnn7egg-activate (&optional name)
  (require 'wnn7egg)
  (require 'wnn7egg-cnv)
  (setq inactivate-current-input-method-function 'wnn7egg-inactivate)
  (setq wnn7egg-default-startup-file "eggrc-wnn7")
  (wnn7-egg-mode)
  (setq wnn7-activate t);;;;
  (toggle-egg-mode))

(defun wnn7egg-inactivate ()
  (setq wnn7-activate nil);;;;
  (cond (egg:*mode-on* (toggle-egg-mode))))

(defun wnn7-p ()
  (or (and current-input-method
	   (string-match "japanese-egg-wnn7" current-input-method))
      wnn7-activate))

(register-input-method
 'japanese-egg-wnn7 "Japanese"
 'wnn7egg-activate nil
 "Wnn7EGG - an interface to the Wnn7 kana to kanji conversion program")

(provide 'wnn7egg-leim)

;;; wnn7egg-leim.el ends here
