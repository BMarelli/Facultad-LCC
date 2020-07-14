-module(client).
-export([start/0, start/1, start_tcp_client/1, start_node_client/1]).
-define(DEFAULT_PORT, 8000).

start() ->
    start_tcp_client(?DEFAULT_PORT),
    ok.
start(Port) ->
    case Port of
        {silencioso, Node} -> start_node_client(Node);
        _ -> start_tcp_client(Port)
    end.

start_node_client(Node) -> ok.

start_tcp_client(Port) ->
    case gen_tcp:connect({127,0,0,1}, Port, [{active, false}]) of
        {ok, Socket} ->
            io:format("Conectado al servidor en 127.0.0.1:~p~n", [Port]),
            spawn(?MODULE, receiver, [Socket]),
            sender(Socket);
        {error, _} ->
            io:format("No se pudo conectar al servidor en 127.0.0.1:~p~n", [Port])
    end.

sender(Socket) ->
    CMDString = string:trim(io:get_line(">> ")),
    Lexemes = string:lexemes(CMDString, " "),
    case Lexemes of
        [] -> sender(Socket);
        _ -> gen_tcp:send(Socket, CMDString), sender(Socket)
    end.


receiver(Socket) ->
    
