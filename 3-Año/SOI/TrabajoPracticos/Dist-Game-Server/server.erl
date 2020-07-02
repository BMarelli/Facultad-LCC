-module(server).
-export([start/0, dispatcher/1, pstat/0, pbalance/1, userlist/1, gamelist/2, psocket/1, pcomando/3, display_current_state/0]).

-define(PSTAT_INTERVAL, 10000).
-define(DEFAULT_PORT, 8000).

-record(game, {player_1, player_2 = none, board = [0, 0, 0, 0, 0, 0, 0, 0, 0], turn = 1, observers = []}).

globalise(Id) -> format("~s|~s", [Id, node()]).

parse_globalised_id(GlobalId) ->
    case string:lexemes(GlobalId, "|") of
        [Id, Node] ->
            NodeAtom = list_to_atom(Node),
            case lists:member(NodeAtom, [node() | nodes()]) of
                true -> {Id, NodeAtom};
                false -> invalid_id
            end;
        _ -> invalid_id
    end.

format(String, Data) -> lists:flatten(io_lib:format(String, Data)).

display_current_state() ->
    userlist ! display_current_state,
    gamelist ! display_current_state,
    ok.

start() ->
    case gen_tcp:listen(?DEFAULT_PORT, [{active, false}]) of
        {ok, Socket} -> spawn_services(Socket);
        {error, Reason} ->
            io:format(">> Error: no se pudo crear el socket en el puerto ~p (~p).~n", [?DEFAULT_PORT, Reason]),
            io:format(">> Reintentando en otro puerto...~n"),
            case gen_tcp:listen(0, [{active, false}]) of
                {ok, Socket} -> spawn_services(Socket);
                {error, Reason2} ->
                    io:format(">> Error: no se pudo crear el socket (~p).~n", [Reason2]),
                    erlang:error(cant_start_server)
            end
    end,
    ok.

spawn_services(ListenSocket) ->
    {_, Port} = inet:port(ListenSocket),
    io:format(">> Socket creado. Escuchando en puerto ~p.~n", [Port]),
    spawn(?MODULE, dispatcher, [ListenSocket]),
    spawn(?MODULE, pstat, []),
    register(pbalance, spawn(?MODULE, pbalance, [maps:new()])),
    register(userlist, spawn(?MODULE, userlist, [maps:new()])),
    register(gamelist, spawn(?MODULE, gamelist, [maps:new(), 1])),
    ok.

dispatcher(ListenSocket) ->
    case gen_tcp:accept(ListenSocket) of
        {ok, Socket} ->
            io:format(">> Se ha conectado un nuevo cliente ~p~n", [Socket]),
            Pid = spawn(?MODULE, psocket, [Socket]),
            gen_tcp:controlling_process(Socket, Pid),
            dispatcher(ListenSocket);
        {error, Reason} ->
            io:format(">> Error: ~p.~n", [Reason]),
            io:format(">> Cerrando dispatcher, considere lanzarlo nuevamente~n")
    end.

pstat() ->
    Load = erlang:statistics(run_queue),
    [{pbalance, Node} ! {update_node_loads, node(), Load} || Node <- [node() | nodes()]],
    timer:sleep(?PSTAT_INTERVAL),
    pstat().

pbalance(NodeLoads) ->
    receive
        {get_best_node, PSocketId} ->
            {BestNode, _} = lists:nth(1, lists:keysort(2, maps:to_list(NodeLoads))),
            PSocketId ! {best_node, BestNode},
            pbalance(NodeLoads);
        {update_node_loads, Node, Load} -> pbalance(maps:put(Node, Load, NodeLoads))
    end.

userlist(Users) ->
    receive
        {put_user, Username, PSocketId} ->
            case lists:member($|, Username) or lists:member($,, Username) of
                true -> PSocketId ! {put_user, invalid_username}, userlist(Users);
                false ->
                    case lists:member(Username, maps:keys(Users)) of
                        true -> PSocketId ! {put_user, username_taken}, userlist(Users);
                        false -> PSocketId ! {put_user, ok}, userlist(maps:put(Username, PSocketId, Users))
                    end
            end;
        {get_user, Username, Caller} ->
            case maps:get(Username, Users, invalid_username) of
                invalid_username -> Caller ! {get_user, invalid_username};
                PSocketId -> Caller ! {get_user, PSocketId}
            end,
            userlist(Users);
        {remove_user, Username} -> userlist(maps:remove(Username, Users));
        display_current_state ->
            io:format("Userlist: ~p~n", [Users]),
            [PSocketId ! display_current_state || PSocketId <- maps:values(Users)],
            userlist(Users)
    end.

gamelist(Games, Id) ->
    receive
        {create_game, Player1, Caller} ->
            GameId = integer_to_list(Id),
            Game = #game{player_1 = Player1},
            Caller ! {create_game, globalise(GameId)},
            gamelist(maps:put(GameId, Game, Games), Id + 1);
        {get_globalised_games, Caller} ->
            GlobalisedGames = [format("~s,~s,~s", [globalise(GameId), Game#game.player_1, Game#game.player_2]) || {GameId, Game} <- maps:to_list(Games)],
            Caller ! {globalised_games, GlobalisedGames},
            gamelist(Games, Id);
        {accept_game, Player2, GameId, Caller} ->
            case maps:get(GameId, Games, invalid_game_id) of
                invalid_game_id ->
                    Caller ! {accept_game, invalid_game_id},
                    gamelist(Games, Id);
                Game ->
                    {Game_, Response} = accept_game(Game, Player2),
                    Caller ! {accept_game, Response},
                    gamelist(maps:update(GameId, Game_, Games), Id)
            end;
        {observe_game, Observer, GameId, Caller} ->
            case maps:get(GameId, Games, invalid_game_id) of
                invalid_game_id ->
                    Caller ! {observe_game, invalid_game_id},
                    gamelist(Games, Id);
                Game ->
                    {Game_, Response} = observe_game(Game, Observer),
                    Caller ! {observe_game, Response},
                    gamelist(maps:update(GameId, Game_, Games), Id)
            end;
        {player_move, Player, GameId, Move, Caller} ->
            case maps:get(GameId, Games, invalid_game_id) of
                invalid_game_id ->
                    Caller ! {player_move, invalid_game_id},
                    gamelist(Games, Id);
                Game ->
                    {Game_, Response} = player_move(Game, Player, Move),
                    Caller ! {player_move, Response},
                    case Response of
                        {game_ended, _} ->
                            update_opponent(globalise(GameId), Game_, Response),
                            update_observers(globalise(GameId), Game_#game.observers, Response),
                            gamelist(maps:remove(GameId, Games), Id);
                        {board, _} ->
                            update_opponent(globalise(GameId), Game_, Response),
                            update_observers(globalise(GameId), Game_#game.observers, Response),
                            gamelist(maps:update(GameId, Game_, Games), Id);
                        _ -> gamelist(maps:update(GameId, Game_, Games), Id)
                    end
            end;
        {leave_game, Observer, GameId, Caller} ->
            case maps:get(GameId, Games, invalid_game_id) of
                invalid_game_id ->
                    Caller ! {leave_game, invalid_game_id},
                    gamelist(Games, Id);
                Game ->
                    {Game_, Response} = leave_game(Game, Observer),
                    Caller ! {leave_game, Response},
                    gamelist(maps:update(GameId, Game_, Games), Id)
            end;
        display_current_state ->
            io:format("Gamelist: ~p~n", [Games]),
            gamelist(Games, Id)
    end.

psocket(Socket) ->
    inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, Socket, Data} ->
            Lexemes = string:lexemes(string:trim(Data), " "),
            case Lexemes of
                ["CON", Username] ->
                    userlist ! {put_user, Username, self()},
                    receive
                        {put_user, ok} ->
                            io:format(">> El cliente ~p se ha registrado como ~s~n", [Socket, Username]),
                            gen_tcp:send(Socket, "OK"),
                            psocket(Socket, Username, [], [], 1);
                        {put_user, invalid_username} -> gen_tcp:send(Socket, "ERROR invalid_username"), psocket(Socket);
                        {put_user, username_taken} -> gen_tcp:send(Socket, "ERROR username_taken"), psocket(Socket)
                    end;
                _ -> gen_tcp:send(Socket, "ERROR not_registered"), psocket(Socket)
            end;
        {tcp_closed, Socket} -> io:format(">> Se ha desconectado el cliente ~p~n", [Socket])
    end.
psocket(Socket, Username, Playing, Observing, Id) ->
    inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, Socket, Data} ->
            pbalance ! {get_best_node, self()},
            receive {best_node, BestNode} -> spawn(BestNode, ?MODULE, pcomando, [Data, globalise(Username), self()]) end,
            psocket(Socket, Username, Playing, Observing, Id);
        {tcp_closed, Socket} ->
            io:format(">> Se ha desconectado el cliente ~s~n", [Username]),
            userlist ! {remove_user, Username},
            unsubscribe_playing(Username, Playing),
            unsubscribe_observing(Username, Observing);
        bye ->
            io:format(">> Se ha desconectado el cliente ~s~n", [Username]),
            userlist ! {remove_user, Username},
            unsubscribe_playing(Username, Playing),
            unsubscribe_observing(Username, Observing),
            gen_tcp:close(Socket);
        {lsg, CMDID, Games} ->
            io:format(">> Enviando lista de juegos al cliente ~s~n", [Username]),
            case Games of
                [] -> gen_tcp:send(Socket, format("OK ~s", [CMDID]));
                _ -> gen_tcp:send(Socket, format("OK ~s ~s", [CMDID, string:join(Games, " ")]))
            end,
            psocket(Socket, Username, Playing, Observing, Id);
        {new, CMDID, GlobalGameId} ->
            io:format(">> Se creó un nuevo juego para el cliente ~s~n", [Username]),
            gen_tcp:send(Socket, format("OK ~s ~s", [CMDID, GlobalGameId])),
            psocket(Socket, Username, [GlobalGameId | Playing], Observing, Id);
        {acc, CMDID, GlobalGameId} ->
            io:format(">> El cliente ~s se ha unido al juego ~s~n", [Username, GlobalGameId]),
            gen_tcp:send(Socket, format("OK ~s", [CMDID])),
            psocket(Socket, Username, [GlobalGameId | Playing], lists:delete(GlobalGameId, Observing), Id);
        {pla, CMDID, GlobalGameId, board, Board} ->
            io:format(">> El cliente ~s ha hecho una jugada en el juego ~s~n", [Username, GlobalGameId]),
            gen_tcp:send(Socket, format("OK ~s ~s board ~s", [CMDID, GlobalGameId, Board])),
            psocket(Socket, Username, Playing, Observing, Id);
        {pla, CMDID, GlobalGameId, game_ended, Winner} ->
            io:format(">> El cliente ~s ha hecho una jugada en el juego ~s~n", [Username, GlobalGameId]),
            io:format(">> El juego ~s terminó. Ganador: ~s~n", [GlobalGameId, Winner]),
            gen_tcp:send(Socket, format("OK ~s ~s game_ended ~s", [CMDID, GlobalGameId, Winner])),
            psocket(Socket, Username, lists:delete(GlobalGameId, Playing), Observing, Id);
        {obs, CMDID, GlobalGameId} ->
            io:format(">> El cliente ~s ha comenzado a observar el juego ~s~n", [Username, GlobalGameId]),
            gen_tcp:send(Socket, format("OK ~s", [CMDID])),
            psocket(Socket, Username, Playing, [GlobalGameId | Observing], Id);
        {lea, CMDID, GlobalGameId} ->
            io:format(">> El cliente ~s ha dejado de observar el juego ~s~n", [Username, GlobalGameId]),
            gen_tcp:send(Socket, format("OK ~s", [CMDID])),
            psocket(Socket, Username, Playing, lists:delete(GlobalGameId, Observing), Id);
        {upd, GlobalGameId, {board, Board}} ->
            io:format(">> Enviando actualización sobre el juego ~s a ~s~n", [GlobalGameId, Username]),
            gen_tcp:send(Socket, format("UPD ~s ~s board ~s", [integer_to_list(Id), GlobalGameId, Board])),
            psocket(Socket, Username, Playing, Observing, Id + 1);
        {upd, GlobalGameId, {game_ended, Winner}} ->
            io:format(">> Enviando actualización sobre el juego ~s a ~s~n", [GlobalGameId, Username]),
            gen_tcp:send(Socket, format("UPD ~s ~s game_ended ~s", [integer_to_list(Id), GlobalGameId, Winner])),
            psocket(Socket, Username, lists:delete(GlobalGameId, Playing), lists:delete(GlobalGameId, Observing), Id + 1);
        {error, Args} ->
            io:format(">> El pedido del cliente ~s resultó en un error: ERROR ~s~n", [Username, string:join(Args, " ")]),
            gen_tcp:send(Socket, format("ERROR ~s", [string:join(Args, " ")])),
            psocket(Socket, Username, Playing, Observing, Id);
        display_current_state ->
            io:format("~s: Playing: ~p, Observing: ~p~n", [Username, Playing, Observing]),
            psocket(Socket, Username, Playing, Observing, Id)
    end.

pcomando(Data, Username, Caller) ->
    Lexemes = string:lexemes(string:trim(Data), " "),
    case Lexemes of
        ["OK", _] -> ok; % Respuestas del usuario a UPD
        ["CON", _] -> Caller ! {error, ["already_registered"]};
        ["BYE"] -> Caller ! bye;
        [CMD, CMDID | Args] ->
            case {CMD, Args} of
                {"LSG", []} ->
                    Games = lists:concat([get_games(Node) || Node <- [node() | nodes()]]),
                    Caller ! {lsg, CMDID, Games};
                {"NEW", []} ->
                    gamelist ! {create_game, Username, self()},
                    receive {create_game, GlobalGameId} -> Caller ! {new, CMDID, GlobalGameId} end;
                {"ACC", [GlobalGameId]} ->
                    case parse_globalised_id(GlobalGameId) of
                        invalid_id -> Caller ! {error, [CMDID, "invalid_game_id"]};
                        {Id, Node} ->
                            {gamelist, Node} ! {accept_game, Username, Id, self()},
                            receive
                                {accept_game, ok} -> Caller ! {acc, CMDID, GlobalGameId};
                                {accept_game, Response} -> Caller ! {error, [CMDID, atom_to_list(Response)]}
                            end
                    end;
                {"PLA", [GlobalGameId, Move]} ->
                    case parse_globalised_id(GlobalGameId) of
                        invalid_id -> Caller ! {error, [CMDID, "invalid_game_id"]};
                        {Id, Node} ->
                            {gamelist, Node} ! {player_move, Username, Id, Move, self()},
                            receive
                                {player_move, {board, Board}} -> Caller ! {pla, CMDID, GlobalGameId, board, Board};
                                {player_move, {game_ended, Winner}} -> Caller ! {pla, CMDID, GlobalGameId, game_ended, Winner};
                                {player_move, Response} -> Caller ! {error, [CMDID, atom_to_list(Response)]}
                            end
                    end;
                {"OBS", [GlobalGameId]} ->
                    case parse_globalised_id(GlobalGameId) of
                        invalid_id -> Caller ! {error, [CMDID, "invalid_game_id"]};
                        {Id, Node} ->
                            {gamelist, Node} ! {observe_game, Username, Id, self()},
                            receive
                                {observe_game, ok} -> Caller ! {obs, CMDID, GlobalGameId};
                                {observe_game, Response} -> Caller ! {error, [CMDID, atom_to_list(Response)]}
                            end
                    end;
                {"LEA", [GlobalGameId]} ->
                    case parse_globalised_id(GlobalGameId) of
                        invalid_id -> Caller ! {error, [CMDID, "invalid_game_id"]};
                        {Id, Node} ->
                            {gamelist, Node} ! {leave_game, Username, Id, self()},
                            receive
                                {leave_game, ok} -> Caller ! {lea, CMDID, GlobalGameId};
                                {leave_game, Response} -> Caller ! {error, [CMDID, atom_to_list(Response)]}
                            end
                    end;
                _ -> Caller ! {error, [CMDID, "invalid_command"]}
            end;
        _ -> Caller ! {error, ["invalid_command"]}
    end.

get_games(Node) ->
    {gamelist, Node} ! {get_globalised_games, self()},
    receive {globalised_games, Games} -> Games end.

unsubscribe_playing(_, []) -> ok;
unsubscribe_playing(Username, [GlobalGameId | Playing]) ->
    case parse_globalised_id(GlobalGameId) of
        invalid_id -> unsubscribe_playing(Username, Playing);
        {Id, Node} ->
            {gamelist, Node} ! {player_move, globalise(Username), Id, "quit", self()},
            receive {player_move, _} -> unsubscribe_playing(Username, Playing) end
    end.

unsubscribe_observing(_, []) -> ok;
unsubscribe_observing(Username, [GlobalGameId | Observing]) ->
    case parse_globalised_id(GlobalGameId) of
        invalid_id -> unsubscribe_observing(Username, Observing);
        {Id, Node} ->
            {gamelist, Node} ! {leave_game, globalise(Username), Id, self()},
            receive {leave_game, _} -> unsubscribe_observing(Username, Observing) end
    end.

accept_game(Game = #game{player_1 = Player2}, Player2) -> {Game, already_playing};
accept_game(Game = #game{player_2 = Player2}, Player2) -> {Game, already_playing};
accept_game(Game = #game{player_2 = none, observers = Observers}, Player2) -> {Game#game{player_2 = Player2, observers = lists:delete(Player2, Observers)}, ok};
accept_game(Game, _) -> {Game, game_full}.

observe_game(Game = #game{player_1 = Observer}, Observer) -> {Game, cant_observe_self};
observe_game(Game = #game{player_2 = Observer}, Observer) -> {Game, cant_observe_self};
observe_game(Game = #game{observers = Observers}, Observer) ->
    case lists:member(Observer, Observers) of
        true -> {Game, already_observing};
        false -> {Game#game{observers = [Observer | Observers]}, ok}
    end.

leave_game(Game = #game{observers = Observers}, Observer) ->
    case lists:member(Observer, Observers) of
        true -> {Game#game{observers = lists:delete(Observer, Observers)}, ok};
        false -> {Game, not_an_observer}
    end.

player_move(Game = #game{player_1 = Player1, player_2 = Player2}, Player, "quit") ->
    if
        Player == Player1 -> {Game#game{turn = -1}, {game_ended, Player2}};
        Player == Player2 -> {Game#game{turn = 1}, {game_ended, Player1}};
        true -> {Game, not_a_player}
    end;
player_move(Game = #game{player_2 = none}, _, _) -> {Game, wait_for_opponent_to_join};
player_move(Game = #game{player_1 = Player, turn = -1}, Player, _) -> {Game, not_your_turn};
player_move(Game = #game{player_2 = Player, turn = 1}, Player, _) -> {Game, not_your_turn};
player_move(Game = #game{board = Board, player_1 = Player1, player_2 = Player2, turn = Turn}, Player, MoveStr) ->
    case lists:member(Player, [Player1, Player2]) of
        false -> {Game, not_a_player};
        true ->
            try list_to_integer(MoveStr) of
                Move ->
                    case Move < 1 orelse Move > 9 orelse lists:nth(Move, Board) =/= 0 of
                        true -> {Game, invalid_move};
                        false ->
                            Board_ = lists:sublist(Board, Move - 1) ++ [Turn] ++ lists:nthtail(Move, Board),
                            Game_ = Game#game{board=Board_, turn = Turn * -1},
                            BoardStr = string:join([integer_to_list(Value) || Value <- Board_], ","),
                            case check_winner(Board_, Turn, Player) of
                                false -> {Game_, {board, BoardStr}};
                                Winner -> {Game_, {game_ended, Winner}}
                            end
                    end
            catch _:_ -> {Game, invalid_move}
            end
    end.

update_opponent(_, #game{player_2 = none}, _) -> ok;
update_opponent(GlobalGameId, #game{player_1 = Player1, player_2 = Player2, turn = Turn}, Response) ->
    case Turn of
        1 -> Player = Player1;
        -1 -> Player = Player2
    end,
    case parse_globalised_id(Player) of
        invalid_id -> ok;
        {Username, Node} ->
            {userlist, Node} ! {get_user, Username, self()},
            receive
                {get_user, invalid_username} -> ok;
                {get_user, PSocketId} -> PSocketId ! {upd, GlobalGameId, Response}
            end
    end.

update_observers(_, [], _) -> ok;
update_observers(GlobalGameId, [Observer | Observers], Response) ->
    case parse_globalised_id(Observer) of
        invalid_id -> update_observers(GlobalGameId, Observers, Response);
        {Username, Node} ->
            {userlist, Node} ! {get_user, Username, self()},
            receive
                {get_user, invalid_username} -> ok;
                {get_user, PSocketId} -> PSocketId ! {upd, GlobalGameId, Response}
            end,
            update_observers(GlobalGameId, Observers, Response)
    end.

check_winner([A11, A12, A13, A21, A22, A23, A31, A32, A33] = Board, Turn, Player) ->
    Sums = [A11+A12+A13, A21+A22+A23, A31+A32+A33, A11+A21+A31, A12+A22+A32, A13+A23+A33, A11+A22+A33, A13+A22+A31],
    case Turn of
        1 -> X = lists:max(Sums);
        -1 -> X = lists:min(Sums)
    end,
    Condition = 3 * Turn,
    case {lists:member(0, Board), X} of
        {false, _} -> "DRAW";
        {_, Condition} -> Player;
        _ -> false
    end.