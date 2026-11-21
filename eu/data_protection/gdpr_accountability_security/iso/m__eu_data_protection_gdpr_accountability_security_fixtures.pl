% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security_fixtures, [gdpr_accountability_security_subject/1, gdpr_accountability_security_profile_for/2, gdpr_accountability_security_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_gdpr_accountability_security, [decide_gdpr_accountability_security/2]).

true_statement(attested(true, attestation(host_system, attestation_time, controller_statement, none))).

false_statement(attested(false, attestation(host_system, attestation_time, controller_statement, none))).

duty_statements(AccountabilityAttributes, SecurityValue, Attributes) :-
    true_statement(TrueStatement),
    append(AccountabilityAttributes, [attribute(controller_measures_implemented_and_reviewed, TrueStatement), attribute(data_protection_policies_implemented, TrueStatement), attribute(by_design_measures_implemented, TrueStatement), attribute(by_default_only_necessary_data_processed, TrueStatement), attribute(security_level_appropriate_to_risk, SecurityValue), attribute(authorised_persons_process_only_on_instructions, TrueStatement)], Attributes).

all_true_statements(Attributes) :-
    true_statement(TrueStatement),
    duty_statements([attribute(accountability_demonstrated, TrueStatement)], TrueStatement, Attributes).

with_extra(Extra, Profile) :-
    all_true_statements(Statements),
    append(Statements, Extra, Profile).

gdpr_accountability_security_subject(all_statements_true).
gdpr_accountability_security_subject(security_statement_false).
gdpr_accountability_security_subject(accountability_statement_absent).
gdpr_accountability_security_subject(by_default_storage_aspect_false).
gdpr_accountability_security_subject(by_default_all_aspects_true).
gdpr_accountability_security_subject(by_default_crisp_fact_false).
gdpr_accountability_security_subject(by_default_crisp_fact_true).
gdpr_accountability_security_subject(joint_arrangement_in_place).
gdpr_accountability_security_subject(joint_arrangement_missing).
gdpr_accountability_security_subject(joint_controllers_unsure).
gdpr_accountability_security_subject(not_joint_controllers).
gdpr_accountability_security_subject(joint_law_sets_responsibilities).
gdpr_accountability_security_subject(joint_law_key_absent).
gdpr_accountability_security_subject(content_requirements_met).
gdpr_accountability_security_subject(content_essence_not_available).
gdpr_accountability_security_subject(content_roles_statement_false).
gdpr_accountability_security_subject(content_roles_statement_absent).
gdpr_accountability_security_subject(duplicated_accountability_statement).
gdpr_accountability_security_subject(unknown_key_present).
gdpr_accountability_security_subject(wrong_type_judgement).

gdpr_accountability_security_profile_for(all_statements_true, Profile) :-
    all_true_statements(Profile).
gdpr_accountability_security_profile_for(security_statement_false, Profile) :-
    true_statement(TrueStatement),
    false_statement(FalseStatement),
    duty_statements([attribute(accountability_demonstrated, TrueStatement)], FalseStatement, Profile).
gdpr_accountability_security_profile_for(accountability_statement_absent, Profile) :-
    true_statement(TrueStatement),
    duty_statements([], TrueStatement, Profile).
gdpr_accountability_security_profile_for(by_default_storage_aspect_false, Profile) :-
    true_statement(TrueStatement),
    false_statement(FalseStatement),
    with_extra([attribute(by_default_amount_collected_limited_to_necessary, TrueStatement), attribute(by_default_extent_of_processing_limited_to_necessary, TrueStatement), attribute(by_default_storage_period_limited_to_necessary, FalseStatement), attribute(by_default_accessibility_limited_to_necessary, TrueStatement), attribute(by_default_not_accessible_to_indefinite_number_without_intervention, true)], Profile).
gdpr_accountability_security_profile_for(by_default_all_aspects_true, Profile) :-
    true_statement(TrueStatement),
    with_extra([attribute(by_default_amount_collected_limited_to_necessary, TrueStatement), attribute(by_default_extent_of_processing_limited_to_necessary, TrueStatement), attribute(by_default_storage_period_limited_to_necessary, TrueStatement), attribute(by_default_accessibility_limited_to_necessary, TrueStatement), attribute(by_default_not_accessible_to_indefinite_number_without_intervention, true)], Profile).
gdpr_accountability_security_profile_for(by_default_crisp_fact_false, Profile) :-
    with_extra([attribute(by_default_not_accessible_to_indefinite_number_without_intervention, false)], Profile).
gdpr_accountability_security_profile_for(by_default_crisp_fact_true, Profile) :-
    with_extra([attribute(by_default_not_accessible_to_indefinite_number_without_intervention, true)], Profile).
gdpr_accountability_security_profile_for(joint_arrangement_in_place, Profile) :-
    with_extra([attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsibilities_set_by_union_or_member_state_law, false), attribute(arrangement_between_controllers_exists, true)], Profile).
gdpr_accountability_security_profile_for(joint_arrangement_missing, Profile) :-
    with_extra([attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsibilities_set_by_union_or_member_state_law, false), attribute(arrangement_between_controllers_exists, false)], Profile).
gdpr_accountability_security_profile_for(joint_controllers_unsure, Profile) :-
    with_extra([attribute(controllers_jointly_determine_purposes_and_means, unsure), attribute(responsibilities_set_by_union_or_member_state_law, false), attribute(arrangement_between_controllers_exists, true)], Profile).
gdpr_accountability_security_profile_for(not_joint_controllers, Profile) :-
    with_extra([attribute(controllers_jointly_determine_purposes_and_means, false)], Profile).
gdpr_accountability_security_profile_for(joint_law_sets_responsibilities, Profile) :-
    with_extra([attribute(controllers_jointly_determine_purposes_and_means, true), attribute(responsibilities_set_by_union_or_member_state_law, true)], Profile).
gdpr_accountability_security_profile_for(joint_law_key_absent, Profile) :-
    with_extra([attribute(controllers_jointly_determine_purposes_and_means, true)], Profile).
gdpr_accountability_security_profile_for(content_requirements_met, Profile) :-
    true_statement(TrueStatement),
    with_extra([attribute(arrangement_reflects_roles_and_relationships, TrueStatement), attribute(essence_of_arrangement_made_available, true)], Profile).
gdpr_accountability_security_profile_for(content_essence_not_available, Profile) :-
    true_statement(TrueStatement),
    with_extra([attribute(arrangement_reflects_roles_and_relationships, TrueStatement), attribute(essence_of_arrangement_made_available, false)], Profile).
gdpr_accountability_security_profile_for(content_roles_statement_false, Profile) :-
    false_statement(FalseStatement),
    with_extra([attribute(arrangement_reflects_roles_and_relationships, FalseStatement), attribute(essence_of_arrangement_made_available, true)], Profile).
gdpr_accountability_security_profile_for(content_roles_statement_absent, Profile) :-
    with_extra([attribute(essence_of_arrangement_made_available, true)], Profile).
gdpr_accountability_security_profile_for(duplicated_accountability_statement, Profile) :-
    true_statement(TrueStatement),
    with_extra([attribute(accountability_demonstrated, TrueStatement)], Profile).
gdpr_accountability_security_profile_for(unknown_key_present, Profile) :-
    with_extra([attribute(controller_location, deu)], Profile).
gdpr_accountability_security_profile_for(wrong_type_judgement, Profile) :-
    with_extra([attribute(controllers_jointly_determine_purposes_and_means, maybe)], Profile).

gdpr_accountability_security_assess(Subject, Result) :-
    gdpr_accountability_security_profile_for(Subject, Profile),
    decide_gdpr_accountability_security(Profile, Result).
