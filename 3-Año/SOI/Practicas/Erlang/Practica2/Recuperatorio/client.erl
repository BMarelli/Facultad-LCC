-module(client).
-export([start/0, start/1]).
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
            try
                spawn_link(?MODULE, receiver, [Socket]),
                sender(Socket)
            catch _:_ -> ok
            end;
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
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            Lexemes = string:lexemes(Data, " "),
            case Lexemes of
                ["OK" | _] ->
                    io:format("OK ~s~n", [Data]);
                ["ERROR", Reason] ->
                    io:format("ERROR: ~s~n", [Reason])
            end,
            receiver(Socket);
        {error, _} ->
            io:format("Se ha perdido la conexión con el servidor~n"),
            exit(lost_connection)
    end.
    
