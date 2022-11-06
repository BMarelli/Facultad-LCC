-module(emptymailbox).

-expor([{emptymailbox, 0}]).

emptymailbox() ->
  receive
    _ ->
      emptymailbox()
    after 0 ->
            ok
  end.

