module Common where

-- Comandos interactivos o de archivos
data Stmt i = Def String i           --  Declarar un nuevo identificador x, let x = t
            | Eval i                 --  Evaluar el término
  deriving (Show)

instance Functor Stmt where
  fmap f (Def str a) = Def str (f a)
  fmap f (Eval a   ) = Eval (f a)

-- Tipos de los nombres
data Name
    =  Global  String
    |  Quote   Int
  deriving (Show, Eq)

type NameEnv v = [(Name, v)]

-- Términos con nombres
data LamTerm  =  LVar String
              |  App LamTerm LamTerm
              |  Abs String LamTerm
              deriving (Show, Eq)

-- Términos localmente sin nombres
data Term  = Bound Int
            | Free Name
            | Term :@: Term
            | Lam Term
        deriving (Show,Eq)

-- Valores
data Value
    =  VLam      (Value -> Value)
    |  VNeutral  Neutral

data Neutral
    =  NFree  Name
    |  NApp   Neutral Value




