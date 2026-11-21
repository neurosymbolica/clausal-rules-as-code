% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2, gdpr_processor_contract_key_order/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_processor_contract_key_order([contract_binding_on_processor, contract_governed_by_union_or_member_state_law, contract_in_writing, contract_sets_out_categories_of_data_subjects, contract_sets_out_controller_obligations_and_rights, contract_sets_out_duration, contract_sets_out_nature_of_processing, contract_sets_out_purpose_of_processing, contract_sets_out_subject_matter, contract_sets_out_type_of_personal_data, controller_given_opportunity_to_object, processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_informed_controller_of_intended_changes, processor_provides_sufficient_guarantees, standard_clauses_adopted, stipulates_assistance_with_articles_32_to_36_obligations, stipulates_assistance_with_data_subject_requests, stipulates_conditions_for_engaging_another_processor, stipulates_confidentiality_commitment, stipulates_deletion_or_return_of_personal_data, stipulates_information_and_audit_rights, stipulates_notice_of_infringing_instruction, stipulates_processing_only_on_documented_instructions, stipulates_security_measures, subprocessor_authorisation, subprocessor_authorisation_given_before_engagement, subprocessor_contract_governed_by_union_or_member_state_law, subprocessor_contract_in_writing, subprocessor_engaged, subprocessor_obligations_same, subprocessor_provides_sufficient_guarantees]).

gdpr_processor_contract_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [contract_binding_on_processor, contract_governed_by_union_or_member_state_law, contract_in_writing, contract_sets_out_categories_of_data_subjects, contract_sets_out_controller_obligations_and_rights, contract_sets_out_duration, contract_sets_out_nature_of_processing, contract_sets_out_purpose_of_processing, contract_sets_out_subject_matter, contract_sets_out_type_of_personal_data, controller_given_opportunity_to_object, processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_informed_controller_of_intended_changes, processor_provides_sufficient_guarantees, standard_clauses_adopted, stipulates_assistance_with_articles_32_to_36_obligations, stipulates_assistance_with_data_subject_requests, stipulates_conditions_for_engaging_another_processor, stipulates_confidentiality_commitment, stipulates_deletion_or_return_of_personal_data, stipulates_information_and_audit_rights, stipulates_notice_of_infringing_instruction, stipulates_processing_only_on_documented_instructions, stipulates_security_measures, subprocessor_authorisation, subprocessor_authorisation_given_before_engagement, subprocessor_contract_governed_by_union_or_member_state_law, subprocessor_contract_in_writing, subprocessor_engaged, subprocessor_obligations_same, subprocessor_provides_sufficient_guarantees],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(contract_binding_on_processor, judgement).
key_type(contract_governed_by_union_or_member_state_law, judgement).
key_type(contract_in_writing, boolean).
key_type(contract_sets_out_categories_of_data_subjects, boolean).
key_type(contract_sets_out_controller_obligations_and_rights, boolean).
key_type(contract_sets_out_duration, boolean).
key_type(contract_sets_out_nature_of_processing, boolean).
key_type(contract_sets_out_purpose_of_processing, boolean).
key_type(contract_sets_out_subject_matter, boolean).
key_type(contract_sets_out_type_of_personal_data, boolean).
key_type(controller_given_opportunity_to_object, boolean).
key_type(processing_on_behalf_of_controller, judgement).
key_type(processor_determines_purposes_and_means, judgement).
key_type(processor_informed_controller_of_intended_changes, boolean).
key_type(processor_provides_sufficient_guarantees, judgement).
key_type(standard_clauses_adopted, outside_fact).
key_type(stipulates_assistance_with_articles_32_to_36_obligations, boolean).
key_type(stipulates_assistance_with_data_subject_requests, boolean).
key_type(stipulates_conditions_for_engaging_another_processor, boolean).
key_type(stipulates_confidentiality_commitment, boolean).
key_type(stipulates_deletion_or_return_of_personal_data, boolean).
key_type(stipulates_information_and_audit_rights, boolean).
key_type(stipulates_notice_of_infringing_instruction, boolean).
key_type(stipulates_processing_only_on_documented_instructions, boolean).
key_type(stipulates_security_measures, boolean).
key_type(subprocessor_authorisation, enum([specific_written, general_written, none])).
key_type(subprocessor_authorisation_given_before_engagement, boolean).
key_type(subprocessor_contract_governed_by_union_or_member_state_law, judgement).
key_type(subprocessor_contract_in_writing, boolean).
key_type(subprocessor_engaged, boolean).
key_type(subprocessor_obligations_same, judgement).
key_type(subprocessor_provides_sufficient_guarantees, judgement).

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

test(key_order_has_thirty_two_keys) :-
    gdpr_processor_contract_key_order(KeyOrder),
    length(KeyOrder, 32).
test(an_empty_profile_has_no_problem) :-
    gdpr_processor_contract_input_problems([], []).
test(a_non_list_profile_is_wrong_type) :-
    gdpr_processor_contract_input_problems(profile_text, [wrong_type(profile)]).
test(unsure_in_a_crisp_key_is_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, unsure)], [wrong_type(contract_in_writing)]).
test(unsure_in_a_judgement_is_well_typed) :-
    gdpr_processor_contract_input_problems([attribute(contract_binding_on_processor, unsure)], []).
test(a_duplicate_key_is_not_also_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, unsure), attribute(contract_in_writing, true)], [duplicate_key(contract_in_writing)]).
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_processor_contract_input_problems([attribute(stray_key, true), attribute(stray_key, false)], [unknown_key(stray_key)]).
test(a_well_formed_attested_fact_is_well_typed) :-
    gdpr_processor_contract_input_problems([attribute(standard_clauses_adopted, attested(true, attestation(host, moment, reason, none)))], []).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(standard_clauses_adopted, true)], [wrong_type(standard_clauses_adopted)]).
test(an_unknown_authorisation_kind_is_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(subprocessor_authorisation, oral)], [wrong_type(subprocessor_authorisation)]).
