% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_kernel, [gdpr_transfer_scc_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [decide_gdpr_transfer_scc/2, gdpr_transfer_scc_checklist/2, gdpr_transfer_scc_decision_resolvable/1, gdpr_transfer_scc_status/2, gdpr_transfer_scc_status_values/1, standard_contractual_clauses_appendix/3, standard_contractual_clauses_availability/4, standard_contractual_clauses_module/3, standard_contractual_clauses_safeguard/4]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_queries, [attested/2, cross_reference_unresolved/2, gdpr_transfer_scc_profile_keys/1, gdpr_transfer_scc_reliance_check/2, gdpr_transfer_scc_what_if/4, indeterminate/1, input_problems/1, open_textured/2, outside_fact/2, resolution/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_fixtures, [gdpr_transfer_scc_assess/2, gdpr_transfer_scc_expected/2, gdpr_transfer_scc_near_miss/2, gdpr_transfer_scc_profile_for/2, gdpr_transfer_scc_subject/1]).

root_export(absent).
root_export(added_clauses_contradict_clauses).
root_export(annex_i_a_list_of_parties_completed).
root_export(annex_i_b_description_of_transfer_completed).
root_export(annex_i_c_competent_supervisory_authority_identified).
root_export(annex_ii_measures_described_in_specific_terms).
root_export(annex_iii_list_of_sub_processors_completed).
root_export(appendix_complete).
root_export(appendix_incomplete).
root_export(appropriate_safeguards_not_provided).
root_export(appropriate_safeguards_provided).
root_export(attestation).
root_export(clauses_available).
root_export(clauses_modified).
root_export(clauses_not_available).
root_export(controller).
root_export(document).
root_export(duplicate_key).
root_export(exporter_processing_subject_to_gdpr).
root_export(exporter_role).
root_export(general_written_authorisation).
root_export(importer_processing_subject_to_gdpr).
root_export(importer_role).
root_export(inputs_relied_on).
root_export(local_laws_assessment_documented).
root_export(module_four).
root_export(module_one).
root_export(module_selected).
root_export(module_three).
root_export(module_two).
root_export(needs_legal_review).
root_export(no_reason_to_believe_local_laws_prevent_compliance).
root_export(not_attempted).
root_export(processor).
root_export(processor_combines_received_data_with_data_collected_in_union).
root_export(specific_prior_authorisation).
root_export(standard_contractual_clauses_concluded).
root_export(standard_contractual_clauses_decision_in_force).
root_export(sub_processor_authorisation_option).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
