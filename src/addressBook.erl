%%%-------------------------------------------------------------------
%%% @author yorg
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. sty 2015 10:22
%%%-------------------------------------------------------------------

-module(addressBook).
-author("yorg").

-record(entry, {
  fullName,
  phones = [],
  emails = []
}).

%% API
-export([createAddressBook/0, addContact/3]).


createAddressBook() ->
  [].

mayAdd(FilterFunction, AddressBook) ->
  case lists:filter(FilterFunction, AddressBook) of
    [] -> true;
    _  -> false
  end.

addContact(AddressBook, FirstName, LastName) ->
  NameFilter = fun(CurrentEntry) -> CurrentEntry#entry.fullName == {FirstName, LastName} end,
  case mayAdd(NameFilter, AddressBook) of
    true  -> [#entry{fullName = {FirstName, LastName}} | AddressBook];
    _ -> AddressBook
  end.

addEmail(AddressBook, FirstName, LastName, Email) ->
  EmailFilter = fun(CurrentEntry) -> lists:member(Email, CurrentEntry#entry.emails) end,
  case mayAdd()

