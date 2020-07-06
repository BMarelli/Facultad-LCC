-module(servnomb).

-export([start/0, client/0, listanombres/2]).

start() ->
    register(listanombres, spawn(?MODULE, listanombres, [maps:new(), 1])),
    ok.

listanombres(Nombres, Id) ->
    receive
        {nuevoId, NombreId, Caller} ->
            Caller ! {nuevoId, Id},
            listanombres(maps:put(Id, NombreId, Nombres), Id + 1);
        {verLista, Caller} ->
            Caller ! {verLista, maps:keys(Nombres)},
            listanombres(Nombres, Id);
        {buscarId, NombreId, Caller} ->
            Caller ! {buscarId, maps:find(NombreId, Nombres)},
            listanombres(Nombres, Id);
        {finalizar, Caller} -> Caller ! {finalizar, ok}
    end.

client() ->
    CMDString = string:trim(io:get_line(">> ")),
    Lexemes = string:lexemes(CMDString, " "),
    case Lexemes of
        [] -> client();
        ["BYE"] ->
            listanombres ! {finalizar, self()},
            receive {finalizar, Res} -> io:format("[BYE] ~p~n", [Res]) end;
        ["LSG"] -> 
            listanombres ! {verLista, self()}, 
            receive {verLista, Lista} -> io:format("[LSG] ~p~n", [Lista]) end,
            client();
        ["NEW" | NombreId] ->
            listanombres ! {nuevoId, NombreId, self()},
            receive {nuevoId, Id} -> io:format("[NEW] ~p~n", [Id]) end,
            client();
        ["SCH" | NombreId] ->
            listanombres ! {buscarId, NombreId, self()},
            receive {buscarId, Id} -> io:format("[SCH] ~p~n", [Id]) end,
            client()
    end.
