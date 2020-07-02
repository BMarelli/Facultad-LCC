-module(pingpong).
-export([start/0, ping/2, pong/0]).

ping(0, Pong_ID) ->
    Pong_ID ! fin,
    io:format("Fin Ping~n");
ping(N, Pong_ID) ->
    Pong_ID ! {ping , self()},
    io:format("Ping a ~p ~n",[Pong_ID]),
    receive
        pong ->
            io:format("Recv Pong!~n");
        _ ->
            io:format("WHAT!~n")
    end,
    ping(N - 1, Pong_ID).

pong() ->
    receive
        {ping, Ping_ID} ->
            io:format("Pong recibe ping de ~p ~n",[Ping_ID]),
            Ping_ID ! pong,
        pong();
        fin -> io:format("Termina~n");
        _ -> io:format("Que?~n")
    end.

start() ->
    Pong_ID = spawn(pingpong,pong,[]),
    spawn(pingpong, ping, [10, Pong_ID]).
