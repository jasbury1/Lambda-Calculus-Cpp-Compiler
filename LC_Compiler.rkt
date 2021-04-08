#lang racket


;LC	 	=	 	num
; 	 	|	 	id
; 	 	|	 	(/ id => LC)
; 	 	|	 	(LC LC)
; 	 	|	 	(+ LC LC)
; 	 	|	 	(* LC LC)
; 	 	|	 	(ifleq0 LC LC LC)
; 	 	|	 	(println LC)

(require typed/rackunit)

(define (compile s)
  (display (~a "#include <iostream>\n\nint main(int argc, char* argv[]){\n" (parse s) "\n}\n")))

(define (parse s)
  (match s
    ; Number
    [(? real? n)
     (~a n)]
    ; Identifier
    [(? symbol? a)
     (~a a)]
    ; Lambda definition
    [(list '/ (? symbol? a) '=> expr)
     (~a "[=](" a ") -> decltype(auto) {return (" (parse expr) ")}")]
    ; If <= 0
    [(list 'ifleq0 expr1 expr2 expr3)
     (~a (parse expr1) " <= 0 ? "(parse expr2) " : " (parse expr3))]
    ; Print
    [(list 'println expr)
     (~a "std::cout << "  (parse expr) " << std::endl;")]
    ; Function call
    [(list expr1 expr2)
     (~a (parse expr1) "(" (parse expr2) ")")]
    ; Addition operation
    [(list '+ expr1 expr2)
     (~a "("(parse expr1) " + " (parse expr2) ")") ]
    ; Multiplication operation
    [(list '* expr1 expr2)
     (~a "("(parse expr1) " * " (parse expr2) ")")]
    [_ 8]
    ))




(parse 17)
(parse 'a)
(parse 'variable_name)
(parse '(/ xyz => (+ 5 (* 1 2))))
(parse '(ifleq0 4 5 6))
(parse '(+ 1 2))
(parse '(println (+ 4 5)))

(compile '((/ x => (ifleq0 x (println (* x -1)) (println x))) -3))


