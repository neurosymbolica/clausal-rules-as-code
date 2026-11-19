% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [calendar_date_before/2, calendar_date_on_or_before/2, calendar_date_relation/3, contract_keys/1, gdpr_information_duties_timing_input_problems/2, keys_in_contract_order/2, profile_key_status/3, public_holidays_referral/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_citations, [citation/2, implements/1, limb_citation/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_parameters, [parameter_source/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [deadline_resolution/2, decide_information_deadline/2, decide_information_deadline_basis/2, earliest_event_limb/2, information_deadline_basis_checklist/2, information_deadline_basis_decision_resolvable/1, information_deadline_basis_status/2, information_deadline_basis_status_values/1, limb_a_date/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [decide_information_timing_verdict/2, information_timing_verdict_checklist/2, information_timing_verdict_decision_resolvable/1, information_timing_verdict_status/2, information_timing_verdict_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [attestation/4, attested/2, cross_reference_unresolved/2, document/2, duplicate_key/1, gdpr_information_duties_timing_compliance_check/3, gdpr_information_duties_timing_obligation/2, gdpr_information_duties_timing_profile_keys/1, gdpr_information_duties_timing_what_if/4, indeterminate/1, information_deadline/2, information_deadline_basis/2, information_timing_verdict/3, input_problems/1, inputs_relied_on/1, needs_legal_review/2, open_textured/2, provenance/2, resolution/2, unknown_key/1, url/2, wrong_type/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_assess/2, gdpr_information_duties_timing_profile_for/2, gdpr_information_duties_timing_subject/1]).

root_export(art13_1).
root_export(art14_3_a).
root_export(art14_3_b).
root_export(art14_3_c).
root_export(automated_decision_making_information).
root_export(automated_decision_making_under_article_22).
root_export(categories_of_personal_data).
root_export(controller_identity_and_contact_details).
root_export(data_protection_officer_contact_details).
root_export(data_protection_officer_designated).
root_export(data_subject_rights).
root_export(data_used_for_communication_with_data_subject).
root_export(disclosure_to_another_recipient_envisaged).
root_export(first_communication_date).
root_export(first_disclosure_date).
root_export(further_processing_for_another_purpose_intended).
root_export(further_processing_information_date).
root_export(further_processing_items_provided).
root_export(further_processing_start_date).
root_export(items_data_subject_already_has).
root_export(items_provided).
root_export(late).
root_export(legitimate_interests).
root_export(not_attempted).
root_export(obtaining_date).
root_export(obtaining_or_disclosure_laid_down_by_law).
root_export(other_purpose_information).
root_export(paragraph_2_information_relevant_to_further_processing).
root_export(personal_data_collected_from_data_subject).
root_export(processing_based_on_consent).
root_export(processing_based_on_legitimate_interests).
root_export(professional_secrecy_obligation_by_law).
root_export(profile).
root_export(protective_measures_taken).
root_export(provided_within_reasonable_period).
root_export(provision_date).
root_export(provision_impossible_or_disproportionate_effort).
root_export(public_holidays).
root_export(purposes_and_legal_basis).
root_export(recipients_exist).
root_export(recipients_or_categories_of_recipients).
root_export(right_to_lodge_complaint).
root_export(right_to_withdraw_consent).
root_export(source_of_personal_data).
root_export(statutory_or_contractual_requirement).
root_export(storage_period_or_criteria).
root_export(third_country_transfer_information).
root_export(timely).
root_export(transfer_intended).
root_export(unsure).
