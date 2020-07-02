# Practica 2 - EyAII

### Ejercicio 1
```haskell
-- a)
test :: (Eq a, Num a) => a -> a -> a -> Bool 
-- b)
esMenor :: Ord a => a -> a -> Bool 
-- c)
eq :: Eq a => a -> a -> Bool
-- d)
showVal :: Show a => a -> String
```

### Ejercicio 2
```haskell
-- a)
(+5) :: Num
-- b)
(0<) :: Ord
-- c)
('a':) :: Char
-- d)
(++ '/0') :: Char
-- e)
filter (== 7) :: Ord
-- f)
map (++[1]) :: Num
```

### Ejercicio 3
```haskell
-- a)
sumaNat :: (Int -> Int) -> Int
sumaNat a b = a + b
-- b)
sumaNat :: Int -> (Int -> Int)
-- c)
suma3 :: (Int -> Int) -> (Int -> Int)
-- d)
esPositivo :: Int -> Bool
-- e)
and :: Bool -> (Bool -> Bool)
-- f)
-- g)
sumaPar :: (Int, Int) -> Int
sumaPar (x,y) = x + y
-- h)
true :: a -> Bool
true _ = True
-- i)
triv :: a -> a
triv x = x
```

### Ejercicio 4
```haskell
-- a)
-- b)
-- c) Bien
False
-- d) Mal
and[1 < 2, 2 < 3]
-- e) Bien
1
-- f)
-- g)
```

### Ejercicio 5
```haskell
-- a)
f x = (x,x)
-- b)
greater (x,y) = x > y
-- c)
f (x, _) = x
```

### Ejercicio 6
```haskell
-- a)
smallest :: Ord a => a -> a -> a -> a
smallest = \x y z -> if (x <= y && x <= z) then x
                     else if (y <= x && y <= z) then y
                     else z
-- b)
second = \_ -> (\x -> x)
-- c)
andThen = \x y -> if x then y
                  else False
-- d)
twice = \f x -> f (f x)
-- e)
flip = \f x y -> f y x
-- f)
inc = \x -> x + 1
```

### Ejercicio 7
```haskell
-- a)
iff True y = not y
iff False = y
-- b)
alpha a = a
```

### Ejercicio 8
```haskell
f :: c -> d
g :: a -> b -> c

h :: a -> b -> d
h x y = f (g x y)
```

### Ejercicio 9
```haskell
zip3 :: [a] -> [a] -> [a] -> [(a,a,a)]
zip3 [] _ _ = []
zip3 _ [] _ = []
zip3 _ _ [] = []
zip3 xs ys zs = [(x, y, z) <- zip (zip (xs ys) zs)]

zip3rec :: [a] -> [a] -> [a] -> [(a,a,a)]
zip3rec [] _ _ = []
zip3rec _ [] _ = []
zip3rec _ _ [] = []
zip3rec (x:xs) (y:ys) z:zs = (x, y, z) : zip3rec xs ys zs
```

### Ejercicio 10
```haskell
-- a) Si xs es lista de listas
False
--b) 
False
-- c)
True
-- d)
True
-- e)
True
-- f)
False
-- g)
False
-- h)
True
-- i)
True
-- j)
True
```

### Ejercicio 11
```haskell
-- a)
modulus :: Floating a => [a] -> a
modulus xs = sqrt (sum (map \x -> x^2 xs))
-- b)
vmod :: Floating a => [[a]] -> [a]
vmod [] = []
vmod (x:xs) = modulus x : vmod xs
```

### Ejercicio 12
```haskell
-- a) suma binaria
type NumBin = [Bool]

incBin :: NumBin -> NumBin
incBin [] = [True]
incBin (x:xs) = if x then [False] : incBin xs else [True] : xs

sumaBin :: NumBin -> NumBin -> NumBin
sumaBin xs [] = xs
sumaBin [] ys = ys
sumaBin (x:xs) (y:ys) = if x && y then False : incBin (sumaBin xs ys)
                    else x || y : sumaBin xs ys

prodBin :: NumBin -> NumBin -> NumBin
prodBin _ [] = []
prodBin [] _ = []
prodBin _ [False] = [False]
prodBin xs [True] = xs
prodBin xs False:ys = prodBin

div2 :: NumBin -> NumBin
div2 [] = []
div2 
```

### Ejercicio 13
```haskell
-- a)
divisor :: Num a => a -> [a]
divisor x | x < 0 = []
          | otherwise = [y | y <- [1..x], (mod x y) == 0]

matches :: Eq a => a -> [a] -> [a]
matches _ [] = []
matches x xs = [y | y <- xs, x == y]

_in :: Eq a => a -> [a] -> Bool
_in _ [] = False
_in x xs = or [x == y | y <- xs]

unique :: Num a => [a] -> [a]
unique [] = []
unique (x:xs) = if (_in_ x xs) then unique xs
              else x:unique xs

```

### Ejercicio 14
```haskell
scalarProduct :: Num a => [a] -> [a] -> a
scalarProduct _ [] = 0
scalarProduct [] _ = 0
scalarProduct xs ys = sum (map (\(x,y) -> x * y) 
(zip xs ys))
```
