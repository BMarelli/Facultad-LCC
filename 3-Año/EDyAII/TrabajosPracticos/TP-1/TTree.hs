-- Trabajo Practico 1 - Bautista Marelli - Francisco Alcacer

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

module TP1 where

import Data.Maybe

data TTree k v = Node k (Maybe v) (TTree k v) (TTree k v) (TTree k v)
                |Leaf k v
                |E
                deriving (Show, Eq)
                
-- Arbol vacio
empty :: TTree k v
empty = E

-- Dado una clave [k] y un TTree, devuelve el valor asociado a la clave [k]
search :: Ord k => [k] -> TTree k v -> Maybe v 
search _ E = Nothing
search [] _ = Nothing
search [c] (Leaf k v) | c == k     = Just v
                      | otherwise  = Nothing
search (c:cs) (Leaf k v) = Nothing
search a@(c:cs) (Node k v xs ys zs) | c == k     = (if cs /= [] then (search cs ys)
                                                    else v)
                                    | c < k      = (search a xs)
                                    | otherwise  = (search a zs)

-- Dado una clave [k], un valor v y un TTree, agrega un par (clave, valor) a un arbol.
-- Si la clave ya esta en el arbol, actualiza su valor
insert :: Ord k => [k] -> v -> TTree k v -> TTree k v
insert (c:cs) n E = if cs == [] then Leaf c n
                    else Node c Nothing E (insert cs n E) E
insert a@(c:cs) n (Leaf k v) | c == k     = case cs of
                                                [] -> Leaf k n
                                                otherwise -> Node k (Just v) E (insert cs n E) E
                             | c < k      = Node k (Just v) (insert a n E) E E
                             | otherwise  = Node k (Just v) E E (insert a n E)

insert a@(c:cs) n (Node k v xs ys zs) | c == k    = (if cs /= [] then Node k v xs (insert cs n ys) zs
                                                   else (Node k (Just n) xs ys zs))
                                      | c < k     = Node k v (insert a n xs) ys zs
                                      |otherwise  = Node k v xs ys (insert a n zs)

-- Dado una clave y un TTree, devuelve el resultado de eliminar la clave del TTree en el caso de que la clave 
-- este en el TTree
delete :: Ord k => [k] -> TTree k v -> TTree k v
delete _ E = E
delete (c:cs) xs@(Leaf k v) = if cs == [] && c == k then E
                              else xs
delete clave@(c:cs) (Node k v xs ys zs) | c < k       = node2leaf (Node k v (delete clave xs) ys zs)
                                        | c > k       = node2leaf (Node k v xs ys (delete clave zs))
                                        | otherwise   = case cs of
                                                          [] -> node2leaf (Node k Nothing xs ys zs)
                                                          otherwise -> node2leaf (Node k v xs (delete cs ys) zs)
    where node2leaf (Node k Nothing E E E)      = E
          node2leaf (Node k (Just v) E E E)     = Leaf k v
          node2leaf xs                          = xs

--Dado un arbol devuelve una lista ordenada con las claves del mismo.
keys :: TTree k v -> [[k]]
keys xs = keys_ xs []
 where keys_ E _ = []
       keys_ (Leaf k v) cs           = [cs ++ [k]]
       keys_ (Node k v xs ys zs) cs  = case v of
                                       Just _ -> (keys_ xs cs) ++ [cs ++ [k]] ++ (keys_ ys (cs ++ [k])) ++ (keys_ zs cs) ++ [cs ++ [k]]
                                       otherwise -> (keys_ xs cs) ++ (keys_ ys (cs ++ [k])) ++ (keys_ zs cs)


class Dic k v d | d -> k v where
      vacio :: d
      insertar :: Ord k => k -> v -> d -> d
      buscar :: Ord k =>  k -> d -> Maybe v
      eliminar :: Ord k => k -> d -> d
      claves :: Ord k => d -> [k]

instance Ord k => Dic [k] v (TTree k v) where
      vacio = empty
      insertar = insert
      buscar = search
      eliminar = delete
      claves = keys
