-module(mutex).

-export([crear/0, borrar/1]).
-export([tomar/1, soltar/1]).
-export([locker/1]).
%% Testing
-export([testLock/0, f/2, waiter/2]).

%% Función que crea el mutex
crear() ->
    spawn(?MODULE, locker, [unlocked]).

%% Función que elimina el mutex
borrar(M) ->
    M ! {finish},
    ok.

%% Función que toma el mutex
tomar(M) ->
    M ! {lock, self()},
    receive
      go ->
          ok
    end.

%% Función que libera el mutex
soltar(M) ->
    M ! {unlock, self()}.

%% Servidor de lock
locker(unlocked) ->
    ok.

%% Test de la implementación
testLock() ->
    L = crear(),
    W = spawn(?MODULE, waiter, [L, 3]),
    spawn(?MODULE, f, [L, W]),
    spawn(?MODULE, f, [L, W]),
    spawn(?MODULE, f, [L, W]),
    ok.

f(L, W) ->
    tomar(L),
    %
    io:format("uno ~p~n", [self()]),
    io:format("dos ~p~n", [self()]),
    io:format("tres ~p~n", [self()]),
    io:format("cuatro ~p~n", [self()]),
    %
    soltar(L),
    W ! finished.

waiter(L, 0) ->
    borrar(L);
waiter(L, N) ->
    receive
      finished ->
          waiter(L, N - 1)
    end.
