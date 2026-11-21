% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_kernel, [gdpr_common_definitions_roles_and_establishments_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_common_definitions_roles_and_establishments_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [data_are_personal_data, party_determines_purposes_and_means, purposes_and_means_determined_by_law, party_provided_for_as_controller_by_law, party_processes_on_behalf_of_controller, data_relate_to_genetic_characteristics_giving_unique_information, data_result_from_technical_processing_allowing_unique_identification, data_relate_to_health_and_reveal_health_status, party_role, established_in_more_than_one_member_state, central_administration_in_union, decisions_taken_in_other_union_establishment, other_establishment_can_have_decisions_implemented, processor_subject_to_specific_obligations, entity_is_person_partnership_or_association, entity_engaged_in_economic_activity, controlling_undertaking_and_controlled_undertakings, party_established_in_authority_member_state, data_subjects_in_authority_member_state_substantially_affected, complaint_lodged_with_authority, processing_in_context_of_establishments_in_more_than_one_member_state, processing_in_context_of_single_union_establishment, substantially_affects_data_subjects_in_more_than_one_member_state, objection_to_draft_decision, objection_concerns_infringement_or_envisaged_action, objection_demonstrates_significance_of_risks],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(data_are_personal_data, judgement).
key_type(party_determines_purposes_and_means, judgement).
key_type(purposes_and_means_determined_by_law, boolean).
key_type(party_provided_for_as_controller_by_law, outside_fact).
key_type(party_processes_on_behalf_of_controller, judgement).
key_type(data_relate_to_genetic_characteristics_giving_unique_information, judgement).
key_type(data_result_from_technical_processing_allowing_unique_identification, judgement).
key_type(data_relate_to_health_and_reveal_health_status, judgement).
key_type(party_role, enum([controller, processor])).
key_type(established_in_more_than_one_member_state, boolean).
key_type(central_administration_in_union, boolean).
key_type(decisions_taken_in_other_union_establishment, boolean).
key_type(other_establishment_can_have_decisions_implemented, judgement).
key_type(processor_subject_to_specific_obligations, boolean).
key_type(entity_is_person_partnership_or_association, boolean).
key_type(entity_engaged_in_economic_activity, judgement).
key_type(controlling_undertaking_and_controlled_undertakings, judgement).
key_type(party_established_in_authority_member_state, boolean).
key_type(data_subjects_in_authority_member_state_substantially_affected, judgement).
key_type(complaint_lodged_with_authority, boolean).
key_type(processing_in_context_of_establishments_in_more_than_one_member_state, judgement).
key_type(processing_in_context_of_single_union_establishment, judgement).
key_type(substantially_affects_data_subjects_in_more_than_one_member_state, judgement).
key_type(objection_to_draft_decision, boolean).
key_type(objection_concerns_infringement_or_envisaged_action, boolean).
key_type(objection_demonstrates_significance_of_risks, judgement).

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
    key_shape_t(Key, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

key_shape_t(Key, true) :-
    var(Key).
key_shape_t(Key, T) :-
    nonvar(Key),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).

no_variables_t([], true).
no_variables_t([_|_], false).

identical_member_t(_, [], false).
identical_member_t(Term, [Element|_], true) :-
    Term == Element.
identical_member_t(Term, [Element|Elements], T) :-
    Term \== Element,
    identical_member_t(Term, Elements, T).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    identical_member_t(Key, Known, IsKnown),
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

test(an_empty_profile_has_no_problem) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(party_role, controller), attribute(data_are_personal_data, unsure), attribute(party_provided_for_as_controller_by_law, attested(true, attestation(host, now, reason, none)))], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    gdpr_common_definitions_roles_and_establishments_input_problems(_, [wrong_type(profile)]).
test(a_non_ground_compound_key_is_not_an_attribute_list) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(foo(_), true)], [wrong_type(profile)]).
test(an_unbound_key_is_one_unknown_key) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(Key, first), attribute(Key, second)], Problems),
    Problems = [unknown_key(Reported)],
    Reported == Key.
test(a_repeated_contract_key_is_a_duplicate_only) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(party_role, controller), attribute(party_role, bogus)], [duplicate_key(party_role)]).
test(unsure_is_wrong_for_a_crisp_key) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(complaint_lodged_with_authority, unsure)], [wrong_type(complaint_lodged_with_authority)]).
test(contract_problems_come_before_unknown_keys) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(stray, 1), attribute(party_role, other), attribute(stray, 2)], [wrong_type(party_role), unknown_key(stray)]).
