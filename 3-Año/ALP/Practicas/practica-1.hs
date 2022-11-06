import Parsing
import Control.Monad
import Control.Applicative hiding (many)

-- Ejercicio 1

factor :: Parser Int
factor = nat
         <|>
         do { char '('; e <- expr; char ')'; return e }

term :: Parser Int
term = do { f <- factor; do { char '*'; t <- term; return (f*t) }
                         <|>
                         do { char '/'; t <- term; return (div f t) } }
       <|> factor

expr :: Parser Int
expr = do { t <- term; do { char '+'; exp <- expr; return (t+exp) } 
                       <|>
                       do { char '-'; exp <- expr; return (t-exp) } }
       <|> term

-- Ejercicio 3
parens :: Parser a -> Parser a
parens p = do char '('
              res <- p
              char ')'
              return res
           <|>
           do p

-- Ejercicio 4
data Op = Add | Mul | Min | Div deriving Show
data Expr = Num Int | BinOp Op Expr Expr deriving Show

term' :: Parser Expr
term' = do f <- factor'
           do char '*'
              t <- term'
              return (BinOp Mul f t)
            <|>
            do char '/'
               t <- term'
               return (BinOp Div f t)
        <|> factor'

factor' :: Parser Expr
factor' = do n <- nat
             return (Num n)
          <|>
          do char '('
             exp <- expr'
             char ')'
             return exp

expr' :: Parser Expr
expr' = do t <- term'
           do char '+'
              exp <- expr'
              return (BinOp Add t exp)
            <|>
            do char '-'
               exp <- expr'
               return (BinOp Min t exp)
        <|> term'

-- Ejercicio 5
type Elements = Either Int Char
lista :: Parser [Elements]
lista = do char '['
           xs <- sepBy elements (char ',')
           char ']'
           return xs
    where
      elements :: Parser Elements
      elements = do n <- nat
                    return (Left n)
                  <|>
                  do char '\''
                     l <- letter
                     char '\''
                     return (Right l)

-- Ejercicio 6
data BaseType = DInt | DChar | DFloat deriving Show
type HaskellType = [BaseType]

baseType :: Parser BaseType
baseType = (string "Int" >> return DInt)
           <|>
           (string "Char" >> return DChar)
           <|>
           (string "Float" >> return DFloat)

haskellType :: Parser HaskellType
haskellType = do sepBy baseType (symbol "->")

-- Ejercicio 7
data HaskellType2 = DInt2 | DChar2 | DFloat2 | Fun HaskellType2 HaskellType2 deriving Show

baseType2 :: Parser HaskellType2
baseType2 = (string "Int" >> return DInt2)
            <|>
            (string "Char" >> return DChar2)
            <|>
            (string "Float" >> return DFloat2)

haskellType2 :: Parser HaskellType2
haskellType2 = do t <- baseType2
                  do symbol "->"
                     t' <- haskellType2
                     return (Fun t t')
               <|>
               baseType2

-- Ejercicio 8

expr_ ::Parser Int
expr_ = do t <- term_
           expr_' t
    where
      expr_' :: Int -> Parser Int
      expr_' n = do char '+'
                    t' <- term_
                    expr_' (n + t')
                 <|>
                 do char '-'
                    t' <- term_
                    expr_' (n - t')
                 <|>
                 return n

term_ :: Parser Int
term_ = do f <- factor
           term_' f
    where
      term_' :: Int -> Parser Int
      term_' n = do char '*'
                    f' <- factor
                    term_' (n * f')
                 <|>
                 do char '/'
                    f' <- factor
                    term_' (div n f')
                 <|>
                 return n

factor_ :: Parser Int
factor_ = do nat
          <|>
          do char '('
             exp <- expr_
             char ')'
             return exp

-- Ejercicio 9
{-
direct_declarator -> '(' direct_declarator ')' direct_declarator' | ident direct_declarator'
direct_declarator' -> E | '[' constant ']' direct_declarator'
-}

data Type = TInt | TFloat | TChar deriving Show
data Values = Array Values Int | Pointer Values | Ident String  deriving Show
data Declaration = Dec Values Type deriving Show

declaration :: Parser Declaration
declaration = do t <- typeSpecifier
                 v <- declarator
                 symbol ";"
                 return (Dec v t)
                 
typeSpecifier :: Parser Type
typeSpecifier = (string "int" >> return TInt)
                 <|>
                 (string "char" >> return TChar)
                 <|>
                 (string "float" >> return TFloat)

declarator :: Parser Values
declarator = do { symbol "*"; dec <- declarator; return (Pointer dec) }
             <|>
             directDeclarator

directDeclarator :: Parser Values
directDeclarator = do { symbol "("; dd <- directDeclarator; dd' <- directDeclarator' dd; symbol ")"; return dd' }
                   <|>
                   do { ss <- identifier; directDeclarator' (Ident ss) }
    where
      directDeclarator' :: Values -> Parser Values
      directDeclarator' v = do { symbol "["; n <- nat; symbol "]"; directDeclarator' (Array v n) }
                            <|>
                            return v
                    

