;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Senor-Marelli) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; Practica 5-Segunda parte
; Ejercicio 6
#|Una List-puntos es:
- '()
- (cons posn List-puntos)
Interpretacion: Esta lista contiene elementos del tipo posn|#
#|Una List-num es:
- '()
- (cons Number List-num)
Interpretacion: Esta lista contiene numeros|#
#|Representamos punto con posn
distancia : posn -> Number
Recibe un elemento posn y calcula la distancia del punto al origen|#
(check-expect (distancia (make-posn 0 3)) 3)
(check-expect (distancia (make-posn 4 3)) 5)
(check-expect (distancia (make-posn 0 0)) 0)
(define (distancia punto)
  (sqrt (+ (sqr (posn-x punto)) (sqr (posn-y punto)))))
#|Representamos l con una lista
sumdist : List-puntos -> Number
Recibe una lista y devuelve la suma de las distancias al
origen de cada elemento de l|#
(check-expect (sumdist (list (make-posn 0 0) (make-posn 0 3) (make-posn 4 3))) 8)
(check-expect (sumdist (list (make-posn 0 4) (make-posn 5 0))) 9)
(check-expect (sumdist empty) 0)
(define (sumdist l)
  (foldr + 0 (map distancia l)))

; Ejercicio 10
#|List-img es:
- '()
- (cons Imagen List-img)
Interpretacion: Esta lista contiene imagenes|#
#|Representamos i con una imagen
gorda? : Imagen -> Boolean
Recibe una imagen y determina si es una imagen "Gorda"
(su alto < su ancho)|#
(check-expect (gorda? (rectangle 30 10 "solid" "black")) #true)
(check-expect (gorda? (rectangle 70 65 "solid" "black")) #true)
(check-expect (gorda? (rectangle 30 80 "solid" "black")) #false)
(define (gorda? i)
  (< (image-height i) (image-width i)))
#|Representamos i con una imagen
area : Imagen -> Number
Recibe una imagen y calcula su area|#
(check-expect (area (rectangle 30 10 "solid" "black")) 300)
(check-expect (area (rectangle 20 20 "solid" "black")) 400)
(check-expect (area (rectangle 10 90 "solid" "black")) 900)
(define (area i)
  (* (image-width i) (image-height i)))
#|Representamos l con una lista
sag : List-img -> Number
Recibe una lista de imágenes y devuelve la suma de
las áreas de aquellas imágenes "Gordas"|#
(check-expect (sag (list (rectangle 20 20 "solid" "black")
                         (rectangle 30 10 "solid" "black"))) 300)
(check-expect (sag (list (rectangle 20 20 "solid" "black")
                         (rectangle 10 10 "solid" "black"))) 0)
(check-expect (sag (list (rectangle 20 20 "solid" "black")
                         (rectangle 100 10 "solid" "black")
                         (rectangle 50 10 "solid" "black"))) 1500)
(check-expect (sag empty) 0)
(define (sag l)
  (foldr + 0 (map area (filter gorda? l))))
