-module(servnomb).

%% Creación y eliminación del servicio
-export([iniciar/0, finalizar/1]).
%% Servidor
-export([servnombres/2]).
%% Librería de Acceso
-export([nuevoNombre/2, quienEs/2, listaDeIds/1]).

% Iniciar crea el proceso servidor, y devuelve el PId.
iniciar() ->
    spawn(?MODULE,
          servnombres,
          %% El servidor comienza con un mapa vacÃ­o
          %% y el contador en 1
          [maps:new(), 1]).

%% Función de servidor de nombres.
servnombres(Map, N) ->
    receive
      %% Llega una peticiÃ³n para crear un Id para nombre
      {nuevoId, Nombre, CId} ->
          NMap = maps:put(N, Nombre, Map),
          CId ! {ok, N, Nombre},
          servnombres(NMap, N + 1);
      %% Llega una peticiÃ³n para saber el nombre de tal Id
      {buscarId, NId, CId} ->
          Value = maps:get(NId, Map, none),
          CId ! Value;
      %% Entrega la lista completa de Ids con Nombres.
      {verLista, CId} ->
          Lista = maps:to_list(Map),
          CId ! Lista;
      %% Cerramos el servidor. Va gratis
      {finalizar, CId} ->
          CId ! ok
    end.

%% Dado un nombre y un servidor le pide que cree un identificador
%% único.
nuevoNombre(Nombre, NMServ) ->
    NMServ ! {nuevoId, Nombre, self()},
    receive
      _ ->
          vacioilegal
    end.

%% Función que recupera el nombre desde un Id
quienEs(Id, NMServ) ->
    NMServ ! {buscarId, Id, self()},
    receive
      Msj ->
          io:format("-> ~p~n", [Msj])
    end.

%% Pedimos la lista completa de nombres e identificadores.
listaDeIds(NMServ) ->
    NMServ ! {verLista, self()},
    receive
      Msj ->
          io:format("=> ~p~n", [Msj])
    end.

% Ya implementada :D!
finalizar(NMServ) ->
    NMServ ! {finalizar, self()},
    receive
      ok ->
          ok
    end.

