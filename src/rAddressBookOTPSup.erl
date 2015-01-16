%%%-------------------------------------------------------------------
%%% @author yorg
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. sty 2015 13:28
%%%-------------------------------------------------------------------
-module(rAddressBookOTPSup).
-author("yorg").

-behaviour(supervisor).

%% API
-export([start_addressbook_server/0, init/1]).

start_addressbook_server() ->
  SupervisorNameTuple = {local, rAddressBookOTPSup},
  supervisor:start_link(SupervisorNameTuple, ?MODULE, []).

init(_) ->
  ChildId = rAddressBookOTP,
  ChildStartFunc = {rAddressBookOTP, start_link, [[]]},
  Restart = permanent,
  Shutdown = brutal_kill,
  Type = worker,
  Modules = [rAddressBookOTP],
  RestartStrategy = one_for_one,
  MaxR = 5,
  MaxT = 1,
  ChildSpec = {ChildId, ChildStartFunc, Restart, Shutdown, Type, Modules},
  {ok, {{RestartStrategy, MaxR, MaxT}, [ChildSpec]}}.
