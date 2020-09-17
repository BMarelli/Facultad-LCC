import Seq
import ArrSeq
import qualified Arr as A

data BTree a = E | L a | N Int (BTree a) (BTree a)
             deriving Show

t = (N 5 (N 3 (N 2 (L "a") (L "b")) (L "c")) (N 2 (L "d") (L "e")))
t1 = (N 7 (N 4 (N 3 (L "A") (N 2 (L "b") (L "c"))) (L "d")) (N 3 (L "e") (N 2 (N 1 E (L "g")) (L "H"))))

inorder :: BTree a -> [a]
inorder E = []
inorder (L x) = [x]
inorder (N _ l r) = (inorder l) ++ (inorder r)

size :: BTree a -> Int
size E = 0
size (L _) = 1
size (N n _ _) = n

mapindex :: (a -> Int -> b) -> BTree a -> BTree b
mapindex f xs = mapindex_ f xs 0
    where
      mapindex_ _ E _ = E
      mapindex_ f (L v) i = L (f v i)
      mapindex_ f (N n ys zs) i = let
                                    (l, r) = (mapindex_ f ys i, mapindex_ f zs (i + (size ys)))
                                  in N n l r

fromSlow :: Int -> Int -> Int -> BTree Int
fromSlow n m k = mapindex (\x i -> x + (div i k)) (generarSecuencia n m)
    where
      generarSecuencia _ 0 = E
      generarSecuencia n 1 = L n
      generarSecuencia n m = let
                              m' = div m 2
                              (xs, ys) = (generarSecuencia n (m - m'), generarSecuencia n m')
                            in N m xs ys
type Peso = Int
type Hora = [Char]

alarma :: Seq s => s (Peso, Hora) -> Peso -> Maybe Hora
alarma xs x = let
                (ys, y) = scanS f (0, "0") xs
              in if ((fst y) >= x) then Just (snd y)
                 else Nothing
    where
      f t1 t2 = if (fst t1) >= x then ((fst t1) + (fst t2), snd t1)
                else ((fst t1) + (fst t2), snd t2)

{-
data GTree a = Node a [GTree a]

P(t) : elem n (allNodes t) == isNode n t

Asumimos que vale para todo GTree que pertenece in [GTree]

Veamos ahora si vale para (Node a [GTree a])

elem n (allNodes (Node v [GTree a])) = ele n (v : concatMap allNodes [GTree a]) 
elem n (v : concat(map allNodes [x1, ..., xn]))
elem n (v : concat [allNodes x1, ..., allNodes xn])
elem n (concat [[v], allNodes x1, ..., allNodes xn])
(Prop elem x (concat xss) = or (map (elem x) xss))
or (map (elem n) [[v], allNodes x1, ..., allNodes xn])
or ([elem n [v], elem n allNodes x1, ..., elem n allNodes xn])
(HI)
n == v || or [isNode n x1, ..., isNode n xn]
n == v || or (map (isNode n) [x1, ..., xn]) = isNode n (Node v [x1, ...,xn])
-}


{-
elem n (allNodes (Node v [GTree a])) = ele n (v : concatMap allNodes [GTree a]) 
elem n (v : concat(map allNodes [x1, ..., xn]))
elem n (v : concat(allNodes x1 : (map allNodes [x2,...,xn])))
elem n (concat ([v] : [allNodes x1]))
-}
