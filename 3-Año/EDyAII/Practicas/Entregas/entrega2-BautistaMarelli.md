# Entrega Laboratorio 1 - Bautista Marelli

### Ejercicio 2
```haskell
-- b)
apply :: (a -> a) -> a -> a
apply f x = f x

-- i)
xor :: Bool -> Bool -> Bool
xor_ p q = (p || q) && not (p && q)

-- j)
max3 :: Int -> Int -> Int -> Int
max3 x y z = max x (max y z)
```

### Ejercicio 4
```haskell
(*$) :: [Int] -> Int -> [Int]
xs *$ y = [z * y | z <- xs]

v = [1, 2, 3] *$ 2 *$ 4
```
### Ejercicio 5
```haskell
-- c)
cuadruplas :: Int -> [(Int,Int,Int,Int)] cuadruplas n = [(a,b,c,d) | a <- [1..n],b <- [1..n],c <- [1..n],d <- [1..n], a^2 + b^2 == c^2 + d^2]
```

### Ejercicio 6
```haskell
scalarProduct :: Num a => [a] -> [a] -> a
scalarProduct xs ys = sum (map (\(x,y) -> x * y) (zip xs ys))
```

### Ejercicio 7
```haskell
-- b)
alguno :: [Bool] -> Bool
alguno [] = False
alguno (x:xs) = x || alguno xs

-- k)
masDe :: [[a]] -> Int -> [[a]]
masDe [] _ = []
masDe (x:xs) n | (length x > n) = x : masDe xs n
               | otherwise = masDe xs n
```
