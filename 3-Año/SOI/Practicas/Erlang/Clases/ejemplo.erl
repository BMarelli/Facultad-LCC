-module(ejemplo).
-export([ejemplo/1]).

ejemplo(A) ->
    {X, Y, Z, W} = A,
    io:format("~p ~p ~p ~p ~n", [X, Y, Z, W]).
