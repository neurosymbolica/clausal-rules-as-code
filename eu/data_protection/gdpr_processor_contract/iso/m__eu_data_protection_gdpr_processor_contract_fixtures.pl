% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_subject/1, gdpr_processor_contract_profile_for/2, gdpr_processor_contract_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [decide_processor_contract_status/2]).

gdpr_processor_contract_subject(eligible_without_subprocessor).
gdpr_processor_contract_subject(eligible_with_standard_clauses_recorded).
gdpr_processor_contract_subject(near_miss_malformed_standard_clauses).
gdpr_processor_contract_subject(near_miss_missing_point_h).
gdpr_processor_contract_subject(near_miss_partial_point_a_recorded_false).
gdpr_processor_contract_subject(near_miss_third_country_law).
gdpr_processor_contract_subject(near_miss_insufficient_guarantees).
gdpr_processor_contract_subject(eligible_specific_written_authorisation).
gdpr_processor_contract_subject(near_miss_authorisation_none).
gdpr_processor_contract_subject(subprocessor_obligations_unsure).
gdpr_processor_contract_subject(eligible_general_written_authorisation).
gdpr_processor_contract_subject(near_miss_general_written_without_objection_opportunity).
gdpr_processor_contract_subject(not_applicable_not_on_behalf).
gdpr_processor_contract_subject(role_controller_deferred).
gdpr_processor_contract_subject(role_processing_unsure).
gdpr_processor_contract_subject(role_purposes_and_means_unsure).
gdpr_processor_contract_subject(role_processing_absent).
gdpr_processor_contract_subject(role_purposes_and_means_absent).
gdpr_processor_contract_subject(absent_keys_list_all).
gdpr_processor_contract_subject(near_miss_unmet_dominates_absence).
gdpr_processor_contract_subject(checklist_binding_unsure).
gdpr_processor_contract_subject(unread_keys_ignored).
gdpr_processor_contract_subject(input_problems_mixed).

contract_base([attribute(processing_on_behalf_of_controller, true), attribute(processor_determines_purposes_and_means, false), attribute(processor_provides_sufficient_guarantees, true), attribute(contract_binding_on_processor, true), attribute(contract_governed_by_union_or_member_state_law, true), attribute(contract_in_writing, true), attribute(contract_sets_out_subject_matter, true), attribute(contract_sets_out_duration, true), attribute(contract_sets_out_nature_of_processing, true), attribute(contract_sets_out_purpose_of_processing, true), attribute(contract_sets_out_type_of_personal_data, true), attribute(contract_sets_out_categories_of_data_subjects, true), attribute(contract_sets_out_controller_obligations_and_rights, true), attribute(stipulates_processing_only_on_documented_instructions, true), attribute(stipulates_confidentiality_commitment, true), attribute(stipulates_security_measures, true), attribute(stipulates_conditions_for_engaging_another_processor, true), attribute(stipulates_assistance_with_data_subject_requests, true), attribute(stipulates_assistance_with_articles_32_to_36_obligations, true), attribute(stipulates_deletion_or_return_of_personal_data, true), attribute(stipulates_information_and_audit_rights, true), attribute(stipulates_notice_of_infringing_instruction, true), attribute(subprocessor_engaged, false)]).

subprocessor_base(Authorisation, Profile) :-
    contract_base(Base),
    replaced(subprocessor_engaged, true, Base, Engaged),
    append(Engaged, [attribute(subprocessor_authorisation, Authorisation), attribute(subprocessor_authorisation_given_before_engagement, true), attribute(subprocessor_obligations_same, true), attribute(subprocessor_provides_sufficient_guarantees, true), attribute(subprocessor_contract_in_writing, true), attribute(subprocessor_contract_governed_by_union_or_member_state_law, true)], Profile).

general_written_base(Profile) :-
    subprocessor_base(general_written, Base),
    append(Base, [attribute(processor_informed_controller_of_intended_changes, true), attribute(controller_given_opportunity_to_object, true)], Profile).

attestation_of(Value, attested(Value, attestation(host, moment, reason, none))).

replaced(_, _, [], []).
replaced(Key, Value, [attribute(ElementKey, Old)|Elements], [attribute(ElementKey, New)|Rest]) :-
    memberd_t(ElementKey, [Key], Same),
    chosen_value(Same, Value, Old, New),
    replaced(Key, Value, Elements, Rest).

chosen_value(true, Value, _, Value).
chosen_value(false, _, Old, Old).

removed(_, [], []).
removed(Key, [attribute(ElementKey, Value)|Elements], Out) :-
    memberd_t(ElementKey, [Key], Same),
    kept(Same, attribute(ElementKey, Value), Rest, Out),
    removed(Key, Elements, Rest).

kept(true, _, Rest, Rest).
kept(false, Attribute, Rest, [Attribute|Rest]).

gdpr_processor_contract_profile_for(todo_baseline_subject, Profile) :-
    contract_base(Profile).
gdpr_processor_contract_profile_for(eligible_without_subprocessor, Profile) :-
    contract_base(Profile).
gdpr_processor_contract_profile_for(eligible_with_standard_clauses_recorded, Profile) :-
    contract_base(Base),
    attestation_of(true, Attested),
    append(Base, [attribute(standard_clauses_adopted, Attested)], Profile).
gdpr_processor_contract_profile_for(near_miss_malformed_standard_clauses, Profile) :-
    contract_base(Base),
    attestation_of(maybe, Attested),
    append(Base, [attribute(standard_clauses_adopted, Attested)], Profile).
gdpr_processor_contract_profile_for(near_miss_missing_point_h, Profile) :-
    contract_base(Base),
    replaced(stipulates_information_and_audit_rights, false, Base, Profile).
gdpr_processor_contract_profile_for(near_miss_partial_point_a_recorded_false, Profile) :-
    contract_base(Base),
    replaced(stipulates_processing_only_on_documented_instructions, false, Base, Profile).
gdpr_processor_contract_profile_for(near_miss_third_country_law, Profile) :-
    contract_base(Base),
    replaced(contract_governed_by_union_or_member_state_law, false, Base, Profile).
gdpr_processor_contract_profile_for(near_miss_insufficient_guarantees, Profile) :-
    contract_base(Base),
    replaced(processor_provides_sufficient_guarantees, false, Base, Profile).
gdpr_processor_contract_profile_for(eligible_specific_written_authorisation, Profile) :-
    subprocessor_base(specific_written, Profile).
gdpr_processor_contract_profile_for(near_miss_authorisation_none, Profile) :-
    subprocessor_base(none, Profile).
gdpr_processor_contract_profile_for(subprocessor_obligations_unsure, Profile) :-
    subprocessor_base(specific_written, Base),
    replaced(subprocessor_obligations_same, unsure, Base, Profile).
gdpr_processor_contract_profile_for(eligible_general_written_authorisation, Profile) :-
    general_written_base(Profile).
gdpr_processor_contract_profile_for(near_miss_general_written_without_objection_opportunity, Profile) :-
    general_written_base(Base),
    replaced(controller_given_opportunity_to_object, false, Base, Profile).
gdpr_processor_contract_profile_for(not_applicable_not_on_behalf, Profile) :-
    contract_base(Base),
    replaced(processing_on_behalf_of_controller, false, Base, Profile).
gdpr_processor_contract_profile_for(role_controller_deferred, Profile) :-
    contract_base(Base),
    replaced(processor_determines_purposes_and_means, true, Base, Profile).
gdpr_processor_contract_profile_for(role_processing_unsure, Profile) :-
    contract_base(Base),
    replaced(processing_on_behalf_of_controller, unsure, Base, Profile).
gdpr_processor_contract_profile_for(role_purposes_and_means_unsure, Profile) :-
    contract_base(Base),
    replaced(processor_determines_purposes_and_means, unsure, Base, Profile).
gdpr_processor_contract_profile_for(role_processing_absent, Profile) :-
    contract_base(Base),
    removed(processing_on_behalf_of_controller, Base, Profile).
gdpr_processor_contract_profile_for(role_purposes_and_means_absent, Profile) :-
    contract_base(Base),
    removed(processor_determines_purposes_and_means, Base, Profile).
gdpr_processor_contract_profile_for(absent_keys_list_all, Profile) :-
    contract_base(Base),
    removed(contract_in_writing, Base, Middle),
    removed(stipulates_security_measures, Middle, Profile).
gdpr_processor_contract_profile_for(near_miss_unmet_dominates_absence, Profile) :-
    contract_base(Base),
    removed(contract_in_writing, Base, Middle),
    replaced(stipulates_security_measures, false, Middle, Profile).
gdpr_processor_contract_profile_for(checklist_binding_unsure, Profile) :-
    contract_base(Base),
    replaced(contract_binding_on_processor, unsure, Base, Profile).
gdpr_processor_contract_profile_for(unread_keys_ignored, Profile) :-
    contract_base(Base),
    attestation_of(false, Attested),
    append(Base, [attribute(subprocessor_authorisation, none), attribute(subprocessor_contract_in_writing, false), attribute(controller_given_opportunity_to_object, false), attribute(standard_clauses_adopted, Attested)], Profile).
gdpr_processor_contract_profile_for(input_problems_mixed, Profile) :-
    contract_base(Base),
    replaced(contract_in_writing, unsure, Base, Middle),
    append(Middle, [attribute(subprocessor_engaged, true), attribute(stray_key, true), attribute(stray_key, false)], Profile).

gdpr_processor_contract_assess(Subject, Result) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    decide_processor_contract_status(Profile, Result).
