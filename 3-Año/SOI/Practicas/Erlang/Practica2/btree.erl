-module(btree).
-export([new/0]).

-record(node, {value, left, right}).
-record(empty, {}).

new() ->
  #empty{}.

add(Val, empty) ->
  #node{value=Val, left=empty, right=empty};
add(Val, BTree) ->
  if
      Val < BTree#node.value -> add(Val, BTree#node.left);
      true -> add(Val, BTree#node.right)
  end.
