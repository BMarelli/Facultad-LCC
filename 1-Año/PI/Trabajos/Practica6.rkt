;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Practica6) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")))))
#|Un N es: 
– 0
– (add1 N)
interpretación: N representa los números naturales|#

; Ejercicio 1
#|sumanat : N N -> N
Recibe dos números naturales y devuelve un natural que es la suma de ambos|#
(check-expect (sumanat 3 2) 5)
(check-expect (sumanat 5 2) 7)
(check-expect (sumanat 0 2) 2)
(define (sumanat a b)
  (cond [(zero? a) b]
        [else (sumanat (sub1 a) (add1 b))]))
;==============================================================================================================================================
; Ejercicio 2 
#|multiplicar : N N -> N
Recibe dos números naturales y devuelve el resultado al multiplicarlos|#
(check-expect (multiplicar 2 4) 8)
(check-expect (multiplicar 2 1) 2)
(define (multiplicar a b)
  (cond [(zero? b) 0]
        [else (sumanat (multiplicar a (sub1 b)) a)]))
;==============================================================================================================================================
; Ejercicio 3
#|powernat : N N -> N
Toma dos números naturales y devuelve el resultado de elevar el primero a la potencia del segundo|#
(check-expect (powernat 2 0) 1)
(check-expect (powernat 4 2) 16)
(define (powernat a b)
  (cond [(zero? b) 1]
        [else (multiplicar (powernat a (sub1 b)) a)]))
;==============================================================================================================================================
; Ejercicio 4
#| Sigma : N (N -> Number) -> Number
Dados un número natural n y una función f, 
devuelve la sumatoria de todos los valores entre f (0) y f (n)|#
(check-expect (Sigma 4 sqr) 30)
(define (Sigma n F)
  (cond [(zero? n) (F 0)]
        [else (+ (F n) (Sigma (sub1 n) F))]))
;==============================================================================================================================================
; Ejercicio 5
;g : N -> Number
(check-expect (g 0) 1)
(check-expect (g 1) 0.125)
(define (g i)
  (/ 1 (expt (+ i 1) 3)))
;G : N -> Number
(define (G i)
  (Sigma i g))

;r : N -> Number
(check-expect (r 0) 1)
(check-expect (r 1) 0.5)
(define (r i)
  (/ 1 (expt 2 i)))
;R : N -> Number
(define (R i)
  (Sigma i r))
;==============================================================================================================================================
; Ejercicio 6
#|intervalo2 : N -> List-num
Dado un número natural n, devuelve la lista [n, ..., 2, 1]. Para 0 devuelve empty|#
(check-expect (intervalo2 3) (list 3 2 1))
(define (intervalo2 n)
  (cond [(zero? n) empty]
        [else (cons n (intervalo2 (sub1 n)))]))
#|intervalo : N -> List-num
Dado un número natural n, devuelve la lista [1, 2, ..., n]. Para 0 devuelve empty|#
(check-expect (intervalo 3) (list 1 2 3))
(define (intervalo n)
  (reverse (intervalo2 n)))
;==============================================================================================================================================
; Ejercicio 7
(check-expect (factnat 4) (* 4 3 2 1))
(define (factnat n)
  (cond [(zero? n) 1]
        [else (* n (factnat (sub1 n)))]))
;==============================================================================================================================================
; Ejercicio 8
#|fibnat : N -> Number
Recibe un número natural y devuelve el valor correspondiente a la secuencia de Fibonacci para ese valor:
fibnat (0) = 1 ,fibnat (1) =1 ,fibnat (n+2) = fibnat (n) + fibnat (n+1)|#
(check-expect (fibnat 4) 5)
(define (fibnat n)
  (cond [(zero? n) 1]
        [(= n 1) 1]
        [else (+ (fibnat (- n 2)) (fibnat (sub1 n)))]))
;==============================================================================================================================================
; Ejercicio 9
#|list-fibonacci |#
(check-expect (list-fibonacci 4) (list 5 3 2 1 1))