% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_kernel, [eprivacy_art_5_3_terminal_equipment_input_problems/2, eprivacy_art_5_3_terminal_equipment_contract_keys/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

eprivacy_art_5_3_terminal_equipment_contract_keys([storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided]).

eprivacy_art_5_3_terminal_equipment_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(storage_or_access_in_terminal_equipment, judgement).
key_type(storage_or_access_solely_for_transmission, judgement).
key_type(service_explicitly_requested_by_user, judgement).
key_type(strictly_necessary_to_provide_requested_service, judgement).
key_type(user_consent_given, judgement).
key_type(clear_and_comprehensive_information_provided, judgement).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, T) :-
    nonvar(Element),
    Element = attribute(Key, _),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

no_variables_t([], true).
no_variables_t([_|_], false).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    memberd_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

test(contract_keys_are_the_six_in_order) :-
    eprivacy_art_5_3_terminal_equipment_contract_keys(Keys),
    Keys == [storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided].
test(empty_profile_has_no_problem) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([], Problems),
    Problems == [].
test(attested_value_is_wrong_type) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, attested(true))], Problems),
    Problems == [wrong_type(storage_or_access_in_terminal_equipment)].
test(duplicate_then_unknown) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_in_terminal_equipment, oops), attribute(zzz, 1)], Problems),
    Problems == [duplicate_key(storage_or_access_in_terminal_equipment), unknown_key(zzz)].
test(not_an_attribute_list) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([foo], Problems),
    Problems == [wrong_type(profile)].
