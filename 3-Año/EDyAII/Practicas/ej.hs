data GTree a = Node a [GTree a] deriving Show
type Bosque a = [GTree a]

esVertice :: Eq a => a -> Bosque a -> Bool
esVertice _ [] = False
esVertice v ((Node w xs):as) = v == w || esVertice v xs || esVertice v as

esLado :: Eq a => (a, a) -> Bosque a -> Bool
esLado _ [] = False
esLado (v, w) ((Node x xs):as) | v == x = any (\(Node y _) -> w == y) xs
                               | w == x = any (\(Node y _) -> v == y) xs
                               | otherwise = esLado (v, w) as

esCamino :: Eq a => (a, a) -> Bosque a -> Bool
esCamino _ [] = False
esCamino (v, w) ((Node x xs):as) | v == x    = esVertice w xs
                                 | w == x    = esVertice v xs
                                 | otherwise = esCamino (v, w) as

-- nuevoLado :: Eq a => (a, a) -> Bosque a -> Bosque a
-- nuevoLado _ [] = []
-- nuevoLado (v, w) b@((Node x xs):as) | v == x    = if esVertice w xs then b else (Node x ((Node w []):xs)):as
--                                     | w == x    = if esVertice v xs then b else (Node x ((Node v []):xs)):as
--                                     | otherwise = nuevoLado (v, w) as
nuevoLado :: Eq a => (a, a) -> Bosque a -> Bosque a
nuevoLado _ [] = []
nuevoLado (v, w) b = if esCamino (v, w) b then b 
                     else 

bs = [(Node 1 [(Node 2 []), (Node 3 [])]), (Node 5 [(Node 6 [(Node 7 [])]), (Node 8 [])])]
