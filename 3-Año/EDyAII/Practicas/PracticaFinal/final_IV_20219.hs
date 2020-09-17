import Seq
import Par
import ArrSeq
import qualified Arr as A

{-
delVertex null v = null
delVertex (addEdge g (w, z)) v = addEdge (delVertex g v) (w,z)
delVertex (addEdge g (v, z)) v = delVertex g v
delVertex (addEdge g (w, v)) v = delVertex g v
delVertex (addVertex g w) v = addVertex (delVertex g v) w
delVertex (addVertex g v) v = g

adyacent null v w = false
adyacent (addVertex g z) v w = adyacent g v w
adyacent (addEdge g (y, z)) v w = if (v == y && w == z) || (v == z && w == y) then true
                                  else adyacent g v w

neightboors null v = 0
neightboors (addVertex g w) v = neightboors g v
neightboors (addEdge g (w, z)) v = if v == w || v == z then 1 + neightboors g v
                                   else neightboors g v

isPath null v w = false
isPath (addVertex g z) v w = isPath g v w
isPath (addEdge g (y, z)) v w = if (v == y && w == z) || (v == z && w == y) then true && isPath g v w
                                else isPath g v w
-}

data Bit = Zero | One deriving (Eq, Show)
type Vertex = Int
type Graph = [[Bit]]


delEdge :: Graph -> (Vertex, Vertex) -> Graph
delEdge xs (v, w) = delEdge_ xs (v, w) 0
    where
      replace :: [Bit] -> Bit -> Vertex -> [Bit]
      replace [] _ _ = []
      replace (_:ys) v 0 = v:ys
      replace (y:ys) v i = y : (replace ys v (i - 1))
      delEdge_ :: Graph -> (Vertex, Vertex) -> Int -> Graph
      delEdge_ [] _ _ = []
      delEdge_ (y:ys) (v, w) i | v == i         = (replace y Zero w) : (delEdge_ ys (v, w) (i + 1))
                               | w == i         = (replace y Zero v) : (delEdge_ ys (v, w) (i + 1))
                               | otherwise      = y : (delEdge_ ys (v, w) (i + 1))

neightboors :: Graph -> Vertex -> [Vertex]
neightboors g v = let
                    xs = g !! v
                    ys = allOneIndex xs 0
                  in ys
    where
      allOneIndex :: [Bit]  -> Int -> [Vertex]
      allOneIndex [] _ = []
      allOneIndex (One:zs) i = i : (allOneIndex zs (i + 1))
      allOneIndex (_:zs) i = allOneIndex zs (i + 1)

adyacent :: Graph -> Vertex -> Vertex -> Bool
adyacent [] _ _ = False
adyacent g v w = let
                    xs = g !! v
                 in (xs !! w) == One

-- Ejercicio 3
data Cadena = E | L Char | N Cadena Cadena deriving Show

cs = N (N (N (L 'a') (L 'b')) E) (N (L 'a') (N (L 'b') (L 'a')))

inorder :: Cadena -> [Char]
inorder E = []
inorder (L v) = [v]
inorder (N xs ys) = let (l, r) = inorder xs ||| inorder ys
                    in l ++ r
merge :: Cadena -> Cadena -> Cadena
merge E x = x
merge x E = x
merge x y = N x y

fromList' :: [Char] -> Cadena
fromList' [] = E
fromList' [x] = L x
fromList' xs = let n = length xs 
                   k = div n 2
               in merge (fromList' (take k xs)) (fromList' (drop k xs))

sizeC :: Cadena -> Int
sizeC E = 0
sizeC (L _) = 1
sizeC (N xs ys) = let (l, r) = sizeC xs ||| sizeC ys
                  in l + r

nthC :: Cadena -> Int -> Char
nthC E _ = error "Invalid"
nthC (L v) i = if i == 0 then v else error "Invalid"
nthC (N xs ys) i | i < x      = nthC xs i
                 | otherwise  = nthC ys (i - x)
                 
    where
      x = sizeC xs

palindromo :: Cadena -> Bool
palindromo xs = let
                  len = (sizeC xs)
                  m = div len 2
                  ys = tabulateS (\i -> (nthC xs i) == (nthC xs (len - i - 1))) m
                in reduceS (&&) True (ys :: A.Arr Bool)

crear :: Int -> (Int -> Char) -> Cadena
crear n f = crear_ (n + 2) (\i -> if i == 0 || i == (n + 1) then '*' else f i) 0
    where
      crear_ 0 f _ = E
      crear_ 1 f i = L (f i)
      crear_ n f i = let
                        m = div n 2 
                        (l, r) = crear_ m f i ||| crear_ (n - m) f (i + m)
                     in N l r

f :: Int -> Char
f i = xs !! i
    where
      xs = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
