-module(kitty_gen_server).
-export([
  start_link/0, order_cat/4, 
  return_cat/2, close_shop/1,
  handle_call/3, handle_cast/2, init/1,
  handle_info/2, terminate/2]).

-behaviour(gen_server).



-record(cat, {name,color=green,description}).

start_link() -> gen_server:start_link(?MODULE, [], []).

init([]) -> {ok, []}.

order_cat(Pid, Name, Color, Description) ->
  gen_server:call(Pid, {order, Name, Color, Description}).

return_cat(Pid, Cat=#cat{}) ->
  gen_server:cast(Pid,{return, Cat}).

close_shop(Pid) ->
  gen_server:call(Pid, terminate).

handle_call({order, Name, Color, Description}, _From, Cats) ->
  if Cats =:= [] ->
      {reply, make_cat(Name, Color, Description), Cats};
     Cats =/= [] ->
      {reply, hd(Cats), tl(Cats)}
  end;

handle_call(terminate, _From, Cats) ->
  {stop, normal, ok, Cats}.

handle_cast({return, Cat=#cat{}}, Cats) ->
  {noreply, [Cat|Cats]}.

handle_info(Msg, Cats) ->
  io:format("Unexpected message: ~p~n", [Msg]),
  {noreply, Cats}.

terminate(normal, Cats) -> 
  [io:format("~p was set free.~n", [C#cat.name]) || C <- Cats],
  ok.

code_change(_OldVer, State, _Extra) ->
  {ok, State}.

make_cat(Name, Color, Description) ->
  #cat{name=Name, color=Color, description=Description}.


