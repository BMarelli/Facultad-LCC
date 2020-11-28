module PrettyPrinter
  ( printTerm
  ,     -- pretty printer para terminos
    printType     -- pretty printer para tipos
  )
where

import           Common
import           Text.PrettyPrint.HughesPJ
import           Prelude                 hiding ( (<>) )
-- lista de posibles nombres para variables
vars :: [String]
vars =
  [ c : n
  | n <- "" : map show [(1 :: Integer) ..]
  , c <- ['x', 'y', 'z'] ++ ['a' .. 'w']
  ]

parensIf :: Bool -> Doc -> Doc
parensIf True  = parens
parensIf False = id

-- pretty-printer de términos

pp :: Int -> [String] -> Term -> Doc
pp ii vs (Bound k         ) = text (vs !! (ii - k - 1))
pp _  _  (Free  (Global s)) = text s
pp ii vs (i :@: c         ) = sep
  [ parensIf (isLam i) (pp ii vs i)
  , nest 1 (parensIf (isNotPairUnitZero c) (pp ii vs c))
  ]
pp ii vs (Lam t c) =
  text "\\"
    <> text (vs !! ii)
    <> text ":"
    <> printType t
    <> text ". "
    <> pp (ii + 1) vs c
pp ii vs (Let u v) = sep
  [
    text "let",
    text (vs !! ii),
    text "=",
    parensIf (isNotPairUnitZero u) (pp ii vs u),
    text "in",
    parensIf (isNotPairUnitZero v) (pp (ii+1) vs v)
  ]
pp ii vs (As u t) = sep
  [
    parensIf (isNotPairUnitZero u) (pp ii vs u),
    text "as",
    printType t
  ]
pp _ _ Unit = text "unit"
pp ii vs (Fst u) = sep
  [
    text "fst",
    parensIf (isNotPairUnitZero u) (pp ii vs u)
  ]
pp ii vs (Snd u) = sep
  [
    text "snd",
    parensIf (isNotPairUnitZero u) (pp ii vs u)
  ]
pp ii vs (Pair u v) = parensIf True $ 
  pp ii vs u
  <> text ", "
  <> pp ii vs v
pp _ _ Zero = text "0"
pp ii vs (Suc u) = sep 
  [
    text "suc",
    parensIf (isNotPairUnitZero u) (pp ii vs u)
  ]
pp ii vs (Rec u v w) = sep
  [
  text "R",
    parensIf (isNotPairUnitZero u) (pp ii vs u),
    parensIf (isNotPairUnitZero v) (pp ii vs v),
    parensIf (isNotPairUnitZero w) (pp ii vs w)
  ]

isNotPairUnitZero :: Term -> Bool
isNotPairUnitZero (Lam _ _) = True
isNotPairUnitZero (_ :@: _) = True
isNotPairUnitZero (Let _ _) = True
isNotPairUnitZero (Fst _)   = True
isNotPairUnitZero (Snd _)   = True
isNotPairUnitZero (Suc _)   = True
isNotPairUnitZero (As _ _)  = True
isNotPairUnitZero _         = False

isLam :: Term -> Bool
isLam (Lam _ _) = True
isLam _         = False

-- pretty-printer de tipos
printType :: Type -> Doc
printType EmptyT = text "E"
printType UnitT = text "Unit"
printType (FunT t1 t2) =
  sep [parensIf (isFun t1) (printType t1), text "->", printType t2]
printType (PairT t1 t2) = parensIf True $ printType t1
                                          <> text ", "
                                          <> printType t2
printType NatT = text "Nat"


isFun :: Type -> Bool
isFun (FunT _ _) = True
isFun _          = False

fv :: Term -> [String]
fv (Bound _         ) = []
fv (Free  (Global n)) = [n]
fv (t   :@: u       ) = fv t ++ fv u
fv (Lam _   u       ) = fv u
fv (Let u v         ) = fv u ++ fv v
fv (As u _          ) = fv u
fv Unit               = []
fv (Fst u)            = fv u
fv (Snd u)            = fv u
fv (Pair u v)         = fv u ++ fv v
fv Zero               = []
fv (Suc u)            = fv u
fv (Rec u v w)        = fv u ++ fv v ++ fv w

---
printTerm :: Term -> Doc
printTerm t = pp 0 (filter (\v -> not $ elem v (fv t)) vars) t
