% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_art36_3_consultation_request_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [consultation_under_article_36_1, joint_controllers_or_processors_involved, respective_responsibilities_provided, purposes_and_means_provided, measures_and_safeguards_provided, data_protection_officer_designated, data_protection_officer_contact_details_provided, impact_assessment_provided, other_information_requested_by_supervisory_authority, requested_other_information_provided],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(consultation_under_article_36_1, boolean).
key_type(joint_controllers_or_processors_involved, outside_fact).
key_type(respective_responsibilities_provided, boolean).
key_type(purposes_and_means_provided, boolean).
key_type(measures_and_safeguards_provided, boolean).
key_type(data_protection_officer_designated, boolean).
key_type(data_protection_officer_contact_details_provided, boolean).
key_type(impact_assessment_provided, boolean).
key_type(other_information_requested_by_supervisory_authority, boolean).
key_type(requested_other_information_provided, boolean).

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

test(an_empty_profile_has_no_problem) :-
    gdpr_art36_3_consultation_request_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(consultation_under_article_36_1, true), attribute(joint_controllers_or_processors_involved, attested(false, attestation(host, moment, reason, none))), attribute(purposes_and_means_provided, false)], Problems),
    Problems == [].
test(an_atom_is_not_a_profile) :-
    gdpr_art36_3_consultation_request_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_a_profile) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(purposes_and_means_provided, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(an_attested_crisp_key_is_wrong_type) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(purposes_and_means_provided, attested(true, attestation(host, moment, reason, none)))], Problems),
    Problems == [wrong_type(purposes_and_means_provided)].
test(a_bare_true_outside_fact_is_wrong_type) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(joint_controllers_or_processors_involved, true)], Problems),
    Problems == [wrong_type(joint_controllers_or_processors_involved)].
test(an_unbound_attestation_argument_is_wrong_type) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(joint_controllers_or_processors_involved, attested(true, attestation(_, moment, reason, none)))], Problems),
    Problems == [wrong_type(joint_controllers_or_processors_involved)].
test(a_repeated_key_is_a_duplicate_only) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(impact_assessment_provided, true), attribute(impact_assessment_provided, unsure)], Problems),
    Problems == [duplicate_key(impact_assessment_provided)].
test(an_unknown_key_comes_after_contract_problems) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(colour, red), attribute(impact_assessment_provided, unsure), attribute(colour, blue)], Problems),
    Problems == [wrong_type(impact_assessment_provided), unknown_key(colour)].
