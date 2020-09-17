-- Practica 4 - EDyAII

-- Implementacion de Cola
type Cola a = [a]

cola_esVacia :: Cola a -> Bool
cola_esVacia [] = True
cola_esVacia _ = False

cola_poner :: a -> Cola a -> Cola a
cola_poner x xs = xs ++ [x]

cola_primero :: Cola a -> a
cola_primero (x:_) = x

cola_sacar :: Cola a -> Cola a
cola_sacar [] = []
cola_sacar (x:xs) = xs

-- Ejercicio 1
{-
tad Lista (A : Set) where
  import Bool
  nill : Lista A
  cons : A -> Lista A -> Lista A
  null : Lista A -> Bool
  head : Lista A -> A
  tail : Lista A -> Lista A

-- (a)
null nill                    = True
null (cons x xs)             = False
head (cons x nill)           = x
head (cons x (cons y xs))    = x    -- (?)
tail (cons x nill)           = nill
tail (cons x xs)             = xs

-- (b)
nill = []
null [x1, ...,xn] = | True  if n == 0
                    | False else
cons x [y1, ..., yn] = [x, y1, ..., yn]
head [x1, ..., xn] = x1
tail [x1, ..., xn] = [x2, ..., xn]

-- (c)
  inL : Lista A -> A -> Bool
inL x nill = False
inL x (cons y nill) = (x == y) || inL x nill
inL x (cons y ys) = (x == y) || inL x ys

inL x [y1, ..., yn] = | True  if x == y | y <- [y1, ..., yn]
                      | False else
-}

-- Ejercicio 2
{-
-- Especificacion Algebraica
isEmpty empty = True
isEmpty (push x p) = False
top (push x q) = x
top (push x (push y q)) = x
pop (push x q) = q
pop (push x (push y q)) = push y q

-- Modelo de Secuencias
empty = <>
push x <x1, ..., xn> = <x, x1, ..., xn>
pop <x1, ..., xn> = <x2, ..., xn>
isEmpty <x1, ..., xn> = | True  if n == 0
                        | False else
-}

-- Ejercicio 3

{-
tad Conjunto (A : Set) where 
  import Bool 
  vacio : Conjunto A 
  insertar : A → Conjunto A → Conjunto A 
  borrar : A → Conjunto A → Conjunto A 
  esVacio : Conjunto A → Bool
  union : Conjunto A → Conjunto A → Conjunto A
  interseccion : Conjunto A → Conjunto A → Conjunto A
  resta : Conjunto A → Conjunto A → Conjunto A

insertar x (insertar x xs) = insertar x xs
insertar x (insertar y xs) = insertar y (insertar x xs)
esVacio vacio = True
esVacio (insertar x xs) = False
borrar x vacio = vacio
borrar x (insertar x vacio) = vacio
borrar x (insertar x xs) = xs
borrar x (insertar y xs) = insertar y (borrar x xs)
union vacio vacio = vacio
union xs vacio = xs
union vacio xs = xs
union xs ys = insertar y xs | y <- ys -- ?
union (insertar x xs) (insertar y ys) = union (insertar y (insertar x xs)) ys
interseccion vacio _ = vacio
interseccion _ vacio = vacio
interseccion (insertar x xs) (insertar y ys) = union (insertar x vacio) (interseccion xs (insertar y ys)) if x in (insertar y ys)
resta xs vacio = xs
resta vacio xs = xs
resta (insertar x xs) (insertar y ys) = union (insertar x vacio) (resta xs (insertar y ys)) if x !in (insertar y ys)
-}

-- Ejercicio 4

{-
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
poner x y xs = {(x, y)} U xs
primero {(x1, y1), ..., (xn, yn)} = (xi, yi) | i = max {y1, ..., yn}
primero {(x1, y1), ..., (xn, yn)} = {(xi, yi) | (xi, yi) <- {(x1, y1), ..., (xn, yn)} && yi = max {y1, ..., yn}}
esVacia vacia = True
esVacia ({(x,y)} U xs) = False
union ({(x,y)} U xs) vacia = ({(x,y)} U xs)
union {(x1,y1), ..., (xn, yn)} ys = {(x1,y1), ..., (xn, yn)} U {(x,y) | (x,y) <- ys, y no pertenece {y1, ..., yn}}
-}

-- Ejercicio 5
{-
tad BalT (a:Ordered Set) where
  import Maybe
  empty  :: BalT a
  join   :: BalT a -> Maybe a -> BalT a
  size   :: BalT a -> Int
  expose :: BalT a -> Maybe (BalT a, a, BalT a)

  join empty Nothing empty = empty
  join empty (Just v) empty = Node empty (Just v) empty
  join xs (Just v) ys = Node xs (Just v) ys

  size empty = 0
  size (Node xs v ys) = 1 + (max (size xs) (size ys))


-}

-- Ejercicio 6
zip_ :: [a] -> [b] -> [(a,b)]
zip_ [] ys = []
zip_ xs [] = []
zip_ (x:xs) (y:ys) = (x,y):(zip_ xs ys)

unzip_ :: [(a,b)] -> ([a], [b])
unzip_ [] = ([], [])
unzip_ ((x,y):zs) = (x:xs, y:ys)
    where
      (xs,ys) = unzip_ zs

{-
P : uncurry zip (unzip xs) = id xs

Caso Base:
uncurry zip (unzip []) = uncurry zip ([],[]) = zip [] [] = []
id [] = []

Caso Inductivo: Supongamos que vale para [(x1,y1), ..., (xn-1,yn-1)]
Veamos si vale para [(x1,y1), ..., (xn,yn)]

uncurry zip (unzip [(x1,y1), ..., (xn,yn)])
uncurry zip ([x1, ..., xn], [y1, ..., yn])
zip [x1, ...,xn] [y1, ..., yn]
[(x1,y1), ..., (xn,yn)]

id [(x1,y1), ..., (xn,yn)] = [(x1,y1), ..., (xn,yn)]
QED
-}

-- Ejercicio 7
maxL :: [Int] -> Int
maxL [] = 0
maxL (x:xs) = max x (maxL xs)

sumL :: [Int] -> Int
sumL [] = 0
sumL (x:xs) = x + (sumL xs)

{-
P : sumL xs <= (length xs) * (maxL xs)

Caso Base:
sumL [] = 0
(length []) * (maxL []) = 0

Caso inductivo: Supongamos que P vale para xs
Veamos si vale para x:xs

sumL (x:xs)
= x + sumL xs
{ HI }
<= x + ((length xs) * (maxL xs))
{ x <= max x (maxL xs) }
<= (max x (maxL xs)) + (length xs) * (maxL xs)
{ maxL xs <= max x (maxL xs) }
<= (max x (maxL xs)) + (length xs) * (max x (maxL xs))
<= max x (maxL xs) * (1 + lengtg xs)
<= max x (maxL xs) * (length (x:xs))
<= (maxL (x:xs)) * (length (x:xs))
QED
-}
-- Ejercicio 8
data Arbol a = Hoja a | Nodo a (Arbol a) (Arbol a)
               deriving Show

sizeA :: Arbol a -> Int
sizeA (Hoja _) = 1
sizeA (Nodo _ xs ys) = 1 + (sizeA xs) + (sizeA ys)

hojas :: Arbol a -> Int
hojas (Hoja _) = 1
hojas (Nodo _ xs ys) = (hojas xs) + (hojas ys)

altura :: Arbol a -> Int
altura (Hoja _) = 1
altura (Nodo _ xs ys) = 1 + (max (altura xs) (altura ys))

{-
P : (hojas t) < 2^(altura t)

Caso Base:
hojas (Hoja v) = 1
altura (Hoja v) = 1

Casp Inductivo: Realizamos induccion sobre la altura del arbol (h)
Supongamos que vale para un arbol de altura h => (hojas t) < 2^h

Veamos si vale para h + 1 (t'):

(hojas t') <= 2 * (hojas t)
           < 2 * (2^h)
           < 2^(h+1)
-}

-- Ejercicio 9

data AGTree a = Node a [AGTree a] deriving Show

ponerProfs :: Int -> AGTree a -> AGTree Int
ponerProfs n (Node x xs) = Node n (map (ponerProfs (n + 1)) xs)

alturaAGT :: AGTree a -> Int
alturaAGT (Node _ []) = 1
alturaAGT (Node _ xs) = 1 + (maximum (map alturaAGT xs))

maxAGT :: Ord a => AGTree a -> a
maxAGT (Node v []) = v
maxAGT (Node v xs) = let 
                        ys = map maxAGT xs
                        y = maximum ys
                     in max v y

{-
P : alturaAGT t = maxAGT (ponerProfs 1 t)

Caso Base:
alturaAGT (Node v []) = 1
maxAGT (ponerProfs 1 (Node v [])) = maxAGT (Node 1 (map (ponerProfs 2) [])) = maxAGT (Node 1 []) = 1

Caso Inductivo: Realizamos induccion sobre la altura del arbol (h)
Supongamos que P vale para [x1, ..., xn] de t@(Node v [x1, ..., xn])
Veamos si P vale para t:

maxAGT (ponerProfs 1 t) = maxAGT (ponerProfs 1 (Node v [x1, ..., xn]))
maxAGT (Node 1 (map (ponerProfs 2) [x1, ..., xn]))
maxAGT (Node 1 [ponerProfs 2 x1, ..., ponerProfs 2 xn])
<Demostrar Prop1>
maxAGT (Node 0 [ponerProfs 1 x1, ..., ponerProfs 1 xn]) + 1
(max 0 (maximum [maxAGT (ponerProfs 1 x1), ..., maxAGT (ponerProfs 1 xn)])) + 1
<HI>
(max 0 (maximum [alturaAGT x1, ..., alturaAGT xn])) + 1
max 0 (maximum (map alturaAGT [x1, ..., xn]))) + 1 = alturaAGT (Node v [x1, ..., xn])
-}

{-
Principio de Induccion de AGTree:
Dadas una propiedad $P$ sobre los elementos de `AGTree`, para probar $\forall xs::$ `AGTree`. $P(xs)$ vale:


Caso base: P(Node a [])

Caso inductivo: Si vale P([X1, X2, ..., Xn]) entonces vale para P(Node a [X1, X2, ..., Xn])
-}

-- Ejercicio 11
join_ :: [[a]] -> [a]
join_ [] = []
join_ (x:xs) = x ++ (join_ xs)

{-
P : join xs = concat (map id xs)

Caso Base:
join [] = []
concat (map id []) = concat [] = []

Caso Inductivo: Supongamos que vale para xs
Veamos si vale para (x:xs)

concat (map id (x:xs))
concat ((id x):(map is xs))
concat (x:xs)
x ++ (concat xs)
{ HI }
x ++ (join xs)
join (x:s)
QED
-}

{-
P : join (join xs) = join (map join xs)

Caso Base:
join (join []) = join [] = []
join (map join []) = join [] = []

Caso Inductivo: Supongamos que vale para xs
Veamos si vale para (x:xs)

join (map join (x:xs))
join ((join x):(map join xs))
(join x) ++ (join (map join xs))
{ HI }
(join x) ++ (join (join xs))
join ((join x):(join xs))
join (join (x:xs))
QED
-}

-- Ejercicio 13

-- type Rank = Int
-- data Heap a = E | N Rank a (Heap a) (Heap a)

-- merge :: Ord a => Heap a -> Heap a -> Heap a
-- merge xs E = xs
-- merge E ys = ys
-- merge xs@(N n1 _ x1 y1) ys@(N n2 _ x2 y2) = if n1 <= n2 then makeH n1 x1 (merge y1 ys)
--                           else makeH n2 x2 (merge xs y2)
-- rank :: Heap a -> Rank
-- rank E = 0
-- rank (N r _ _ _) = r

-- makeH n x y = if rank x > rank y then N (rank y + 1) n x y
--               else N (rank x + 1) n y x

{-
Queremsos demostrar que l1 y l2 son leftist heap, entonces merge l1 l2 es un leftist heap.

Lo veremos por induccion sobre l2:

Definimos nuestra hipotesis inductiva: Si l1, l2 son leftist heap, entonces `merge y1 l2` es un leftist heap (donde `l1 = N n1 x1 y1`) -> (H.I-1)

merge :: Ord a -> Heap a -> Heap a -> Heap a

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


Ahora demostremos el Lema-1:

Realizamos induccion sobre l1:

Definimos una hipotesis inductiva: Si l1, l2 son leftist heap, entonces `makeH n l1 l2` es un leftist heap (H.I)


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


De esta manera demostramos que si l1, l2 son L.H, entonces `merge l1 l2` es un L.H
-}
