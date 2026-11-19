% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_kernel, [gdpr_transfer_dpf_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_transfer_dpf_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [transfer_from_union, recipient_is_organisation_in_united_states, data_privacy_framework_decision_in_force, recipient_on_data_privacy_framework_list, certification_covers_transferred_data],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(transfer_from_union, boolean).
key_type(recipient_is_organisation_in_united_states, boolean).
key_type(data_privacy_framework_decision_in_force, outside_fact).
key_type(recipient_on_data_privacy_framework_list, outside_fact).
key_type(certification_covers_transferred_data, outside_fact).

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

in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

truth_and(true, T, T).
truth_and(false, _, false).

attested_t(attested(AttestedValue, Attestation), Type, T) :-
    attestation_t(Attestation, IsAttestation),
    attested_value_t(IsAttestation, Type, AttestedValue, T).
attested_t(Value, _, false) :-
    Value \= attested(_, _).

attestation_t(attestation(_, _, _, _), true).
attestation_t(Value, false) :-
    Value \= attestation(_, _, _, _).

attested_value_t(false, _, _, false).
attested_value_t(true, Type, AttestedValue, T) :-
    in_type_t(Type, AttestedValue, T).

test(a_well_formed_profile_has_no_problem) :-
    gdpr_transfer_dpf_input_problems([attribute(transfer_from_union, true), attribute(data_privacy_framework_decision_in_force, attested(true, attestation(by, at, reason, none)))], []).
test(an_empty_profile_has_no_problem) :-
    gdpr_transfer_dpf_input_problems([], []).
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    gdpr_transfer_dpf_input_problems([attribute(recipient_on_data_privacy_framework_list, true)], [wrong_type(recipient_on_data_privacy_framework_list)]).
test(a_crisp_key_given_an_attested_term_is_wrong_type) :-
    gdpr_transfer_dpf_input_problems([attribute(transfer_from_union, attested(true, attestation(by, at, reason, none)))], [wrong_type(transfer_from_union)]).
test(an_unbound_attestation_argument_is_wrong_type) :-
    gdpr_transfer_dpf_input_problems([attribute(certification_covers_transferred_data, attested(true, attestation(by, _, reason, none)))], [wrong_type(certification_covers_transferred_data)]).
test(a_duplicate_comes_before_an_unknown_key) :-
    gdpr_transfer_dpf_input_problems([attribute(colour, red), attribute(transfer_from_union, true), attribute(transfer_from_union, 7)], [duplicate_key(transfer_from_union), unknown_key(colour)]).
test(a_partial_list_is_not_a_profile) :-
    gdpr_transfer_dpf_input_problems([attribute(transfer_from_union, true)|_], [wrong_type(profile)]).
test(the_check_has_exactly_one_answer) :-
    findall(Problems, gdpr_transfer_dpf_input_problems([attribute(transfer_from_union, maybe)], Problems), Answers),
    Answers == [[wrong_type(transfer_from_union)]].

test(a_good_profile_is_not_reported_as_a_problem, fail) :-
    gdpr_transfer_dpf_input_problems([attribute(transfer_from_union, true)], [_|_]).
