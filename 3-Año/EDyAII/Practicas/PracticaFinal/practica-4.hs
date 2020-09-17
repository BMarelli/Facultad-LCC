-- Ejercicio 1
{-
Especificacion Algebraica
null nil = True
null (cons x xs) = False

head (cons x xs) = x

tail nil = nil
tail (cons x xs) = xs

Especificacion con Modelos: Secuencias
nil = <>
cons x <> = <x>
cons x <x1, ..., xn> = <x, x1, ..., xn>

null <> = True
null <x1, ..., xn> = False

head <x1, ..., xn> = x1

tail <> = <>
tail <x1> = <>
tail <x1, ..., xn> = <x2, ..., xn>

inL v nil = False
inL v (cons x xs) = if v == x then True else inL v xs

inL xk <x1, ..., xn> = if k \in [1,.., n] then True else False
-}

-- Ejercicio 2
{-
Especificacion Algebraica:
isEmpty empty = True
isEmpty (push x xs) = False

top (push x empty) = x
top (push x xs) = x

pop empty = empty
pop (cons x xs) = xs

Especificacion con Modelos: Secuencias
isEmpty <> = True
isEmpty <x1, ..., xn> = False

top <x1, ..., xn> = x1

pop <> = <>
pop <x1, ..., xn> = <x2, ..., xn>
-}

-- Ejercicio 3
{-
Especificacion Algebraica:
insertar x (insertar x xs) = (insertar x xs)
insertar y (insertar x xs) = insertar x (insertar y xs)

borrar x vacio = vacio
borrar x (insertar y xs) = if x == y then xs else (insertar x xs)

esVacio vacio = True
esVacio (insertar x xs) = False

union xs vacio = xs
union vacio ys = ys
union (insertar x xs) ys = insertar x (union xs ys)

interseccion xs vacio = vacio
interseccion vacio ys = vacio
interseccion (insertar x xs) (insertar y ys) = union (insertar x vacio) (interseccion xs (insertar y ys)) 
                                               if x in (insertar y ys))

resta xs vacio = xs
resta vacio ys = vacio
resta (insertar x xs) ys = borrar x (resta xs ys)

choose (insertar x xs) = x
choose (insertar x (insertar y xs)) = x  |
choose (insertar y (insertar y ys)) = y  | => insertar x (insertar y xs) = insertar y (insertar x xs)
-}

-- Ejercicio 4
{-
poner k v (poner k v' xs) = poner k v xs

primero (poner k v vacio) = v
primero (poner k v (poner k' v' xs)) = if k < k' then primero (poner k' v' xs)
                                       else primero (poner k v xs)

sacar vacia = vacia
sacar (poner k v vacia) = vacia
sacar (poner k v (poner k' v' xs)) = if k < k' then poner k v (sacar (poner k' v' xs))
                                     else if k > k' then poner k' v' (sacar (poner k v xs))
                                          else sacar (poner k v xs)

esVacia vacia = True
esVacia (poner k v xs) = False

union xs vacia = xs
union vacia ys = ys
union (poner k v xs) ys = poner k v (union xs ys)   { Por la definicon de poner }
-}

-- Ejericicio 5
{-
size empty = 0
size (join xs v ys) = if v == Just x then 1 + (size xs) + (size ys)
                      else (size xs) + (size ys)

expose empty = Nothing

expose (join xs (Just v) ys) = Just (xs, v, ys)
-}
