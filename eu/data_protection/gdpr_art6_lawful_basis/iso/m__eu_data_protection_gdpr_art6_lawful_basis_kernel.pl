% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2, gdpr_art6_lawful_basis_root_keys/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_art6_lawful_basis_root_keys([basis_claimed, consent_given_and_conditions_met, contract_necessary, legal_obligation_necessary, legal_obligation_laid_down_by_law, vital_interests_necessary, public_interest_task_necessary, public_interest_task_laid_down_by_law, processing_by_public_authority_in_its_tasks, legitimate_interests_pursued, interests_overridden, child_data_subject, special_category, new_purpose_processing, compatible_purpose, link_between_purposes_taken_into_account, collection_context_taken_into_account, nature_of_data_taken_into_account, possible_consequences_taken_into_account, appropriate_safeguards_taken_into_account]).

gdpr_art6_lawful_basis_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    gdpr_art6_lawful_basis_root_keys(Keys),
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(basis_claimed, lawful_basis_choice).
key_type(consent_given_and_conditions_met, outside_fact).
key_type(contract_necessary, judgement).
key_type(legal_obligation_necessary, judgement).
key_type(legal_obligation_laid_down_by_law, outside_fact).
key_type(vital_interests_necessary, judgement).
key_type(public_interest_task_necessary, judgement).
key_type(public_interest_task_laid_down_by_law, outside_fact).
key_type(processing_by_public_authority_in_its_tasks, boolean).
key_type(legitimate_interests_pursued, judgement).
key_type(interests_overridden, judgement).
key_type(child_data_subject, outside_fact).
key_type(special_category, outside_fact).
key_type(new_purpose_processing, boolean).
key_type(compatible_purpose, judgement).
key_type(link_between_purposes_taken_into_account, boolean).
key_type(collection_context_taken_into_account, boolean).
key_type(nature_of_data_taken_into_account, boolean).
key_type(possible_consequences_taken_into_account, boolean).
key_type(appropriate_safeguards_taken_into_account, boolean).

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

in_type_t(lawful_basis_choice, Value, T) :-
    in_type_t(enum([consent, contract, legal_obligation, vital_interests, public_interest_task, legitimate_interests]), Value, T).
in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
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

test(root_keys_are_twenty) :-
    gdpr_art6_lawful_basis_root_keys(Keys),
    length(Keys, 20).
test(empty_profile_has_no_problem) :-
    gdpr_art6_lawful_basis_input_problems([], []).
test(unbound_profile_is_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems(_, [wrong_type(profile)]).
test(bare_true_outside_fact_is_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems([attribute(special_category, true)], [wrong_type(special_category)]).
test(attested_outside_fact_is_well_formed) :-
    gdpr_art6_lawful_basis_input_problems([attribute(special_category, attested(true, attestation(by, at, reason, none)))], []).
test(duplicate_key_is_named_once) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, true), attribute(contract_necessary, unsure)], [duplicate_key(contract_necessary)]).
test(unknown_key_is_named) :-
    gdpr_art6_lawful_basis_input_problems([attribute(colour, blue)], [unknown_key(colour)]).
