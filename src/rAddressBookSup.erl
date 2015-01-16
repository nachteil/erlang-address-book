%%%-------------------------------------------------------------------
%%% @author yorg
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. sty 2015 09:31
%%%-------------------------------------------------------------------
-module(rAddressBookSup).
-author("yorg").

%% API
-export([start/0, init/0]).

start() ->
  register(frontServer, self()),
  register(supervisorServer, spawn(?MODULE, init, [])).

init() ->
  process_flag(trap_exit, true),
  io:format("rAddressBookSup: Initializing new rAddressBook server...~n"),
  AddressBookServerPid = spawn_link(rAddressBook, init, []),
  io:format("rAddressBookSup: rAddressBook server initialized~n"),
  loop(AddressBookServerPid, []).

loop(AddressBookServerPid, AddressBookBackup) ->
  receive
    {'EXIT', AddressBookServerPid, _} ->
      io:format("rAddressBookSup: Received exit signal from rAddressBook server. Restoring server...~n"),
      NewAddressBookServerPid = spawn_link(rAddressBook, init, []),
      NewAddressBookServerPid ! {restoreServerState, AddressBookBackup},
      loop(NewAddressBookServerPid, AddressBookBackup) ;

    {updateAddressBookBackup, Backup} ->
      loop(AddressBookServerPid, Backup) ;

    serverRestored ->
      io:format("rAddressBookSup: Server successfully restored after crash~n"),
      loop(AddressBookServerPid, AddressBookBackup) ;

    _ ->
        io:format("rAddressBookSup: Unexpected message arrived, ingored it~n"),
        loop(AddressBookServerPid, AddressBookBackup)
  end.

