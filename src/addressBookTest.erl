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
-import(addressBook, [createAddressBook/0, addContact/3, addEmail/4]).
-author("yorg").

%% API
-compile(export_all).

getNamesOnlyAddressBook() ->
  Fn1 = "Name",
  Sn1 = "Surname",
  Fn2 = "OtherName",
  Sn2 = "OtherSurname",
  Fn3 = "YetOtherName",
  Sn3 = "YetOtherSurname",
  FirstElement = {entry, {Fn1, Sn1}, [], []},
  SecontElement = {entry, {Fn2, Sn2}, [], []},
  ThirdElement = {entry, {Fn3, Sn3}, [], []},

  [FirstElement | [SecontElement | [ThirdElement]]].

createAddressBook_test() -> [] = createAddressBook().

addContact_test() ->

  %% given
  [FirstElement, SecondElement, ThirdElement] = getNamesOnlyAddressBook(),
  { _, {Fn1, Sn1}, _, _ } = FirstElement,
  { _, {Fn2, Sn2}, _, _ } = SecondElement,
  { _, {Fn3, Sn3}, _, _ } = ThirdElement,

  %% when
  OneElementList = addContact([], Fn1, Sn1),
  TwoElementList = addContact(OneElementList, Fn2, Sn2),
  ThreeElementList = addContact(TwoElementList, Fn3, Sn3),
  ListSupposedToNotContainDuplicatedElements = addContact(
    addContact(
      addContact(ThreeElementList, Fn3, Sn3), Fn1, Sn1
    ), Fn2, Sn2
  ),

  %% then
  ?assert(OneElementList == [FirstElement]),
  ?assert(OneElementList == addContact(OneElementList, Fn1, Sn1)),

  ?assert(lists:member(FirstElement, TwoElementList)),
  ?assert(lists:member(SecondElement, TwoElementList)),

  ?assert(lists:member(FirstElement, ThreeElementList)),
  ?assert(lists:member(SecondElement, ThreeElementList)),
  ?assert(lists:member(ThirdElement, ThreeElementList)),
  ?assertEqual(length(ListSupposedToNotContainDuplicatedElements), 3),
  ?assertEqual(ThreeElementList, ListSupposedToNotContainDuplicatedElements)
.

%%
%% addEmail_test() ->
%%
%%   %% given
%%   [FirstElement, SecondElement, ThirdElement] = getNamesOnlyAddressBook(),
%%   { _, {Fn1, Sn1}, _, _ } = FirstElement,
%%   { _, {Fn2, Sn2}, _, _ } = SecondElement,
%%   { _, {Fn3, Sn3}, _, _ } = ThirdElement,
%%   FirstEmail = "a@b.c",
%%   SecondEmail = "c@b.a",
%%   ThirdEmail = "x@y.z",
%%
%%   FindByName = fun(AddressBook, Name) -> [X || X <- AddressBook, fun(X) -> {_, XName, _, _} = X, XName == Name end] end,
%%   FindEmailFun = fun(Entry, Email) ->
%%     {_, _, _, Emails} = Entry,
%%     lists:member(Email, Emails)
%%   end,
%%   FindByEmail = fun(AddressBook, Name) -> [X || X <- AddressBook, FindEmailFun] end,
%%
%%   %% when
%%   [FirstElementWithEmail] = addEmail([FirstElement], Fn1, Sn1, FirstEmail),
%%   [FirstElementWithNoDuplicatedEmail] = addEmail([FirstElementWithEmail], Fn1, Sn1, FirstEmail),
%%   ok
%%
%%   %% then
%%
%% .
