% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_kernel, [gdpr_chapter_v_transfers_cascade/5, gdpr_chapter_v_transfers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer, [decide_transfer/2, transfer_checklist/2, transfer_decision_resolvable/1, transfer_outside_facts/2, transfer_permitted/2, transfer_requirement/4, transfer_requirement_ids/1, transfer_status/2, transfer_status_values/1, transfer_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer_basis, [decide_transfer_basis/2, transfer_basis/2, transfer_basis_checklist/2, transfer_basis_decision_resolvable/1, transfer_basis_status/2, transfer_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_queries, [attested/2, cross_reference_unresolved/2, duplicate_key/1, gdpr_chapter_v_transfers_profile_keys/1, gdpr_chapter_v_transfers_what_if/4, indeterminate/1, input_problems/1, inputs_relied_on/1, needs_legal_review/2, open_textured/2, outside_fact/2, provenance/2, resolution/2, wrong_type/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_fixtures, [gdpr_chapter_v_transfers_assess/2, gdpr_chapter_v_transfers_profile_for/2, gdpr_chapter_v_transfers_subject/1]).

root_export(absent).
root_export(adequacy_decision_in_force).
root_export(attestation).
root_export(binding_corporate_rules_approved).
root_export(contract_necessity).
root_export(data_subject_interest_contract_necessity).
root_export(derogation_claimed).
root_export(document).
root_export(explicit_consent_obtained).
root_export(important_public_interest).
root_export(international_agreement_basis_for_judgment_or_decision).
root_export(legal_claims_necessity).
root_export(legitimate_interests_derogation).
root_export(none).
root_export(not_attempted).
root_export(public_authority_public_powers).
root_export(register_consultation_conditions_fulfilled).
root_export(register_not_entire).
root_export(register_public_by_law).
root_export(register_requester_condition_met).
root_export(safeguard_in_place).
root_export(third_country_judgment_or_decision_requires_transfer).
root_export(transfer_is_onward_transfer).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(vital_interests_necessity).
