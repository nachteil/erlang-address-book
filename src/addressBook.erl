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
  emails = [],
  employment = {}
}).

%% API
-export([createAddressBook/0,
  addContact/3,
  addEmail/4,
  addPhone/4,
  removeContact/3,
  removeEmail/2,
  getEmails/3,
  getPhones/3,
  findByPhone/2,
  findByEmail/2,
  removePhones/2,
  setEmployment/5, findByCompany/2]).

getBy(Predicate, AddressBook, FilterValue) ->
  Filter = case Predicate of
             email -> fun(CurrentEntry) -> lists:member(FilterValue, CurrentEntry#entry.emails) end ;
             phone -> fun(CurrentEntry) -> lists:member(FilterValue, CurrentEntry#entry.phones) end ;
             fullName -> fun(CurrentEntry) -> CurrentEntry#entry.fullName == FilterValue end ;
             employment -> fun(CurrentEntry) -> {Company, _ } = CurrentEntry#entry.employment, Company == FilterValue end ;
             _ -> fun(_) -> 1 == 0 end
           end,
  lists:filter(Filter, AddressBook).

getModifiedPhonesAndEmails(phone, remove, Entry, ModificationValue) ->
  {Entry#entry.phones -- [ModificationValue], Entry#entry.emails} ;

getModifiedPhonesAndEmails(phone, add, Entry, ModificationValue) ->
  {[ModificationValue | Entry#entry.phones], Entry#entry.emails} ;

getModifiedPhonesAndEmails(email, remove, Entry, ModificationValue) ->
  {Entry#entry.phones, Entry#entry.emails -- [ModificationValue]} ;

getModifiedPhonesAndEmails(email, add, Entry, ModificationValue) ->
  {Entry#entry.phones, [ModificationValue | Entry#entry.emails]}.

modifyEntry(FieldType, Operation, Entry, ModificationValue) ->
  {Phones, Emails} =  getModifiedPhonesAndEmails(FieldType, Operation, Entry, ModificationValue),
  Employment = if FieldType == employment -> ModificationValue; FieldType /= employment -> Entry#entry.employment end,
  #entry{fullName = Entry#entry.fullName, phones = Phones, emails = Emails, employment = Employment}.

createAddressBook() ->
  [].

addContact(AddressBook, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    []  -> [#entry{fullName = {FirstName, LastName}} | AddressBook];
    _ -> AddressBook
  end.

addValue(FieldType, AddressBook, ValueToAdd, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [] -> case getBy(FieldType, AddressBook, ValueToAdd) of
            [] -> [modifyEntry(FieldType, add, #entry{fullName = {FirstName, LastName}}, ValueToAdd) | AddressBook];
            _ -> AddressBook
          end ;
    [EntryWithSameName] -> case getBy(FieldType, AddressBook, ValueToAdd) of
                             [] ->
                               ModifiedEntry = modifyEntry(FieldType, add, EntryWithSameName, ValueToAdd),
                               [ModifiedEntry | AddressBook -- [EntryWithSameName]] ;
                             _ -> AddressBook
                           end
  end.

addEmail(AddressBook, FirstName, LastName, Email) ->
  addValue(email, AddressBook, Email, FirstName, LastName).

addPhone(AddressBook, FirstName, LastName, Phone) ->
  addValue(phone, AddressBook, Phone, FirstName, LastName).

removeContact(AddressBook, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [EntryFound] -> AddressBook -- [EntryFound] ;
    _ -> AddressBook
  end.

removeEmail(AddressBook, Email) ->
  case getBy(email, AddressBook, Email) of
    [EntryFound] -> [modifyEntry(email, remove, EntryFound, Email) | AddressBook -- [EntryFound]] ;
    _ -> AddressBook
  end.

removePhones(AddressBook, Phone) ->
  case getBy(phone, AddressBook, Phone) of
    [EntryFound] -> [modifyEntry(phone, remove, EntryFound, Phone) | AddressBook -- [EntryFound]] ;
    _ -> AddressBook
  end.

getEmails(AddressBook, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [SomeEntry] -> SomeEntry#entry.emails ;
    _ -> []
  end.

getPhones(AddressBook, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [SomeEntry] -> SomeEntry#entry.phones;
    _ -> []
  end.

findByEmail(AddressBook, Email) ->
  case getBy(email, AddressBook, Email) of
    [FoundEntry] -> FoundEntry#entry.fullName ;
    _ -> recordNotFound
  end.

findByPhone(AddressBook, Phone) ->
  case getBy(phone, AddressBook, Phone) of
    [FoundEntry] -> FoundEntry#entry.fullName ;
    _ -> recordNotFound
  end.

setEmployment(AddressBook, FirstName, LastName, Company, Position) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [EntryFound] ->
      [modifyEntry(employment, any, EntryFound, {Company, Position}) | AddressBook -- [EntryFound]] ;
    _ -> [#entry{fullName = {FirstName, LastName}, employment = {Company, Position}} | AddressBook]
  end.

findByCompany(AddressBook, Company) ->
  case getBy(employment, AddressBook, Company) of
    [] -> noEmployeeWorksForThisCompany;
    List -> List
  end.