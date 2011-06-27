;; Wnn7Egg is Egg modified for Wnn7, and the current maintainer 
;; is OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;;
;; This file is part of Wnn7Egg. (base code is egg-com.el (eggV4))
;;
;;; ------------------------------------------------------------------
;;;
;;; Wnn7Egg ��Wnn "�ʤ�"���ޤ���--- Wnn7 Emacs Client 
;;; 
;;; Wnn7Egg �ϡ��֤��ޤ��裳�ǡ�v3.09 ��١����� �֤��ޤ��裴�ǡפ��̿���
;;; �饤�֥�������Ȥ߹������Wnn7 �ΰ٤����ѥ��饤����ȤǤ���
;;;
;;; ���٤ƤΥ������� Emacs Lisp �ǵ��Ҥ���Ƥ���Τǡ�Wnn SDK/Library ��ɬ��
;;; �Ȥ�����GNU Emacs �ڤ� XEmacs �Ķ��ǻ��Ѥ��뤳�Ȥ��Ǥ��ޤ������ѵ������
;;; �� GPL �Ǥ���
;;;
;;; GNU Emacs 20.3 �ʹߡ�XEmacs 21.x �ʹߤ�ư���ǧ���Ƥ��ޤ���
;;;
;;;
;;; Wnn7Egg �� Wnn7 �ε�ǽ�Ǥ���ڡ����ϡ�����ͽ¬�ˡ�Ϣ���Ѵ��򥵥ݡ���
;;; ���Ƥ��ޤ���
;;;
;;; �֤��ޤ��פ���Ω����¸�Ǥ���褦�ˡ��ƶ�������פʴؿ����ѿ�̾��
;;; "wnn7..." �Ȥ��������ѹ����Ƥ��ޤ���
;;;
;;; ------------------------------------------------------------------

;;; egg-com.el --- Communication Routines in Egg Input Method Architecture

;; Copyright (C) 1999, 2000 Free Software Foundation, Inc

;; Author: Hisashi Miyashita <himi@bird.scphys.kyoto-u.ac.jp>
;;         NIIBE Yutaka <gniibe@chroot.org>
;;	   KATAYAMA Yoshio <kate@pfu.co.jp>  ; Korean, Chinese support.

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


(require 'wnn7egg-edep)
;;(require 'wnn7egg-cnv)

(defvar egg-fixed-euc '(fixed-euc-jp))
(make-variable-buffer-local 'egg-fixed-euc)
(put 'egg-fixed-euc 'permanent-local t)

(defvar egg-mb-euc 'euc-japan)
(make-variable-buffer-local 'egg-mb-euc)
(put 'egg-mb-euc 'permanent-local t)

;; Japanese

(eval-and-compile
(define-ccl-program ccl-decode-fixed-euc-jp
  `(2
    ((r2 = ,(charset-id 'japanese-jisx0208))
     (r3 = ,(charset-id 'japanese-jisx0212))
     (r4 = ,(charset-id 'katakana-jisx0201))
     (read r0)
     (loop
      (read r1)
      (if (r0 < ?\x80)
	  ((r0 = r1)
	   (if (r1 < ?\x80)
	       (write-read-repeat r0))
	   (write r4)
	   (write-read-repeat r0))
	((if (r1 > ?\x80)
	     ((write r2 r0)
	      (r0 = r1)
	      (write-read-repeat r0))
	   ((write r3 r0)
	    (r0 = (r1 | ?\x80))
	    (write-read-repeat r0)))))))))

(define-ccl-program ccl-encode-fixed-euc-jp
  `(2
    ((read r0)
     (loop
      (if (r0 == ,(charset-id 'latin-jisx0201))                   ; Unify
	  ((read r0)
	   (r0 &= ?\x7f)))
      (if (r0 < ?\x80)                                            ;G0
	  ((write 0)
	   (write-read-repeat r0)))
      (r6 = (r0 == ,(charset-id 'japanese-jisx0208)))
      (r6 |= (r0 == ,(charset-id 'japanese-jisx0208-1978)))
      (if r6                                                      ;G1
	  ((read r0)
	   (write r0)
	   (read r0)
	   (write-read-repeat r0)))
      (if (r0 == ,(charset-id 'katakana-jisx0201))                ;G2
	  ((read r0)
	   (write 0)
	   (write-read-repeat r0)))
      (if (r0 == ,(charset-id 'japanese-jisx0212))                ;G3
	  ((read r0)
	   (write r0)
	   (read r0)
	   (r0 &= ?\x7f)
	   (write-read-repeat r0)))
      (read r0)
      (repeat)))))
)

(if (not (coding-system-p 'fixed-euc-jp))
    (make-coding-system 'fixed-euc-jp 4 ?W 
		"Coding System for fixed EUC Japanese"
		(cons ccl-decode-fixed-euc-jp ccl-encode-fixed-euc-jp)))

;; Binary data

(eval-and-compile
(define-ccl-program ccl-decode-egg-binary
  `(1
    ((read r0)
     (loop
      (if (r0 == ?\xff)
	  (read r1))			; toss out
      (write-read-repeat r0)))))

(define-ccl-program ccl-encode-egg-binary
  `(2
    ((read r0)
     (loop
      (if (r0 == ?\xff)
	  ((write r0)
	   (r0 = 0)))
      (write-read-repeat r0))))))

(if (not (coding-system-p 'egg-binary))
    (make-coding-system 'egg-binary 4 ?W "Coding System for binary data"
		    (cons ccl-decode-egg-binary ccl-encode-egg-binary)))


(defun comm-format-u32c (uint32c)
  (insert-char (logand (lsh (car uint32c) -8) 255) 1)
  (insert-char (logand (car uint32c) 255) 1)
  (insert-char (logand (lsh (nth 1 uint32c) -8) 255) 1)
  (insert-char (logand (nth 1 uint32c) 255) 1))

(defun comm-format-u32 (uint32)
  (insert-char (logand (lsh uint32 -24) 255) 1)
  (insert-char (logand (lsh uint32 -16) 255) 1)
  (insert-char (logand (lsh uint32 -8) 255) 1)
  (insert-char (logand uint32 255) 1))

(defun comm-format-i32 (int32)
  (insert-char (logand (ash int32 -24) 255) 1)
  (insert-char (logand (ash int32 -16) 255) 1)
  (insert-char (logand (ash int32 -8) 255) 1)
  (insert-char (logand int32 255) 1))

(defun comm-format-u16 (uint16)
  (insert-char (logand (lsh uint16 -8) 255) 1)
  (insert-char (logand uint16 255) 1))

(defun comm-format-u8 (uint8)
  (insert-char (logand uint8 255) 1))

(defun comm-format-truncate-after-null (s)
  (if (string-match "\0" s)
      (substring s 0 (match-beginning 0))
    s))

(defun comm-format-u16-string (s)
  (insert (encode-coding-string (comm-format-truncate-after-null s)
				egg-fixed-euc))
  (insert-char 0 2))

(defun comm-format-mb-string (s)
  (insert (encode-coding-string  (comm-format-truncate-after-null s)
				 egg-mb-euc))
  (insert-char 0 1))

(defun comm-format-u8-string (s)
  (insert (comm-format-truncate-after-null s))
  (insert-char 0 1))

(defun comm-format-binary-data (s)
  (insert (encode-coding-string s 'egg-binary))
  (insert-char ?\377 2))

(defun comm-format-fixlen-string (s len)
  (setq s (comm-format-truncate-after-null s))
  (insert (if (< (length s) len) s (substring s 0 (1- len))))
  (insert-char 0 (max (- len (length s)) 1)))

(defun comm-format-vector (s len)
  (setq s (concat s))
  (insert (if (<= (length s) len) s (substring s 0 len)))
  (insert-char 0 (- len (length s))))

(defmacro comm-format (format &rest args)
  "Format a string out of a control-list and arguments into the buffer.
The formated datas are network byte oder (i.e. big endian)..
U: 32-bit integer.  The argument is 2 element 16-bit unsigned integer list.
u: 32-bit integer.  The argument is treat as unsigned integer.
   (Note:  Elisp's integer may be less than 32 bits)
i: 32-bit integer.
w: 16-bit integer.
b: 8-bit integer.
S: 16-bit wide-character EUC string (0x0000 terminated).
E: Multibyte EUC string (0x00 terminated).
s: 8-bit string (0x00 terminated).
B: Binary data (0xff terminated).
v: 8-bit vector (no terminator).  This takes 2 args (data length).
V: Fixed length string (0x00 terminated).  This takes 2 args (data length)."
  (let ((p args)
	(form format)
	(result (list 'progn))
	f arg)
    (while (and form p)
      (setq f (car form)
	    arg (car p))
      (nconc result
	     (list
	      (cond ((eq f 'U) (list 'comm-format-u32c arg))
		    ((eq f 'u) (list 'comm-format-u32 arg))
		    ((eq f 'i) (list 'comm-format-i32 arg))
		    ((eq f 'w) (list 'comm-format-u16 arg))
		    ((eq f 'b) (list 'comm-format-u8 arg))
		    ((eq f 'S) (list 'comm-format-u16-string arg))
		    ((eq f 'E) (list 'comm-format-mb-string arg))
		    ((eq f 's) (list 'comm-format-u8-string arg))
		    ((eq f 'B) (list 'comm-format-binary-data arg))
		    ((eq f 'V) (setq p (cdr p))
			       (list 'comm-format-fixlen-string arg (car p)))
		    ((eq f 'v) (setq p (cdr p))
			       (list 'comm-format-vector arg (car p))))))
      (setq form (cdr form)
	    p (cdr p)))
    (if (or form p)
	(error "comm-format %s: arguments mismatch" format))
    result))

(defvar comm-accept-timeout nil)

;; Assume PROC is bound to the process of current buffer
;; Do not move the point, leave it where it was.
(defmacro comm-accept-process-output ()
  `(let ((p (point)))
     (if (null (accept-process-output proc comm-accept-timeout))
	 (error "backend timeout"))
     (goto-char p)))

(defmacro comm-require-process-output (n)
  `(if (< (point-max) (+ (point) ,n))
       (comm-wait-for-space proc ,n)))

(defun comm-wait-for-space (proc n)
  (let ((p (point))
	(r (+ (point) n)))
    (while (< (point-max) r)
      (if (null (accept-process-output proc comm-accept-timeout))
	  (error "backend timeout"))
      (goto-char p))))

(defmacro comm-following+forward-char ()
  `(prog1
       (following-char)
     (forward-char 1)))

(defun comm-unpack-u32c ()
  (progn
    (comm-require-process-output 4)
    (list (+ (lsh (comm-following+forward-char) 8)
	     (comm-following+forward-char))
	  (+ (lsh (comm-following+forward-char) 8)
	     (comm-following+forward-char)))))

(defun comm-unpack-u32 ()
  (progn
    (comm-require-process-output 4)
    (+ (lsh (comm-following+forward-char) 24)
       (lsh (comm-following+forward-char) 16)
       (lsh (comm-following+forward-char) 8)
       (comm-following+forward-char))))

(defun comm-unpack-u16 ()
  (progn
    (comm-require-process-output 2)
    (+ (lsh (comm-following+forward-char) 8)
       (comm-following+forward-char))))

(defun comm-unpack-u8 ()
  (progn
    (comm-require-process-output 1)
    (comm-following+forward-char)))

(defun comm-unpack-u16-string ()
  (let ((start (point)))
    (while (not (search-forward "\0\0" nil t))
      (comm-accept-process-output))
    (decode-coding-string (buffer-substring start (- (point) 2))
			  egg-fixed-euc)))

(defun comm-unpack-mb-string ()
  (let ((start (point)))
    (while (not (search-forward "\0" nil t))
      (comm-accept-process-output))
    (decode-coding-string (buffer-substring start (1- (point)))
			  egg-mb-euc)))

(defun comm-unpack-u8-string ()
  (let ((start (point)))
    (while (not (search-forward "\0" nil 1))
      (comm-accept-process-output))
    (buffer-substring start (1- (point)))))

(defun comm-unpack-binary-data ()
  (let ((start (point)))
    (while (not (search-forward "\377\377" nil 1))
      (comm-accept-process-output))
    (string-as-unibyte
     (decode-coding-string (buffer-substring start (- (point) 2))
			   'egg-binary))))

(defun comm-unpack-fixlen-string (len)
  (let (s)
    (comm-require-process-output len)
    (goto-char (+ (point) len))
    (setq s (buffer-substring (- (point) len) (point)))
    (if (string-match "\0" s)
	(setq s (substring s 0 (match-beginning 0))))
    s))

(defun comm-unpack-vector (len)
  (progn
    (comm-require-process-output len)
    (goto-char (+ (point) len))
    (buffer-substring (- (point) len) (point))))

(defmacro comm-unpack (format &rest args)
  "Unpack a string out of a control-string and set arguments.
See `comm-format' for FORMAT."
  (let ((p args)
	(form format)
	(result (list 'progn))
	arg f)
    (while (and form p)
      (setq f (car form)
	    arg (car p))
      (nconc result
	     (list
	      (cond ((eq f 'U) `(setq ,arg (comm-unpack-u32c)))
		    ((eq f 'u) `(setq ,arg (comm-unpack-u32)))
		    ((eq f 'i) `(setq ,arg (comm-unpack-u32)))
		    ((eq f 'w) `(setq ,arg (comm-unpack-u16)))
		    ((eq f 'b) `(setq ,arg (comm-unpack-u8)))
		    ((eq f 'S) `(setq ,arg (comm-unpack-u16-string)))
		    ((eq f 'E) `(setq ,arg (comm-unpack-mb-string)))
		    ((eq f 's) `(setq ,arg (comm-unpack-u8-string)))
		    ((eq f 'B) `(setq ,arg (comm-unpack-binary-data)))
		    ((eq f 'V) (setq p (cdr p))
			       `(setq ,arg (comm-unpack-fixlen-string ,(car p))))
		    ((eq f 'v) (setq p (cdr p))
			       `(setq ,arg (comm-unpack-vector ,(car p)))))))
      (setq form (cdr form)
	    p (cdr p)))
    (if (or form p)
	(error "comm-unpack %s: arguments mismatch" format))
    result))

(defmacro comm-call-with-proc (proc vlist send-expr &rest receive-exprs)
  (let ((euc-select
	 (and (eq (car-safe (car vlist)) 'zhuyin)
	      '((egg-fixed-euc (nth (if zhuyin 1 0) egg-fixed-euc))))))
  `(let* ((proc ,proc)
	  (buffer (process-buffer proc))
	  ,@vlist)
     (if (and (eq (process-status proc) 'open)
	      (buffer-live-p buffer))
	 (save-excursion
	   (set-buffer buffer)
	   (let ,euc-select
	     (erase-buffer)
	     ,send-expr
	     (goto-char (point-max))
	     (process-send-region proc (point-min) (point-max))
	     ,@receive-exprs))
       (error "process %s was killed" proc)))))

(defmacro comm-call-with-proc-1 (proc vlist send-expr &rest receive-exprs)
  `(let ,vlist
     (erase-buffer)
     ,send-expr
     (goto-char (point-max))
     (process-send-region proc (point-min) (point-max))
     ,@receive-exprs))

(provide 'wnn7egg-com)

;;; wnn7egg-com.el ends here.
