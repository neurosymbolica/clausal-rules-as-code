% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_checklist/2, gdpr_art6_lawful_basis_decision_resolvable/1, gdpr_art6_lawful_basis_status/2, gdpr_art6_lawful_basis_status_values/1, lawful_basis_status/4, purpose_compatibility/4]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_queries, [compatibility_test_not_engaged/0, eligible/0, gdpr_art6_lawful_basis_profile_keys/1, gdpr_art6_lawful_basis_what_if/4, ineligible/0, purpose_compatible/0, purpose_not_compatible/0]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_assess/2, gdpr_art6_lawful_basis_profile_for/2, gdpr_art6_lawful_basis_subject/1]).

root_export(absent).
root_export(attestation).
root_export(attested).
root_export(basis_claimed).
root_export(child_data_subject).
root_export(compatibility_test_not_engaged).
root_export(compatible_purpose).
root_export(consent).
root_export(consent_given_and_conditions_met).
root_export(contract).
root_export(contract_necessary).
root_export(cross_reference_unresolved).
root_export(document).
root_export(duplicate_key).
root_export(eligible).
root_export(flagged).
root_export(indeterminate).
root_export(ineligible).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(interests_overridden).
root_export(legal_obligation).
root_export(legal_obligation_laid_down_by_law).
root_export(legal_obligation_necessary).
root_export(legitimate_interests).
root_export(legitimate_interests_pursued).
root_export(needs_legal_review).
root_export(new_purpose_processing).
root_export(not_attempted).
root_export(open_textured).
root_export(outside_fact).
root_export(processing_by_public_authority_in_its_tasks).
root_export(provenance).
root_export(public_interest_task).
root_export(public_interest_task_laid_down_by_law).
root_export(public_interest_task_necessary).
root_export(purpose_compatible).
root_export(purpose_not_compatible).
root_export(resolution).
root_export(special_category).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(vital_interests).
root_export(vital_interests_necessary).
root_export(wrong_type).
