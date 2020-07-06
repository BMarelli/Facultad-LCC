-module(ms).
-export([start/1, master_init/1, master/1]).
-export([to_slave/0, echo/0, start_slaves/1, replace_slave/3]).

echo() ->
    receive
        die -> exit(die);
        Msj -> io:format("[slave: ~p] ~s~n", [self(), Msj]), echo()
    end.

replace_slave(X, Y, [Z | Zs]) when Y == Z -> [X | Zs];
replace_slave(X, Y, [Z | Zs]) -> [Z | replace_slave(X, Y, Zs)].

to_slave() ->
    CMDString = string:trim(io:get_line(">> ")),
    [Msj, N] = string:lexemes(CMDString, " "),
    case Msj of
        "EXIT" -> ok;
        "DIE" -> master ! {to_slave, die, list_to_integer(N)};
        _ -> master ! {to_slave, Msj, list_to_integer(N)}
    end,
    to_slave().

start_slaves(0) -> [];
start_slaves(N) ->
    New = spawn_link(?MODULE, echo, []),
    io:format("start ~p ~n", [New]),
    [New | start_slaves(N - 1)].

master_init(N) ->
    io:format("[master: ~p] start ~n", [self()]),
    Slaves = start_slaves(N),
    process_flag(trap_exit, true),
    master(Slaves).

master(Slaves) ->
    receive
        {'EXIT', Slave, die} ->
            New = spawn_link(?MODULE, echo, []),
            io:format("start ~p ~n", [New]),
            master(replace_slave(New, Slave, Slaves));
        {to_slave, Msj, Slave} ->
            SlavePID = lists:nth(Slave, Slaves),
            SlavePID ! Msj,
            master(Slaves)
    end.

start(N) ->
    register(master, spawn(?MODULE, master_init, [N])),
    ok.
