% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [decide_information_duty_exemption/2, information_duty_exemption/2, information_duty_exemption_checklist/2, information_duty_exemption_decision_resolvable/1, information_duty_exemption_status/2, information_duty_exemption_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [decide_information_duty_verdict/2, information_duty_verdict/3, information_duty_verdict_checklist/2, information_duty_verdict_decision_resolvable/1, information_duty_verdict_status/2, information_duty_verdict_status_values/1, information_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_queries, [attestation/4, attested/2, document/2, duplicate_key/1, gdpr_information_duties_headline_verdict_compliance_check/3, gdpr_information_duties_headline_verdict_deadline/2, gdpr_information_duties_headline_verdict_obligations/2, gdpr_information_duties_headline_verdict_profile_keys/1, gdpr_information_duties_headline_verdict_what_if/4, indeterminate/1, input_problems/1, inputs_relied_on/1, needs_legal_review/2, open_textured/2, outside_fact/2, provenance/2, unknown_key/1, url/2, wrong_type/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_assess/2, gdpr_information_duties_headline_verdict_profile_for/2, gdpr_information_duties_headline_verdict_subject/1]).

root_export(absent).
root_export(automated_decision_making_information).
root_export(automated_decision_making_under_article_22).
root_export(categories_of_personal_data).
root_export(controller_identity_and_contact_details).
root_export(data_protection_officer_contact_details).
root_export(data_protection_officer_designated).
root_export(data_subject_rights).
root_export(data_used_for_communication_with_data_subject).
root_export(disclosure_to_another_recipient_envisaged).
root_export(eligible).
root_export(first_communication_date).
root_export(first_disclosure_date).
root_export(further_processing_for_another_purpose_intended).
root_export(further_processing_information_date).
root_export(further_processing_items_provided).
root_export(further_processing_start_date).
root_export(impossible_or_disproportionate_effort).
root_export(ineligible).
root_export(items_data_subject_already_has).
root_export(items_provided).
root_export(law_lays_down_obtaining_or_disclosure).
root_export(legitimate_interests).
root_export(none).
root_export(obtaining_date).
root_export(obtaining_or_disclosure_laid_down_by_law).
root_export(other_purpose_information).
root_export(paragraph_2_information_relevant_to_further_processing).
root_export(personal_data_collected_from_data_subject).
root_export(processing_based_on_consent).
root_export(processing_based_on_legitimate_interests).
root_export(professional_secrecy_obligation).
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
root_export(transfer_intended).
root_export(unsure).
