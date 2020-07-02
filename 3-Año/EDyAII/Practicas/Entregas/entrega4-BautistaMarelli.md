# Practica 4 - Entrega - Bautista Marelli - EDyAII

### Ejercicio 4
```haskell
tad PriorityQueue (A : Set, N : OrderedSet) where
  import Bool
  vacia: PriorityQueue A
  poner: A -> N -> PriorityQueue A -> PriorityQueue A
  primero: PriorityQueue A -> A
  sacar: PriorityQueue A -> PriorityQueue A
  esVacia: PriorityQueue A -> Bool
  union: PriorityQueue A -> PriorityQueue A -> PriorityQueue A

poner x n (poner y n ys) = poner x n ys
primero (poner x n vacia) = x
primero (poner x n1 (poner y n2 ys)) = if n1 >= n2 then primero (poner x n1 ys)
                                       else primero (poner y n2 ys)
sacar vacio = vacio
sacar (poner x n vacio) = vacio
sacar (poner x n xs) = poner x n (sacar xs)
esVacia vacia = True
esVacia (poner x n xs) = False
union xs vacia = xs
union xs (poner y n ys) = union (poner y n xs) ys

-- Implementacion con conjuntos
vacia = {}
poner x y xs = {(x,y)} U xs
primero ({(x,y)} U vacia) = (x,y)
primero ({(x1,y1), (x2,y2)} U xs) = if y1 > y2 then primero ({(x1,y1)} U xs)
                                    else primero ({(x2,y2)} U xs)
sacar ({(x,y)} U xs) = vacia
sacar ({(x1,y1), (x2,y2)} U xs) = if y1 > y2 then {x2,y2} U sacar ({(x1,y1)} U xs)
                                  else {x1,y1} U sacar ({(x2,y2)} U xs)
esVacia vacia = True
esVacia ({(x,y)} U xs) = False
union ({(x,y)} U xs) vacia = ({(x,y)} U xs)
union {(x1,y1), ..., (xn, yn)} ys = {(x1,y1), ..., (xn, yn)} U {(x,y) | (x,y) <- ys, y no pertenece {y1, ..., yn}}
```

### Ejercicio 9
```haskell
data AGTree a = Node a [AGTree a]
ponerProfs n (Node x xs) = Node n (map (ponerProfs (n + 1)) xs)
```
Principio de Induccion de AGTree:
Dadas una propiedad $P$ sobre los elementos de `AGTree`, para probar $\forall xs::$ `AGTree`. $P(xs)$ vale:

```
Caso base: P(Node a [])

Caso inductivo: Si vale P([X1, X2, ..., Xn]) entonces vale para P(Node a [X1, X2, ..., Xn])
```

### Ejercicio 13
```haskell
type Rank = Int
data Heap a = E | N Rank a (Heap a) (Heap a)

merge :: Ord a -> Heap a -> Heap a -> Heap a
merge xs E = xs
merge E ys = ys
merge xs@(N n1 x1 y1) ys@(N n2 x2 y2) = if n1 <= n2 then makeH n1 x1(merge y1 ys)
                          else makeH n2 x2(merge xs y2)
rank :: Heap a -> Rank
rank E = 0
rank (N r _ _) = r

makeH n x y = if rank x > rank y then N (rank y + 1) n x y
              else N (rank x + 1) n y x
```

Queremsos demostrar que l1 y l2 son leftist heap, entonces merge l1 l2 es un leftist heap.

Lo veremos por induccion sobre l2:

Definimos nuestra hipotesis inductiva: Si l1, l2 son leftist heap, entonces `merge y1 l2` es un leftist heap (donde `l1 = N n1 x1 y1`) -> (H.I-1)
```haskell
merge :: Ord a -> Heap a -> Heap a -> Heap a
haskell
merge :: Ord a -> Heap a -> Heap a -> Heap a

-- 1) Caso l2 = E:

merge l1 E = {- def merge -} = l1. {- Luego por la (H.I-1), l1 es L.H -}

-- 2) Caso l2 = N Rank a (Heap a) (Heap a):

merge l1 l2 = {- separamos en casos -}

  {- Definimos una nueva hipotesis inductiva: Si l1, l2 son leftist heap, entonces merge xs y2 es un leftist heap (donde l2 = N n2 x2 y2) -> (H.I-2)  -}
  -- > Caso l1 = E:

    merge E l2 = {- def merge -} = l2 {- Luego por la (H.I-2), l2 es L.H -}

  -- > Caso l1 = N Rank a (Heap a) (Heap a):
    merge xs@(N n1 x1 y1) ys@(N n2 x2 y2) = {- def merge -} =
          if n1 <= n2 then makeH n1 x1(merge y1 ys)
          else makeH n2 x2(merge xs y2)
    = {- separamos por casos -}

      -- >> Caso n1 <= n2
        = {- n1 <= n2 -}
        makeH n1 x1 (merge y1 ys)
        = {-
        - (Lema-1): si l1, l2 son leftist heaps => makeH n1 l1 l2 es un leftist heap
        - Por (H.I-1) merge y1 ys es un L.H -}
      -- >> Caso n1 > n2
        = {- n1 > n2  -}
        makeH n2 x2 (merge xs y2)
        = {-
        - (Lema-1): si l1, l2 son leftist heaps entonces makeH n1 l1 l2 es un leftist heap
        - Por (H.I-2) merge xs y2 es un L.H -}
        = {- Por lo tanto es un leftist heap -}
```

Ahora demostremos el Lema-1:

Realizamos induccion sobre l1:

Definimos una hipotesis inductiva: Si l1, l2 son leftist heap, entonces `makeH n l1 l2` es un leftist heap (H.I)

```haskell
makeH n x y = if rank x > rank y then N (rank y + 1) n x y
              else N (rank x + 1) n y x

-- Caso l1 = E
makeH n E l2 = {- def makeH -} = N 1 n l1 E = {- Esto cumple con la definicion de leftsit heap -}

-- Caso l1 = N Rank a (Heap a) (Heap a):
make n l1 l2 = {- Separamos en casos -}

        -- l2 = E:
        make n l1@(N n1 x1 x2) E = {- def makeH -} = N 1 n l1 E = {- Esto cumple con la definicion de leftist heap -}

        -- l2 = N Rank a (Heap a) (Heap a):
        make n l1@(N n1 x1 x2) l2@(N n2 x2 y2) = {- Separamos en casos -}

                -- n1 > n2:
                {- def makeH -} = N (n1 + 1) n l1 l2 = {- Esto cumple con la definicion de leftist heap -}

                -- n1 <= n2:
                {- def makeH -} = N (n2 + 1) n l2 l1 = {- Esto cumple con la definicion de leftist heap -}
```

De esta manera demostramos que si l1, l2 son L.H, entonces `merge l1 l2` es un L.H
