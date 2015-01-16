%%%-------------------------------------------------------------------
%%% @author yorg
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. sty 2015 13:23
%%%-------------------------------------------------------------------
-module(rAddressBookOTP).
-author("yorg").

-behaviour(gen_server).

%% API
-export([start_link/0]).

start_link() ->
  ServerNameTuple = {local, rAddressBookOTP},
  gen_server:start_link(ServerNameTuple, rAddressBookOTP, [], [] ).


handleCall()