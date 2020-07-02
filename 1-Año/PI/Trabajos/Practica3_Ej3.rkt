;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname Practica3_Ej3) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; Ejercicio 5
;definimos el valor del radio del circlo
(define RADIO 100)
;Definimos el color del fondo de la escena
(define FONDO "white")
;Deinimos el color inicial del circulo
(define COLOR "yellow")
;pantalla : String -> Imagen
(define (pantalla color)
  (place-image (circle RADIO "solid" color) 200 200
               (empty-scene 400 400 FONDO)))
;change_color : String -> String
;A medida que pasa el tiempo, cambia el color del circulo
;Esta construido como un ciclo
(check-expect (change_color "yellow") "red")
(define (change_color color)
  (cond [(string=? color "yellow") "red"]
        [(string=? color "red") "green"]
        [(string=? color "green") "blue"]
        [(string=? color "blue") "yellow"]))

(big-bang COLOR ;Estado incial
          [to-draw pantalla]
          [on-tick change_color 0.5])