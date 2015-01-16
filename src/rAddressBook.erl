%%%-------------------------------------------------------------------
%%% @author yorg
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. sty 2015 19:28
%%%-------------------------------------------------------------------
-module(rAddressBook).
-author("yorg").

%% API
-export([stop/0, addContact/2, findByCompany/1, setEmployment/4, findByPhone/1, findByEmail/1, getPhones/2, getEmails/2, removePhone/1, removeEmail/1, addEmail/3, addPhone/3, removeContact/2, init/0, crash/0]).

stop() ->
  server ! terminate,
  receive
    M -> M
  end.

addContact(FirstName, LastName) ->
  server ! {addContact, FirstName, LastName},
  awaitAndReturnResponse().

addEmail(FirstName, LastName, Email) ->
  server ! {addEmail, FirstName, LastName, Email},
  awaitAndReturnResponse().

addPhone(FirstName, LastName, Phone) ->
  server ! {addPhone, FirstName, LastName, Phone},
  awaitAndReturnResponse().

removeContact(FirstName, LastName) ->
  server ! {removeContact, FirstName, LastName},
  awaitAndReturnResponse().

removeEmail(Email) ->
  server ! {removeEmail, Email},
  awaitAndReturnResponse().

removePhone(Phone) ->
  server ! {removePhone, Phone},
  awaitAndReturnResponse().

getEmails(FirstName, LastName) ->
  server ! {getEmails, FirstName, LastName},
  awaitAndReturnResponse().

getPhones(FirstName, LastName) ->
  server ! {getPhones, FirstName, LastName},
  awaitAndReturnResponse().

findByEmail(Email) ->
  server ! {findByEmail, Email},
  awaitAndReturnResponse().

findByPhone(Phone) ->
  server ! {findByPhone, Phone},
  awaitAndReturnResponse().

setEmployment(FirstName, LastName, Company, Position) ->
  server ! {setEmployment, FirstName, LastName, Company, Position},
  awaitAndReturnResponse().

findByCompany(CompanyName) ->
  server ! {findByCompany, CompanyName},
  awaitAndReturnResponse().

crash() ->
  server ! {crash},
  awaitAndReturnResponse().

init() ->
  register(server, self()),
  NeuAddressBook = addressBook:createAddressBook(),
  io:format("rAddressBook: New server initialized~n"),
  loop(NeuAddressBook).


awaitAndReturnResponse() ->
  receive
    Message -> Message
  end.

loop(AddressBook) ->
  supervisorServer ! {updateAddressBookBackup, AddressBook},
  receive
    {addContact, FirstName, LastName } ->
      frontServer ! ok,
      loop(addressBook:addContact(AddressBook, FirstName, LastName)) ;

    {addEmail, FirstName, LastName, Email} ->
      frontServer ! ok,
      loop(addressBook:addEmail(AddressBook, FirstName, LastName, Email)) ;

    {addPhone, FirstName, LastName, Phone} ->
      frontServer ! ok,
      loop(addressBook:addPhone(AddressBook, FirstName, LastName, Phone)) ;

    {removeContact, FirstName, LastName} ->
      frontServer ! ok,
      loop(addressBook:removeContact(AddressBook, FirstName, LastName)) ;

    {removeEmail, Email} ->
      frontServer ! ok,
      loop(addressBook:removeEmail(AddressBook, Email)) ;

    {removePhone, Phone} ->
      frontServer ! ok,
      loop(addressBook:removePhones(AddressBook, Phone)) ;

    {getEmails, FirstName, LastName } ->
      frontServer ! addressBook:getEmails(AddressBook, FirstName, LastName),
      loop(AddressBook) ;

    {getPhones, FirstName, LastName} ->
      frontServer ! addressBook:getPhones(AddressBook, FirstName, LastName),
      loop(AddressBook) ;

    {findByEmail, Email} ->
      frontServer ! addressBook:findByEmail(AddressBook, Email),
      loop(AddressBook) ;

    {findByPhone, Phone} ->
      frontServer ! addressBook:findByPhone(AddressBook, Phone),
      loop(AddressBook) ;

    {setEmployment, FirstName, LastName, Company, Position} ->
      frontServer ! ok,
      loop(addressBook:setEmployment(AddressBook, FirstName, LastName, Company, Position)) ;

    {findByCompany, Company} ->
      frontServer ! addressBook:findByCompany(AddressBook, Company),
      loop(AddressBook) ;

    {crash} ->
      frontServer ! ok,
      1 / 0,
      loop(AddressBook) ;

    {restoreServerState, State} ->
      supervisorServer ! serverRestored,
      loop(State) ;

    terminate ->
      frontServer ! ok,
      ok
  end.
