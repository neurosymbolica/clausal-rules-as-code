% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [contract_checklist/2, contract_missing_stipulations/2, decide_processor_contract/2, decide_processor_contract_status/2, processor_contract_outside_facts/2, processor_contract_status/2, processor_contract_status_checklist/2, processor_contract_status_decision_resolvable/1, processor_contract_status_status/2, processor_contract_status_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_queries, [gdpr_processor_contract_profile_keys/1, gdpr_processor_contract_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_assess/2, gdpr_processor_contract_profile_for/2, gdpr_processor_contract_subject/1]).

root_export(absent).
root_export(attestation).
root_export(attested).
root_export(checklist_item).
root_export(contract_binding_on_processor).
root_export(contract_governed_by_union_or_member_state_law).
root_export(contract_in_writing).
root_export(contract_sets_out_categories_of_data_subjects).
root_export(contract_sets_out_controller_obligations_and_rights).
root_export(contract_sets_out_duration).
root_export(contract_sets_out_nature_of_processing).
root_export(contract_sets_out_purpose_of_processing).
root_export(contract_sets_out_subject_matter).
root_export(contract_sets_out_type_of_personal_data).
root_export(controller_given_opportunity_to_object).
root_export(deferred_provision).
root_export(document).
root_export(duplicate_key).
root_export(general_written).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(none).
root_export(not_attempted).
root_export(open_textured).
root_export(outside_fact).
root_export(processing_on_behalf_of_controller).
root_export(processor_contract_verdict).
root_export(processor_determines_purposes_and_means).
root_export(processor_informed_controller_of_intended_changes).
root_export(processor_provides_sufficient_guarantees).
root_export(provenance).
root_export(specific_written).
root_export(standard_clauses_adopted).
root_export(stipulates_assistance_with_articles_32_to_36_obligations).
root_export(stipulates_assistance_with_data_subject_requests).
root_export(stipulates_conditions_for_engaging_another_processor).
root_export(stipulates_confidentiality_commitment).
root_export(stipulates_deletion_or_return_of_personal_data).
root_export(stipulates_information_and_audit_rights).
root_export(stipulates_notice_of_infringing_instruction).
root_export(stipulates_processing_only_on_documented_instructions).
root_export(stipulates_security_measures).
root_export(subprocessor_authorisation).
root_export(subprocessor_authorisation_given_before_engagement).
root_export(subprocessor_contract_governed_by_union_or_member_state_law).
root_export(subprocessor_contract_in_writing).
root_export(subprocessor_engaged).
root_export(subprocessor_obligations_same).
root_export(subprocessor_provides_sufficient_guarantees).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
