import Parsing
import Control.Monad
import Control.Applicative hiding (many)

-- EJERCICIO 2
expr :: Parser Int
expr = do t <- term
          (do char '+'
              e <- expr
              return (t+e)
              <|> (do char '-'
                      e <- expr
                      return (t-e)
                      <|> return t))

term :: Parser Int
term = do f <- factor
          (do char '*'
              t <- term
              return (f*t)
              <|> (do char '/'
                      t <- term
                      return (div f t)
                      <|> return f))

dig2int :: Char -> Int
dig2int '0' = 0
dig2int '1' = 1
dig2int '2' = 2
dig2int '3' = 3
dig2int '4' = 4
dig2int '5' = 5
dig2int '6' = 6
dig2int '7' = 7
dig2int '8' = 8
dig2int '9' = 9


factor :: Parser Int
factor = do d <- digit
            return (dig2int d)
         <|> do char '('
                e <- expr
                char ')'
                return e

eval :: String -> Int
eval xs = fst(head(parse expr xs)) 

-- EJERCICIO 3
transform :: Parser a -> Parser a
transform p = do t <- p
                 return t
                 <|> do char '('
                        t <- p
                        char ')'
                        return t

-- EJERCICIO 4
data Expr = Num Int | BinOp Op Expr Expr deriving Show
data Op = Add | Mul | Min | Div deriving Show

exprT :: Parser Expr
exprT = do t <- termT
           (do char '+'
               e <- exprT
               return (BinOp Add t e)
               <|>(do char '-'
                      e <- exprT
                      return (BinOp Min t e)
                      <|> return t))

termT :: Parser Expr
termT = do f <- factorT
           (do char '*'
               t <- termT
               return (BinOp Mul f t)
               <|> (do char '/'
                       t <- termT
                       return (BinOp Div f t)
                       <|> return f))

factorT :: Parser Expr
factorT = do d <- digit
             return (Num (dig2int d))
          <|> do char '('
                 e <- exprT
                 char ')'
                 return e

evalT :: String -> Expr
evalT xs = fst(head(parse exprT xs)) 

-- EJERCICIO 5
type HElement = Either Char Int

elementHList :: Parser HElement
elementHList = do n <- nat
                  return (Right n)
                <|> do char '\''
                       c <- letter
                       char '\''
                       return (Left c)

parserHList :: Parser [HElement]
parserHList = do char '['
                 xs <- sepBy elementHList (char ',')
                 char ']'
                 return xs

-- EJERCICIO 6
data BaseType = DInt | DChar | DFloat deriving Show
type HaskType = [BaseType]

parseBase :: Parser BaseType
parseBase = (string "Int" >> return DInt)
            <|>
            (string "Char" >> return DChar)
            <|>
            (string "Float" >> return DFloat)
               
parserHasktype :: Parser HaskType
parserHasktype = sepBy parseBase (symbol "->")

-- EJERCICIO 7
data HaskType_ = DInt_ | DChar_ | Func_ HaskType_ HaskType_ deriving Show

parseBase_ :: Parser HaskType_
parseBase_ = (string "Int" >> return DInt_)
             <|>
             (string "Char" >> return DChar_)

parserHasktype_ :: Parser HaskType_
parserHasktype_ = do h1 <- parseBase_
                     (do symbol "->"
                         h2 <- parserHasktype_
                         return (Func_ h1 h2)
                         <|> return h1)


-- EJERCICIO 9

