import Control.Applicative (Applicative (..))
import Control.Monad (liftM ,ap)
import Data.Maybe

{- FINAL SANTI -}

{-

-- Ejercicio 3

(b)
Sea t termino, t:T y t -> t' => t':T
P(t): t:T y t->t' => t':T

- Caso t = 0:
  Como t es un valor => No Existe t' / t->t' => Vale (no se cumple premisa)
- Caso t = nil:
  Como t es un valor => No Existe t' / t->t' => Vale (no se cumple premisa)

- Caso t = suc t1
  Como no existe una regla de evaluacion para el caso suc => No existe t' / t->t' => Vale (no se cumple premisa)

- Caso t = cons t1 t2 
  Como t:[Nat] => t1:Nat, t2:[Nat]. Si aplicamos E-Cons, tenemos que t1=nv y Existe t2' / t2->t2'.
  Por HI tenemos que t2':[Nat].
  Luego por T-Cons resulta que t=cons t1 t2' : [Nat]

- Caso t = append t1 t2
  Como t:[Nat] => t1:[Nat], t2:[Nat]
   * Si aplico E-Append0, tenemos que t1=nil y t=t2. Como t2:[Nat], Vale
   * Si aplico E-Append1, tenemos que t1=cons nv t1' y tenemos que t'=cons nv (append t1' t2).
     Por HI, T-Append y T-Cons, tenemos que (append t1' t2):[Nat] y t':[Nat]
   * Si aplico E-Append2, tenemos que Existe t1' / t1->t1', t'=append t1' t2.
     Por HI y T-Append, tenemos que t1':[Nat] y t':[Nat]

(c)
t := ... | true | false | t v t | t == t | elem t t
v := ... | true | false
T := ... | Bool

Extendemos el sistema de Tipos:
true: Bool (T-True)
false: Bool (T-False)

t1:Bool t2:Bool
--------------- (T-Or)
    t1 v t2

t1:Nat t2:Nat
--------------- (T-Eq)
    t1 == t2

t1:Nat t2:[Nat]
--------------- (T-Elem)
   elem t1 t2

Extendemos el sistema de Evaluancion:

true v t -> true (E-Or1)
false v t -> t (E-Or2)

        t1->t1'
----------------------- (E-Or3)
  t1 v t2 -> t1' v t2

    nv1 === nv2
-------------------- (E-Eq1)
 nv1 == nv2 -> true

    nv1 =/= nv2
--------------------- (E-Eq2)
 nv1 == nv2 -> false

    t -> t'
----------------------- (E-Eq3)
 nv == t -> nv == t'   

        t1 -> t1'
----------------------- (E-Eq4)
 t1 == t2 -> t1' == t2   

elem nv nil -> false (E-Elem1)

      nv === x
---------------------------- (E-Elem2)
elem nv (cons x xs) -> true

      nv =/= x
-------------------------------- (E-Elem3)
elem nv (cons x xs) -> elem nv xs

      t1 -> nv
-------------------------------- (E-Elem4)
elem t1 t2 -> elem nv t2

      t -> xs
-------------------------------- (E-Elem4)
elem nv t -> elem nv xs

-}

-- Ejercicio 10
{-

Nat = \forall X. (X -> X) -> X -> X
Pair X Y = \forall Z . (X -> Y -> Z) -> Z
List X = \forall Y. (X -> Y -> Y) -> Y -> Y

zipLen :: [a] -> [(a, Int)]
zipLen [] = []
zipLen (x:xs) = (x, length xs):(zipLen xs)

-- zipLen foldr
foldr f e [] = e
foldr f e (x:xs) = (f x e) : (foldr f e xs)

zipLen xs = foldr (\y r -> (y, length r):r) [] xs

-- zipLen lambda no tipdado
zipLen = \xs. xs (\y r . cons (pair y (length r)) r) nil

-- zipLen lambda tipado
zipLen : \forall X. List X -> List (Pair X Nat)
zipLen = /\X . \xs:List X .
  xs<List (Pair X Nat)>
  (\y:X . \r:List (Pair X Nat) . cons<Pair X Nat> (pair<X><Nat> y (length<Pair X Nat> r)) r)
  nil<List (Pair X Nat)>

length = /\X . \xs:List X . xs (\y:X \r:Nat. suc<Nat> r) zero

-- zip
zip' :: [a] -> [b] -> [(a,b)]
zip' xs ys = foldr (\y r s -> if isNil s then [] else (y,head s):(r (tail s))) (const []) xs ys
    where
      isNil [] = True
      isNil _ = False


zip = \xs ys . xs (\y r s. (isNil s) nil (cons (pair y, head s) (r (tail s)))) (\ss -> nil) ys

zip : \forall X. \forall Y. List X -> List Y -> List (Pair X Y)
zip = /\X. /\Y. \xs:List X. \ys:List Y.
  xs<List Y -> List (Pair X Y)>
  (\y:X. \r:List Y -> List (Pair X Y). \s:List Y. (isNil s) nil<> (cons<> (pair<X><Y> y (head<> s)) (tail<> s)))
  (\ss:List Y. nil<>)
  ys
-}


-- Ejercicio 5
set :: Monad m => s -> MEstado m s ()
set s = Es (\_ -> return ((),s))

{- 
get :: Monad m => MEstado m s s
get = Es (\s -> return (s,s))
-}

fail' :: Parser a
fail' = Es (\_ -> Nothing)

item :: Parser Char
item = do ss <- get
          case ss of
             [] -> fail'
             (x:xs) -> set xs >> return x

{-
tail :: [a] -> [a]
tail xs = fst (tail' xs ([],[]))
    where
      tail' xs e = foldr (\y r -> (snd r, y:(snd r))) e xs

-- tail lambda no tipado
zz = pair nil nil
tail = \xs . fst (tail' xs zz)
tail' = \xs e . xs (\y r . (snd r, y:(snd r))) e

-- tail lambda tipado
zz : \forall X. Pair (List X) (List X)
zz = /\X. pair<List X><List X> (nil<X>) (nil<X>)
tail : \forall X . List X -> List X
tail = /\X. \xs:List X. tail'<X> xs zz
tail' : \forall X. List X -> Pair (List X) (List X) -> Pair (List X) (List X)
tail' = /\X. \xs:List X. \zz:Pair (List X) (List X).
         xs<Pair (List X) (List X)>
         (\y:X. \r:Pair (List X) (List X). pair<List X><List X> (snd<List X><List X> r) (cons<X> y (snd<List X><List X> r)))
         zz<X>

insert :: (a -> a -> Bool) -> [a] -> a -> [a]
insert f [] v = [v]
insert f (x:xs) v = if f v x then v:x:xs else x:(insert f xs v)

insert f xs v = foldr (\y r -> if f v y then v:y:r else y:r) [v] xs

insert : \forall X. (X -> X -> Bool) -> List X -> X -> List X

-}

{- FINAL DELFI -}

-- Ejercicio 1
{-

Sea t termino, t:T y t -> t' => t':T
P(t): t:T y t->t' => t':T

- Caso t=0 o t=empty:
  Como t es un valor => No Existe t' / t->t' => Vale (no se cumple premisa)

- Caso t=suc t1:
  Como no existe una regla de evaluacion para el caso suc => No existe t' / t->t' => Vale (no se cumple premisa)

- Caso t=insert t1 t2:
  Sabemos t:{Nat}, t1:{Nat} y t2:{Nat}. Si aplicamos E-Insert tenemos que t1=nv y existe t2' / t2->t2'.
  Por HI, t2:{Nat} y por T-Insert t'=insert t1 t2':{Nat}

- Caso t=t1 union t2:
  Sabemos t:{Nat}, t1:{Nat}, t2:{Nat}.
   * Si aplicamos E-Union0, tenemos que t1=empty y t'=t2 => t':{Nat}
   * Si aplicamos E-Union1, tenemos que t1=insert nv t1' => t'=insert nv (t1' union t2)
     Por HI, t1' union t2:{Nat} y por T-Insert y T-Union, t':{Nat}
   * Si aplicamos E-Union2, tenemos que existe t1' / t1->t1', t'=t1' union t2.
     Por HI, t1':{Nat} y por T-Union t':{Nat}

-}

-- Ejercicio 2

newtype MEstado m s a = Es { runSt :: s -> m (a, s)}

instance Monad m => Monad (MEstado m s) where
  return x = Es (\s -> return (x, s))
  (Es h) >>= f = Es (\s -> do (x, s') <- h s
                              runSt (f x) s')

instance Monad m => Functor (MEstado m s)  where
  fmap = liftM

instance Monad m => Applicative (MEstado m s) where
  pure = return
  (<*>) = ap

update :: Monad m => (s -> s) -> MEstado m s ()
update f = Es (\s -> return ((), f s))

get :: Monad m => MEstado m s s
get = Es (\s -> return (s, s))

type Parser a = MEstado Maybe String a

(<+>) :: Parser a -> Parser a -> Parser a
(<+>) p q = Es (\s -> do case runSt p s of
                            Nothing -> case runSt q s of
                                          Nothing -> Nothing 
                                          (Just s') -> Just s'
                            (Just s') -> Just s')

many :: Parser a -> Parser [a]
many p =  many1 p <+> return []
many1 :: Parser a -> Parser [a]
many1 p =  do v <- p
              vs <- many p
              return (v:vs)

separator :: Parser a -> Parser b -> Parser ([a], [b])
separator p sep = do xs <- many p
                     y <- sep
                     (xs', ys) <- separator p sep
                     return (xs++xs', y:ys)
                  <+>
                  do xs <- many p
                     return (xs, [])



parse :: Parser a -> String -> Maybe (a,String)
parse p inp = runSt p inp                     

failure                       :: Parser a
failure                       =  Es (\_ -> Nothing)

sat :: (Char -> Bool) -> Parser Char
sat p =  do x <- item
            if p x then return x else failure

char :: Char -> Parser Char
char x =  sat (== x)


-- Ejercicio 3
{-

Nat = \forall X. (X -> X) -> X -> X
Pair X Y = \forall Z . (X -> Y -> Z) -> Z
List X = \forall Y. (X -> Y -> Y) -> Y -> Y

(a)
foldr f e [] = e
foldr f e (x:xs) = (f x e) : (foldr f e xs)

length :: [a] -> Int
length [] = 0
length (x:xs) = 1 + (length xs)
-- length foldr
length = foldr (\_ r -> r + 1) 0
-- length lambda no tipado
length = \xs . xs (\y r . suc r) zero

length : \forall X . List X -> Nat
length = /\X . \xs : List X . xs<Nat> (\y:X. \r:Nat . suc r) zero


indexed :: [a] -> [(a, Int)]
indexed xs = indexed' xs (length xs)
    where
      indexed' [] _ = []
      indexed' (x:xs) n = let i = n - (length xs) - 1
                          in (x, i):(indexed' xs n)

-- indexed foldr
indexed xs = indexed' xs (length xs)
    where
      indexed' xs n = foldr (\y r -> (n - (length r) - 1, y):r) [] xs


-- indexed lambda no tipado
indexed = \xs . indexed' xs zero
indexed' = \xs . \n . xs (\y r . cons (pair (n-(length r)-1) y) r) nil 

-- indexed lambda tipado
indexed : \forall X. List X -> List (Pair Nat X)
indexed = /\X . \xs : List X . indexed' xs (length<X> xs)

indexed' : \forall X . List X -> Nat -> List (Pair Nat X)
indexed' = /\X . \xs:List X . \n:Nat .
  xs<Pair Nat X>
    (\y:X. \r:(List (Pair Nat X)). cons<Pair Nat X> (pair<Nat><X> (n-(length<Pair Nat X> r)-1) y))
    nil<Pair Nat X>

-}

{-
zipTail :: [a] -> [(a, [a])]
zipTail [] = []
zipTail (x:xs) = (x,xs):(zipTail xs)

zipTail xs = foldr (\y r s -> (y,tail s):(r (tail s))) (\_ -> []) xs xs

zipTail = \xs. xs (\y r s. cons (pair y (tail s)) (r (tail s))) (\x. []) xs

zipTail : \forall X. List X -> List (Pair X (List X))
zipTail = /\X. \xs:List X.
  xs<List X -> List (Pair X (List X))>
  (\y:X. \r:List X -> List (Pair X (List X)). \s:List X. cons<Pair X (List X)> (pair<X><List X> y (tail<X> s)) (r (tail<X> s)))
  (\x:X. nil<Pair X (List X)>)
  xs
-}

{-
take :: Int -> [a] -> [a]
take _ []              =  []
take n (x:xs)          =  if n <= 0 then [] else x : take (n-1) xs

take n xs = foldr (\y r i -> if i == 0 then [] else y:(r (i-1))) (\_ -> []) xs n

-- lambda no tipado
take = \n xs. xs (\y r i. (isZero i) nil (cons y (r (pred i)))) n

-- lambda tipado
take : \forall X. Nat -> List X -> List X
take = /\X. \n:Nat. \xs:List X.
  xs<Nat -> List X>
  (\y:X. \r:Nat -> List X. \i:Nat. (isZero i) nil<X> (cons<X> y (r (pred i))))
  (\x:Nat. nil<X>)
  n

-}

{-
zipPre [1,2,3,4] = [(1,[]), (2,[1]), (3,[1,2]), (4,[1,2,3])]
zipPre :: [a] -> [(a,[a])]
zipPre xs = zipPre' xs []
    where
      zipPre' [] _ = []
      zipPre' (x:xs) ys = (x,ys):(zipPre' xs (ys++[x]))

zipPre :: [a] -> [(a,[a])]
zipPre xs = zipPre' xs []
    where
      zipPre' xs ys = foldr (\y r s -> (y,s):(r (s++[y]))) (\_ -> []) xs ys

-- lambda no tipado
zipPre = \xs . zipPre' xs nil
zipPre' = \xs ys.
  xs
  (\y r s. cons (pair y s) (r (s ++ (cons y nil))))
  (\x -> nil)
  ys

-- lambda tipado
zipPre' : \forall X. List X -> List X -> List (Pair X (List X))
zipPre' = /\X. \xs:List X. \ys:List X.
  xs<List X -> List (Pair X (List X))>
  (\y:X. \r:List X -> List (Pair X (List X)). \s:X. cons<Pair X (List X)> (pair<X><List X> y s) (r (++<X> s (cons<X> y nil<X>))))
  (\x:X -> nil<X>)
  ys
-}
