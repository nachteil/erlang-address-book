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
-export([init/0]).

start_link() ->


init() ->
  ok.
