-module(server).
-export([format/2, start/0, start/1, start_tcp_server/1, start_node_server/0, dispatcher/1, listclient/1, psocket/1]).
-define(DEFAULT_PORT, 8000).

format(String, Data) -> lists:flatten(io_lib:format(String, Data)).

start() ->
    start_tcp_server(?DEFAULT_PORT),
    ok.
start(Port) ->
    case Port of
        silencioso -> start_node_server();
        _ -> start_tcp_server(Port)
    end.

start_node_server() ->
    case nodes() of
        [] -> io:format("Error: no se hay ningun nodo conectado");
        Nodes ->
            io:format("Se encuentran conectados los siguientes nodos: ~p~n", [Nodes]),
            register(listclient, spawn(?MODULE, listclient, [maps:new()]))
    end.

start_tcp_server(Port) ->
    case gen_tcp:listen(Port, [{active, false}]) of
        {ok, Socket} -> spawn_services(Socket);
        {error, Reason} ->
            io:format(">> Error: no se pudo crear el socket en el puerto ~p (~p).~n", [Port, Reason])
    end.

spawn_services(LSocket) ->
    {_, Port} = inet:port(LSocket),
    io:format(">> Socket creado. Escuchando en puerto ~p.~n", [Port]),
    spawn(?MODULE, dispatcher, [LSocket]),
    register(listclient, spawn(?MODULE, listclient, [maps:new()])),
    ok.

dispatcher(LSocket) ->
    case gen_tcp:accept(LSocket) of
        {ok, Socket} ->
            io:format(">> Se ha conectado un nuevo cliente ~p~n", [Socket]),
            Pid = spawn(?MODULE, psocket, [Socket]),
            gen_tcp:controlling_process(Socket, Pid),
            dispatcher(LSocket);
        {error, Reason} ->
            io:format(">> Error: ~p.~n", [Reason]),
            io:format(">> Cerrando dispatcher, considere lanzarlo nuevamente~n")
    end.

listclient(Clients) ->
    receive
        {new, Username, Caller} ->
            case maps:get(Username, Clients, not_taken) of
                not_taken ->
                    io:format("Se creo el cliente: ~p~n", [Username]),
                    Caller ! {new, Username},
                    listclient(maps:put(Username, 0, Clients));
                _ ->
                    Caller ! {error, username_taken}
            end;
        {dep, Username, Amount, Caller} ->
            case maps:get(Username, Clients, invalid_username) of
                invalid_username ->
                    Caller ! {error, username_taken};
                _ ->
                    io:format("[DEPOSIT] <~s> ~p", [Username, Amount]),
                    Caller ! {dep, Username, Amount},
                    listclient(maps:put(Username, Amount, Clients))
            end;
        {ext, Username, Amount, Caller} ->
            case maps:get(Username, Clients, invalid_username) of
                invalid_username ->
                    Caller ! {error, username_taken};
                ActualAmount ->
                    io:format("[EXT] <~s> ~p", [Username, Amount]),
                    if 
                        ActualAmount - Amount < 0 ->
                            Caller ! {error, not_enough_money};
                        true ->
                            Caller ! {ext, Username, Amount},
                            listclient(maps:put(Username, ActualAmount + Amount, Clients))
                    end
            end;
        {amo, Username, Caller} ->
            case maps:get(Username, Clients, invalid_username) of
                invalid_username ->
                    Caller ! {error, username_taken};
                Amount ->
                    io:format("[AMOUNT] <~s>", [Username]),
                    Caller ! {amo, Username, Amount},
                    listclient(Clients)
            end
    end.

psocket(Socket) ->
    inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, Socket, Data} ->
            Lexemes = string:lexemes(string:trim(Data), " "),
            io:format("~p~n", [Lexemes]),
            case Lexemes of
                ["NEW", Username] ->
                    listclient ! {new, Username, self()},
                    psocket(Socket);
                ["DEP", Username, Amount] ->
                    listclient ! {dep, Username, list_to_integer(Amount), self()},
                    psocket(Socket);
                ["EXT", Username, Amount] ->
                    listclient ! {ext, Username, list_to_integer(Amount), self()},
                    psocket(Socket);
                ["AMO", Username] ->
                    listclient ! {amo, Username, self()},
                    psocket(Socket);
                _ -> io:format("Error: No se pudo ejecutar el comando~n"), psocket(Socket)
            end;
        {tcp_closed, Socket} -> io:format(">> Se ha desconectado el cliente ~p~n", [Socket]);
        {new, Username} ->
            gen_tcp:send(Socket, format("OK ~p ~s", [new, Username])), psocket(Socket);
        {dep, Username, Amount} ->
            gen_tcp:send(Socket, format("OK ~p ~s ~p", [dep, Username, Amount])), psocket(Socket);
        {ext, Username, Amount} ->
            gen_tcp:send(Socket, format("OK ~p ~s ~p", [ext, Username, Amount])), psocket(Socket);
        {amo, Username, Amount} ->
            gen_tcp:send(Socket, format("OK ~p ~s ~p", [amo, Username, Amount])), psocket(Socket)
    end.
