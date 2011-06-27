;; Wnn7Egg is Egg modified for Wnn7, and the current maintainer 
;; is OMRON SOFTWARE Co., Ltd. <wnn-info@omronsoft.co.jp>
;;
;; This file is part of Wnn7Egg. (base code is egg/wnnrpc.el (eggV4))
;;
;;; ------------------------------------------------------------------
;;;
;;; Wnn7Egg $B!J(BWnn "$B$J$J(B"$B$?$^$4!K(B--- Wnn7 Emacs Client 
;;; 
;;; Wnn7Egg $B$O!"!V$?$^$4Bh#3HG!W(Bv3.09 $B$r%Y!<%9$K(B $B!V$?$^$4Bh#4HG!W$NDL?.!"(B
;;; $B%i%$%V%i%jIt$rAH$_9~$s$@!"(BWnn7 $B$N0Y$N@lMQ%/%i%$%"%s%H$G$9!#(B
;;;
;;; $B$9$Y$F$N%=!<%9$,(B Emacs Lisp $B$G5-=R$5$l$F$$$k$N$G!"(BWnn SDK/Library $B$rI,MW(B
;;; $B$H$;$:!"(BGNU Emacs $B5Z$S(B XEmacs $B4D6-$G;HMQ$9$k$3$H$,$G$-$^$9!#;HMQ5vBz>r7o(B
;;; $B$O(B GPL $B$G$9!#(B
;;;
;;; GNU Emacs 20.3 $B0J9_!"(BXEmacs 21.x $B0J9_$GF0:n3NG'$7$F$$$^$9!#(B
;;;
;;;
;;; Wnn7Egg $B$O(B Wnn7 $B$N5!G=$G$"$k3Z!9F~NO!JF~NOM=B,!K!"O"A[JQ49$r%5%]!<%H(B
;;; $B$7$F$$$^$9!#(B
;;;
;;; $B!V$?$^$4!W$HFHN)!?6&B8$G$-$k$h$&$K!"1F6A$9$k<gMW$J4X?t!?JQ?tL>$r(B
;;; "wnn7..." $B$H$$$&7A$KJQ99$7$F$$$^$9!#(B
;;;
;;; ------------------------------------------------------------------

;;; egg/wnnrpc.el --- WNN Support (low level interface) in Egg
;;;                   Input Method Architecture

;; Copyright (C) 1999, 2000 Free Software Foundation, Inc

;; Author: NIIBE Yutaka <gniibe@chroot.org>
;;         KATAYAMA Yoshio <kate@pfu.co.jp> ; Korean, Chinese support.

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

;;; 2001/9/30  Modified Error Messages

;;; Code:


(require 'wnn7egg-com)

(defmacro wnn-file-string ()
  (string-as-unibyte (decode-coding-string "$B#W#n#n$N%U%!%$%k(B" 'euc-jp)))
(defmacro wnn-const (c)
  "Macro for WNN constants."
  (cond ((eq c 'JS_VERSION)               0)
	((eq c 'JS_OPEN)                  1)
	((eq c 'JS_CLOSE)                 3)
	((eq c 'JS_CONNECT)               5)
	((eq c 'JS_DISCONNECT)            6)
	((eq c 'JS_ENV_EXIST)             7)
	((eq c 'JS_ENV_STICKY)            8)
	((eq c 'JS_ENV_UNSTICKY)          9)
	((eq c 'JS_KANREN)               17)
	((eq c 'JS_KANTAN_SHO)           18)
	((eq c 'JS_KANZEN_SHO)           19)
	((eq c 'JS_KANTAN_DAI)           20)
	((eq c 'JS_KANZEN_DAI)           21)
	((eq c 'JS_HINDO_SET)            24)
	((eq c 'JS_DIC_ADD)              33)
	((eq c 'JS_DIC_DELETE)           34)
	((eq c 'JS_DIC_USE)              35)
	((eq c 'JS_DIC_LIST)             36)
	((eq c 'JS_DIC_INFO)             37)
	((eq c 'JS_FUZOKUGO_SET)         41)
	((eq c 'JS_FUZOKUGO_GET)         48)
	((eq c 'JS_WORD_ADD)             49)
	((eq c 'JS_WORD_DELETE)          50)
	((eq c 'JS_WORD_SEARCH)          51)
	((eq c 'JS_WORD_SEARCH_BY_ENV)   52)
	((eq c 'JS_WORD_INFO)            53)
	((eq c 'JS_WORD_COMMENT_SET)     54)
	((eq c 'JS_PARAM_SET)            65)
	((eq c 'JS_PARAM_GET)            66)
	((eq c 'JS_MKDIR)                81)
	((eq c 'JS_ACCESS)               82)
	((eq c 'JS_WHO)                  83)
	((eq c 'JS_ENV_LIST)             85)
	((eq c 'JS_FILE_LIST_ALL)        86)
	((eq c 'JS_DIC_LIST_ALL)         87)
	((eq c 'JS_FILE_READ)            97)
	((eq c 'JS_FILE_WRITE)           98)
	((eq c 'JS_FILE_SEND)            99)
	((eq c 'JS_FILE_RECEIVE)        100)
	((eq c 'JS_HINDO_FILE_CREATE)   101)
	((eq c 'JS_DIC_FILE_CREATE)     102)
	((eq c 'JS_FILE_REMOVE)         103)
	((eq c 'JS_FILE_LIST)           104)
	((eq c 'JS_FILE_INFO)           105)
	((eq c 'JS_FILE_LOADED)         106)
	((eq c 'JS_FILE_LOADED_LOCAL)   107)
	((eq c 'JS_FILE_DISCARD)        108)
	((eq c 'JS_FILE_COMMENT_SET)    109)
	((eq c 'JS_FILE_PASSWORD_SET)   110)
	((eq c 'JS_FILE_STAT)           111)
	((eq c 'JS_KILL)                112)
	((eq c 'JS_HINSI_LIST)          114)
	((eq c 'JS_HINSI_NAME)          115)
	((eq c 'JS_HINSI_NUMBER)        116)
	((eq c 'JS_HINSI_DICTS)         117)
	((eq c 'JS_HINSI_TABLE_SET)     118)
	((eq c 'JS_ACCESS_ADD_HOST)         #xf00011)
	((eq c 'JS_ACCESS_ADD_USER)         #xf00012)
	((eq c 'JS_ACCESS_REMOVE_HOST)      #xf00013)
	((eq c 'JS_ACCESS_REMOVE_USER)      #xf00014)
	((eq c 'JS_ACCESS_ENABLE)           #xf00015)
	((eq c 'JS_ACCESS_DISABLE)          #xf00016)
	((eq c 'JS_ACCESS_GET_INFO)         #xf00017)
	((eq c 'JS_TEMPORARY_DIC_ADD)       #xf00021)
	((eq c 'JS_TEMPORARY_DIC_DELETE)    #xf00022)
	((eq c 'JS_AUTOLEARNING_WORD_ADD)   #xf00023)
	((eq c 'JS_SET_AUTOLEARNING_DIC)    #xf00024)
	((eq c 'JS_GET_AUTOLEARNING_DIC)    #xf00025)
	((eq c 'JS_IS_LOADED_TEMPORARY_DIC) #xf00026)
	((eq c 'JS_TEMPORARY_WORD_ADD)      #xf00027)
	((eq c 'JS_SET_HENKAN_ENV)          #xf00031)
	((eq c 'JS_GET_HENKAN_ENV)          #xf00032)
	((eq c 'JS_SET_HENKAN_HINSI)        #xf00033)
	((eq c 'JS_GET_HENKAN_HINSI)        #xf00034)
	((eq c 'JS_HENKAN_WITH_DATA)        #xf00035)
	((eq c 'JS_FI_DIC_ADD)              #xf00061)
	((eq c 'JS_FI_HINDO_FILE_CREATE)    #xf00062)
	((eq c 'JS_FI_KANREN)               #xf00065)
	((eq c 'JS_SET_FI_PRIORITY)         #xf00066)
	((eq c 'JS_OPTIMIZE_FI)             #xf00067)
	((eq c 'JS_HENKAN_IKEIJI)           #xf0006f)
	((eq c 'JS_LOCK)                    #xf00071)
	((eq c 'JS_UNLOCK)                  #xf00072)
	((eq c 'JS_FI_DIC_LIST)             #xf00081)
	((eq c 'JS_FI_DIC_LIST_ALL)         #xf00082)
	((eq c 'JS_FUZOKUGO_LIST)           #xf00083)
	
	((eq c 'JS_YOSOKU_INIT)                 #xf01001)
	((eq c 'JS_YOSOKU_FREE)                 #xf01002)
	((eq c 'JS_YOSOKU_YOSOKU)               #xf01003)
	((eq c 'JS_YOSOKU_TOROKU)               #xf01004)
	((eq c 'JS_YOSOKU_SELECTED_CAND)        #xf01005)
	((eq c 'JS_YOSOKU_DELETE_CAND)          #xf01006)
	((eq c 'JS_YOSOKU_CANCEL_LATEST_TOROKU) #xf01007)
	((eq c 'JS_YOSOKU_RESET_PRE_YOSOKU)     #xf01008)
	((eq c 'JS_YOSOKU_IKKATSU_TOROKU)       #xf01009)
	((eq c 'JS_YOSOKU_SAVE_DATALIST)        #xf0100a)
	((eq c 'JS_YOSOKU_INIT_TIME_KEYDATA)    #xf0100b)
	((eq c 'JS_YOSOKU_INIT_INPUTINFO)       #xf0100c)
	((eq c 'JS_YOSOKU_SET_USER_INPUTINFO)   #xf0100d)
	((eq c 'JS_YOSOKU_SET_TIMEINFO)         #xf0100e)
	((eq c 'JS_YOSOKU_STATUS)               #xf0100f)
	((eq c 'JS_YOSOKU_SET_PARAM)            #xf01010)
	((eq c 'JS_YOSOKU_IKKATSU_TOROKU_INIT)  #xf01011)
	((eq c 'JS_YOSOKU_IKKATSU_TOROKU_END)   #xf01012)
	((eq c 'JS_HENKAN_ASSOC)                #xf01013)
	
	((eq c 'JLIB_VERSION)           #x4003)
	((eq c 'JLIB_VERSION_WNN6)      #x4f00)
	((eq c 'JLIB_VERSION_WNN7)      #x4f01)
	
	((eq c 'WNN_C_LOCAL)            "!")
	((eq c 'WNN_FT_DICT_FILE)         1)
	((eq c 'WNN_FT_HINDO_FILE)        2)
	((eq c 'WNN_FILE_STRING)       (encode-coding-string
					"$B#W#n#n$N%U%!%$%k(B" 'euc-jp))
	((eq c 'WNN_FILE_STRING7)       (encode-coding-string
					"$B#W#n#n#7%U%!%$%k(B" 'euc-jp))
	((eq c 'WNN_FILE_STRING_LEN)     16)
	((eq c 'WNN_PASSWD_LEN)          16)
	((eq c 'WNN_HOST_LEN)            16)
	((eq c 'WNN_UNIQ_LEN)            28)
	((eq c 'WNN_FILE_HEADER_LEN)    128)
	((eq c 'WNN_FILE_HEADER_PAD)     36)
	((eq c 'WNN_FILE_BODY_PAD)      116)
	((eq c 'WNN_ENVNAME_LEN)         32)
	((eq c 'WNN_MAX_ENV_OF_A_CLIENT) 32)
	((eq c 'WNN_MAX_DIC_OF_AN_ENV)   30)
	((eq c 'WNN_MAX_FILE_OF_AN_ENV)  60)
	
	((eq c 'WNN_ACK)                  0)
	((eq c 'WNN_NAK)                 -1)
	
	((eq c 'WNN_NO_EXIST)             1)
	((eq c 'WNN_OPENF_ERR)           16)
	((eq c 'WNN_JSERVER_DEAD)        70)
	((eq c 'WNN_BAD_VERSION)         73)
	((eq c 'WNN_FILE_READ_ERROR)     90)
	((eq c 'WNN_FILE_WRITE_ERROR)    91)
	((eq c 'WNN_INCORRECT_PASSWD)    94)
	((eq c 'WNN_FILE_IN_USE)         95)
	((eq c 'WNN_UNLINK)              96)
	((eq c 'WNN_FILE_CREATE_ERROR)   97)
	((eq c 'WNN_NOT_A_FILE)          98)
	((eq c 'WNN_INODE_CHECK_ERROR)   99)
	
	((eq c 'WNN_UD_DICT)        	    2)
	((eq c 'WNN_REV_DICT)       	    3)
	((eq c 'CWNN_REV_DICT)            #x103)
	((eq c 'BWNN_REV_DICT)            #x203)
	((eq c 'WNN_COMPACT_DICT)         5)
	((eq c 'WNN_FI_SYSTEM_DICT)       6)
	((eq c 'WNN_FI_USER_DICT)         7)
	((eq c 'WNN_FI_HINDO_FILE)        8)
	((eq c 'WNN_GROUP_DICT)           9)
	((eq c 'WNN_MERGE_DICT)          10)
	((eq c 'WNN_VECT_NO)             -1)
	((eq c 'WNN_VECT_BUNSETSU)        2)
	((eq c 'WNN_VECT_KANREN)          0)
	((eq c 'WNN_VECT_KANZEN)          1)
	((eq c 'WNN_VECT_KANTAN)          1)))

(defvar wnn7-dic-no-temps ?\x3f)

(defconst wnn7rpc-error-message
  '((Japanese .
     [
      nil
      "$B%U%!%$%k$,B8:_$7$^$;$s(B"
      nil
      "$B%a%b%j(B allocation $B$G<:GT$7$^$7$?(B"
      nil
      "$B<-=q$G$O$"$j$^$;$s(B"
      "$BIQEY%U%!%$%k$G$O$"$j$^$;$s(B"
      "$BIUB08l%U%!%$%k$G$O$"$j$^$;$s(B"
      nil
      "$B<-=q%F!<%V%k$,0lGU$G$9(B"
      "$BIQEY%U%!%$%k$,;XDj$5$l$?<-=q$NIQEY%U%!%$%k$G$O$"$j$^$;$s(B"
      nil
      nil
      nil
      nil
      nil
      "$B%U%!%$%k$,%*!<%W%s$G$-$^$;$s(B"
      "$B@5$7$$IQEY%U%!%$%k$G$O$"$j$^$;$s(B"
      "$B@5$7$$IUB08l%U%!%$%k$G$O$"$j$^$;$s(B"
      "$BIUB08l$N8D?t(B, $B%Y%/%?D9$5$J$I$,B?2a$.$^$9(B"
      "$B$=$NHV9f$N<-=q$O;H$o$l$F$$$^$;$s(B"
      nil
      nil
      nil
      "$BIUB08l%U%!%$%k$NFbMF$,@5$7$/$"$j$^$;$s(B"
      "$B5?;wIJ;lHV9f$,0[>o$G$9(B(hinsi.data $B$,@5$7$/$"$j$^$;$s(B)"
      "$BL$Dj5A$NIJ;l$,A0C<IJ;l$H$7$FDj5A$5$l$F$$$^$9(B"
      "$BIUB08l%U%!%$%k$,FI$_9~$^$l$F$$$^$;$s(B"
      nil
      nil
      "$B<-=q$N%(%$%s%H%j$,B?2a$.$^$9(B"
      "$BJQ49$7$h$&$H$9$kJ8;zNs$,D92a$.$^$9(B"
      "$BIUB08l2r@ONN0h$,ITB-$7$F$$$^$9(B"
      nil
      "$B<!8uJdNN0h$,ITB-$7$F$$$^$9(B"
      "$B8uJd$,(B 1 $B$D$b:n$l$^$;$s$G$7$?(B"
      nil
      nil
      nil
      nil
      "$BFI$_$,D92a$.$^$9(B"
      "$B4A;z$,D92a$.$^$9(B"
      "$B;XDj$5$l$?<-=q$OEPO?2DG=$G$O$"$j$^$;$s(B"
      "$BFI$_$ND9$5$,(B 0 $B$G$9(B"
      "$B;XDj$5$l$?<-=q$O5U0z$-2DG=$G$O$"$j$^$;$s(B"
      "$B%j!<%I%*%s%j!<$N<-=q$KEPO?(B/$B:o=|$7$h$&$H$7$^$7$?(B"
      "$B4D6-$KB8:_$7$J$$<-=q$KEPO?$7$h$&$H$7$^$7$?(B"
      nil
      nil
      "$B%j!<%I%*%s%j!<$NIQEY$rJQ99$7$h$&$H$7$^$7$?(B"
      "$B;XDj$5$l$?C18l$,B8:_$7$^$;$s(B"
      nil
      nil
      nil
      nil
      nil
      nil
      nil
      nil
      nil
      "$B%a%b%j(B allocation $B$G<:GT$7$^$7$?(B"
      nil
      nil
      nil
      nil
      nil
      nil
      nil
      "$B2?$+$N%(%i!<$,5/$3$j$^$7$?(B"
      "$B%P%0$,H/@8$7$F$$$kLOMM$G$9(B"
      "$B%5!<%P$,;`$s$G$$$^$9(B"
      "allocation $B$K<:GT$7$^$7$?(B"
      "$B%5!<%P$H@\B3$G$-$^$;$s$G$7$?(B"
      "$BDL?.%W%m%H%3%k$N%P!<%8%g%s$,9g$C$F$$$^$;$s(B"
      "$B%/%i%$%"%s%H$N@8@.$7$?4D6-$G$O$"$j$^$;$s(B"
      nil
      nil
      nil
      nil
      nil
      "$B%G%#%l%/%H%j$r:n$k$3$H$,$G$-$^$;$s(B"
      nil
      nil
      nil
      nil
      nil
      nil
      nil
      nil
      nil
      "$B%U%!%$%k$rFI$_9~$`$3$H$,$G$-$^$;$s(B"
      "$B%U%!%$%k$r=q$-=P$9$3$H$,$G$-$^$;$s(B"
      "$B%/%i%$%"%s%H$NFI$_9~$s$@%U%!%$%k$G$O$"$j$^$;$s(B"
      "$B$3$l0J>e%U%!%$%k$rFI$_9~$`$3$H$,$G$-$^$;$s(B"
      "$B%Q%9%o!<%I$,4V0c$C$F$$$^$9(B"
      "$B%U%!%$%k$,FI$_9~$^$l$F$$$^$9(B"
      "$B%U%!%$%k$,:o=|$G$-$^$;$s(B"
      "$B%U%!%$%k$,:n@.=PMh$^$;$s(B"
      "WNN $B$N%U%!%$%k$G$"$j$^$;$s(B"
      "$B%U%!%$%k$N(B inode $B$H(B FILE_UNIQ $B$r0lCW$5$;$k;v$,$G$-$^$;$s(B"
      "$BIJ;l%U%!%$%k$,Bg$-2a$.$^$9(B"
      "$BIJ;l%U%!%$%k$,Bg$-2a$.$^$9(B"
      "$BIJ;l%U%!%$%k$,B8:_$7$^$;$s(B"
      "$BIJ;l%U%!%$%k$NFbMF$,4V0c$C$F$$$^$9(B"
      nil
      "$BIJ;l%U%!%$%k$,FI$_9~$^$l$F$$$^$;$s(B"
      "$BIJ;lL>$,4V0c$C$F$$$^$9(B"
      "$BIJ;lHV9f$,4V0c$C$F$$$^$9(B"
      nil
      "$B$=$NA`:n$O%5%]!<%H$5$l$F$$$^$;$s(B"
      "$B%Q%9%o!<%I$NF~$C$F$$$k%U%!%$%k$,%*!<%W%s$G$-$^$;$s(B"
      "uumrc $B%U%!%$%k$,B8:_$7$^$;$s(B"
      "uumrc $B%U%!%$%k$N7A<0$,8m$C$F$$$^$9(B"
      "$B$3$l0J>e4D6-$r:n$k$3$H$O$G$-$^$;$s(B"
      "$B$3$N%/%i%$%"%s%H$,FI$_9~$s$@%U%!%$%k$G$"$j$^$;$s(B"
      "$B<-=q$KIQEY%U%!%$%k$,$D$$$F$$$^$;$s(B"
      "$B%Q%9%o!<%I$N%U%!%$%k$,:n@.=PMh$^$;$s(B"
      ]))
  "Array of WNN error messages.  Indexed by error code.")

(defconst wnn7rpc-error-message500
  '((Japanese .
     [
      "$B0l;~3X=,<-=q$,4{$K4D6-$KEPO?$5$l$F$$$^$9(B"
      "$B0l;~3X=,<-=q$N4D6-$X$NEPO?$K<:GT$7$^$7$?(B"
      "$B0l;~3X=,<-=q$N4D6-$+$i$N:o=|$K<:GT$7$^$7$?(B"
      "$B%Q%i%a!<%?<+F0%A%e!<%K%s%0=hM}$r=i4|2=$9$k$3$H$,$G$-$^$;$s(B"
      "$B%Q%i%a!<%?<+F0%A%e!<%K%s%0%G!<%?$r:n@.$9$k$3$H$,$G$-$^$;$s(B"
      "$B%Q%i%a!<%?<+F0%A%e!<%K%s%0%G!<%?$,4V0c$C$F$$$^$9(B"
      ]))
  "Array of WNN error messages part of 500-1000.  caution, start-no. is 500")

(defconst wnn7rpc-error-message3000
  '((Japanese .
     [
      nil
      "$B#F#I4X78<-=q%U%!%$%k$G$O$"$j$^$;$s(B"
      "$B#F#I4X78IQEY%U%!%$%k$G$O$"$j$^$;$s(B"
      "$B#F#I4X78%7%9%F%`<-=q$G$O$"$j$^$;$s(B"
      "$B#F#I4X78%f!<%6<-=q$G$O$"$j$^$;$s(B"
      "$B8E$$%P!<%8%g%s$NIUB08l%U%!%$%k$,@_Dj$5$l$F$$$^$9(B"
      "$B#1$D$NIQEY%U%!%$%k$r0[$J$k<-=q4V$G6&MQ$7$h$&$H$7$^$7$?(B"
      nil
      nil
      nil
      "$B%5!<%P$,%m%C%/$5$l$F$$$^$9(B"
      "$B%i%$%;%s%9$,<hF@$G$-$^$;$s(B"
      ]))
  "Array of WNN error messages part of 3000-4000.  Indexed by error code.")

(defconst wnn7rpc-error-message4000
  '((Japanese .
     [
      nil
      nil
      nil
      nil
      "$BF~NOM=B,%(%i!<(B (4004)"
      nil
      nil
      "$BM=B,8uJdEPO??t$,%*!<%P!<$7$^$7$?(B"
      nil
      "$BF~NOM=B,%(%i!<(B (4009)"
      "$BF~NOM=B,%(%i!<(B (4010)"
      "$BF~NOM=B,%(%i!<(B (4011)"
      "$BF~NOM=B,%(%i!<(B (4012)"
      "$BF~NOM=B,%(%i!<(B (4013)"
      "$BF~NOM=B,%(%i!<(B (4014)"
      ]))
  "Array of WNN error messages part of 4000-5000.  Indexed by error code.")

(defconst wnn7rpc-error-message5000
  '((Japanese .
     [
      nil
      "$B%*%s%G%#%9%/$N%U%!%$%k$r%m!<%I$G$-$^$;$s(B"
      "$B<-=q$,%m!<%I$5$l$F$$$^$;$s(B"
      "$B%*%s%G%#%9%/$G$O%5%]!<%H$7$F$$$J$$%U%!%$%k$G$9(B"
      "$B<-=q%G!<%?$NFI$_9~$_NN0h$,3NJ]$G$-$^$;$s$G$7$?(B"
      "$B%U%!%$%k$N%7!<%/$K<:GT$7$^$7$?(B"
      ]))
  "Array of WNN error messages part of 5000-.  Indexed by error code.")

(defvar wnn7rpc-timeout 10)

(defun wnn7rpc-get-error-message (errno)
  "Return error message string specified by ERRNO."
  (let ((msg))
    (cond ((< errno 500)
	   (setq msg (cdr (assq 'Japanese wnn7rpc-error-message))))
	  ((< errno 1000)
	   (setq msg (cdr (assq 'Japanese wnn7rpc-error-message500)))
	   (setq errno (- errno 500)))
	  ((< errno 4000)
	   (setq msg (cdr (assq 'Japanese wnn7rpc-error-message3000)))
	   (setq errno (- errno 3000)))
	  ((< errno 5000)
	   (setq msg (cdr (assq 'Japanese wnn7rpc-error-message4000)))
	   (setq errno (- errno 4000)))
	  ((< errno 6000)
	   (setq msg (cdr (assq 'Japanese wnn7rpc-error-message5000)))
	   (setq errno (- errno 5000))))
    (or (and (< errno (length msg)) (aref msg errno))
	(format "?\\x%d" errno))))

(defmacro wnn7rpc-call-with-proc (proc vlist send-expr &rest receive-exprs)
  `(comm-call-with-proc ,proc
       ((zhuyin nil)
	(comm-accept-timeout wnn7rpc-timeout)
	,@vlist)
     ,send-expr ,@receive-exprs))

(defmacro wnn7rpc-call-with-environment (env vlist send-expr &rest rcv-exprs)
  `(comm-call-with-proc (wnn7env-get-proc ,env)
       ((zhuyin nil)
	(comm-accept-timeout wnn7rpc-timeout)
	(env-id (wnn7env-get-env-id ,env))
	,@vlist)
     ,send-expr ,@rcv-exprs))

(defmacro wnn7rpc-get-result (&rest body)
  `(let (result)
     (comm-unpack (u) result)
     (if (< result 0)
       (progn
	 (comm-unpack (u) result)
	 (- result))
     ,@(or body '(result)))))

(defun wnn7rpc-open-internal (proc version myhostname username)
  "Open the session.  Return 0 on success, error code on failure."
  (comm-call-with-proc proc ()
    (comm-format (u u s s)
		 (wnn-const JS_OPEN)
		 version myhostname username)
    (wnn7rpc-get-result)))

(defun wnn7rpc-open (proc myhostname username)
  "Open the session.  Return 0 on success, NIL on failure."
  (let ((wnnversion (wnn-const JLIB_VERSION_WNN7))
	result)
    (setq result (wnn7rpc-open-internal proc wnnversion myhostname username))))

(defun wnn7rpc-connect (proc envname)
  "Establish new `connection' and make an environment.
Return the identitifation of the environment on success, 
or negative error code on failure."
  (comm-call-with-proc proc ()
    (comm-format (u s) (wnn-const JS_CONNECT) envname)
    (wnn7rpc-get-result)))

(defun wnn7rpc-file-read (env filename)
  "Read the file FILENAME on the environment ENV
Return non-negative file ID on success, or negative error code on failure."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u s) (wnn-const JS_FILE_READ) env-id filename)
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-fuzokugo-file (env fid)
  "For PROC, on environment ENV-ID, 
Set Fuzokugo file specified by FID.
Return 0 on success, negate-encoded error code on failure."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u i) (wnn-const JS_FUZOKUGO_SET) env-id fid)
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-dictionary (env dic-id freq-id priority dic-rw freq-rw
				  dic-passwd freq-passwd reverse)
  "Set dictionary on server.
Return dictionary number on success, negate-encoded error code on faiulure."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u i i i u u s s u) (wnn-const JS_DIC_ADD)
		 env-id dic-id freq-id
		 priority
		 (if (numberp dic-rw) dic-rw (if dic-rw 0 1))
		 (if (numberp freq-rw) freq-rw (if freq-rw 0 1))
		 dic-passwd freq-passwd
		 (if reverse 1 0))
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-fi-dictionary (env dic-id freq-id sys dic-rw freq-rw
				     dic-passwd freq-passwd)
  "Set FI dictionary on the server.
Return 0 on success, negate-encoded error code on faiulure."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u i i u u u s s) (wnn-const JS_FI_DIC_ADD)
		 env-id dic-id freq-id
		 (if sys
		     (wnn-const WNN_FI_SYSTEM_DICT)
		   (wnn-const WNN_FI_USER_DICT))
		 (if (numberp dic-rw) dic-rw (if dic-rw 0 1))
		 (if (numberp freq-rw) freq-rw (if freq-rw 0 1))
		 dic-passwd freq-passwd)
    (wnn7rpc-get-result)))

(defun wnn7rpc-get-autolearning-dic (env type)
  "Get id of auto learning dictionary on the server.
Return dictionary id + 1 on success, 0 on no dictionary, negate-encoded
error code on faiulure."
  (wnn7rpc-call-with-environment env (result)
    (comm-format (u u u) (wnn-const JS_GET_AUTOLEARNING_DIC)
		 env-id type)
    (wnn7rpc-get-result
      (comm-unpack (u) result)
      (1+ result))))

(defun wnn7rpc-set-autolearning-dic (env type dic-id)
  "Set auto learning dictionary on the server.
Return 0 on success, negate-encoded error code on faiulure."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u i) (wnn-const JS_SET_AUTOLEARNING_DIC)
		 env-id type dic-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-version (proc)
  "Return the version number of WNN server."
  (comm-call-with-proc proc (result)
    (comm-format (u) (wnn-const JS_VERSION))
    (comm-unpack (u) result)
    result))

(defun wnn7rpc-access (env path mode) 
  "Check the accessibility of file in the environment ENV.
Return 0 when the remote file (dictionary/frequency) of PATH on server
can be accessed in mode MODE.  Return Non-zero otherwise."
  (wnn7rpc-call-with-environment env (result)
    (comm-format (u u u s) (wnn-const JS_ACCESS) env-id mode path)
    (comm-unpack (u) result)
    result))

(defun wnn7rpc-mkdir (env path)
  "Create directory specified by PATH."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u s) (wnn-const JS_MKDIR) env-id path)
    (wnn7rpc-get-result)))

(defun wnn7rpc-writable-dic-type (env fi rw)
  (cond (fi                        (wnn-const WNN_FI_USER_DICT))
	((eq rw 3)                 (wnn-const WNN_GROUP_DICT))
	((eq rw 4)                 (wnn-const WNN_MERGE_DICT))
	(t                         (wnn-const WNN_REV_DICT))))

(defun wnn7rpc-dic-file-create (env dicname type comment passwd hpasswd)
  "Create a dictionary on the server."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u s S s s u) (wnn-const JS_DIC_FILE_CREATE)
		 env-id dicname comment
		 passwd hpasswd type)
    (wnn7rpc-get-result)))

(defun wnn7rpc-hindo-file-create (env fi dic-id freqname comment passwd)
  "Create a frequency file on the server."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u s S s)
		 (if fi
		     (wnn-const JS_FI_HINDO_FILE_CREATE)
		   (wnn-const JS_HINDO_FILE_CREATE))
		 env-id dic-id freqname comment passwd)
    (wnn7rpc-get-result)))

(defun wnn7rpc-file-discard (env fid)
  "Discard a file specified by FID.  Call this for already-opened file
before remove and create new file."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u i) (wnn-const JS_FILE_DISCARD)
		 env-id fid)
    (wnn7rpc-get-result)))

(defun wnn7rpc-file-remove (proc filename passwd)
  "Remove the file."
  (comm-call-with-proc proc ()
    (comm-format (u s s) (wnn-const JS_FILE_REMOVE)
		 filename (or passwd ""))
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-conversion-parameter (env v)
  "Set conversion parameter."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u i i i i i i i i i i i i i i i i i)
		 (wnn-const JS_PARAM_SET)
		 env-id
		 (aref v  0) (aref v  1) (aref v  2) (aref v  3) (aref v  4)
		 (aref v  5) (aref v  6) (aref v  7) (aref v  8) (aref v  9)
		 (aref v 10) (aref v 11) (aref v 12) (aref v 13) (aref v 14)
		 (aref v 15) (aref v 16))
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-conversion-env-param (env mask v)
  "Set Wnn7 conversion parameter."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u i i i i i i i i i i i i i i i i i i i i i i i i)
		 (wnn-const JS_SET_HENKAN_ENV)
		 env-id mask
		 (aref v  0) (aref v  1) (aref v  2) (aref v  3) (aref v  4)
		 (aref v  5) (aref v  6) (aref v  7) (aref v  8) (aref v  9)
		 (aref v 10) (aref v 11) (aref v 12) (aref v 13) (aref v 14)
		 (aref v 15) (aref v 16) (aref v 17) (aref v 18) (aref v 19)
		 (aref v 20) (aref v 21) (aref v 22) (aref v 23))
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-conversion-env-param-highbit (env maskh maskl v)
  "Set Wnn7 conversion parameter (use high bit mask)."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u w w i i i i i i i i i i i i i i i i i i i i i i i i)
		 (wnn-const JS_SET_HENKAN_ENV)
		 env-id maskh maskl
		 (aref v  0) (aref v  1) (aref v  2) (aref v  3) (aref v  4)
		 (aref v  5) (aref v  6) (aref v  7) (aref v  8) (aref v  9)
		 (aref v 10) (aref v 11) (aref v 12) (aref v 13) (aref v 14)
		 (aref v 15) (aref v 16) (aref v 17) (aref v 18) (aref v 19)
		 (aref v 20) (aref v 21) (aref v 22) (aref v 23))
    (wnn7rpc-get-result)))

(defun wnn7rpc-temporary-dic-loaded (env)
  "Ask to the server whether the temporary dictionary is loaded or not.
Return positive if loaded, zero if not, negative on failure."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_IS_LOADED_TEMPORARY_DIC)
		 env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-temporary-dic-add (env reverse)
  "Add temporary dictionary on the server."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u) (wnn-const JS_TEMPORARY_DIC_ADD)
		 env-id (if reverse 1 0))
    (wnn7rpc-get-result)))

(defun wnn7rpc-receive-sho-bunsetsu-list (env n-bunsetsu)
  (let ((proc (wnn7env-get-proc env))
	slist
	end start jiritsugo-end dic-no entry freq right-now
	hinshi status status-backward kangovect evaluation
	result source fuzokugo)
    (while (> n-bunsetsu 0)
      (comm-unpack (u u u u u u u u u u u u)
		   end start jiritsugo-end
		   dic-no entry freq right-now hinshi
		   status status-backward kangovect evaluation)
      (setq slist
	    (cons
	     (wnn7-bunsetsu-create env (1+ (- jiritsugo-end start))
				  dic-no entry freq right-now hinshi
				  status status-backward kangovect evaluation)
	     slist))
      (setq n-bunsetsu (1- n-bunsetsu)))
    (prog1
	(setq slist (nreverse slist))
      (while slist
	(comm-unpack (S S S) result source fuzokugo)
	(wnn7-bunsetsu-set-converted (car slist) result)
	(wnn7-bunsetsu-set-yomi (car slist) source)
	(wnn7-bunsetsu-set-fuzokugo (car slist) fuzokugo)
	(setq slist (cdr slist))))))

(defun wnn7rpc-receive-dai-bunsetsu-list (env n-dai separate)
  (let ((proc (wnn7env-get-proc env))
	n-bunstsu kanji-length dlist slist
	end start n-sho evaluation
	n retval)
    (comm-unpack (u u) n-bunstsu kanji-length)
    (while (> n-dai 0)
      (comm-unpack (u u u u) end start n-sho evaluation)
      (setq dlist (cons (cons n-sho evaluation) dlist)
	    n-dai (1- n-dai)))
    (setq dlist (nreverse dlist)
	  slist (wnn7rpc-receive-sho-bunsetsu-list env n-bunstsu))
    (if (null separate)
	(prog1
	    slist
	  (while dlist
	    (setq n (caar dlist))
	    (while (> n 0)
	      (wnn7-bunsetsu-set-dai-evaluation (car slist) (cdar dlist))
	      (wnn7-bunsetsu-set-dai-continue (car slist) (> n 1))
	      (setq slist (cdr slist)
		    n (1- n)))
	    (setq dlist (cdr dlist))))
      (while dlist
	(setq retval (cons slist retval)
	      n (caar dlist))
	(while (> n 1)
	  (wnn7-bunsetsu-set-dai-evaluation (car slist) (cdar dlist))
	  (wnn7-bunsetsu-set-dai-continue (car slist) t)
	  (setq slist (cdr slist)
		n (1- n)))
	(wnn7-bunsetsu-set-dai-evaluation (car slist) (cdar dlist))
	(wnn7-bunsetsu-set-dai-continue (car slist)
				       (wnn7-bunsetsu-connect-next 
					(car slist)))
	(setq slist (prog1 (cdr slist) (setcdr slist nil))
	      dlist (cdr dlist)))
      (nreverse retval))))

(defun wnn7rpc-renbunsetsu-conversion (env yomi hinshi fuzokugo v)
  "Convert YOMI string into Kanji.
HINSHI and FUZOKUGO are information of preceding bunsetsu."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u S i S i i i) (wnn-const JS_KANREN)
		 env-id yomi hinshi fuzokugo
		 (or v (wnn-const WNN_VECT_KANREN))
		 (if v (wnn-const WNN_VECT_KANREN) (wnn-const WNN_VECT_NO))
		 (wnn-const WNN_VECT_BUNSETSU))
     (wnn7rpc-get-result
      (wnn7rpc-receive-dai-bunsetsu-list env result nil))))

(defun wnn7rpc-fi-renbunsetsu-conversion (env yomi hinshi fuzokugo v context)
  "Convert YOMI string into Kanji.
HINSHI and FUZOKUGO are information of preceding bunsetsu."
  (wnn7rpc-call-with-environment env (result)
    (comm-format (u u S i S i i i i i i i S i i i i S) (wnn-const JS_FI_KANREN)
		 env-id yomi hinshi fuzokugo
		 (or v (wnn-const WNN_VECT_KANREN))
		 (if v (wnn-const WNN_VECT_KANREN) (wnn-const WNN_VECT_NO))
		 (wnn-const WNN_VECT_BUNSETSU)
		 (wnn7-context-dic-no (car context))
		 (wnn7-context-entry (car context))
		 (wnn7-context-jirilen (car context))
		 (wnn7-context-hinshi (car context))
		 (wnn7-context-fuzokugo (car context))
		 (wnn7-context-dic-no (nth 1 context))
		 (wnn7-context-entry (nth 1 context))
		 (wnn7-context-jirilen (nth 1 context))
		 (wnn7-context-hinshi (nth 1 context))
		 (wnn7-context-fuzokugo (nth 1 context)))
    (setq result (wnn7rpc-get-result
		   (wnn7rpc-receive-dai-bunsetsu-list env result nil)))
    (prog1
	result
      (unless (numberp result)
	(wnn7-bunsetsu-set-fi-rel (car result)
				  (wnn7rpc-get-fi-relation-data env))
	(while result
	  (wnn7-bunsetsu-set-context (car result) context)
	  (setq result (cdr result)))))))

(defun wnn7rpc-get-fi-relation-data (env)
  "Receive FI relation data from the server."
  (let ((proc (wnn7env-get-proc env))
	fi-dic dic entry offset num result)
    (comm-unpack (i) num)
    (while (> num 0)
      (comm-unpack (u u u u) fi-dic dic entry offset)
      (setq result (cons (vector fi-dic dic entry offset -2 -4) result)
	    num (1- num)))
    (nreverse result)))

(defun wnn7rpc-tanbunsetsu-conversion (env yomi hinshi fuzoku v)
  ""
  (wnn7rpc-call-with-environment env (kanji-length)
    (comm-format (u u S i S i i) (wnn-const JS_KANTAN_SHO)
		 env-id yomi hinshi fuzoku
		 (or v (wnn-const WNN_VECT_KANTAN))
		 (if v (wnn-const WNN_VECT_KANTAN) (wnn-const WNN_VECT_NO)))
    (wnn7rpc-get-result
      (comm-unpack (u) kanji-length)	; ignore kanji-length
      (wnn7rpc-receive-sho-bunsetsu-list env result))))

(defun wnn7rpc-get-bunsetsu-candidates (env yomi hinshi fuzoku v)
  ""
  (wnn7rpc-call-with-environment env (kanji-length)
    (comm-format (u u S i S i i) (wnn-const JS_KANZEN_SHO)
		 env-id yomi hinshi fuzoku
		 (or v (wnn-const WNN_VECT_KANZEN))
		 (if v (wnn-const WNN_VECT_KANZEN) (wnn-const WNN_VECT_NO)))
    (wnn7rpc-get-result
      (comm-unpack (u) kanji-length)	; ignore kanji-length
      (mapcar (lambda (b)
		(wnn7-bunsetsu-set-dai-continue b 
						(wnn7-bunsetsu-connect-next b))
		(list b))
	      (wnn7rpc-receive-sho-bunsetsu-list env result)))))

(defun wnn7rpc-daibunsetsu-conversion (env yomi hinshi fuzoku v)
  ""
  (wnn7rpc-call-with-environment env (n-sho-bunsetsu kanji-size)
    (comm-format (u u S i S i i) (wnn-const JS_KANTAN_DAI)
		 env-id yomi hinshi fuzoku
		 (or v (wnn-const WNN_VECT_KANTAN))
		 (if v (wnn-const WNN_VECT_KANTAN) (wnn-const WNN_VECT_NO)))
    (wnn7rpc-get-result
      (wnn7rpc-receive-dai-bunsetsu-list env result nil))))

(defun wnn7rpc-get-daibunsetsu-candidates (env yomi hinshi fuzoku v)
  ""
  (wnn7rpc-call-with-environment env (n-sho-bunsetsu kanji-size)
    (comm-format (u u S i S i i) (wnn-const JS_KANZEN_DAI)
		 env-id yomi hinshi fuzoku
		 (or v (wnn-const WNN_VECT_KANZEN))
		 (if v (wnn-const WNN_VECT_KANZEN) (wnn-const WNN_VECT_NO)))
    (wnn7rpc-get-result
      (wnn7rpc-receive-dai-bunsetsu-list env result t))))

(defun wnn7rpc-set-frequency (env dicno entry ima hindo)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u i i i i) (wnn-const JS_HINDO_SET)
		 env-id dicno entry ima hindo)
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-fi-priority (env fi-rel)
  ""
  (wnn7rpc-call-with-environment env ()
    (progn
      (comm-format (u u u) (wnn-const JS_SET_FI_PRIORITY)
		   env-id (length fi-rel))
      (while fi-rel
	(comm-format (i i i i i i)
		     (aref (car fi-rel) 0) (aref (car fi-rel) 1)
		     (aref (car fi-rel) 2) (aref (car fi-rel) 3)
		     (aref (car fi-rel) 4) (aref (car fi-rel) 5))
	(setq fi-rel (cdr fi-rel))))
    (wnn7rpc-get-result)))

(defun wnn7rpc-optimize-fi (env context)
  ""
  (wnn7rpc-call-with-environment env (c)
    (progn
      (comm-format (u u u) (wnn-const JS_OPTIMIZE_FI)
		   env-id (length context))
      (while context
	(setq c (car context)
	      context (cdr context))
	(comm-format (i i i i i S)
		     (wnn7-context-dic-no c)
		     (wnn7-context-entry c)
		     (wnn7-context-right-now c)
		     (wnn7-context-freq c)
		     (wnn7-context-length c)
		     (concat (wnn7-context-converted c)
			     (wnn7-context-fuzokugo c)))))
    (wnn7rpc-get-result)))

(defun wnn7rpc-close (proc)
  ""
  (comm-call-with-proc proc ()
    (comm-format (u) (wnn-const JS_CLOSE))
    (wnn7rpc-get-result)))

(defun wnn7rpc-env-exist (proc envname)
  ""
  (comm-call-with-proc proc (result)
    (comm-format (u s) (wnn-const JS_ENV_EXIST) envname)
    (comm-unpack (u) result)
    result))

(defun wnn7rpc-make-env-sticky (env)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_ENV_STICKY) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-make-env-unsticky (env)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_ENV_UNSTICKY) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-disconnect (env)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_DISCONNECT) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-add-word (env dictionary yomi kanji comment hinshi initial-freq)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u S S S u u) (wnn-const JS_WORD_ADD)
		 env-id dictionary yomi kanji comment hinshi initial-freq)
    (wnn7rpc-get-result)))

(defun wnn7rpc-auto-learning (env type yomi kanji comment hinshi initial-freq)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u S S S u u) (wnn-const JS_AUTOLEARNING_WORD_ADD)
		 env-id type yomi kanji comment hinshi initial-freq)
    (wnn7rpc-get-result)))

(defun wnn7rpc-temporary-learning (env yomi kanji comment hinshi initial-freq)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u S S S u u) (wnn-const JS_AUTOLEARNING_WORD_ADD)
		 env-id yomi kanji comment hinshi initial-freq)
    (wnn7rpc-get-result)))

(defun wnn7rpc-get-dictionary-list-with-environment (env)
  ""
  (wnn7rpc-call-with-environment env (n-dic)
    (comm-format (u u) (wnn-const JS_DIC_LIST) env-id)
    (comm-unpack (u) n-dic)
    (wnn7rpc-receive-dictionary-list proc n-dic)))

(defun wnn7rpc-get-fi-dictionary-list-with-environment (env mask)
  ""
  (wnn7rpc-call-with-environment env (n-dic)
    (comm-format (u u u) (wnn-const JS_FI_DIC_LIST) env-id mask)
    (comm-unpack (u) n-dic)
    (wnn7rpc-receive-dictionary-list proc n-dic)))

(defun wnn7rpc-receive-dictionary-list (proc n-dic)
  (let (entry dic freq dic-mode freq-mode enable-flag nice
	rev comment dicname freqname dic-passwd freq-passwd
	type gosuu dic-local-flag freq-local-flag retval)
    (while (> n-dic 0)
      (comm-unpack (u u u u u u u u S s s s s u u u u)
		   entry dic freq dic-mode freq-mode enable-flag nice
		   rev comment dicname freqname dic-passwd freq-passwd
		   type gosuu dic-local-flag freq-local-flag)
      (setq retval (cons
		    (vector entry dic freq dic-mode freq-mode enable-flag nice
			    rev comment dicname freqname dic-passwd freq-passwd
			    type gosuu dic-local-flag freq-local-flag)
		    retval)
	    n-dic (1- n-dic)))
    (nreverse retval)))

(defsubst wnndic-get-id (dic) (aref dic 0))
(defsubst wnndic-get-comment (dic) (aref dic 8))
(defsubst wnndic-get-dictname (dic) (aref dic 9))

(defun wnn7rpc-get-writable-dictionary-id-list (env)
  ""
  (wnn7rpc-call-with-environment env (dic-list dic)
    (comm-format (u u i) (wnn-const JS_HINSI_DICTS) env-id -1)
    (wnn7rpc-get-result
      (while (> result 0)
	(comm-unpack (u) dic)
	(setq dic-list (nconc dic-list (list dic))
	      result (1- result)))
      dic-list)))

(defun wnn7rpc-get-hinshi-list (env dic name)
  ""
  (wnn7rpc-call-with-environment env (hinshi hinshi-list str-size)
    (comm-format (u u u S) (wnn-const JS_HINSI_LIST) env-id dic name)
    (wnn7rpc-get-result
      (comm-unpack (u) str-size)	; ignore
      (while (> result 0)
	(comm-unpack (S) hinshi)
	(setq hinshi-list (nconc hinshi-list (list hinshi))
	      result (1- result)))
      hinshi-list)))

(defun wnn7rpc-hinshi-number (proc name)
  ""
  (wnn7rpc-call-with-proc proc ()
    (comm-format (u S) (wnn-const JS_HINSI_NUMBER) name)
    (wnn7rpc-get-result)))

(defun wnn7rpc-get-conversion-parameter (env)
  ""
  (wnn7rpc-call-with-environment env (n nsho p1 p2 p3 p4 p5 p6 p7 p8 p9
				     p10 p11 p12 p13 p14 p15)
    (comm-format (u u) (wnn-const JS_PARAM_GET) env-id)
    (wnn7rpc-get-result
      (comm-unpack (u u  u u u u u  u u u u u  u u u u u)
		   n nsho p1 p2 p3 p4 p5 p6 p7 p8 p9
		   p10 p11 p12 p13 p14 p15)
      (vector n nsho p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15))))

(defun wnn7rpc-get-conversion-env-param (env)
  ""
  (wnn7rpc-call-with-environment env (p1 p2 p3 p4 p5 p6 p7 p8 p9
				    p10 p11 p12 p13 p14 p15 p16 p17 p18
				    p19 p20 p21 p22 p23 p24)
    (comm-format (u u) (wnn-const JS_GET_HENKAN_ENV) env-id)
    (wnn7rpc-get-result
      (comm-unpack (i i i i i i i i i i i i i i i i i i i i i i i i)
		   p1 p2 p3 p4 p5 p6 p7 p8 p9
		   p10 p11 p12 p13 p14 p15 p16
		   p17 p18 p19 p20 p21 p22 p23 p24)
      (vector p1 p2 p3 p4 p5 p6 p7 p8 p9
	      p10 p11 p12 p13 p14 p15 p16 p17 p18
	      p19 p20 p21 p22 p23 p24))))

(defun wnn7rpc-file-loaded (proc path)
  ""
  (comm-call-with-proc proc (result)
    (comm-format (u s) (wnn-const JS_FILE_LOADED) path)
    (comm-unpack (u) result)
    result))

(defun wnn7rpc-write-file (env fid filename)
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u s) (wnn-const JS_FILE_WRITE) env-id fid filename)
    (wnn7rpc-get-result)))

(defun wnn7rpc-get-fuzokugo-file (env)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_FUZOKUGO_GET) env-id)
    (wnn7rpc-get-result)))

(defsubst wnn7rpc-receive-file-list (proc)
  (let ((i 0)
	flist
	nfiles fid local ref-count type name)
    (comm-unpack (u) nfiles)
    (while (> nfiles 0)
      (comm-unpack (u u u u s) fid local ref-count type name)
      (setq flist (nconc flist (list (vector fid local ref-count type name)))
	    nfiles (1- nfiles)))
    flist))

(defun wnn7rpc-get-file-list (proc)
  ""
  (comm-call-with-proc proc ()
    (comm-format (u) (wnn-const JS_FILE_LIST_ALL))
    (wnn7rpc-receive-file-list proc)))

(defun wnn7rpc-get-file-list-with-env (env)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_FILE_LIST) env-id)
    (wnn7rpc-receive-file-list proc)))

(defun wnn7rpc-file-attribute (env path)
  "3: dictionary, 4: hindo file, 5: fuzokugo-file"
  (wnn7rpc-call-with-environment env (result)
    (comm-format (u u s) (wnn-const JS_FILE_STAT) env-id path)
    (comm-unpack (u) result)
    result))

(defun wnn7rpc-get-file-info (env fid)
  ""
  (wnn7rpc-call-with-environment env (name local ref-count type)
    (comm-format (u u u) (wnn-const JS_FILE_INFO) env-id fid)
    (wnn7rpc-get-result
      (comm-unpack (s u u u) name local ref-count type)
      (vector name local ref-count type))))

(defmacro wnn7rpc-receive-vector (n)
  `(let ((v (make-vector ,n -1))
	 (i 0)
	 j)
     (while (< i ,n)
       (comm-unpack (u) j)
       (aset v i j)
       (setq i (1+ i)))
     v))

(defun wnn7rpc-who (proc)
  ""
  (comm-call-with-proc proc (who socket username hostname)
    (comm-format (u) (wnn-const JS_WHO))
    (wnn7rpc-get-result
      (while (> result 0)
	(comm-unpack (u s s) socket username hostname)
	(setq who (nconc who
			 (list (vector socket username hostname
				       (wnn7rpc-receive-vector
					(wnn-const WNN_MAX_ENV_OF_A_CLIENT)))))
	      result (1- result)))
      who)))

(defun wnn7rpc-get-env-list (proc)
  (comm-call-with-proc proc (envs id name count fuzokugo dic-max)
    (comm-format (u) (wnn-const JS_ENV_LIST))
    (wnn7rpc-get-result
      (while (> result 0)
	(comm-unpack (u s u u u) id name count fuzokugo dic-max)
	(setq envs (nconc envs
			  (list (vector id name count fuzokugo dic-max
					(wnn7rpc-receive-vector
					 (wnn-const WNN_MAX_DIC_OF_AN_ENV))
					(wnn7rpc-receive-vector
					 (wnn-const WNN_MAX_FILE_OF_AN_ENV)))))
	      result (1- result)))
	envs)))

(defun wnn7rpc-kill (proc)
  ""
  (comm-call-with-proc proc (result)
    (comm-format (u) (wnn-const JS_KILL))
    (comm-unpack (u) result)
    result))

(defun wnn7rpc-delete-dictionary (env dic)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u) (wnn-const JS_DIC_DELETE) env-id dic)
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-flag-on-dictionary (env dic flag)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u u) (wnn-const JS_DIC_USE) env-id dic flag)
    (wnn7rpc-get-result)))

(defun wnn7rpc-get-dictionary-list (proc)
  ""
  (wnn7rpc-call-with-proc proc (n-dic)
    (comm-format (u) (wnn-const JS_DIC_LIST_ALL))
    (comm-unpack (u) n-dic)
    (wnn7rpc-receive-dictionary-list proc n-dic)))

(defun wnn7rpc-delete-word (env dic entry)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u u) (wnn-const JS_WORD_DELETE) env-id dic entry)
    (wnn7rpc-get-result)))

(defun wnn7rpc-receive-word (proc yomi)
  (let (dic serial hinshi hindo right-now internal-hindo internal-right-now
	kanji comment l l1)
    (comm-unpack (u) dic)
    (while (>= dic 0)
      (comm-unpack (u u u u u u) serial hinshi hindo right-now
		   internal-hindo internal-right-now)
      (setq l (cons (vector dic serial hinshi hindo right-now
			    internal-hindo internal-right-now
			    yomi nil nil)
		    l))
      (comm-unpack (u) dic))
    (setq l (nreverse l)
	  l1 l)
    (while l1
      (comm-unpack (S S) kanji comment)
      (aset (car l1) 8 kanji)
      (aset (car l1) 9 comment)
      (setq l1 (cdr l1)))
    l))

(defun wnn7rpc-search-word-in-dictionary (env dic yomi)
  ""
  (wnn7rpc-call-with-environment env (n-entries len)
    (comm-format (u u u S) (wnn-const JS_WORD_SEARCH) env-id dic yomi)
    (comm-unpack (u u) n-entries len)	; ignore
    (wnn7rpc-receive-word proc yomi)))

(defun wnn7rpc-search-word (env yomi)
  ""
  (wnn7rpc-call-with-environment env (n-entries len)
    (comm-format (u u S) (wnn-const JS_WORD_SEARCH_BY_ENV) env-id yomi)
    (comm-unpack (u u) n-entries len)	; ignore
    (wnn7rpc-receive-word proc yomi)))

(defun wnn7rpc-get-word-info (env dic entry)
  ""
  (wnn7rpc-call-with-environment env (n-entries len yomi)
    (comm-format (u u u u) (wnn-const JS_WORD_INFO) env-id dic entry)
    (wnn7rpc-get-result
      (comm-unpack (S) yomi)
      (comm-unpack (u u) n-entries len)	; ignore
      (wnn7rpc-receive-word proc yomi))))

(defun wnn7rpc-set-comment-on-word (env dic entry comment)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u u S) (wnn-const JS_WORD_COMMENT_SET)
		 env-id dic entry comment)
    (wnn7rpc-get-result)))

(defun wnn7rpc-get-dictionary-info (env dic)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u) (wnn-const JS_DIC_INFO) env-id dic)
    (wnn7rpc-get-result
      (wnn7rpc-receive-dictionary-list proc 1))))

(defun wnn7rpc-set-file-comment (env fid comment)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u S) (wnn-const JS_FILE_COMMENT_SET) env-id fid comment)
    (wnn7rpc-get-result)))

(defun wnn7rpc-hinshi-name (proc hinshi)
  ""
  (wnn7rpc-call-with-proc proc ()
    (comm-format (u u) (wnn-const JS_HINSI_NAME) hinshi)
    (wnn7rpc-get-result
      (comm-unpack (S) result)
      result)))

(defun wnn7rpc-set-file-password (env fid which old new)
  "WHICH: 1: DIC, 2: HINDO, 3(0): Both"
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u u s s) (wnn-const JS_FILE_PASSWORD_SET)
		 env-id fid which old new)
    (wnn7rpc-get-result)))

(defun wnn7rpc-set-hinshi-table (env dic hinshi-table)
  ""
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u S) (wnn-const JS_HINSI_TABLE_SET)
		 env-id dic hinshi-table)
    (wnn7rpc-get-result)))

(defmacro wnn7rpc-with-temp-buffer (&rest body)
  `(with-temp-buffer
     (let ((coding-system-for-read 'no-conversion)
	   (coding-system-for-write 'no-conversion))
       (set-buffer-multibyte nil)
       ,@body)))

(defmacro wnn7rpc-with-write-file (filename error-handler &rest body)
  `(condition-case error
       (with-temp-file ,filename
	 (let ((coding-system-for-read 'no-conversion)
	       (coding-system-for-write 'no-conversion))
	   (set-buffer-multibyte nil)
	   ,@body))
     (file-error ,error-handler)))

(defmacro wnn7rpc-terminate-current-command (errno)
  `(progn
     (comm-call-with-proc-1 proc ()
       (comm-format (i) (wnn-const WNN_NAK)))
     (- (wnn-const ,errno))))

(defun wnn7rpc-get-local-filename (name)
  (if (and (string-match (wnn-const WNN_C_LOCAL) name)
	   (string= (substring name 0 (match-beginning 0)) wnn-system-name))
      (substring name (match-end 0))
    name))

;; <header> ::= (<type> <uniq> <uniq> <passwd>)
;; <uniq>   ::= string
;; <passwd> ::= string

(defun wnn7rpc-scan-file-header ()
  (let ((proc nil)
	type uniq1 uniq2 passwd)
    (if (and (> (point-max) (wnn-const WNN_FILE_HEADER_LEN))
;;;	     (equal (buffer-substring 1 (1+ (wnn-const WNN_FILE_STRING_LEN)))
;;;		    (wnn-const WNN_FILE_STRING)))
	     (or (equal (buffer-substring 1 (1+ (wnn-const WNN_FILE_STRING_LEN)))
			(wnn-const WNN_FILE_STRING))
		 (equal (buffer-substring 1 (1+ (wnn-const WNN_FILE_STRING_LEN)))
			(wnn-const WNN_FILE_STRING7))))
	(progn
	  (goto-char (1+ (wnn-const WNN_FILE_STRING_LEN)))
	  (comm-unpack (u v v v)
		       type
		       uniq1 (wnn-const WNN_UNIQ_LEN)
		       uniq2 (wnn-const WNN_UNIQ_LEN)
		       passwd (wnn-const WNN_PASSWD_LEN))
	  (list type uniq1 uniq2 passwd)))))

(defun wnn7rpc-get-file-header (filename)
  (wnn7rpc-with-temp-buffer
    (if (null (file-readable-p filename))
	(list nil (make-string (wnn-const WNN_UNIQ_LEN) 0) "" "")
      (insert-file-contents filename nil 0 (wnn-const WNN_FILE_HEADER_LEN))
      (wnn7rpc-scan-file-header))))

(defun wnn7rpc-check-local-file (path &optional preserve)
  (let ((header (wnn7rpc-get-file-header path)))
    (cond ((null header)
	   (- (wnn-const WNN_NOT_A_FILE)))
	  ((null (car header))
	   (if (file-exists-p path) 
	       (- (wnn-const WNN_OPENF_ERR))
	     (- (wnn-const WNN_NO_EXIST))))
	  (t
	   (if (wnn7rpc-check-inode header path)
	       header
	     (if preserve
		 (- (wnn-const WNN_INODE_CHECK_ERROR))
	       (wnn7rpc-change-file-uniq header path)
	       (wnn7rpc-check-local-file path t)))))))

(defsubst wnn7rpc-get-inode (uniq)
  (+ (lsh (aref uniq 8) 24)
     (lsh (aref uniq 9) 16)
     (lsh (aref uniq 10) 8)
     (aref uniq 11)))

(defun wnn7rpc-check-inode (header path)
  (let ((inode (nth 10 (file-attributes path))))
    (and inode (= inode (wnn7rpc-get-inode (nth 1 header))))))

(defun wnn7rpc-make-uniq (attributes)
  (wnn7rpc-with-temp-buffer
    (let ((ctime (nth 6 attributes))
	  (ino (nth 10 attributes))
	  (devno (nth 11 attributes)))
      (if (numberp devno)
	  (comm-format (U i u V)
		       ctime devno ino
		       wnn-system-name (wnn-const WNN_HOST_LEN))
	;; Emacs 21 returns returns negative devno as 16 bits uint pair
	(comm-format (U U u V)
		     ctime (list (car devno) (cdr devno)) ino
		     wnn-system-name (wnn-const WNN_HOST_LEN)))
      (buffer-string))))

(defun wnn7rpc-change-file-uniq (header path &optional new)
  (wnn7rpc-with-write-file path
      nil
    (insert-file-contents path)
    (if (wnn7rpc-scan-file-header)
	(let ((uniq (wnn7rpc-make-uniq (file-attributes path))))
	  (goto-char (1+ (wnn-const WNN_FILE_STRING_LEN)))
	  (delete-region (point) (1+ (wnn-const WNN_FILE_HEADER_LEN)))
	  (comm-format (u v v v v)
		       (car header)
		       uniq (wnn-const WNN_UNIQ_LEN)
		       (if new uniq (nth 1 header)) (wnn-const WNN_UNIQ_LEN)
		       (nth 3 header) (wnn-const WNN_PASSWD_LEN)
		       "" (wnn-const WNN_FILE_HEADER_PAD))
	  t))))

(defun wnn7rpc-check-passwd (proc passwd header)
  (let ((env-id -1))
    (unwind-protect
	(if (< (setq env-id (wnn7rpc-connect proc "")) 0)
	    -1
	  (wnn7rpc-call-with-environment (wnn7-env-create proc env-id)
	      (file-id)
	    (comm-format (u u v) (wnn-const JS_FILE_SEND)
			 env-id
			 (nth 1 header) (wnn-const WNN_UNIQ_LEN))
	    (comm-unpack (u) file-id)
	    (if (>= file-id 0)
		(progn
		  (wnn7rpc-get-result)	; ignore result code
		  (- (wnn-const WNN_FILE_IN_USE)))
	      (wnn7rpc-get-result
		(comm-call-with-proc-1 proc ()
		  (comm-format (s B)
			       (concat wnn-system-name "!TEMPFILE")
			       (wnn7rpc-make-dummy-dictionary header))
		  (wnn7rpc-get-result
		    (let ((egg-fixed-euc (list egg-fixed-euc egg-fixed-euc)))
		      (wnn7rpc-set-dictionary (wnn7-env-create proc env-id)
					     result -1 1 t t
					     passwd "" nil))))))))
      (if (>= env-id 0)
	  (wnn7rpc-disconnect (wnn7-env-create proc env-id))))))

(defun wnn7rpc-make-dummy-dictionary (header)
  (wnn7rpc-with-temp-buffer
    (comm-format (v u v v v v u v)
;;;		 (wnn-const WNN_FILE_STRING) (wnn-const WNN_FILE_STRING_LEN)
		 (wnn-const WNN_FILE_STRING7) (wnn-const WNN_FILE_STRING_LEN)
		 (wnn-const WNN_FT_DICT_FILE)
		 (nth 1 header) (wnn-const WNN_UNIQ_LEN)
		 (nth 1 header) (wnn-const WNN_UNIQ_LEN)
		 (nth 3 header) (wnn-const WNN_PASSWD_LEN)
		 "" (wnn-const WNN_FILE_HEADER_PAD)
		 (wnn-const WNN_REV_DICT)
		 "" (wnn-const WNN_FILE_BODY_PAD))
    (buffer-string)))

(defun wnn7rpc-file-loaded-local (proc path &optional preserve)
  ""
  (let ((header (wnn7rpc-check-local-file path preserve)))
    (if (numberp header)
	-1
      (comm-call-with-proc proc (result)
	(comm-format (u v) (wnn-const JS_FILE_LOADED_LOCAL)
		     (nth 1 header) (wnn-const WNN_UNIQ_LEN))
	(comm-unpack (u) result)
	result))))

(defun wnn7rpc-file-receive (env fid local-filename)
  ""
  (condition-case err
      (wnn7rpc-call-with-environment env (filename)
	(comm-format (u u u) (wnn-const JS_FILE_RECEIVE)
		     env-id fid)
	(comm-unpack (s) filename)
	(if (null local-filename)
	    (setq local-filename (wnn7rpc-get-local-filename filename)))
	(let ((header (wnn7rpc-get-file-header local-filename))
	      contents)
	  (if (null header)
	      (wnn7rpc-terminate-current-command WNN_NOT_A_FILE)
	    (comm-call-with-proc-1 proc ()
	      (comm-format (u v) (wnn-const WNN_ACK)
			   (nth 1 header) (wnn-const WNN_UNIQ_LEN)))
	    (wnn7rpc-get-result
	      (cond
	       ((= result 0) 0)
	       ((null (file-writable-p local-filename))
		(wnn7rpc-terminate-current-command WNN_FILE_WRITE_ERROR))
	       (t
		(wnn7rpc-with-write-file local-filename
		    (- (wnn-const WNN_FILE_WRITE_ERROR))	    
		  (comm-call-with-proc proc ()
		    (comm-format (u) (wnn-const WNN_ACK))
		    (comm-unpack (B) contents))
		  (insert contents)
		  (if (= result 2)
		      (insert-file-contents local-filename nil (1- (point))))
		  (save-excursion
		    (set-buffer (process-buffer proc))
		    (wnn7rpc-get-result)))))))))
    ((quit error)
     (wnn7rpc-call-with-environment env ()
       (comm-format (i) (wnn-const WNN_NAK)))
     (signal (car err) (cdr err)))))

(defun wnn7rpc-file-send (env filename)
  ""
  (let ((header (wnn7rpc-check-local-file filename)))
    (if (numberp header)
	header
      (condition-case err
	  (wnn7rpc-call-with-environment env (file-id)
	    (comm-format (u u v) (wnn-const JS_FILE_SEND)
			 env-id
			 (nth 1 header) (wnn-const WNN_UNIQ_LEN))
	    (comm-unpack (u) file-id)
	    (if (>= file-id 0)
		(wnn7rpc-get-result
		  (wnn7env-set-client-file env filename)
		  file-id)
	      (wnn7rpc-get-result
		(comm-call-with-proc-1 proc ()
		  (comm-format (s B)
			       (concat wnn-system-name "!" filename)
			       (wnn7rpc-with-temp-buffer
				 (insert-file-contents filename)
				 (buffer-string)))
		  (wnn7rpc-get-result
		    (wnn7env-set-client-file env filename)
		    result)))))
	((quit error)
	 (wnn7rpc-call-with-environment env ()
	   (comm-format (s B B B B B B) "" "" "" "" "" "" ""))
	 (signal (car err) (cdr err)))))))

(defun wnn7rpc-file-remove-client (proc name passwd)
  (let (header)
    (cond
     ((/= (wnn7rpc-file-loaded-local proc name) -1)
      (- (wnn-const WNN_FILE_IN_USE)))
     ((null (file-readable-p name))
      (- (wnn-const WNN_FILE_READ_ERROR)))
     ((null (numberp (car (setq header (wnn7rpc-get-file-header name)))))
      (- (wnn-const WNN_NOT_A_FILE)))
     ((< (wnn7rpc-check-passwd proc passwd header) 0)
      (- (wnn-const WNN_INCORRECT_PASSWD)))
     (t
      (condition-case nil
	  (progn
	    (delete-file name)
	    0)
	(error (- (wnn-const WNN_UNLINK))))))))

(defun wnn7rpc-dic-file-create-client (env dicname type comment passwd hpasswd)
  (if (and (null (file-exists-p dicname))
	   (file-writable-p dicname)
	   (or (eq type (wnn-const WNN_REV_DICT))
	       (eq type (wnn-const CWNN_REV_DICT))
	       (eq type (wnn-const BWNN_REV_DICT))
	       (eq type (wnn-const WNN_UD_DICT))
	       (eq type (wnn-const WNN_FI_USER_DICT)))
	   (wnn7rpc-create-and-move-to-client env nil dicname type
					     comment passwd hpasswd))
      0
    (- (wnn-const WNN_FILE_CREATE_ERROR))))

(defun wnn7rpc-hindo-file-create-client (env fi dic-id freqname comment passwd)
  (if (and (null (file-exists-p freqname))
	   (file-writable-p freqname)
	   (wnn7rpc-create-and-move-to-client env dic-id freqname fi
					     comment passwd nil))
      0
    (- (wnn-const WNN_FILE_CREATE_ERROR))))

(defun wnn7rpc-make-temp-name (env)
  (let ((n 0)
	(temp-form "usr/temp"))
    (while (= (wnn7rpc-access env (concat temp-form (number-to-string n)) 0) 0)
      (setq n (1+ n)))
    (concat temp-form (number-to-string n))))

(defun wnn7rpc-create-and-move-to-client (env dic-id filename type
					     comment passwd hpasswd)
  (let ((tempfile (wnn7rpc-make-temp-name env))
	(created -1)
	(fid -1))
    (unwind-protect
	(progn
	  (if (numberp type)
	      (setq created (wnn7rpc-dic-file-create env tempfile type
						    comment passwd hpasswd))
	    (setq created (wnn7rpc-hindo-file-create env type dic-id tempfile
						    comment passwd)))
	  (if (and (>= created 0)
		   (>= (setq fid (wnn7rpc-file-read env tempfile)) 0)
		   (>= (wnn7rpc-file-receive env fid filename) 0))
	      (wnn7rpc-change-file-uniq (wnn7rpc-get-file-header filename)
				       filename t)
	    (condition-case nil (delete-file filename) (error))
	    nil))
      (if (>= fid 0)
	  (wnn7rpc-file-discard env fid))
      (if (>= created 0)
	  (wnn7rpc-file-remove (wnn7env-get-proc env) tempfile passwd)))))

(defun wnn7rpc-read-passwd-file (filename)
  (cond
   ((null filename) "")
   ((null (file-readable-p filename)) (- (wnn-const WNN_FILE_READ_ERROR)))
   (t 
    (wnn7rpc-with-temp-buffer
      (insert-file-contents filename nil 0 (1- (wnn-const WNN_PASSWD_LEN)))
      (goto-char 1)
      (if (and (search-forward-regexp "[\0\n]" nil 0)
	       (= (preceding-char) 0))
	  (backward-char))
      (buffer-substring 1 (point))))))

;;;
;;; Wnn7 new function:
;;;   Input Prediction
;;;
;;;
(defun wnn7rpc-yosoku-init (env)
  "Initialize input prediction function"
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_YOSOKU_INIT) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-free (env)
  "Free input prediction function area from server."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_YOSOKU_FREE) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-yosoku (env moji)
  "Execute input prediction."
  (wnn7rpc-call-with-environment env (candnum len kouho kouho-list)
    (comm-format (u u E) (wnn-const JS_YOSOKU_YOSOKU) env-id moji)
    (wnn7rpc-get-result
      (comm-unpack (u) candnum)
      (while (> candnum 0)
	(comm-unpack (u s) len kouho)
	(setq kouho (decode-coding-string kouho 'euc-jp))
	(setq kouho-list (nconc kouho-list (list kouho))
	      candnum (1- candnum)))
      kouho-list)))

(defun wnn7rpc-yosoku-toroku (env bun-suu yosoku-bunsetsu)
  "Register the input prediction candidate."
  (wnn7rpc-call-with-environment env ()
    (progn
      (comm-format (u u u) (wnn-const JS_YOSOKU_TOROKU) env-id bun-suu)
      (while yosoku-bunsetsu
	(comm-format (E u E u u) 
		     (aref (car yosoku-bunsetsu) 0)
		     (aref (car yosoku-bunsetsu) 1)
		     (aref (car yosoku-bunsetsu) 2)
		     (aref (car yosoku-bunsetsu) 3)
		     (aref (car yosoku-bunsetsu) 4))
	(setq yosoku-bunsetsu (cdr yosoku-bunsetsu))))
    (wnn7rpc-get-result)))
				
(defun wnn7rpc-yosoku-selected-cand (env selectpos)
  "Select the input prediction candidate."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u) (wnn-const JS_YOSOKU_SELECTED_CAND) 
		 env-id selectpos)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-delete-cand (env selectpos)
  "Delete the input prediction candidate."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u) (wnn-const JS_YOSOKU_DELETE_CAND) 
		 env-id selectpos)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-cancel-latest-toroku (env)
  "Cancel the latest registered word."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_YOSOKU_CANCEL_LATEST_TOROKU) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-reset-pre-yosoku (env)
  "Clear the connection information for the latest registered word."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_YOSOKU_RESET_PRE_YOSOKU) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-ikkatsu-toroku (env torokustr)
  "Register the input prediction candidate with phrase analysis."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u S) (wnn-const JS_YOSOKU_IKKATSU_TOROKU) 
		 env-id torokustr)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-save-datalist (env)
  "Save the input prediction data in data file."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_YOSOKU_SAVE_DATALIST) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-init-time-keydata (env)
  "Initialize input efficiency data about inputed key."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_YOSOKU_INIT_TIME_KEYDATA) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-init-inputinfo (env)
  "Initialize input efficiency data about input time."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u) (wnn-const JS_YOSOKU_INIT_INPUTINFO) env-id)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-set-user-inputinfo (env allkey userkey yosokuselect)
  "Set user input information to the input efficiency data."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u u) (wnn-const JS_YOSOKU_SET_USER_INPUTINFO) 
		 env-id allkey 
		 (if yosokuselect
		     (logior userkey ?\x8000)
		   userkey))
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-set-timeinfo (env yosokuselect throughyosoku inputtime
				       keylen)
  "Set input-time information to the input efficiency data."
  (wnn7rpc-call-with-environment env ()
    (comm-format (u u u u u u) (wnn-const JS_YOSOKU_SET_TIMEINFO) 
		 env-id yosokuselect throughyosoku inputtime keylen)
    (wnn7rpc-get-result)))

(defun wnn7rpc-yosoku-status (env)
  "Get input efficiency information."
  (wnn7rpc-call-with-environment env (totalrod totalallkey totaluserkey 
				     totalrot totalalltime totalusertime 
				     stmday sthour stmin ltmday lthour ltmin
				     totalroykinput totalallykkey nowrod 
				     nowallkey nowuserkey nowrot nowalltime 
				     nowusertime timeperonekey)
    (comm-format (u u) (wnn-const JS_YOSOKU_STATUS) env-id)
    (comm-unpack (u) totalrod)
    (if (< totalrod 0)
	totalrod
      (comm-unpack (u u u u u u u u u u u u u u u u u u u u)
		   totalallkey totaluserkey 
		   totalrot totalalltime totalusertime
		   stmday sthour stmin ltmday lthour ltmin
		   totalroykinput totalallykkey 
		   nowrod nowallkey nowuserkey nowrot nowalltime nowusertime
		   timeperonekey)
      (vector totalrod totalallkey totaluserkey totalrot totalalltime 
	      totalusertime stmday sthour stmin ltmday lthour ltmin
	      totalroykinput totalallykkey nowrod nowallkey nowuserkey 
	      nowrot nowalltime nowusertime timeperonekey))))

;;;
;;; Wnn7 new function:
;;;   association translation 
;;;
(defun wnn7rpc-assoc-with-data (env yomi hinsi fuzokugo v 
				   jilihin yomi_org jililen yomilen kanjilen
				   real_kanjilen)
  "Convert YOMI string into Kanji with association."
  (wnn7rpc-call-with-environment env (kanji-length)
	(comm-format (u u S i S i i u S i i i i) (wnn-const JS_HENKAN_ASSOC)
		     env-id yomi hinsi fuzokugo
		     (or v (wnn-const WNN_VECT_KANZEN))
		     (if v (wnn-const WNN_VECT_KANZEN) (wnn-const WNN_VECT_NO))
		     jilihin yomi_org jililen yomilen kanjilen real_kanjilen)
	(wnn7rpc-get-result
	 (comm-unpack (u) kanji-length)	; ignore kanji-length
	 (mapcar (lambda (b)
		   (wnn7-bunsetsu-set-dai-continue b 
						   (wnn7-bunsetsu-connect-next b))
		   (list b))
		 (wnn7rpc-receive-sho-bunsetsu-list env result)))))


(defun wnn7rpc-set-henkan-hinshi (env mode nhinshi hlist)
  ""
  (wnn7rpc-call-with-environment env ()
     (progn
       (comm-format (u u i i) (wnn-const JS_SET_HENKAN_HINSI) 
		    env-id mode nhinshi)
       (while hlist
	 (comm-format (u) (car hlist))
	 (setq hlist (cdr hlist))))
     (wnn7rpc-get-result)))

(provide 'wnn7egg-rpc)
;;; wnn7egg-rpc.el ends here.
