% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_kernel, [working_time_weekly_limit_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

working_time_weekly_limit_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [reference_period_basis, on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, member_state_uses_article_22_option, worker_agreement_to_exceed_obtained_first],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(reference_period_basis, reference_period_basis_atom).
key_type(on_call_on_site_counts_as_working_time, judgement).
key_type(on_call_standby_counts_as_working_time, judgement).
key_type(member_state_uses_article_22_option, boolean).
key_type(worker_agreement_to_exceed_obtained_first, boolean).

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
    key_known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

key_known_t(_, [], false).
key_known_t(Key, [KnownKey|_], true) :-
    Key == KnownKey.
key_known_t(Key, [KnownKey|KnownKeys], T) :-
    Key \== KnownKey,
    key_known_t(Key, KnownKeys, T).

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

in_type_t(reference_period_basis_atom, Value, T) :-
    in_type_t(enum([member_state_reference_period, derogation_under_article_17_3_or_article_18, collective_agreement_under_article_19, offshore_work_under_article_20_2]), Value, T).
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

test(an_empty_profile_has_no_problem) :-
    working_time_weekly_limit_input_problems([], []).
test(a_good_profile_has_no_problem) :-
    working_time_weekly_limit_input_problems([attribute(reference_period_basis, member_state_reference_period), attribute(on_call_on_site_counts_as_working_time, unsure), attribute(member_state_uses_article_22_option, false)], []).
test(a_wrong_basis_and_a_repeated_unknown_key) :-
    working_time_weekly_limit_input_problems([attribute(reference_period_basis, x), attribute(foo, 1), attribute(foo, 2)], [wrong_type(reference_period_basis), unknown_key(foo)]).
test(a_duplicate_key_is_not_also_wrong_type) :-
    working_time_weekly_limit_input_problems([attribute(member_state_uses_article_22_option, maybe), attribute(member_state_uses_article_22_option, true)], [duplicate_key(member_state_uses_article_22_option)]).
test(unsure_is_not_a_crisp_value) :-
    working_time_weekly_limit_input_problems([attribute(worker_agreement_to_exceed_obtained_first, unsure)], [wrong_type(worker_agreement_to_exceed_obtained_first)]).
test(a_number_key_is_unknown) :-
    working_time_weekly_limit_input_problems([attribute(7, true)], [unknown_key(7)]).
test(an_unbound_value_is_wrong_type) :-
    working_time_weekly_limit_input_problems([attribute(on_call_standby_counts_as_working_time, _)], [wrong_type(on_call_standby_counts_as_working_time)]).
test(an_unbound_profile_is_not_a_profile) :-
    working_time_weekly_limit_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_not_a_profile) :-
    working_time_weekly_limit_input_problems([attribute(reference_period_basis, member_state_reference_period)|_], [wrong_type(profile)]).
test(a_foreign_element_is_not_a_profile) :-
    working_time_weekly_limit_input_problems([attribute(foo, 1), reference_period_basis], [wrong_type(profile)]).
test(the_check_answers_once) :-
    findall(Problems, working_time_weekly_limit_input_problems([attribute(foo, 1), attribute(bar, 2), attribute(foo, 3)], Problems), Answers),
    Answers == [[unknown_key(foo), unknown_key(bar)]].
