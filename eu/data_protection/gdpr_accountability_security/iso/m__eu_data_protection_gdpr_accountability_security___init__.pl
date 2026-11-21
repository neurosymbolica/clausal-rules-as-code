% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_kernel, [gdpr_accountability_security_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_gdpr_accountability_security, [decide_gdpr_accountability_security/2, duty_status/5, gdpr_accountability_security_checklist/2, gdpr_accountability_security_decision_resolvable/1, gdpr_accountability_security_status/2, gdpr_accountability_security_status_values/1, joint_controller_arrangement/3, joint_controller_arrangement_content/4, non_binding_items/3]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_queries, [accountability/0, accountability_demonstrated/0, accountability_principles/0, arrangement_between_controllers_exists/0, arrangement_in_place/0, arrangement_missing/0, arrangement_not_required/0, arrangement_reflects_roles_and_relationships/0, authorised_persons_process_only_on_instructions/0, by_default_accessibility_limited_to_necessary/0, by_default_amount_collected_limited_to_necessary/0, by_default_extent_of_processing_limited_to_necessary/0, by_default_not_accessible_to_indefinite_number_without_intervention/0, by_default_only_necessary_data_processed/0, by_default_storage_period_limited_to_necessary/0, by_design_measures_implemented/0, content_requirements_met/0, content_requirements_not_met/0, controller_measures/0, controller_measures_implemented_and_reviewed/0, controllers_jointly_determine_purposes_and_means/0, data_protection_by_default/0, data_protection_by_design/0, data_protection_policies/0, data_protection_policies_implemented/0, essence_of_arrangement_made_available/0, gdpr_accountability_security_profile_keys/1, gdpr_accountability_security_what_if/4, met/0, not_joint_controllers/0, not_met/0, processing_on_instructions/0, responsibilities_set_by_union_or_member_state_law/0, security_level_appropriate_to_risk/0, security_measures/0, security_of_processing/0, unsure/0]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_fixtures, [gdpr_accountability_security_assess/2, gdpr_accountability_security_profile_for/2, gdpr_accountability_security_subject/1]).

root_export(absent).
root_export(accountability).
root_export(accountability_demonstrated).
root_export(accountability_principles).
root_export(arrangement_between_controllers_exists).
root_export(arrangement_in_place).
root_export(arrangement_missing).
root_export(arrangement_not_required).
root_export(arrangement_reflects_roles_and_relationships).
root_export(attestation).
root_export(attested).
root_export(authorised_persons_process_only_on_instructions).
root_export(by_default_accessibility_limited_to_necessary).
root_export(by_default_amount_collected_limited_to_necessary).
root_export(by_default_extent_of_processing_limited_to_necessary).
root_export(by_default_not_accessible_to_indefinite_number_without_intervention).
root_export(by_default_only_necessary_data_processed).
root_export(by_default_storage_period_limited_to_necessary).
root_export(by_design_measures_implemented).
root_export(content_requirements_met).
root_export(content_requirements_not_met).
root_export(controller_measures).
root_export(controller_measures_implemented_and_reviewed).
root_export(controllers_jointly_determine_purposes_and_means).
root_export(cross_reference_unresolved).
root_export(data_protection_by_default).
root_export(data_protection_by_design).
root_export(data_protection_policies).
root_export(data_protection_policies_implemented).
root_export(document).
root_export(duplicate_key).
root_export(essence_of_arrangement_made_available).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(met).
root_export(needs_legal_review).
root_export(non_binding_item).
root_export(not_attempted).
root_export(not_joint_controllers).
root_export(not_met).
root_export(open_textured).
root_export(outside_fact).
root_export(processing_on_instructions).
root_export(provenance).
root_export(resolution).
root_export(responsibilities_set_by_union_or_member_state_law).
root_export(security_level_appropriate_to_risk).
root_export(security_measures).
root_export(security_of_processing).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
