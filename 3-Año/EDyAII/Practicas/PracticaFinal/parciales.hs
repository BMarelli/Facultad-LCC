type Bag a = [a]

{-
size vacio = 0
size (insertar x vacio) = 1
size (insertar x xs) = 1 + (size xs)
resta vacio vacio = 0
resta vacio xs = vacio
resta xs vacio = xs
resta (x:xs) ys = if (pertenece x ys) then (resta xs ys) else (insertar x (resta xs ys))
-}

insertar :: Eq a => a -> Bag (a, Int) -> Bag (a, Int)
insertar x [] = [(x, 1)]
insertar x (y:ys) = if x == (fst y) then (x, (snd y) + 1) : ys
                    else y : (insertar x ys)

borrar :: Eq a => a -> Bag (a, Int) -> Bag (a, Int)
borrar _ [] = []
borrar x (y:ys) = if x == (fst y) then (if (snd y) == 1 then ys else ((x, (snd y) - 1) : ys))
                  else y : (borrar x ys)

union :: Eq a => Bag (a, Int) -> Bag (a, Int) -> Bag (a, Int)
union xs [] = xs
union [] xs = xs
union (x:xs) b2@(y:ys) = if (fst x) == (fst y) then ((fst x, (snd x) + (snd y)) : (union xs ys))
                         else (x : (union xs b2))

pertenece :: Eq a => a -> Bag (a, Int) -> Bool
pertenece _ [] = False
pertenece x xs = any (\(v, _) -> x == v) xs

interseccion :: Eq a => Bag (a, Int) -> Bag (a, Int) -> Bag (a, Int)
interseccion xs ys = [x | x <- xs, pertenece x ys]

{-

-}
