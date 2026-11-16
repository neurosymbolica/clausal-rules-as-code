% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_recognised_legitimate_interests_kernel, [uk_recognised_legitimate_interests_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

uk_recognised_legitimate_interests_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [processing_by_a_public_authority_in_the_performance_of_its_tasks, processing_necessary_for_a_disclosure_in_response_to_a_request, request_states_need_for_article_6_1_e_processing_with_article_6_3_basis, processing_necessary_for_national_security_public_security_or_defence, event_is_an_emergency_within_part_2_of_the_civil_contingencies_act_2004, processing_necessary_for_responding_to_the_emergency, processing_necessary_for_detecting_investigating_or_preventing_crime_or_apprehending_or_prosecuting_offenders, processing_necessary_for_safeguarding_an_individual, individual_aged_under_18, controller_has_reasonable_cause_to_suspect_the_individual_is_at_risk, legitimate_interest_pursued_by_the_controller_or_a_third_party, processing_necessary_for_that_legitimate_interest, interests_overridden_by_data_subject_interests_or_fundamental_rights, basis_relied_on, objection_on_grounds_relating_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds_that_override, processing_for_establishment_exercise_or_defence_of_legal_claims],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(processing_by_a_public_authority_in_the_performance_of_its_tasks, judgement).
key_type(processing_necessary_for_a_disclosure_in_response_to_a_request, judgement).
key_type(request_states_need_for_article_6_1_e_processing_with_article_6_3_basis, boolean).
key_type(processing_necessary_for_national_security_public_security_or_defence, judgement).
key_type(event_is_an_emergency_within_part_2_of_the_civil_contingencies_act_2004, judgement).
key_type(processing_necessary_for_responding_to_the_emergency, judgement).
key_type(processing_necessary_for_detecting_investigating_or_preventing_crime_or_apprehending_or_prosecuting_offenders, judgement).
key_type(processing_necessary_for_safeguarding_an_individual, judgement).
key_type(individual_aged_under_18, boolean).
key_type(controller_has_reasonable_cause_to_suspect_the_individual_is_at_risk, judgement).
key_type(legitimate_interest_pursued_by_the_controller_or_a_third_party, judgement).
key_type(processing_necessary_for_that_legitimate_interest, judgement).
key_type(interests_overridden_by_data_subject_interests_or_fundamental_rights, judgement).
key_type(basis_relied_on, enum([public_task, recognised_legitimate_interest, legitimate_interests, other_basis])).
key_type(objection_on_grounds_relating_to_particular_situation, judgement).
key_type(controller_demonstrates_compelling_legitimate_grounds_that_override, judgement).
key_type(processing_for_establishment_exercise_or_defence_of_legal_claims, judgement).

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
    identical_member_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

identical_member_t(_, [], false).
identical_member_t(Item, [Candidate|_], true) :-
    Item == Candidate.
identical_member_t(Item, [Candidate|Candidates], Truth) :-
    Item \== Candidate,
    identical_member_t(Item, Candidates, Truth).

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
