%%%-------------------------------------------------------------------
%%% @author yorg
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. sty 2015 11:19
%%%-------------------------------------------------------------------
-module(addressBookTest).
-include_lib("eunit/include/eunit.hrl").
-import(addressBook, [createAddressBook/0, addContact/3]).
-author("yorg").

%% API
-compile(export_all).

createAddressBook_test() -> [] = createAddressBook().

addContact_test() ->

  %% given
  FirstElement = {entry, {"Name", "Surname"}, [], []},
  SecontElement = {entry, {"OtherName", "OtherSurname"}, [], []},


  %% when
  OneElementList = addContact([], "Name", "Surname"),
  TwoElementList = addContact(OneElementList, "OtherName", "OtherSurname"),

  %% then
  ?assert(OneElementList == [FirstElement]),
  ?assert(OneElementList == addContact(OneElementList, "Name", "Surname")),
  ?assert(lists:member(FirstElement, TwoElementList)),
  ?assert(lists:member(SecontElement, TwoElementList)).