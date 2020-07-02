-module(broadcast).

-export([inicializar/0, broadcaster/1, subscribir/2, enviar/2, destruir/1, foreach/2]).
%% Ejemplo
-export([echo/0, start/0]).

foreach(F, [X]) ->
  F(X),
  ok;
foreach(F, [X | Xs]) ->
  F(X),
  foreach(F, Xs).

%% Función de inicialización `inicializar/0` que devuelve el Pid del
%% proceso encargado de repartir los mensajes.
inicializar() ->
  io:format("Comienza el Broadcasting~n"),
  Pid = spawn(?MODULE, broadcaster, [[]]),
  register(broad, Pid),
  ok.

%% Función de subscripción `subscribir/2` que tome el Pid de un proceso
%% que subscribiese al servicio de repartición de mensajes y el
%% PId del proceso encargado de repartir los mensajes.
subscribir(Pid, Broad) ->
  Broad ! {subs, Pid}.

%% Función de envío de un mensaje a *todos* los subscriptores `enviar/2`, que
%% toma un mensaje y el Pid del proceso encargado de repartir el mensaje.
enviar(Msj, Broad) ->
  Broad ! {env, Msj}.

%% Función de eliminación del servicio de repartición de mensajes `destruir/1`
%% que toma el PId de un proceso y le indica que ya no se necesitarán sus servicios.
destruir(Broad) ->
  Broad ! dest.

%% Función auxiliar que envía el mensaje `Msj`
%% a cada Pid de la lista `Ps`.

broadcast(Msj, Xs) ->
  foreach(fun (X) ->
                X ! Msj
          end,
          Xs).

%% Proceso encargado de repartir los mensajes.
%% Recordar que al igual que en el ejemplo visto de
%% `Ping Pong` la forma de hacer que el proceso siga
%% vivo es a través de llamadas recursivas.
broadcaster(Ps) ->
  receive
    {subs, Pid} ->
      broadcaster([Pid | Ps]);
    {env, Msj} ->
      broadcast(Msj, Ps),
      broadcaster(Ps);
    dest ->
      ok
  end.

echo() ->
  receive
    Msj ->
      io:format("Soy ~p me llego ~p~n", [self(), Msj])
  end.

start() ->
  Gen1 = spawn(?MODULE, echo, []),
  Gen2 = spawn(?MODULE, echo, []),
  Gen3 = spawn(?MODULE, echo, []),
  inicializar(),
  subscribir(Gen1, broad),
  subscribir(Gen2, broad),
  subscribir(Gen3, broad),
  enviar("Holis!", broad),
  destruir(broad),
  ok.

