import Seq
import ArrSeq
import qualified Arr as A

-- Ejercicio 1
-- aumentos :: (Seq s, Ord a) => s (a, Int) -> (a, Int)

-- Ejercicio 2
type Name = String
data DirTree a = Dir Name [DirTree a] | File Name a
                 deriving Show

type Path = [String]

dir = Dir "/" [Dir "home" [Dir "luis" [File "Carta.txt" "xxx"], Dir "Pedro" []], Dir "mnt" []]
dirs = [Dir "home" [Dir "luis" [File "Carta.txt" "xxx"],Dir "Pedro" []], Dir "mnt" [], File "Nati" "BOBA"]

names :: [DirTree a] -> [Name]
names [] = []
names xs = Prelude.map f xs
    where
      f (Dir name _) = name
      f (File name _) = name

mkDir :: Path -> Name -> DirTree a -> DirTree a
mkDir path name dir = mkdir ("/" : path) name dir
    where
      mkdir :: [String] -> Name -> DirTree a -> DirTree a
      mkdir [p] name d@(Dir n xs) = if (p == n) && (name `elem` (names xs)) then d
                                      else (Dir n ((Dir name []) : xs))
      mkdir (p:ps) name d@(Dir n xs) = if p == n then Dir n (Prelude.map (mkdir ps name) xs)
                                         else d

ls :: Path -> DirTree a -> [Name]
ls path dir = ls_ ("/" : path) dir
    where
      ls_ :: Path -> DirTree a -> [Name]
      ls_ [p] (Dir n xs) = if p == n then names xs else []
      ls_ (p:ps) d@(Dir n xs) = if p == n then concat (Prelude.map (ls_ ps) xs) else []

-- Ejercicio 3
{-
Caso Base:
elem n (allName (File x c))
elem n [x]
n == x || elem [] => n == x
isName n (File x c) (OK)

Caso Inductivo:
Supongamos que P vale para todos los hijos de Dir x [x1, ..., xn]
elem n (allName (Dir x [x1, ..., xn]))
elem n (x : (concatMap allName [x1, ..., xn]))
elem n (x : (concat (map allName [x1, ..., xn])))
elem n (x : (concat [allName x1, ..., allName xn]))
elem n (concat [[x], allName x1, ..., allName xn])
<Propiedad: elem x (concat xs) = or (map (elem x) xs)>
or (map (elem n) [[x], allName x1, ..., allName xn])
or [elem n [x], elem n (allName x1), ..., elem n (allName xn)]
or [n == x || elem n [], elem n (allName x1), ..., elem n (allName xn)]
or [n == x, elem n (allName x1), ..., elem n (allName xn)]
n == x || or [elem n (allName x1), ..., elem n (allName xn)]
<HI>
n == x || or [isName n x1, ..., isName n xn]
n == x || or (map (isName n) [x1, ..., xn])
isName n (Dir x [x1, ..., xn])
QED
-}
