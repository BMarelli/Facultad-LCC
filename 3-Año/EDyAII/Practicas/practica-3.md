# Practica 3 - EyAII

### Ejercicio 1
```haskell
type Color = (Int, Int, Int)

mezclar :: Color -> Color -> Color
mezclar (x,y,z) (a,b,c) = (div (x+a) 2, div (y+b) 2, div (z+c) 2)
```
### Ejercicio 2
```haskell
type Linea = (String, Int)

vacia :: Linea
vacia = ([], 0)

moverIzq :: Linea -> Linea
moverIzq (xs, n) | n == 0 = (xs, 0)
                 | otherwise = (xs, n - 1)

moverDer :: Linea -> Linea
moverDer (xs, n) | n == length xs = (xs, n)
                 | otherwise = (xs, n + 1)

moverIni :: Linea -> Linea
moverIni (xs, n) = (xs, 0)

moverFin :: Linea -> Linea
moverFin (xs, n) = (xs, length(xs))

insertar :: Char -> Linea -> Linea
insertar :: Char -> Linea -> Linea
insertar c (xs, n) = ((take n xs)++[c]++(drop n xs), n)
