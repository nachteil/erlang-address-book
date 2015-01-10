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
-export([createAddressBook/0, addContact/3, addEmail/4, addPhone/4, removeContact/3, removeEmail/2, getEmails/3, getPhones/3, findByPhone/2, findByEmail/2]).

getBy(Predicate, AddressBook, FilterValue) ->
  Filter = case Predicate of
             emil -> fun(CurrentEntry) -> lists:member(FilterValue, CurrentEntry#entry.emails) end ;
             phone -> fun(CurrentEntry) -> lists:member(FilterValue, CurrentEntry#entry.phones) end ;
             fullName -> fun(CurrentEntry) -> CurrentEntry#entry.fullName == FilterValue end ;
             _ -> fun(CurrentEntry) -> 1 == 0 end
           end,
  lists:filter(Filter, AddressBook)
.

modifyEntry(FieldType, Operation, Entry, ModificationValue) ->
  {Phones, Emails} =  case FieldType of
                        phone -> case Operation of
                                   remove -> {Entry#entry.phones -- [ModificationValue], Entry#entry.emails} ;
                                   add -> {[ModificationValue | Entry#entry.phones], Entry#entry.emails}
                                 end ;
                        emil -> case Operation of
                                  remove -> {Entry#entry.phones, Entry#entry.emails -- [ModificationValue]} ;
                                  add -> {Entry#entry.phones, addEmil, [ModificationValue | Entry#entry.emails]}
                                end
                      end
  #entry{fullName = Entry#entry.fullName, phones = Phones, emails = Emails}
.

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
  end
.

addEmail(AddressBook, FirstName, LastName, Email) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [] -> case getBy(emil, AddressBook, Email) of
            [] -> [#entry{fullName = {FirstName, LastName}, emails = [Email]} | AddressBook];
            _ -> AddressBook
          end ;
    [EntryWithSameName] -> case getBy(emil, AddressBook, Email) of
                            [] ->
                              ModifiedEntry = #entry{
                                fullName = {FirstName, LastName},
                                emails = [Email | EntryWithSameName#entry.emails ],
                                phones = EntryWithSameName#entry.phones
                              },
                              [ModifiedEntry | AddressBook -- [EntryWithSameName]] ;
                            _ -> AddressBook
                           end
  end.

addPhone(AddressBook, FirstName, LastName, Phone) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [] -> case getBy(phone, AddressBook, Phone) of
            [] -> [#entry{fullName = {FirstName, LastName}, phones = [Phone]} | AddressBook];
            _ -> AddressBook
          end ;
    [EntryWithSameName] -> case getBy(phone, AddressBook, Phone) of
                             [] ->
                               ModifiedEntry = #entry{
                                 fullName = {FirstName, LastName},
                                 phones = [Phone | EntryWithSameName#entry.phones ],
                                 emails = EntryWithSameName#entry.emails
                               },
                               [ModifiedEntry | AddressBook -- [EntryWithSameName]] ;
                             _ -> AddressBook
                           end
  end.

removeContact(AddressBook, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [EntryFound] -> AddressBook - [EntryFound] ;
    _ -> AddressBook
  end
.

removeEmail(AddressBook, Email) ->
  case getBy(emil, AddressBook, Email) of
    [EntryFound] ->
      ModifiedEntry = #entry{
        fullName = EntryFound#entry.fullName,
        phones = EntryFound#entry.phones,
        emails = EntryFound#entry.emails -- [Email]
      },
      [ModifiedEntry | AddressBook -- [EntryFound]]
  end.

getEmails(AddressBook, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [SomeEntry] -> SomeEntry#entry.emails ;
    _ -> []
  end
.

getPhones(AddressBook, FirstName, LastName) ->
  case getBy(fullName, AddressBook, {FirstName, LastName}) of
    [SomeEntry] -> SomeEntry#entry.phones;
    _ -> []
  end
.

findByEmail(AddressBook, Email) ->
  case getBy(emil, AddressBook, Email) of
    [FoundEntry] -> FoundEntry#entry.fullName ;
    _ -> recordNotFound
  end
.

findByPhone(AddressBook, Phone) ->
  case getBy(phone, AddressBook, Phone) of
    [FoundEntry] -> FoundEntry#entry.fullName ;
    _ -> recordNotFound
  end
.