% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_queries, [gdpr_common_definitions_roles_and_establishments_profile_keys/1, gdpr_common_definitions_roles_and_establishments_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_kernel, [gdpr_common_definitions_roles_and_establishments_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [gdpr_common_definitions_roles_and_establishments_status/2]).

gdpr_common_definitions_roles_and_establishments_profile_keys([data_are_personal_data, party_determines_purposes_and_means, purposes_and_means_determined_by_law, party_provided_for_as_controller_by_law, party_processes_on_behalf_of_controller, data_relate_to_genetic_characteristics_giving_unique_information, data_result_from_technical_processing_allowing_unique_identification, data_relate_to_health_and_reveal_health_status, party_role, established_in_more_than_one_member_state, central_administration_in_union, decisions_taken_in_other_union_establishment, other_establishment_can_have_decisions_implemented, processor_subject_to_specific_obligations, entity_is_person_partnership_or_association, entity_engaged_in_economic_activity, controlling_undertaking_and_controlled_undertakings, party_established_in_authority_member_state, data_subjects_in_authority_member_state_substantially_affected, complaint_lodged_with_authority, processing_in_context_of_establishments_in_more_than_one_member_state, processing_in_context_of_single_union_establishment, substantially_affects_data_subjects_in_more_than_one_member_state, objection_to_draft_decision, objection_concerns_infringement_or_envisaged_action, objection_demonstrates_significance_of_risks]).

gdpr_common_definitions_roles_and_establishments_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_common_definitions_roles_and_establishments_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Rest], Key, Value, [attribute(Key, Value)|Rest]).
override_attribute([attribute(Other, Old)|Rest], Key, Value, [attribute(Other, Old)|Changed]) :-
    dif(Other, Key),
    override_attribute(Rest, Key, Value, Changed).
