-module(ms).

-import(lists, [nth/2]).

-export([start/1, to_slave/2]).
-export([echo/0, master_work/1, master_start/1, replacenth/3]).

echo() ->
  receive
    die ->
      exit(die);
    Msj ->
      io:format("~p -> ~p~n", [self(), Msj]),
      echo()
  end.

start_slave(0) ->
  [];
start_slave(N) ->
  New = spawn_link(?MODULE, echo, []),
  io:format("start ~p ~n", [New]),
  [New | start_slave(N - 1)].

replacenth(_, _, []) ->
  [];
replacenth(X, Y, [Z | Zs]) ->
  if Y == Z ->
       [X | Zs];
     true ->
       [Z | replacenth(X, Y, Zs)]
  end.

master_start(N) ->
  Ps = start_slave(N),
  process_flag(trap_exit, true),
  master_work(Ps),
  ok.

master_work(Ps) ->
  receive
    {'EXIT', Slave, die} ->
      New = spawn_link(?MODULE, echo, []),
      io:format("start ~p ~n", [New]),
      master_work(replacenth(New, Slave, Ps));
    {Msj, N} ->
      Slave = lists:nth(N, Ps),
      Slave ! Msj,
      master_work(Ps)
  end.

to_slave(Msj, N) ->
  master ! {Msj, N},
  ok.

start(N) ->
  Master = spawn(?MODULE, master_start, [N]),
  io:format("master: start ~p~n", [Master]),
  register(master, Master),
  ok.

