module Untyped where

import           Control.Monad
import           Data.List
import           Data.Maybe

import           Common

----------------------------------------------
-- Seccón 2  
-- Ejercicio 2: Conversión a términos localmente sin nombres
----------------------------------------------

conversion :: LamTerm -> Term
conversion lt = conv lt []
    where
      conv :: LamTerm -> [String] -> Term
      conv (LVar xs) ys = case elemIndex xs ys of
                              Nothing -> Free (Global xs)
                              Just i -> Bound i
      conv (App lt1 lt2) ys = let t1 = conv lt1 ys
                                  t2 = conv lt2 ys
                              in t1 :@: t2
      conv (Abs xs lt) ys = Lam (conv lt (xs:ys))
-------------------------------
-- Sección 3
-------------------------------

vapp :: Value -> Value -> Value
vapp (VLam func) v2 = func v2
vapp (VNeutral neu) v2 = VNeutral (NApp neu v2)

eval :: NameEnv Value -> Term -> Value
eval e t = eval' t (e, [])

eval' :: Term -> (NameEnv Value, [Value]) -> Value
eval' (Bound ii) (_, lEnv) = lEnv !! ii
eval' (Free n) (gEnv, _) = case searchGlobal n gEnv of
                              Nothing -> VNeutral (NFree n)
                              Just v -> v
    where
      searchGlobal :: Name -> NameEnv Value -> Maybe Value
      searchGlobal n [] = Nothing
      searchGlobal n ((n', v):xs) = if n == n' then Just v else searchGlobal n xs
eval' (t1 :@: t2) e = let v1 = eval' t1 e
                          v2 = eval' t2 e
                      in vapp v1 v2
eval' (Lam t) (gEnv, lEnv) = VLam (\v -> eval' t (gEnv, v:lEnv))

--------------------------------
-- Sección 4 - Mostrando Valores
--------------------------------

quote :: Value -> Term
quote v = quote' v 0
    where
      quote' :: Value -> Int -> Term
      quote' (VLam func) i = Lam (quote' (func (VNeutral (NFree (Quote i)))) (i + 1))
      quote' (VNeutral (NFree name)) i = case name of
                                              Quote k -> Bound (i - k  - 1) 
                                              Global _ -> Free name
      quote' (VNeutral (NApp neu v)) i = (quote' (VNeutral neu) i) :@: (quote' v i)






