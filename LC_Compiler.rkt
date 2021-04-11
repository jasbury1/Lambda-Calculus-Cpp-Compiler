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
  (display
   (~a "#include <iostream>\n\nint main(int argc, char* argv[]){\n"
       (make-string 4 #\space)
       (parse s 4)
       ";\n}\n")))

(define (parse s indent)
  (match s
    ; Number
    [(? real? n)
     (~a n)]
    ; Identifier
    [(? symbol? a)
     (~a a)]
    ; Lambda definition
    [(list '/ (? symbol? a) '=> expr)
     (~a "[=](int " a ") -> decltype(auto) {\n"
         (make-string (+ 4 indent) #\space)
         "return (" (parse expr (+ 4 indent)) ");\n"
         (make-string indent #\space) "}")]
    ; If <= 0
    [(list 'ifleq0 expr1 expr2 expr3)
     (~a (parse expr1 indent) " <= 0 ? "(parse expr2 indent) " : " (parse expr3 indent))]
    ; Print
    [(list 'println expr)
     (~a "std::cout << "  (parse expr indent) " << std::endl")]
    ; Function call
    [(list expr1 expr2)
     (~a (parse expr1 indent) "(" (parse expr2 indent) ")")]
    ; Addition operation
    [(list '+ expr1 expr2)
     (~a "("(parse expr1 indent) " + " (parse expr2 indent) ")") ]
    ; Multiplication operation
    [(list '* expr1 expr2)
     (~a "("(parse expr1 indent) " * " (parse expr2 indent) ")")]
    [_ (error 'Comiler "No expression matched the pattern found. Given: ~v" s)]
    ))




(check-equal? (parse 17 0) "17")
(check-equal? (parse 'a 0) "a")
(check-equal? (parse 'variable_name 0) "variable_name")
(check-equal? (parse '(/ xyz => (+ 5 (* 1 2))) 0)
              "[=](int xyz) -> decltype(auto) {\n    return ((5 + (1 * 2)));\n}")
(parse '(ifleq0 4 5 6) 0)
(check-equal? (parse '(+ 1 2) 0) "(1 + 2)")
(parse '(println (+ 4 5)) 0)

(compile '((/ x => (ifleq0 x (println (* x -1)) (println x))) -3))

(compile '((/ val => (+ val 3)) 5))

(compile '(((/ x => (/ y => (+ x y))) 4 ) 3))

(compile '((((/ x => (/ y => (/ z => (* x (+ y z))))) 4 ) 3) 2))



