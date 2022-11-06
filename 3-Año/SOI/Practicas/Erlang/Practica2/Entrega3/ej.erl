-module(ej).

-compile(export_all).

w() ->
  io:format(user, "Trabajando...~n", []),
  timer:sleep(2000),
  w().

node_manager([]) -> ok;
node_manager([X|Xs]) ->
  spawn_link(X, ?MODULE, w, []),
  receive
    {'EXIT', Node, _} ->
      io:format("Murio: ~p~n", [Node])
  end,
  node_manager(Xs).

s() ->
  process_flag(trap_exit, true),
  node_manager(nodes()).

