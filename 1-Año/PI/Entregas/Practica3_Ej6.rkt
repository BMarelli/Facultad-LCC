;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname Practica3_Ej6) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; Ejercicio 6
#|pantalla : String -> Imagen
Transforma el estado en una imagen|#
(define (pantalla estado)
  (place-image/align (text estado 20 "indigo")
                   0 0 "left" "top" (empty-scene 800 60)))
;Definimos el estado inicial
(define TEXT "")
#|borrar : String -> String
Elimina el ultimo caracter de la string entrante|#
(define (borrar estado)
  (cond [(>= (string-length estado) 1) (substring estado 0 (- (string-length estado) 1))]
        [(string=? estado "") estado]))
#|writing : Estado String -> Estado
Interpreta los eventos del teclado, que se agregan al estado|#
(define (writing estado key)
  (cond [(string=? key "\b") (borrar estado)] ;Cuando key = Backspace le saca el ultimo caracter al estado
        [(and (string? key) (= (string-length key) 1)) (string-append estado key)] ;La longitud de un caracter es = 1
        [else estado]))
(big-bang TEXT ;Estado incial
  [to-draw pantalla]
  [on-key writing])