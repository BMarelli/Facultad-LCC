data BTS a = E | N (BTS a) a (BTS a)
             deriving Show

-- La Invariante que debe cumplir es que el hijo izq debe ser menor al padre y el hijo der tiene que ser
-- mayor al padre

delete :: Eq a => a -> BTS a -> BTS a
delete _ E = E
delete x (N xs v ys) = 
