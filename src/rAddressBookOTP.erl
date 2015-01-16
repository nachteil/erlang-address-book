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
-export([start_link/1,
  init/1,
  handle_call/3,
  addContact/2,
  addEmail/3,
  addPhone/3,
  removeContact/2,
  removeEmail/1,
  removePhone/1,
  getEmails/2,
  getPhones/2,
  findByEmail/1,
  findByPhone/1,
  setEmployment/4,
  findByCompany/1,
  crash/0,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

%% --------- --------- --------- Public Server API

start_link(InitialValue) ->
  ServerNameTuple = {local, rAddressBookOTP},
  %% API: gen_server:start_link(NameTuple, Module, Argument, Options)
  gen_server:start_link(ServerNameTuple, rAddressBookOTP, InitialValue, [] ).

init(InitialValue) ->
  {ok, InitialValue}.

%% --------- --------- --------- Public client API

addContact(FirstName, LastName) ->
  gen_server:cast(rAddressBookOTP, {addContact, FirstName, LastName}).

addEmail(FirstName, LastName, Email) ->
  gen_server:cast(rAddressBookOTP, {addEmail, FirstName, LastName, Email}).

addPhone(FirstName, LastName, Phone) ->
  gen_server:cast(rAddressBookOTP, {addPhone, FirstName, LastName, Phone}).

removeContact(FirstName, LastName) ->
  gen_server:cast(rAddressBookOTP, {removeContact, FirstName, LastName}).

removeEmail(Email) ->
  gen_server:cast(rAddressBookOTP, {removeEmail, Email}).

removePhone(Phone) ->
  gen_server:cast(rAddressBookOTP, {removePhone, Phone}).

getEmails(FirstName, LastName) ->
  gen_server:call(rAddressBookOTP, {getEmails, FirstName, LastName}).

getPhones(FirstName, LastName) ->
  gen_server:call(rAddressBookOTP, {getPhones, FirstName, LastName}).

findByEmail(Email) ->
  gen_server:call(rAddressBookOTP, {findByEmail, Email}).

findByPhone(Phone) ->
  gen_server:call(rAddressBookOTP, {findByPhone, Phone}).

setEmployment(FirstName, LastName, Company, Position) ->
  gen_server:cast(rAddressBookOTP, {setEmployment, FirstName, LastName, Company, Position}).

findByCompany(CompanyName) ->
  gen_server:call(rAddressBookOTP, {findByCompany, CompanyName}).

crash() ->
  gen_server:cast(rAddressBookOTP, {crash}).

%% --------- --------- --------- gen_server behaviur contract methods

handle_call(Request, _, AddressBook) ->

  case Request of

    {getEmails, FirstName, LastName } ->
      Reply = addressBook:getEmails(AddressBook, FirstName, LastName),
      {reply, Reply, AddressBook} ;

    {getPhones, FirstName, LastName} ->
      Reply = addressBook:getPhones(AddressBook, FirstName, LastName),
      {reply, Reply, AddressBook} ;

    {findByEmail, Email} ->
      Reply = addressBook:findByEmail(AddressBook, Email),
      {reply, Reply, AddressBook} ;

    {findByPhone, Phone} ->
      Reply = addressBook:findByPhone(AddressBook, Phone),
      {reply, Reply, AddressBook} ;

    {findByCompany, Company} ->
      Reply = addressBook:findByCompany(AddressBook, Company),
      {reply, Reply, AddressBook}

  end.

handle_cast(Request, AddressBook) ->

  io:format("Przylaz request: ~p~n", [Request]),

  case Request of

    {addContact, FirstName, LastName } ->
      NewState = addressBook:addContact(AddressBook, FirstName, LastName),
      {noreply, NewState};

    {addEmail, FirstName, LastName, Email} ->
      NewState = addressBook:addEmail(AddressBook, FirstName, LastName, Email),
      {noreply, NewState};

    {addPhone, FirstName, LastName, Phone} ->
      NewState = addressBook:addPhone(AddressBook, FirstName, LastName, Phone),
      {noreply, NewState} ;

    {removeContact, FirstName, LastName} ->
      NewState = addressBook:removeContact(AddressBook, FirstName, LastName),
      {noreply, NewState} ;

    {removeEmail, Email} ->
      NewState = addressBook:removeEmail(AddressBook, Email),
      {noreply, NewState} ;

    {removePhone, Phone} ->
      NewState = addressBook:removePhones(AddressBook, Phone),
      {noreply, NewState} ;

    {setEmployment, FirstName, LastName, Company, Position} ->
      NewState = addressBook:setEmployment(AddressBook, FirstName, LastName, Company, Position),
      {reply, NewState} ;

    {crash} ->
      1 / 0,
      {noreply, AddressBook}

  end.

handle_info(_, State) ->
  {noreply, State}.

terminate(Reason, _) ->
  io:format("rAddressBookOTP: Terminate signal received, ending process~n"),
  Reason.

code_change(_, State, _) ->
  {ok, State}.