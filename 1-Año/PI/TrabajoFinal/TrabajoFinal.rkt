;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Final) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
#|     Bautista Marelli   Comision 1     |#
#|  Trabajo final  |#
; Cifrado de Cesar

; Representaremos alfabetos como Strings.
; Por ejemplo, si nuestros simbolos son las cinco primeras letras, los di­gitos y el espacio,
; lo representaremos como "ABCDE0123456789 "

; Representaremos simbolos como strings de longitud 1. En el alfabeto anterior,
; el simbolo E lo representamos con el string "E"

; El codigo del Cesar lo representaremos mediante parejas de si­mbolos.
; Por ejemplo, si queremos decir que el simbolo "A" se codifica con el
; simbolo "C", tendremos (make-posn "A" "C") para representar esta situacion

; List(String) es:
; empty
; (cons String List(String))
; Interpretacion : Esta lista contiene string

#|  Definimos algunas funciones de utilidad  |#

; partir : String -> List(String)
; Dado un string, devuele una lista de strings con cada simbolo separado
(check-expect (partir "ABC") (list "A" "B" "C"))
(check-expect (partir "12345") (list "1" "2" "3" "4" "5"))
(define (partir s)
  (map string (string->list s)))

; tomar : List N -> List
; Dada una lista y un numero natural n, devuelve una lista
; con los primeros n elementos de l. Si l no tiene tantos elementos,
; devuelve l.
(check-expect (tomar (list #t #f #t #f #t) 4) (list #t #f #t #f))
(check-expect (tomar (list 1 2 3 4 5) 10) (list 1 2 3 4 5))
(check-expect (tomar (list 1 2 3 4 5) 0) empty)
(define (tomar l n)
  (cond [(zero? n) empty]
        [(< (length l) n) l]
        [else (cons (first l) (tomar (rest l) (sub1 n)))]))

; tirar : List N -> List
; Dada una lista y un numero natural n, devuelve una lista
; sin los primeros n elementos de l. Si l no tiene tantos elementos,
; devuelve empty.
(check-expect (tirar (list 1 2 3 4 5) 2) (list 3 4 5))
(check-expect (tirar (list 1 2 3 4 5) 10) empty)
(check-expect (tirar (list 1 2 3 4 5) 0) (list 1 2 3 4 5))
(define (tirar l n)
  (cond [(zero? n) l]
        [(< (length l) n) empty]
        [else (remove (first l) (tirar (rest l) (sub1 n)))]))
; OBSERVACION: para cualquier n <= length l, (append (tomar n l) (tirar n l)) = l

; emparejar : List List -> List
; Dadas dos listas [a0,..., an] y [b0, ...., bn] de la misma longitud, devuelve una lista
; de posn con parejas tomadas de ambas listas: [(make-posn a0 b0), ...., (make-posn an bn)]
(check-expect (emparejar (list 1 2) (list "a" "b")) (list (make-posn 1 "a") (make-posn 2 "b")))
(check-expect (emparejar (list #t #f) (list 1 0)) (list (make-posn #t 1) (make-posn #f 0)))
(define (emparejar l1 l2)
  (cond [(and (empty? l1) (empty? l2)) empty]
        [else (cons (make-posn (first l1) (first l2)) (emparejar (rest l1) (rest l2)))]))

#|  Ahora comienzan las funciones especificas para el cifrado del Cesar  |#

; Definimos el alfabeto que vamos a utilizar
(define ALFABETO "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 123456890!?")

; La clave para poder encriptar nuestros mensajes, son aquellos n <= 64,
; ya que tiene que ser menor a la cantidad de letras del alfabeto utilizada 

; cifrado : N String -> List
; Dada una clave de desplazamiento y un alfabeto s, devuelve una lista
; con parejas de strings, donde el primer elemento es el caracter a cifrar, y el segundo
; su codigo del Cesar de acuerdo a la clave. Se asume que n < (string-length s)
(check-expect (cifrado 2 "ABC") (list (make-posn "A" "C") (make-posn "B" "A") (make-posn "C" "B"))) 
(check-expect (cifrado 1 "ABC") (list (make-posn "A" "B") (make-posn "B" "C") (make-posn "C" "A")))
(check-expect (cifrado 0 "ABC") (list (make-posn "A" "A") (make-posn "B" "B") (make-posn "C" "C")))
(define (cifrado n s)
  (cond [(zero? n) (emparejar (partir s) (partir s))]
        [else (emparejar (partir s) (append (tirar (partir s) n) (tomar (partir s) n)))]))

; encriptar-simbolo : String List -> String
; dado un string s de longitud 1 que es un simbolo del
; alfabeto y una lista de parejas que representa un codigo del Cesar,
; devuelve el codigo que le corresponde a s
(check-expect (encriptar-simbolo "A" (cifrado 2 "ABC")) "C")
(check-expect (encriptar-simbolo "A" (cifrado 1 "ABC")) "B")
(define (encriptar-simbolo s l)
  (cond [(string=? (posn-x (first l)) s) (posn-y (first l))]
        [else (encriptar-simbolo s (rest l))]))

; script : N -> List(String)
; Esta funcion utiliza la funcion cifrado para
; cifrar el alfabeto utilizado
(define (script n)
  (cifrado n ALFABETO))

; primer-caracter : String N -> String
; Esta fincion utiliza encriptar-simbolo para
; encriptar el primer caracter de la string
(check-expect (primer-caracter "H" 3) "K")
(check-expect (primer-caracter "E" 3) "H")
(define (primer-caracter s n)
  (encriptar-simbolo (first (partir s)) (script n)))

; encriptar-mensaje : String N -> String
; dado un string y una clave, devuelve el string encriptado
(check-expect (encriptar-mensaje "ABC" 3) "DEF")
(check-expect (encriptar-mensaje "ABC" 4) "EFG")
(define (encriptar-mensaje s n)
  (cond [(string=? s "") ""]
        [(= n 0) s]
        [else (string-append (primer-caracter s n) (encriptar-mensaje (substring s 1) n))]))

; desencriptar-simbolo : String List -> String
; Dado un string s de longitud 1 que es un si­mbolo del
; alfabeto y una lista de parejas que representa un codigo del Cesar,
; devuelve el caracter desencriptado que le corresponde a s
(check-expect (desencriptar-simbolo "A" (cifrado 2 "ABC")) "B")
(check-expect (desencriptar-simbolo "A" (cifrado 1 "ABC")) "C")
(define (desencriptar-simbolo s l)
  (cond [(string=? "" s) ""]
        [(string=? (posn-y (first l)) s) (posn-x (first l))]
        [else (desencriptar-simbolo s (rest l))]))

; reverse-primer-caracter : String N -> String
; Esta fincion utiliza desencriptar-simbolo para
; desencriptar el primer caracter de la string
(check-expect (reverse-primer-caracter "K" 3) "H")
(check-expect (reverse-primer-caracter "H" 3) "E")
(define (reverse-primer-caracter s n)
  (desencriptar-simbolo (first (partir s)) (script n)))

; desencriptar-mensaje : String N -> String
; Dado un string y una clave, devuelve el string encriptado
(check-expect (desencriptar-mensaje "DEF" 3) "ABC")
(check-expect (desencriptar-mensaje "EFG" 4) "ABC")
(define (desencriptar-mensaje s n)
  (cond [(string=? s "") ""]
        [(= n 0) s]
        [else (string-append (reverse-primer-caracter s n) (desencriptar-mensaje (substring s 1) n))]))

#|  Podemos ver el algunos ejemplos  |#
"A continuacion encriptaremos la siguiente frase: 'Tengo que rendir el Final de Programacion el Lunes' con la clave: 17"
"Mensaje encriptado:"
(encriptar-mensaje "Tengo que rendir el Final de Programacion el Lunes" 17)
""
"Desencriptamos el mensaje '1gsuy6Gxmktzotg' con la clave CORRECTA"
"Mensaje:"
(desencriptar-mensaje "1gsuy6Gxmktzotg" 6)
""
"Desencriptamos el mensaje: 'Kyzk6sktygpk6tu6zoktk6yktzoju' con una clave INCORRECTA"
(desencriptar-mensaje "Kyzk6sktygpk6tu6zoktk6yktzoju" 4)
"En este ultimo ejemplo podemos ver que si no tenemos la clave adecuada, no podremos desencriptar el mensaje"
