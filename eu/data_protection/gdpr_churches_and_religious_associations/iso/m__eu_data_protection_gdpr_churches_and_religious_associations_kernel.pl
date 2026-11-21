% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_kernel, [gdpr_churches_and_religious_associations_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_churches_and_religious_associations_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [body_is_church_or_religious_association_or_community, rules_applied_in_a_member_state, comprehensive_rules_relating_to_protection_with_regard_to_processing, rules_applied_at_entry_into_force_of_the_regulation, rules_brought_into_line_with_the_regulation, supervisory_authority_is_specific, specific_authority_fulfils_chapter_vi_conditions],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(body_is_church_or_religious_association_or_community, boolean).
key_type(rules_applied_in_a_member_state, boolean).
key_type(comprehensive_rules_relating_to_protection_with_regard_to_processing, judgement).
key_type(rules_applied_at_entry_into_force_of_the_regulation, outside_fact).
key_type(rules_brought_into_line_with_the_regulation, judgement).
key_type(supervisory_authority_is_specific, boolean).
key_type(specific_authority_fulfils_chapter_vi_conditions, outside_fact).

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
in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

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
    gdpr_churches_and_religious_associations_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(body_is_church_or_religious_association_or_community, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, unsure), attribute(rules_applied_at_entry_into_force_of_the_regulation, attested(true, attestation(host, today, reason, none)))], Problems),
    Problems == [].
test(a_non_list_is_not_a_profile) :-
    gdpr_churches_and_religious_associations_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_not_a_profile) :-
    gdpr_churches_and_religious_associations_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_repeated_key_is_a_duplicate) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(supervisory_authority_is_specific, true), attribute(supervisory_authority_is_specific, maybe)], Problems),
    Problems == [duplicate_key(supervisory_authority_is_specific)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(rules_applied_in_a_member_state, unsure)], Problems),
    Problems == [wrong_type(rules_applied_in_a_member_state)].
test(an_unbound_attestation_argument_is_wrong_type) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(specific_authority_fulfils_chapter_vi_conditions, attested(true, attestation(host, _, reason, none)))], Problems),
    Problems == [wrong_type(specific_authority_fulfils_chapter_vi_conditions)].
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
