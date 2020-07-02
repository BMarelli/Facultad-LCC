;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Practica5-1eraP-EJ-18) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;Ejercicio 18

; Una Lista-de-numeros es:
; – '()
; – (cons Numero Lista-de-numeros)

;eliminar: Lista-de-numeros -> Lista-de-numeros
;eliminar toma una lista de números y un número y devuelve la lista luego
;de eliminar el número que indica el 2do argumento.
(check-expect(eliminar empty 2) empty)
(check-expect(eliminar (list 1 2 3 2 7 6) 2)(list 1 3 7 6))
(check-expect(eliminar (list 1 2 3 2 7 6) 0)(list 1 2 3 2 7 6))

(define (eliminar l n)
  (cond [(empty? l) empty]
        [(cons? l) (if (= (first l) n)
                       (eliminar (rest l) n)
                       (cons (first l)(eliminar (rest l) n)))]
        ))









