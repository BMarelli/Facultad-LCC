--  Practica 3 - EyAII
type Color = (Int, Int, Int)

mezclar :: Color -> Color -> Color
mezclar (x,y,z) (a,b,c) = (div (x+a) 2, div (y+b) 2, div (z+c) 2)

-- Ejercicio 2
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
insertar c (xs, n) = ((take n xs)++[c]++(drop n xs), n)

--  Ejercicio 3
data CList a = Empty | CUnit a | Consnoc a (CList a) a
               deriving Show

headCL :: CList a -> a
headCL Empty = error "Invalid"
headCL (CUnit v) = v
headCL (Consnoc v _ _) = v

tailCL :: CList a -> CList a
tailCL Empty = error "Invalid"
tailCL (CUnit v) = Empty
tailCL (Consnoc _ xs v) = case xs of
                            Empty -> CUnit v
                            CUnit x -> Consnoc x Empty v
                            otherwise -> Consnoc (headCL xs) (tailCL xs) v

lastCL :: CList a -> a
lastCL Empty = error "Invalid"
lastCL (CUnit v) = v
lastCL (Consnoc _ _ y) = y  

isEmpty :: CList a -> Bool
isEmpty Empty = True
isEmpty _ = False

isUnit :: CList a -> Bool
isUnit (CUnit _) = True
isUnit _ = False

reverseCL :: CList a -> CList a
reverseCL (Consnoc x xs y) = Consnoc y (reverseCL xs) y
reverseCL xs = xs

snocCL :: a -> CList a -> CList a
snocCL v Empty = CUnit v
snocCL v (CUnit x) = Consnoc x Empty v
snocCL v (Consnoc x xs y) = Consnoc x (snocCL y xs) v

delHeadCL :: CList a -> CList a
delHeadCL (Consnoc x xs y) = Consnoc (headCL xs) (tailCL xs) y
delHeadCL _ = Empty

delLastCL :: CList a -> CList a
delLastCL (Consnoc x xs y) = case xs of
                                Empty -> CUnit x
                                CUnit v -> Consnoc x Empty v
                                otherwise -> Consnoc x (delLastCL xs) (lastCL xs)
delLastCL _ = Empty

inits :: CList a -> CList (CList a)
inits Empty = CUnit Empty
inits (CUnit x) = Consnoc Empty Empty (CUnit x) -- [[], [x]]
inits xs = snocCL xs (inits (delLastCL xs))

concatCL :: CList (CList a) -> CList a
concatCL Empty = Empty
concatCL (CUnit xs) = xs
concatCL (Consnoc xs zss ys) = xs +++ (concatCL zss) +++ ys
    where
      (+++) :: CList a -> CList a -> CList a
      (+++) xs Empty = xs
      (+++) Empty ys = ys
      (+++) (CUnit v) ys = Consnoc v (delLastCL ys) (lastCL ys)
      (+++) xs ys = Consnoc (headCL xs) ((tailCL xs) +++ (delLastCL ys)) (lastCL ys)

-- TODO: Ejercicio 4 - 5

-- Ejercicio 6
data GenTree a = EmptyG | NodeG a [GenTree a] deriving Show
data BinTree a = EmptyB | NodeB (BinTree a) a (BinTree a) deriving Show

g2bt :: GenTree a -> BinTree a
g2bt EmptyG = EmptyB
g2bt (NodeG v xs) = NodeB (g2bt_ xs) v EmptyB
    where
      g2bt_ :: [GenTree a] -> BinTree a
      g2bt_ [] = EmptyB
      g2bt_ ((NodeG y ys):zs) = NodeB (g2bt_ ys) y (g2bt_ zs)

-- Ejercicio 7

maximumBST :: Ord a => BinTree a -> a
maximumBST EmptyB = error "Invalid"
maximumBST (NodeB xs v ys) = case ys of
                          EmptyB -> v
                          otherwise -> maximumBST ys

minimumBST :: Ord a => BinTree a -> a
minimumBST EmptyB = error "Invalid"
minimumBST (NodeB xs v ys) = case ys of
                                EmptyB -> v
                                otherwise -> minimumBST xs

chechBST :: Ord a => BinTree a -> Bool
chechBST EmptyB = True
chechBST (NodeB EmptyB _ EmptyB) = True
chechBST (NodeB EmptyB v ys) = (v < maximumBST ys) && (chechBST ys)
chechBST (NodeB xs v EmptyB) = (minimumBST xs < v) && (chechBST xs)
chechBST (NodeB xs v ys) = let (min, max) = (minimumBST xs, maximumBST ys)
                          in (min < v) && (v < max) && (chechBST xs) && (chechBST ys)

-- Ejercicio 8
member :: Ord a => a -> BinTree a -> Bool
member _ EmptyB = False
member v t@(NodeB xs x ys) = member' t x
    where
      member' EmptyB y = v == y
      member' (NodeB l z r) y = if v > z then member' r y
                               else member' l z
