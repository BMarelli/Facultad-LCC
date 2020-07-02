# Practica 5 - Entrega - Bautista Marelli - EDyAII

## Ejercicio 1
```haskell
data BTree a = Empty | Node Int (BTree a) a (BTree a)
              deriving Show
```
### Implementacion de `cons`
```haskell
{- Inserta un elemento al comienzo de la secuencia -}
cons :: a -> BTree a -> BTree a
cons v Empty = Node 1 Empty v Empty
cons v (Node k xs x ys) = Node (k + 1) (cons v xs) x ys
```

### Calculo del trabajo y la profundidad de `cons`
Definimos la funcion de trabajo de `cons` como `w_cons` en relacion a la altura del árbol:

```haskell
w_cons 0 = c1
w_cons h = (w_cons (h - 1)) + c2

-- Supongamos que w_cons h <= c * n
w_cons (h + 1) = w_cons h + c2 <= c * h + c2 <= c * (h - 1) + c2 

-- Caso Base:
w_cons (1) = c1 + c2 <= c

==> w_cons(h) ϵ O(h)

-- Luego es facil ver que w_cons(h) ϵ Ω(h)

==> w_cons(h) ϵ Θ(h)

-- Como w_cons(h) = s_cons(h), nos queda que s_cons(h) ϵ Θ(h)
```

### Implementacion de `tabulate`
```haskell
{- Dada una funcion f y un entero n devuelve una secuencia de tamaño n,
 donde cada elemento de la secuencia es el resultado de aplicar f al indice del elemento -}
tabulate :: (Int -> a) -> Int -> BTree a
tabulate f 0 = Empty
tabulate f 1 = Node 1 Empty (f 0) Empty
tabulate f n = let mid = div n 2
                   (xs, ys) = (tabulate f mid, tabulate (\x -> f (x + mid + 1)) (n - mid - 1))
               in Node n xs (f mid) ys
```

### Calculo del trabajo y profundidad de `tabulate`
Definimos la funcion del trabajo y profunda en funcion del tamaño del arbol:
```haskell
w_tabulate(h) | h == 0  = w_tabulate 0 = c1
              | h > 0   = w_tabulate h = (w_tabulatefloor (h/2)) + (w_tabulate (h - floor (h/2) - 1) + c2)
-- Como h - floor (h/2) - 1 <= floor (h/2),

w_tabulate h <= c2 + 2 * w_tabulate (floor (h/2))

{- Si consideramos w_tabulate(h) = c2 +  2 * w_tabulate(h/2), Por el Teorema Maestro resulta w_tabulate(h) ϵ Θ(h) 
==> Como f(h) = h es una funcion suave, resulta w_tabulate(h) ϵ Θ(h) -}

s_tabulate(h) | h == 0  = s_tabulate(0) = c3
              | h > 0   = s_tabulate(h) = c4 + max(s_tabulate(floor(h/2)) + w_tabulate(h - floor(h/2) - 1))         = c4 + s_tabulate(floor(h/2))

{- Si consideramos s_tabulate(h) = c4 + s_tabulate(h), Por el Teorema Maestro resulta s_tabulate(h) in O(log h) Como f(h) = log h es una funcion suave,resulta s_tabulate(h) in O(log h) -}
```

### Implementacion de `take`
```haskell
{- Dados un entero n y una secuencia s devuelve los primeros n elementos de s -}
take_ :: Int -> BTree a -> BTree a
take_ 0 _ = Empty
take_ _ Empty = Empty
take_ n tr@(Node k xs v ys) | k <= n = tr
                            | x == n       = xs
                            | x > n        = take_ n xs
                            | otherwise    = Node n xs v (take_ (n - x - 1) ys)
                        where x = size xs
```

### Calculo del trabajo y profundidad de `take`
Definimo la funcion del trabajo y profundidad en relacion a la altura del arbol
```haskell
w_take h | h == 0       = c1
         | h > 0        = c2 + w_take (h - 1)
{- Sea h la altura del arbol -}
-- Caso Base:
w_take 0 = c1

-- Caso inductivo
w_take h = c2 + w_take (n - 1) = (n - 1) * c2 + c1 <= c * n

-- Luego podemos ver que w_take(h) ϵ O(h)
```
