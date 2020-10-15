module Parser where

import           Text.ParserCombinators.Parsec
import           Text.Parsec.Token
import           Text.Parsec.Language           ( emptyDef )
import           AST

-----------------------
-- Funcion para facilitar el testing del parser.
totParser :: Parser a -> Parser a
totParser p = do
  whiteSpace lis
  t <- p
  eof
  return t

-- Analizador de Tokens
lis :: TokenParser u
lis = makeTokenParser
  (emptyDef
    { commentStart    = "/*"
    , commentEnd      = "*/"
    , commentLine     = "//"
    , opLetter        = char '='
    , reservedNames   = ["true", "false", "if", "else", "while", "skip"]
    , reservedOpNames = [ "+"
                        , "-"
                        , "*"
                        , "/"
                        , "<"
                        , ">"
                        , "&&"
                        , "||"
                        , "!"
                        , "="
                        , "=="
                        , "!="
                        , ";"
                        , ","
                        ]
    }
  )

(<||>) :: Parser a -> Parser a -> Parser a
(<||>) p q = (try p) <|> q

-----------------------------------
--- Parser de expressiones enteras
-----------------------------------
intelem :: Parser (Exp Int)
intelem = do reservedOp lis "-"
             e <- intelem
             return (UMinus e)
          <||> do i <- integer lis
                  return (Const (fromIntegral i))
          <||> do xs <- identifier lis
                  return (Var xs)
          <||> parens lis intexp

intfactor :: Parser (Exp Int)
intfactor = chainl1 intelem (do { reservedOp lis "*"; return (Times) }
                             <||>
                             do { reservedOp lis "/"; return (Div) })

intterm :: Parser (Exp Int)
intterm = chainl1 intfactor (do { reservedOp lis "+"; return (Plus) }
                             <||>
                             do { reservedOp lis "-"; return (Minus) })

intassgn :: Parser (Exp Int)
intassgn = do xs <- identifier lis
              reservedOp lis "="
              ass <- intassgn
              return (EAssgn xs ass)
           <||> intterm

intexp :: Parser (Exp Int)
intexp = chainl1 intassgn (do { reservedOp lis ","; return (ESeq) })

-------------------------------------
--- Parser de expressiones booleanas
-------------------------------------
boolelem :: Parser (Exp Bool)
boolelem = (parens lis boolexp)
           <||> (reserved lis "true" >> return BTrue)
           <||> (reserved lis "false" >> return BFalse)

boolfactor :: Parser (Exp Bool)
boolfactor = do x <- intexp
                (do reservedOp lis "=="
                    y <- intexp
                    return (Eq x y)
                 <||> do reservedOp lis "!="
                         y <- intexp
                         return (NEq x y)
                 <||> do reservedOp lis "<"
                         y <- intexp
                         return (Lt x y)
                 <||> do reservedOp lis ">"
                         y <- intexp
                         return (Gt x y))
             <||> boolelem

boolnot :: Parser (Exp Bool)
boolnot = do reservedOp lis "!"
             not <- boolnot
             return (Not not)
          <||> boolfactor

boolterm :: Parser (Exp Bool)
boolterm = chainl1 boolnot (do { reservedOp lis "&&"; return (And)})

boolexp :: Parser (Exp Bool)
boolexp = chainl1 boolterm (do { reservedOp lis "||"; return (Or) })

-----------------------
--- Parser de comandos
-----------------------
commLet :: Parser Comm
commLet = do xs <- identifier lis
             reservedOp lis "="
             exp <- intexp
             return (Let xs exp)

commIfElse :: Parser Comm
commIfElse = do reserved lis "if"
                bool <- boolexp
                com <- braces lis comm
                (do reserved lis "else"
                    com' <- braces lis comm
                    return (IfThenElse bool com com'))
                 <||> return (IfThen bool com)
                
commWhile :: Parser Comm
commWhile = do reserved lis "while"
               bool <- boolexp
               com <- braces lis comm
               return (While bool com)

commelem :: Parser Comm
commelem = (reserved lis "skip" >> return Skip) <||> commLet <||> commIfElse <||> commWhile

comm :: Parser Comm
comm = chainl1 commelem (do {reservedOp lis ";"; return (Seq)})

---------------------
-- Función de parseo
---------------------
parseComm :: SourceName -> String -> Either ParseError Comm
parseComm = parse (totParser comm)
