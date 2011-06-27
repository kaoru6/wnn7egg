;; Basic translation table to input KANA with ASCII keyboard
;; Created by DEMIZU Norotishi <nori-d@is.aist-nara.ac.jp>  on 1994.1.26
;; $Id: kanainput.el,v 1.1 2001/03/03 05:20:21 fukita Exp $

;;
;; $BG[I[>r7o$O(B GNU GENERAL PUBLIC LICENSE $B$K=>$$$^$9!#(B
;;
;; $B$3$l$O(B ASCII $BG[Ns$N%-!<%\!<%I$G$+$JF~NO$G2>L>4A;zJQ49$r$9$k$?$a$N(B
;; $BJQ49%k!<%k$r5-$7$?(B lisp $B$G$9!#;H$$J}$O<!$NDL$j$G$9!#(B
;;  (load "its/kanainput")
;;  (setq its:*standard-modes*
;;        (append (list (its:get-mode-map "kanainput"))
;;  	      its:*standard-modes*))
;;  (setq-default its:*current-map* (its:get-mode-map "kanainput"))
;;

;;
;; $B0lHL$N(B JIS $B$+$J$H0c$&$H$3$m$O<!$G$9!#(B
;;   $B!&(B $B!V$m!W$,(B "|" $B$N0LCV$K!#K\Mh$N!V$m!W$N0LCV$K%-!<$,$J$$$?$a!#(B($BITJX(B)
;;   $B!&(B $B!V!<!W$,B?$/$N%"%9%-!<%-!<%\!<%I$G$O4|BT$H0c$&0LCV$K$"$k!#(B($BITJX(B)
;;   $B!&(B `$B!V(B'  $B$,(B `[' $B$N0LCV$K!#(BASCII $B$N(B "[" $B$K5$;}$A$r9g$o$;$?!#(B
;;   $B!&(B `$B!W(B'  $B$,(B `]' $B$N0LCV$K!#(BASCII $B$N(B "]" $B$K5$;}$A$r9g$o$;$?!#(B
;;   $B!&(B $B!V!)!W$,(B "?" $B$N0LCV$K!#(BASCII $B$N(B "?" $B$K5$;}$A$r9g$o$;$?!#(B
;;   $B!&(B $B!V!&!W$,(B ":" $B$N0LCV$K!#!V!)!W$r(B "?" $B$HF1$80LCV$K$9$k$?$a$:$i$7$?!#(B
;;
;; $BA43QJ8;z!"H>3QJ8;z!"(BJIS $B5-9fF~NO$NItJ,$O(B its/hira.el $B$HF1$8$K$7$^$7$?!#(B
;; $BF~NO$N$?$a$N(B prefix $B$O0J2<$NDL$j!#(B
;;   Q: $BA43QF~NO(B (Quote $B$H3P$($k(B)  ; k-zenkaku-escape $B$GDj5A2DG=(B
;;   A: $BH>3QF~NO(B (Ascii $B$H3P$($k(B)  ; k-hankaku-escape $B$GDj5A2DG=(B
;;   S: $B5-9fF~NO(B (Symbol $B$H3P$($k(B) ; k-symbols-escape $B$GDj5A2DG=(B
;;
;;$B!V$+$JF~NO;~$NG[Ns!W(B
;; $B$L!*(B $B$U!w(B $B$"$!(B $B$&$%(B $B$($'(B $B$*$)(B $B$d$c(B $B$f$e(B $B$h$g(B $B$o$r(B $B$[$m(B $B$X!\(B $B!<!A(B
;;  $B$?(B__ $B$F(B__ $B$$$#(B $B$9$9(B $B$+%u(B $B$s$s(B $B$J$J(B $B$K$K(B $B$i$i(B $B$;$;(B $B!I!V(B $B!,!W(B
;;   $B$A(B__ $B$H(B__ $B$7$7(B $B$O$O(B $B$-$-(B $B$/$/(B $B$^$^(B $B$N$N(B $B$j$j(B $B$l!&(B $B$1%v(B $B$`$m(B
;;    $B$D$C(B $B$5$5(B $B$=$=(B $B$R$R(B $B$3$3(B $B$_$_(B $B$b$b(B $B$M!"(B $B$k!#(B $B$a!)(B
;;
;;$B!V5-9fF~NO;~$NG[Ns!W(B(proposed by TANAKA Jiro <jiro@math.keio.ac.jp> 90.3.2)
;; $B!{!|(B $B"&"'(B $B"$"%(B $B"""#(B $B!~"!(B $B!y!z(B $B!}!r(B $B!q!_(B $B!i!Z(B $B!j![(B $B!A!h(B $B!b!^(B $B!-!/(B
;;  $B!T!R(B $B!U!S(B ____ $B!9!8(B $B!:!x(B $B!o(B__ ____ ____ ____ $B")",(B $B!X!L(B $B!Y!M(B
;;   ____$B!3!4(B $B!5!6(B $B!7"*(B $B!>!=(B $B"+(B__ $B"-!2(B $B",!1(B $B"*(B__ $B!+!,(B $B!F!H(B $B!@!B(B
;;    ____ :-:-)$B!;!n(B $B"(!`(B $B!k"+(B $B!l"-(B $B!m".(B $B!E!e(B $B!D!f(B $B!&!g(B
;;
;;$B!VA[Dj$7$F$$$k(B ASCII $B%-!<%\!<%I$NG[Ns!W(B($BH>3Q!"A43QF~NO;~$b(B)
;; 1!  2@  3#  4$  5%  6^  7&  8*  9(  0)  -_  =+  `~
;;  qQ  wW  eE  rR  tT  yY  uU  iI  oO  pP  [{  ]}
;;   aA  sS  dD  fF  gG  hH  jJ  kK  lL  ;:  '"  \|
;;    zZ  xX  cC  vV  bB  nN  mM  ,<  .>  /?
;;
;; kanainput.el 1.1 -> 1.2:
;;  o $B5-9fF~NO(B prefix $B$r(B "X" $B$+$i(B "S" $B$K$7$?!#(B
;;  o $B0J2<$NF~NOJ}K!$r4JC1$K$9$k$?$aJQ99$7$?!#(B
;;      $B!V$p!W(B  "W4E" --> "WE"
;;      $B!V$q!W(B  "W4%" --> "W%"
;;      $B!V%t!W(B  "W4[" --> "W["
;;  o $B0J2<$NF~NO7k2L$rJQ99$7$?!#K\J*$N(B Quote $B$K$9$k$?$a!#(B
;;      "Q\\"   $B!V!o!W(B-->$B!V!@!W(B
;;      "Q~"    $B!V!1!W(B-->$B!V!A!W(B
;;  o $B0J2<$N%k!<%k$rDI2C$7$?!#(B
;;      "Sy" -->$B!V!o!W(B
;;      "SJ" -->$B!V!2!W(B
;;      "Sk" -->$B!V!1!W(B
;;  o $B3F%k!<%k$K$D$$$F(B its-defrule $B$r=q$$$F$$$?$N$r!"(B
;;    $B4JC1$N$?$aI=%Y!<%9$K$7$?!#(B
;;

(its-define-mode "kanainput" "$B$+(B" t)
(defvar k-zenkaku-escape "Q")  ; $BA43QF~NO$N(B prefix
(defvar k-hankaku-escape "A")  ; $BH>3QF~NO$N(B prefix
(defvar k-symbols-escape "S")  ; $B5-9fF~NO$N(B prefix


(defun its:make-terminal-state-kanainput (map input action state)
  (cond((its:standard-actionp action) (action-output action))
       (t nil)))

(let ((its:make-terminal-state 'its:make-terminal-state-kanainput))
  ;; $B$+$JF~NOMQ(B
  (dolist (normal-pair
	   '(
	     ;; $B@62;(B
	     ("3"   "$B$"(B") ("e"   "$B$$(B") ("4"   "$B$&(B") ("5"   "$B$((B") ("6"   "$B$*(B")
	     ("t"   "$B$+(B") ("g"   "$B$-(B") ("h"   "$B$/(B") ("'"   "$B$1(B") ("b"   "$B$3(B")
	     ("x"   "$B$5(B") ("d"   "$B$7(B") ("r"   "$B$9(B") ("p"   "$B$;(B") ("c"   "$B$=(B")
	     ("q"   "$B$?(B") ("a"   "$B$A(B") ("z"   "$B$D(B") ("w"   "$B$F(B") ("s"   "$B$H(B")
	     ("u"   "$B$J(B") ("i"   "$B$K(B") ("1"   "$B$L(B") (","   "$B$M(B") ("k"   "$B$N(B")
	     ("f"   "$B$O(B") ("v"   "$B$R(B") ("2"   "$B$U(B") ("="   "$B$X(B") ("-"   "$B$[(B")
	     ("j"   "$B$^(B") ("n"   "$B$_(B") ("\\"  "$B$`(B") ("/"   "$B$a(B") ("m"   "$B$b(B")
	     ("7"   "$B$d(B")              ("8"   "$B$f(B")              ("9"   "$B$h(B")
	     ("o"   "$B$i(B") ("l"   "$B$j(B") ("."   "$B$k(B") (";"   "$B$l(B") ("|"   "$B$m(B")
	     ("0"   "$B$o(B") ("WE"  "$B$p(B")              ("W%"  "$B$q(B") (")"   "$B$r(B")
	     ("y"   "$B$s(B")
	     ;; $BBy2;(B
	     ("t["  "$B$,(B") ("g["  "$B$.(B") ("h["  "$B$0(B") ("'["  "$B$2(B") ("b["  "$B$4(B")
	     ("x["  "$B$6(B") ("d["  "$B$8(B") ("r["  "$B$:(B") ("p["  "$B$<(B") ("c["  "$B$>(B")
	     ("q["  "$B$@(B") ("a["  "$B$B(B") ("z["  "$B$E(B") ("w["  "$B$G(B") ("s["  "$B$I(B")
	     ("f["  "$B$P(B") ("v["  "$B$S(B") ("2["  "$B$V(B") ("=["  "$B$Y(B") ("-["  "$B$\(B")
	     ;; $BH>By2;(B
	     ("f]"  "$B$Q(B") ("v]"  "$B$T(B") ("2]"  "$B$W(B") ("=]"  "$B$Z(B") ("-]"  "$B$](B")
	     ;; $B>.$5$J;z(B
	     ("#"   "$B$!(B") ("E"   "$B$#(B") ("$"   "$B$%(B") ("%"   "$B$'(B") ("^"   "$B$)(B")
	     ("&"   "$B$c(B")              ("*"   "$B$e(B")              ("("   "$B$g(B")
	     ("T"   "$B%u(B") ("\""  "$B%v(B") ("Z"   "$B$C(B") ("W0"  "$B$n(B") ("W#"  "$B$n(B")
	     ;; $B$=$NB>(B
	     ("W["  "$B%t(B") ("W"   "$B$&(B")
	     ;; $B5-9f(B
	     ("<"   "$B!"(B") (">"   "$B!#(B") (":"   "$B!&(B") ("?"   "$B!)(B")
	     ("{"   "$B!V(B") ("}"   "$B!W(B") ("["   "$B!+(B") ("]"   "$B!,(B") ("`"   "$B!<(B")
	     ;; $B%7%U%H%-!<2!2<;~$N07$$(B
	     ("G"   "$B$-(B") ("H"   "$B$/(B") ("B"   "$B$3(B")
	     ("X"   "$B$5(B") ("D"   "$B$7(B") ("R"   "$B$9(B") ("P"   "$B$;(B") ("C"   "$B$=(B")
	     ("U"   "$B$J(B") ("I"   "$B$K(B") ("K"   "$B$N(B")
	     ("F"   "$B$O(B") ("V"   "$B$R(B")
	     ("J"   "$B$^(B") ("N"   "$B$_(B") ("M"   "$B$b(B")
	     ("O"   "$B$i(B") ("L"   "$B$j(B")
	     ("Y"   "$B$s(B")
	     ("!"   "$B!*(B") ("@"   "$B!w(B") ("+"   "$B!\(B") ("~"   "$B!A(B")
	     ("_"   "$B$m(B");;; $B!V$m!W$,$"$k%-!<%\!<%IMQ(B
	     ))
    (its-defrule (car normal-pair) (car (cdr normal-pair))))

  ;; $BA43QF~NO(B
  (dolist (zenkaku-pair
	   '(
	     (" "  "$B!!(B") ("!"  "$B!*(B") ("\"" "$B!I(B") ("#"  "$B!t(B")  ; 20--24
	     ("$"  "$B!p(B") ("%"  "$B!s(B") ("&"  "$B!u(B") ("'"  "$B!G(B")  ; 25--27
	     ("("  "$B!J(B") (")"  "$B!K(B") ("*"  "$B!v(B") ("+"  "$B!\(B")  ; 28--2b
	     (","  "$B!$(B") ("-"  "$B!](B") ("."  "$B!%(B") ("/"  "$B!?(B")  ; 2c--2f
	     ("0"  "$B#0(B") ("1"  "$B#1(B") ("2"  "$B#2(B") ("3"  "$B#3(B")  ; 30--33
	     ("4"  "$B#4(B") ("5"  "$B#5(B") ("6"  "$B#6(B") ("7"  "$B#7(B")  ; 34--37
	     ("8"  "$B#8(B") ("9"  "$B#9(B") (":"  "$B!'(B") (";"  "$B!((B")  ; 38--3b
	     ("<"  "$B!c(B") ("="  "$B!a(B") (">"  "$B!d(B") ("?"  "$B!)(B")  ; 3c--3f
	     ("@"  "$B!w(B") ("A"  "$B#A(B") ("B"  "$B#B(B") ("C"  "$B#C(B")  ; 40--43
	     ("D"  "$B#D(B") ("E"  "$B#E(B") ("F"  "$B#F(B") ("G"  "$B#G(B")  ; 44--47
	     ("H"  "$B#H(B") ("I"  "$B#I(B") ("J"  "$B#J(B") ("K"  "$B#K(B")  ; 48--4b
	     ("L"  "$B#L(B") ("M"  "$B#M(B") ("N"  "$B#N(B") ("O"  "$B#O(B")  ; 4c--4f
	     ("P"  "$B#P(B") ("Q"  "$B#Q(B") ("R"  "$B#R(B") ("S"  "$B#S(B")  ; 50--53
	     ("T"  "$B#T(B") ("U"  "$B#U(B") ("V"  "$B#V(B") ("W"  "$B#W(B")  ; 54--57
	     ("X"  "$B#X(B") ("Y"  "$B#Y(B") ("Z"  "$B#Z(B") ("["  "$B!N(B")  ; 58--5a
	     ("\\" "$B!@(B") ("]"  "$B!O(B") ("^"  "$B!0(B") ("_"  "$B!2(B")  ; 5b--5f
	     ("`"  "$B!.(B") ("a"  "$B#a(B") ("b"  "$B#b(B") ("c"  "$B#c(B")  ; 60--63
	     ("d"  "$B#d(B") ("e"  "$B#e(B") ("f"  "$B#f(B") ("g"  "$B#g(B")  ; 64--67
	     ("h"  "$B#h(B") ("i"  "$B#i(B") ("j"  "$B#j(B") ("k"  "$B#k(B")  ; 68--6b
	     ("l"  "$B#l(B") ("m"  "$B#m(B") ("n"  "$B#n(B") ("o"  "$B#o(B")  ; 6c--6f
	     ("p"  "$B#p(B") ("q"  "$B#q(B") ("r"  "$B#r(B") ("s"  "$B#s(B")  ; 70--73
	     ("t"  "$B#t(B") ("u"  "$B#u(B") ("v"  "$B#v(B") ("w"  "$B#w(B")  ; 74--77
	     ("x"  "$B#x(B") ("y"  "$B#y(B") ("z"  "$B#z(B") ("{"  "$B!P(B")  ; 78--7b
	     ("|"  "$B!C(B") ("}"  "$B!Q(B") ("~"  "$B!A(B")              ; 7c--7e
	     ))
    (its-defrule (concat k-zenkaku-escape (car zenkaku-pair))
		 (car (cdr zenkaku-pair))))

  ;; $BH>3QF~NO(B
  (dolist (character
	   '( "1"  "2"  "3"  "4" "5"  "6"  "7"  "8"  "9"  "0"
	      " "  "!"  "@"  "#"  "$"  "%"  "^"  "&"  "*"  "("  ")"
	      "-"  "="  "`"  "\\" "|"  "_"  "+"  "~" "["  "]"  "{"  "}"
	      ":"  ";"  "\"" "'"  "<"  ">"  "?"  "/"  ","  "."
	      "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
	      "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
	      "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N"
	      "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
    (its-defrule (concat k-hankaku-escape character)  character))

  ;;; proposal key bindings for JIS symbols
  ;;; 90.3.2  by jiro@math.keio.ac.jp (TANAKA Jiro)
  ;;; $B!V!o!W!"!V!1!W!"!V!2!W(B are added
  ;;; 94.2.4 by nori-d@is.aist-nara.ac.jp (DEMIZU Noritoshi)
  (dolist (symbols-pair
	   '(
	     ("1"  "$B!{(B") ("2"  "$B"&(B") ("3"  "$B"$(B") ("4"  "$B""(B") ("5"  "$B!~(B")
	     ("6"  "$B!y(B") ("7"  "$B!}(B") ("8"  "$B!q(B") ("9"  "$B!i(B") ("0"  "$B!j(B")
	     ("-"  "$B!A(B") ("="  "$B!b(B") ("\\" "$B!@(B") ("`"  "$B!-(B")
	     ("!"  "$B!|(B") ("@"  "$B"'(B") ("#"  "$B"%(B") ("$"  "$B"#(B") ("%"  "$B"!(B")
	     ("^"  "$B!z(B") ("&"  "$B!r(B") ("*"  "$B!_(B") ("("  "$B!Z(B") (")"  "$B![(B")
	     ("_"  "$B!h(B") ("+"  "$B!^(B") ("|"  "$B!B(B") ("~"  "$B!/(B")
	     ("q"  "$B!T(B") ("w"  "$B!U(B") ("r"  "$B!9(B") ("t"  "$B!:(B") ("y"  "$B!o(B")
	     ("Q"  "$B!R(B") ("W"  "$B!S(B") ("R"  "$B!8(B") ("T"  "$B!x(B")
	     ("p"  "$B")(B") ("["  "$B!X(B") ("]"  "$B!Y(B")
	     ("P"  "$B",(B") ("{"  "$B!L(B") ("}"  "$B!M(B")
	     ("s"  "$B!3(B") ("d"  "$B!5(B") ("f"  "$B!7(B") ("g"  "$B!>(B")
	     ("S"  "$B!4(B") ("D"  "$B!6(B") ("F"  "$B"*(B") ("G"  "$B!=(B")
	     ("h"  "$B"+(B") ("j"  "$B"-(B") ("k"  "$B",(B") ("l"  "$B"*(B")
	                 ("J"  "$B!2(B") ("K"  "$B!1(B")
	     (";"  "$B!+(B") (":"  "$B!,(B") ("\'" "$B!F(B") ("\"" "$B!H(B")
	     ("x"  ":-") ("c"  "$B!;(B") ("v"  "$B"((B") ("b"  "$B!k(B") ("n"  "$B!l(B")
	     ("X" ":-)") ("C"  "$B!n(B") ("V"  "$B!`(B") ("B"  "$B"+(B") ("N"  "$B"-(B")
	     ("m"  "$B!m(B") (","  "$B!E(B") ("."  "$B!D(B") ("/"  "$B!&(B")
	     ("M"  "$B".(B") ("<"  "$B!e(B") (">"  "$B!f(B") ("?"  "$B!g(B")
	     ))
    (its-defrule (concat k-symbols-escape (car symbols-pair))
		 (car (cdr symbols-pair))))
)
