data Tree a = E | L a | N (Tree a) (Tree a) deriving Show

inorder :: Tree a -> [a]
inorder E = []
inorder (L v) = [v]
inorder (N xs ys) = inorder xs ++ inorder ys 

sufijos :: Tree Int -> Tree (Tree Int)
sufijos t = sufijos_ t E
      where
        sufijos_ E _             = L E
        sufijos_ (L _) zs        = L zs
        sufijos_ (N xs ys) zs    = let (l, r) = case zs of
                                                      E -> (sufijos_ xs ys, sufijos_ ys E)
                                                      _ -> (sufijos_ xs (N ys zs), sufijos_ ys zs)
                                      in N l r

prefijos :: Tree Int -> Tree (Tree Int)
prefijos t = prefijos_ t E
      where
        prefijos_ E _             = L E
        prefijos_ (L _) zs        = L zs
        prefijos_ (N xs ys) zs    = let (l, r) = case zs of
                                                      E -> (prefijos_ xs E, prefijos_ ys xs)
                                                      _ -> (prefijos_ xs zs, prefijos_ ys (N xs zs))
                                    in N l r

separar :: Tree Int -> Tree (Tree Int, Int, Tree Int)
separar E = E
separar t = let prjs = prefijos t
                sfjs = sufijos t
            in unir t prjs sfjs
    where
      unir (L v) (L p) (L s) = L (p, v, s)
      unir (N xs ys) (N ps ps') (N ss ss') = let (l, r) = (unir xs ps ss, unir ys ps' ss')
                                             in N l r

mayor :: Int -> Tree Int -> Bool
mayor _ E = False
mayor v (L v') = v > v'
mayor v (N xs ys) = let (l, r) = (mayor v xs, mayor v ys)
                    in l || r

menor :: Int -> Tree Int -> Bool
menor _ E = False
menor v (L v') = v < v'
menor v (N xs ys) = let (l, r) = (menor v xs, menor v ys)
                    in l || r

addInfo :: Tree Int -> Tree (Bool, Int, Bool)
addInfo t = let tps = separar t
            in comparar tps
    where
      comparar :: Tree (Tree Int, Int, Tree Int) -> Tree (Bool, Int, Bool)
      comparar E = E
      comparar (L (ps, v, ss)) = L (mayor v ps, v, menor v ss)
      comparar (N xs ys) = let (l, r) = (comparar xs, comparar ys)
                           in N l r

-- Otra forma con mapreduce
mapreduceT :: (a -> b) -> (b -> b -> b) -> b -> Tree a -> b
mapreduceT _ _ e E = e
mapreduceT f g e (L v) = g e (f v)
mapreduceT f g e (N xs ys) = let (l, r) = (mapreduceT f g e xs, mapreduceT f g e ys)
                                 in g l r

addInfo2 :: Tree Int -> Tree (Bool, Int, Bool)
addInfo2 t = let tps = separar t
            in comparar tps
    where
      comparar E = E
      comparar (L (ps, v, ss)) = L (mapreduceT (< v) (||) False ps, v,  mapreduceT (> v) (||) False ss)
      comparar (N xs ys) = let (l, r) = (comparar xs, comparar ys)
                           in N l r

-- Ejercicio TAD
{-
esVertice v (nuevo []) = False
esVertice v (nuevo [x1, ..., xn]) = if v in [x1, ..., xn] else False
esVertice v (nuevoLado (v1, v2) b) = esVertice v b

esLado (v, w) (nuevo xs) = False
esLado (v, w) (nuevoLado (v, w) b) = True
esLado (v, w) (nuevoLado (w, v) b) = True
esLado (v, w) (nuevoLado (v1, v2) b) = esLado (v, w) b

P: Si elem x xs => esVertice x (nuevo xs)
Caso Base: xs = []
elem x xs = False
esVertice v (nuevo []) = False

Caso inductivo: Supongamos que vale para [x1, ..., xn-1], veamos si vale para [x1, ..., xn]

-}

data GTree a = Node a [GTree a]
type Bosque a = [GTree a]

nuevo :: [a] -> Bosque a
nuevo = map (`Node` [])

isVertex :: Eq a => a -> GTree a -> Bool
isVertex v (Node v' []) = v == v'
isVertex v (Node v' xs) = (v == v') || or (map (isVertex v) xs)

esVertice :: Eq a => a -> Bosque a -> Bool
esVertice v xs = or(map (isVertex v) xs)

