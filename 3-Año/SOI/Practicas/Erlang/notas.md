# Erlang - **Notas de Clase**

## Inicio del codigo
Definimos el modulo de la funcion
```erlang
-module(function).
-export([function/ar(function)]). % Donde ar(f) es la cantidad de argumentos
```
Para poder compilar hacemos:
```properties
bautistamarelli@BM:~$ erl

Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

Eshell V10.6.4  (abort with ^G)
1> c(function).
{ok,function}
2>
```

## Ejemplo - Factorial
```erl
-module(factorial).
-export([factorial/1]).

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).
```
```properties
bautistamarelli@BM:~$ erl

Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

Eshell V10.6.4  (abort with ^G)
1> c(factorial).
{ok,factorial}
2>
```

## if/else statement
```erl
if
  10 =< 20 ->
    1;
  true ->
    0
end.
```
En este caso, devuelve 1. El `true ->` es como el otherwise.
En el caso que no entre en la primera condision, entra en el `true ->`

## Tuplas
```erl
% Definimos una tupla de la siguiente manera
tupla = {a, b}
```

### Ejemplo - Minimo de una lista
```erl
-module(min).
-export([min/1]).

min([Hd]) -> Hd;
min([Hd|Tl]) ->
    Rest = min(Tl),
    if
        Hd =< Rest ->
            Hd;
        true ->
            Rest

    end.

```
```properties
bautistamarelli@BM:~$ erl

Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

Eshell V10.6.4  (abort with ^G)
1> c(min).
{ok,min}
2> min:min([10,22,12,4,1]).
1
```
