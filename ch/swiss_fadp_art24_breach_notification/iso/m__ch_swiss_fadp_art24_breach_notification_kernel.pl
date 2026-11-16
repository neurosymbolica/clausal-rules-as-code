% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2, swiss_fadp_art24_breach_notification_contract_keys/1, swiss_fadp_art24_breach_notification_key_state/3, swiss_fadp_art24_breach_notification_first_key_in_state/4, swiss_fadp_art24_breach_notification_pairs/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

swiss_fadp_art24_breach_notification_contract_keys([breach_of_data_security, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement, personal_data_breach, breach_unlikely_to_result_in_risk]).

swiss_fadp_art24_breach_notification_key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
swiss_fadp_art24_breach_notification_key_state(Profile, Key, State) :-
    profile_get(Profile, Key, Value),
    present_state(Value, State).

present_state(true, true).
present_state(false, false).
present_state(unsure, unsure).

swiss_fadp_art24_breach_notification_first_key_in_state(Profile, [Key|_], State, Key) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, Key, State).
swiss_fadp_art24_breach_notification_first_key_in_state(Profile, [Key|Keys], State, Found) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, Key, OtherState),
    dif(OtherState, State),
    swiss_fadp_art24_breach_notification_first_key_in_state(Profile, Keys, State, Found).

swiss_fadp_art24_breach_notification_pairs(_, [], []).
swiss_fadp_art24_breach_notification_pairs(Profile, [Key|Keys], Pairs) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, Key, State),
    swiss_fadp_art24_breach_notification_pairs(Profile, Keys, LaterPairs),
    pair_for_state(State, Key, LaterPairs, Pairs).

pair_for_state(absent, _, Pairs, Pairs).
pair_for_state(State, Key, Pairs, [Key - State|Pairs]) :-
    dif(State, absent).

swiss_fadp_art24_breach_notification_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    swiss_fadp_art24_breach_notification_contract_keys(Keys),
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(breach_of_data_security, judgement).
key_type(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, judgement).
key_type(information_necessary_for_protection_of_data_subject, judgement).
key_type(commissioner_requested_information_of_data_subject, boolean).
key_type(article_26_ground_or_statutory_secrecy_obligation_applies, judgement).
key_type(information_impossible_or_requires_disproportionate_effort, judgement).
key_type(information_ensured_comparably_by_public_announcement, judgement).
key_type(personal_data_breach, judgement).
key_type(breach_unlikely_to_result_in_risk, judgement).

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
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

known_t(_, [], false).
known_t(Key, [Known|_], true) :-
    Known == Key.
known_t(Key, [Known|Knowns], T) :-
    Known \== Key,
    known_t(Key, Knowns, T).

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
