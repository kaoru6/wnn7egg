;; Basic Roma-to-Kana Translation Table for Egg
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

;; This file is part of Egg on Nemacs (Japanese Environment)

;; Egg is distributed in the forms of patches to GNU
;; Emacs under the terms of the GNU EMACS GENERAL PUBLIC
;; LICENSE which is distributed along with GNU Emacs by the
;; Free Software Foundation.

;; Egg is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU EMACS GENERAL PUBLIC LICENSE for
;; more details.

;; You should have received a copy of the GNU EMACS GENERAL
;; PUBLIC LICENSE along with Nemacs; see the file COPYING.
;; If not, write to the Free Software Foundation, 675 Mass
;; Ave, Cambridge, MA 02139, USA.

;; 90.3.2   modified for Nemacs Ver.3.3.1
;;	by jiro@math.keio.ac.jp (TANAKA Jiro)
;;     proposal of keybinding for JIS symbols
;; 92.3.23  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;;	defrule -> its-defrule, define-its-mode -> its-define-mode
;; 92.7.6   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	New rules added.

(its-define-mode "roma-kana" "$B$"(B" t)

(its-defrule-select-mode-temporally "q" "downcase")
(its-defrule-select-mode-temporally "Q" "zenkaku-downcase")

;;; $B!V$C!W$NF~NO(B

(dolist (aa '("k" "s" "t" "h" "y" "r" "w" "g" "z" "d" "b"
		 "p" "c" "f" "j" "v"))
  (its-defrule (concat aa aa) "$B$C(B" aa))

(its-defrule "tch"  "$B$C(B" "ch")

;;; $B!V$s!W$NF~NO(B

(dolist (q1 '("b" "m" "p"))
  (its-defrule (concat "m" q1) "$B$s(B" q1))

(its-defrule "N" "$B$s(B")

(its-defrule "n'" "$B$s(B")

(defvar enable-double-n-syntax nil "*\"nn\"$B$r(B\"$B$s(B\"$B$KJQ49$9$k(B")

(its-defrule "n" "$B$s(B")
(its-defrule-conditional* "nn" "$B$s(B" nil
			  (enable-double-n-syntax "$B$s(B")
			  (t nil))

;; 92.7.6 by Y.Kawabe
;;(dolist (aa '("k" "s" "t" "c" "h" "f" "m" "y" "r" "l"
;;	      "w" "g" "z" "j" "d" "b" "v" "p" "x"))
;;  (its-defrule (concat "n" aa) "$B$s(B" aa))
;; end of patch

(let ((small '"x" ))
  (its-defrule (concat small "a") "$B$!(B")
  (its-defrule (concat small "i") "$B$#(B")
  (its-defrule (concat small "u") "$B$%(B")
  (its-defrule (concat small "e") "$B$'(B")
  (its-defrule (concat small "o") "$B$)(B")
  (its-defrule (concat small "ya") "$B$c(B")
  (its-defrule (concat small "yu") "$B$e(B")
  (its-defrule (concat small "yo") "$B$g(B")
  (its-defrule (concat small "tu") "$B$C(B")
  (its-defrule (concat small "tsu") "$B$C(B")
  (its-defrule (concat small "wa") "$B$n(B")
  )

(its-defrule   "a"    "$B$"(B")
(its-defrule   "i"    "$B$$(B")
(its-defrule   "u"    "$B$&(B")
(its-defrule   "e"    "$B$((B")
(its-defrule   "o"    "$B$*(B")
(its-defrule   "ka"   "$B$+(B")
(its-defrule   "ki"   "$B$-(B")
(its-defrule   "ku"   "$B$/(B")
(its-defrule   "ke"   "$B$1(B")
(its-defrule   "ko"   "$B$3(B")
(its-defrule   "kya"  "$B$-$c(B")
(its-defrule   "kyu"  "$B$-$e(B")
(its-defrule   "kye"  "$B$-$'(B")
(its-defrule   "kyo"  "$B$-$g(B")
(its-defrule   "sa"   "$B$5(B")
(its-defrule   "si"   "$B$7(B")
(its-defrule   "su"   "$B$9(B")
(its-defrule   "se"   "$B$;(B")
(its-defrule   "so"   "$B$=(B")
(its-defrule   "sya"  "$B$7$c(B")
(its-defrule   "syu"  "$B$7$e(B")
(its-defrule   "sye"  "$B$7$'(B")
(its-defrule   "syo"  "$B$7$g(B")
(its-defrule   "sha"  "$B$7$c(B")
(its-defrule   "shi"  "$B$7(B")
(its-defrule   "shu"  "$B$7$e(B")
(its-defrule   "she"  "$B$7$'(B")
(its-defrule   "sho"  "$B$7$g(B")
(its-defrule   "ta"   "$B$?(B")
(its-defrule   "ti"   "$B$A(B")
(its-defrule   "tu"   "$B$D(B")
(its-defrule   "te"   "$B$F(B")
(its-defrule   "to"   "$B$H(B")
(its-defrule   "tya"  "$B$A$c(B")
(its-defrule   "tyi"  "$B$F$#(B")
(its-defrule   "tyu"  "$B$A$e(B")
(its-defrule   "tye"  "$B$A$'(B")
(its-defrule   "tyo"  "$B$A$g(B")
(its-defrule   "tsu"  "$B$D(B")
(its-defrule   "cha"  "$B$A$c(B")
(its-defrule   "chi"  "$B$A(B")
(its-defrule   "chu"  "$B$A$e(B")
(its-defrule   "che"  "$B$A$'(B")
(its-defrule   "cho"  "$B$A$g(B")
(its-defrule   "na"   "$B$J(B")
(its-defrule   "ni"   "$B$K(B")
(its-defrule   "nu"   "$B$L(B")
(its-defrule   "ne"   "$B$M(B")
(its-defrule   "no"   "$B$N(B")
(its-defrule   "nya"  "$B$K$c(B")
(its-defrule   "nyu"  "$B$K$e(B")
(its-defrule   "nye"  "$B$K$'(B")
(its-defrule   "nyo"  "$B$K$g(B")
(its-defrule   "ha"   "$B$O(B")
(its-defrule   "hi"   "$B$R(B")
(its-defrule   "hu"   "$B$U(B")
(its-defrule   "he"   "$B$X(B")
(its-defrule   "ho"   "$B$[(B")
(its-defrule   "hya"  "$B$R$c(B")
(its-defrule   "hyu"  "$B$R$e(B")
(its-defrule   "hye"  "$B$R$'(B")
(its-defrule   "hyo"  "$B$R$g(B")
(its-defrule   "fa"   "$B$U$!(B")
(its-defrule   "fi"   "$B$U$#(B")
(its-defrule   "fu"   "$B$U(B")
(its-defrule   "fe"   "$B$U$'(B")
(its-defrule   "fo"   "$B$U$)(B")
(its-defrule   "ma"   "$B$^(B")
(its-defrule   "mi"   "$B$_(B")
(its-defrule   "mu"   "$B$`(B")
(its-defrule   "me"   "$B$a(B")
(its-defrule   "mo"   "$B$b(B")
(its-defrule   "mya"  "$B$_$c(B")
(its-defrule   "myu"  "$B$_$e(B")
(its-defrule   "mye"  "$B$_$'(B")
(its-defrule   "myo"  "$B$_$g(B")
(its-defrule   "ya"   "$B$d(B")
(its-defrule   "yi"   "$B$$(B")
(its-defrule   "yu"   "$B$f(B")
(its-defrule   "ye"   "$B$$$'(B")
(its-defrule   "yo"   "$B$h(B")
(its-defrule   "ra"   "$B$i(B")
(its-defrule   "ri"   "$B$j(B")
(its-defrule   "ru"   "$B$k(B")
(its-defrule   "re"   "$B$l(B")
(its-defrule   "ro"   "$B$m(B")
(its-defrule   "la"   "$B$i(B")
(its-defrule   "li"   "$B$j(B")
(its-defrule   "lu"   "$B$k(B")
(its-defrule   "le"   "$B$l(B")
(its-defrule   "lo"   "$B$m(B")
(its-defrule   "rya"  "$B$j$c(B")
(its-defrule   "ryu"  "$B$j$e(B")
(its-defrule   "rye"  "$B$j$'(B")
(its-defrule   "ryo"  "$B$j$g(B")
(its-defrule   "lya"  "$B$j$c(B")
(its-defrule   "lyu"  "$B$j$e(B")
(its-defrule   "lye"  "$B$j$'(B")
(its-defrule   "lyo"  "$B$j$g(B")
(its-defrule   "wa"   "$B$o(B")
(its-defrule   "wi"   "$B$p(B")
(its-defrule   "wu"   "$B$&(B")
(its-defrule   "we"   "$B$q(B")
(its-defrule   "wo"   "$B$r(B")
(its-defrule   "ga"   "$B$,(B")
(its-defrule   "gi"   "$B$.(B")
(its-defrule   "gu"   "$B$0(B")
(its-defrule   "ge"   "$B$2(B")
(its-defrule   "go"   "$B$4(B")
(its-defrule   "gya"  "$B$.$c(B")
(its-defrule   "gyu"  "$B$.$e(B")
(its-defrule   "gye"  "$B$.$'(B")
(its-defrule   "gyo"  "$B$.$g(B")
(its-defrule   "za"   "$B$6(B")
(its-defrule   "zi"   "$B$8(B")
(its-defrule   "zu"   "$B$:(B")
(its-defrule   "ze"   "$B$<(B")
(its-defrule   "zo"   "$B$>(B")
(its-defrule   "zya"  "$B$8$c(B")
(its-defrule   "zyu"  "$B$8$e(B")
(its-defrule   "zye"  "$B$8$'(B")
(its-defrule   "zyo"  "$B$8$g(B")
(its-defrule   "ja"   "$B$8$c(B")
(its-defrule   "ji"   "$B$8(B")
(its-defrule   "ju"   "$B$8$e(B")
(its-defrule   "je"   "$B$8$'(B")
(its-defrule   "jo"   "$B$8$g(B")
;; 92.7.6 by Y.Kawabe
(its-defrule   "jya"   "$B$8$c(B")
(its-defrule   "jyu"   "$B$8$e(B")
(its-defrule   "jye"   "$B$8$'(B")
(its-defrule   "jyo"   "$B$8$g(B")
;; end of patch
(its-defrule   "da"   "$B$@(B")
(its-defrule   "di"   "$B$B(B")
(its-defrule   "du"   "$B$E(B")
(its-defrule   "de"   "$B$G(B")
(its-defrule   "do"   "$B$I(B")
(its-defrule   "dya"  "$B$B$c(B")
(its-defrule   "dyi"  "$B$G$#(B")
(its-defrule   "dyu"  "$B$B$e(B")
(its-defrule   "dye"  "$B$B$'(B")
(its-defrule   "dyo"  "$B$B$g(B")
(its-defrule   "ba"   "$B$P(B")
(its-defrule   "bi"   "$B$S(B")
(its-defrule   "bu"   "$B$V(B")
(its-defrule   "be"   "$B$Y(B")
(its-defrule   "bo"   "$B$\(B")
(its-defrule   "va"   "$B%t$!(B")
(its-defrule   "vi"   "$B%t$#(B")
(its-defrule   "vu"   "$B%t(B")
(its-defrule   "ve"   "$B%t$'(B")
(its-defrule   "vo"   "$B%t$)(B")
(its-defrule   "bya"  "$B$S$c(B")
(its-defrule   "byu"  "$B$S$e(B")
(its-defrule   "bye"  "$B$S$'(B")
(its-defrule   "byo"  "$B$S$g(B")
(its-defrule   "pa"   "$B$Q(B")
(its-defrule   "pi"   "$B$T(B")
(its-defrule   "pu"   "$B$W(B")
(its-defrule   "pe"   "$B$Z(B")
(its-defrule   "po"   "$B$](B")
(its-defrule   "pya"  "$B$T$c(B")
(its-defrule   "pyu"  "$B$T$e(B")
(its-defrule   "pye"  "$B$T$'(B")
(its-defrule   "pyo"  "$B$T$g(B")
(its-defrule   "kwa"  "$B$/$n(B")
(its-defrule   "kwi"  "$B$/$#(B")
(its-defrule   "kwu"  "$B$/(B")
(its-defrule   "kwe"  "$B$/$'(B")
(its-defrule   "kwo"  "$B$/$)(B")
(its-defrule   "gwa"  "$B$0$n(B")
(its-defrule   "gwi"  "$B$0$#(B")
(its-defrule   "gwu"  "$B$0(B")
(its-defrule   "gwe"  "$B$0$'(B")
(its-defrule   "gwo"  "$B$0$)(B")
(its-defrule   "tsa"  "$B$D$!(B")
(its-defrule   "tsi"  "$B$D$#(B")
(its-defrule   "tse"  "$B$D$'(B")
(its-defrule   "tso"  "$B$D$)(B")
(its-defrule   "xka"  "$B%u(B")
(its-defrule   "xke"  "$B%v(B")
(its-defrule   "xti"  "$B$F$#(B")
(its-defrule   "xdi"  "$B$G$#(B")
(its-defrule   "xdu"  "$B$I$%(B")
(its-defrule   "xde"  "$B$G$'(B")
(its-defrule   "xdo"  "$B$I$)(B")
(its-defrule   "xwi"  "$B$&$#(B")
(its-defrule   "xwe"  "$B$&$'(B")
(its-defrule   "xwo"  "$B$&$)(B")

;;; Zenkaku Symbols

(its-defrule   "1"   "$B#1(B")
(its-defrule   "2"   "$B#2(B")
(its-defrule   "3"   "$B#3(B")
(its-defrule   "4"   "$B#4(B")
(its-defrule   "5"   "$B#5(B")
(its-defrule   "6"   "$B#6(B")
(its-defrule   "7"   "$B#7(B")
(its-defrule   "8"   "$B#8(B")
(its-defrule   "9"   "$B#9(B")
(its-defrule   "0"   "$B#0(B")

;;(its-defrule   " "   "$B!!(B")
(its-defrule   "!"   "$B!*(B")
(its-defrule   "@"   "$B!w(B")
(its-defrule   "#"   "$B!t(B")
(its-defrule   "$"   "$B!p(B")
(its-defrule   "%"   "$B!s(B")
(its-defrule   "^"   "$B!0(B")
(its-defrule   "&"   "$B!u(B")
(its-defrule   "*"   "$B!v(B")
(its-defrule   "("   "$B!J(B")
(its-defrule   ")"   "$B!K(B")
(its-defrule   "-"   "$B!<(B") ;;; JIS 213c  ;;;(its-defrule   "-"   "$B!](B")
(its-defrule   "="   "$B!a(B")
(its-defrule   "`"   "$B!.(B")
(its-defrule   "\\"  "$B!o(B")
(its-defrule   "|"   "$B!C(B")
(its-defrule   "_"   "$B!2(B")
(its-defrule   "+"   "$B!\(B")
(its-defrule   "~"   "$B!1(B")
(its-defrule   "["    "$B!V(B")  ;;(its-defrule   "["   "$B!N(B")
(its-defrule   "]"    "$B!W(B")  ;;(its-defrule   "]"   "$B!O(B")
(its-defrule   "{"   "$B!P(B")
(its-defrule   "}"   "$B!Q(B")
(its-defrule   ":"   "$B!'(B")
(its-defrule   ";"   "$B!((B")
(its-defrule   "\""  "$B!I(B")
(its-defrule   "'"   "$B!G(B")
(its-defrule   "<"   "$B!c(B")
(its-defrule   ">"   "$B!d(B")
(its-defrule   "?"   "$B!)(B")
(its-defrule   "/"   "$B!?(B")

(defvar use-kuten-for-period t "*$B%T%j%*%I$r6gE@$KJQ49$9$k(B")
(defvar use-touten-for-comma t "*$B%3%s%^$rFIE@$KJQ49$9$k(B")

(its-defrule-conditional "."
  (use-kuten-for-period "$B!#(B")
  (t "$B!%(B"))

(its-defrule-conditional ","
  (use-touten-for-comma "$B!"(B")
  (t "$B!$(B"))

;;; Escape character to Zenkaku inputs

(defvar zenkaku-escape "Z")

;;; Escape character to Hankaku inputs

(defvar hankaku-escape "~")
;;;
;;; Zenkaku inputs
;;;

(its-defrule (concat zenkaku-escape "0") "$B#0(B")
(its-defrule (concat zenkaku-escape "1") "$B#1(B")
(its-defrule (concat zenkaku-escape "2") "$B#2(B")
(its-defrule (concat zenkaku-escape "3") "$B#3(B")
(its-defrule (concat zenkaku-escape "4") "$B#4(B")
(its-defrule (concat zenkaku-escape "5") "$B#5(B")
(its-defrule (concat zenkaku-escape "6") "$B#6(B")
(its-defrule (concat zenkaku-escape "7") "$B#7(B")
(its-defrule (concat zenkaku-escape "8") "$B#8(B")
(its-defrule (concat zenkaku-escape "9") "$B#9(B")

(its-defrule (concat zenkaku-escape "A") "$B#A(B")
(its-defrule (concat zenkaku-escape "B") "$B#B(B")
(its-defrule (concat zenkaku-escape "C") "$B#C(B")
(its-defrule (concat zenkaku-escape "D") "$B#D(B")
(its-defrule (concat zenkaku-escape "E") "$B#E(B")
(its-defrule (concat zenkaku-escape "F") "$B#F(B")
(its-defrule (concat zenkaku-escape "G") "$B#G(B")
(its-defrule (concat zenkaku-escape "H") "$B#H(B")
(its-defrule (concat zenkaku-escape "I") "$B#I(B")
(its-defrule (concat zenkaku-escape "J") "$B#J(B")
(its-defrule (concat zenkaku-escape "K") "$B#K(B")
(its-defrule (concat zenkaku-escape "L") "$B#L(B")
(its-defrule (concat zenkaku-escape "M") "$B#M(B")
(its-defrule (concat zenkaku-escape "N") "$B#N(B")
(its-defrule (concat zenkaku-escape "O") "$B#O(B")
(its-defrule (concat zenkaku-escape "P") "$B#P(B")
(its-defrule (concat zenkaku-escape "Q") "$B#Q(B")
(its-defrule (concat zenkaku-escape "R") "$B#R(B")
(its-defrule (concat zenkaku-escape "S") "$B#S(B")
(its-defrule (concat zenkaku-escape "T") "$B#T(B")
(its-defrule (concat zenkaku-escape "U") "$B#U(B")
(its-defrule (concat zenkaku-escape "V") "$B#V(B")
(its-defrule (concat zenkaku-escape "W") "$B#W(B")
(its-defrule (concat zenkaku-escape "X") "$B#X(B")
(its-defrule (concat zenkaku-escape "Y") "$B#Y(B")
(its-defrule (concat zenkaku-escape "Z") "$B#Z(B")

(its-defrule (concat zenkaku-escape "a") "$B#a(B")
(its-defrule (concat zenkaku-escape "b") "$B#b(B")
(its-defrule (concat zenkaku-escape "c") "$B#c(B")
(its-defrule (concat zenkaku-escape "d") "$B#d(B")
(its-defrule (concat zenkaku-escape "e") "$B#e(B")
(its-defrule (concat zenkaku-escape "f") "$B#f(B")
(its-defrule (concat zenkaku-escape "g") "$B#g(B")
(its-defrule (concat zenkaku-escape "h") "$B#h(B")
(its-defrule (concat zenkaku-escape "i") "$B#i(B")
(its-defrule (concat zenkaku-escape "j") "$B#j(B")
(its-defrule (concat zenkaku-escape "k") "$B#k(B")
(its-defrule (concat zenkaku-escape "l") "$B#l(B")
(its-defrule (concat zenkaku-escape "m") "$B#m(B")
(its-defrule (concat zenkaku-escape "n") "$B#n(B")
(its-defrule (concat zenkaku-escape "o") "$B#o(B")
(its-defrule (concat zenkaku-escape "p") "$B#p(B")
(its-defrule (concat zenkaku-escape "q") "$B#q(B")
(its-defrule (concat zenkaku-escape "r") "$B#r(B")
(its-defrule (concat zenkaku-escape "s") "$B#s(B")
(its-defrule (concat zenkaku-escape "t") "$B#t(B")
(its-defrule (concat zenkaku-escape "u") "$B#u(B")
(its-defrule (concat zenkaku-escape "v") "$B#v(B")
(its-defrule (concat zenkaku-escape "w") "$B#w(B")
(its-defrule (concat zenkaku-escape "x") "$B#x(B")
(its-defrule (concat zenkaku-escape "y") "$B#y(B")
(its-defrule (concat zenkaku-escape "z") "$B#z(B")

(its-defrule (concat zenkaku-escape " ")  "$B!!(B")
(its-defrule (concat zenkaku-escape "!")  "$B!*(B")
(its-defrule (concat zenkaku-escape "@")  "$B!w(B")
(its-defrule (concat zenkaku-escape "#")  "$B!t(B")
(its-defrule (concat zenkaku-escape "$")  "$B!p(B")
(its-defrule (concat zenkaku-escape "%")  "$B!s(B")
(its-defrule (concat zenkaku-escape "^")  "$B!0(B")
(its-defrule (concat zenkaku-escape "&")  "$B!u(B")
(its-defrule (concat zenkaku-escape "*")  "$B!v(B")
(its-defrule (concat zenkaku-escape "(")  "$B!J(B")
(its-defrule (concat zenkaku-escape ")")  "$B!K(B")
(its-defrule (concat zenkaku-escape "-")  "$B!](B")
(its-defrule (concat zenkaku-escape "=")  "$B!a(B")
(its-defrule (concat zenkaku-escape "`")  "$B!.(B")
(its-defrule (concat zenkaku-escape "\\") "$B!o(B")
(its-defrule (concat zenkaku-escape "|")  "$B!C(B")
(its-defrule (concat zenkaku-escape "_")  "$B!2(B")
(its-defrule (concat zenkaku-escape "+")  "$B!\(B")
(its-defrule (concat zenkaku-escape "~")  "$B!1(B")
(its-defrule (concat zenkaku-escape "[")  "$B!N(B")
(its-defrule (concat zenkaku-escape "]")  "$B!O(B")
(its-defrule (concat zenkaku-escape "{")  "$B!P(B")
(its-defrule (concat zenkaku-escape "}")  "$B!Q(B")
(its-defrule (concat zenkaku-escape ":")  "$B!'(B")
(its-defrule (concat zenkaku-escape ";")  "$B!((B")
(its-defrule (concat zenkaku-escape "\"") "$B!I(B")
(its-defrule (concat zenkaku-escape "'")  "$B!G(B")
(its-defrule (concat zenkaku-escape "<")  "$B!c(B")
(its-defrule (concat zenkaku-escape ">")  "$B!d(B")
(its-defrule (concat zenkaku-escape "?")  "$B!)(B")
(its-defrule (concat zenkaku-escape "/")  "$B!?(B")
(its-defrule (concat zenkaku-escape ",")  "$B!$(B")
(its-defrule (concat zenkaku-escape ".")  "$B!%(B")

;;;
;;; Hankaku inputs
;;;

;;(defvar escd '("-" "," "." "/" ";" ":" "[" "\\" "]" "^" "~"))
;;(its-defrule '("x" escd)  '(escd))


(defvar digit-characters 
   '( "1"  "2"  "3"  "4" "5"  "6"  "7"  "8"  "9"  "0" ))

(defvar symbol-characters 
   '( " "  "!"  "@"  "#"  "$"  "%"  "^"  "&"  "*"  "("  ")"
      "-"  "="  "`"  "\\" "|"  "_"  "+"  "~" "["  "]"  "{"  "}"
      ":"  ";"  "\"" "'"  "<"  ">"  "?"  "/"  ","  "." ))

(defvar downcase-alphabets 
   '("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
     "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))

(defvar upcase-alphabets
   '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N"
     "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))

(dolist (digit digit-characters)
  (its-defrule (concat hankaku-escape digit)  digit))

(dolist (symbol symbol-characters)
  (its-defrule (concat hankaku-escape symbol) symbol))

(dolist (downcase downcase-alphabets)
  (its-defrule (concat hankaku-escape downcase) downcase))

(dolist (upcase upcase-alphabets)
  (its-defrule (concat hankaku-escape upcase) upcase))

;;; proposal key bindings for JIS symbols
;;; 90.3.2  by jiro@math.keio.ac.jp (TANAKA Jiro)

(its-defrule   "z1"   "$B!{(B")	(its-defrule   "z!"   "$B!|(B")
(its-defrule   "z2"   "$B"&(B")	(its-defrule   "z@"   "$B"'(B")
(its-defrule   "z3"   "$B"$(B")	(its-defrule   "z#"   "$B"%(B")
(its-defrule   "z4"   "$B""(B")	(its-defrule   "z$"   "$B"#(B")
(its-defrule   "z5"   "$B!~(B")	(its-defrule   "z%"   "$B"!(B")
(its-defrule   "z6"   "$B!y(B")	(its-defrule   "z^"   "$B!z(B")
(its-defrule   "z7"   "$B!}(B")	(its-defrule   "z&"   "$B!r(B")
(its-defrule   "z8"   "$B!q(B")	(its-defrule   "z*"   "$B!_(B")
(its-defrule   "z9"   "$B!i(B")	(its-defrule   "z("   "$B!Z(B")
(its-defrule   "z0"   "$B!j(B")	(its-defrule   "z)"   "$B![(B")
(its-defrule   "z-"   "$B!A(B")	(its-defrule   "z_"   "$B!h(B")	; z-
(its-defrule   "z="   "$B!b(B")	(its-defrule   "z+"   "$B!^(B")
(its-defrule   "z\\"  "$B!@(B")	(its-defrule   "z|"   "$B!B(B")
(its-defrule   "z`"   "$B!-(B")	(its-defrule   "z~"   "$B!/(B")

(its-defrule   "zq"   "$B!T(B")	(its-defrule   "zQ"   "$B!R(B")
(its-defrule   "zw"   "$B!U(B")	(its-defrule   "zW"   "$B!S(B")
; e
(its-defrule   "zr"   "$B!9(B")	(its-defrule   "zR"   "$B!8(B")	; zr
(its-defrule   "zt"   "$B!:(B")	(its-defrule   "zT"   "$B!x(B")
; y u i o
(its-defrule   "zp"   "$B")(B")	(its-defrule   "zP"   "$B",(B")	; zp
(its-defrule   "z["   "$B!X(B")	(its-defrule   "z{"   "$B!L(B")	; z[
(its-defrule   "z]"   "$B!Y(B")	(its-defrule   "z}"   "$B!M(B")	; z]

; a
(its-defrule   "zs"   "$B!3(B")	(its-defrule   "zS"   "$B!4(B")
(its-defrule   "zd"   "$B!5(B")	(its-defrule   "zD"   "$B!6(B")
(its-defrule   "zf"   "$B!7(B")	(its-defrule   "zF"   "$B"*(B")
(its-defrule   "zg"   "$B!>(B")	(its-defrule   "zG"   "$B!=(B")
(its-defrule   "zh"   "$B"+(B")
(its-defrule   "zj"   "$B"-(B")
(its-defrule   "zk"   "$B",(B")
(its-defrule   "zl"   "$B"*(B")
(its-defrule   "z;"   "$B!+(B")	(its-defrule   "z:"   "$B!,(B")
(its-defrule   "z\'"  "$B!F(B")	(its-defrule   "z\""  "$B!H(B")

; z
(its-defrule   "zx"   ":-")	(its-defrule   "zX"   ":-)")
(its-defrule   "zc"   "$B!;(B")	(its-defrule   "zC"   "$B!n(B")	; zc
(its-defrule   "zv"   "$B"((B")	(its-defrule   "zV"   "$B!`(B")
(its-defrule   "zb"   "$B!k(B")	(its-defrule   "zB"   "$B"+(B")
(its-defrule   "zn"   "$B!l(B")	(its-defrule   "zN"   "$B"-(B")
(its-defrule   "zm"   "$B!m(B")	(its-defrule   "zM"   "$B".(B")
(its-defrule   "z,"   "$B!E(B")	(its-defrule   "z<"   "$B!e(B")
(its-defrule   "z."   "$B!D(B")	(its-defrule   "z>"   "$B!f(B")	; z.
(its-defrule   "z/"   "$B!&(B")	(its-defrule   "z?"   "$B!g(B")	; z/

;;; Commented out by K.Handa.  Already defined in a different way.
;(its-defrule   "va"   "$B%t%!(B")
;(its-defrule   "vi"   "$B%t%#(B")
;(its-defrule   "vu"   "$B%t(B")
;(its-defrule   "ve"   "$B%t%'(B")
;(its-defrule   "vo"   "$B%t%)(B")
