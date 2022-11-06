;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Practica5-1eraP-EJ-29) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;Ejercicio 29

; Una Lista-de-puntos es:
; – '()
; – (cons Numero Lista-de-puntos)

;sumdist: Lista-de-puntos -> Number
;toma una lista de puntos del plano y devuelve
;la suma de sus distancias al origen.
(check-expect(sumdist empty) 0)
(check-expect(sumdist (list (make-posn 3 4) (make-posn 0 4) (make-posn 12 5))) 22)

(define (sumdist l)
  (cond [(empty? l) 0]
        [(cons? l) (+  (sqrt (+ (sqr (posn-x (first l))) (sqr (posn-y (first l))))) (sumdist (rest l)))]
        ))
