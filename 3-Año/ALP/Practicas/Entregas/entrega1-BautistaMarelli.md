# Bautista Marelli - Análisis de Lenguajes de Programación

## Ejercicio 4.2
Definimos una nueva gramatica `G'` no ambigua

`G' = (N, T, P, <Ex>)`

`N = {<Exp>, <Termino>, <Elemento>}`

`T = {+, *, (, ), x, y, z}`

`S = <Exp>`

Las producciones de `P` son:

- `<Exp> -> <Exp> + <Termino> | <Termino>`
- `<Termino> -> <Termino> * <Elemento> | <Elemento>`
- `<Elemento> -> (<Exp>) | x | y | z`
