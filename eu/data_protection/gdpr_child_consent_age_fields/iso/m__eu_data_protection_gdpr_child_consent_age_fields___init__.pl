% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_outside_facts/2, child_consent_status/2, child_consent_status_checklist/2, child_consent_status_decision_resolvable/1, child_consent_status_status/2, child_consent_status_status_values/1, decide_child_consent_status/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_parental_verification, [decide_parental_verification/2, parental_verification/2, parental_verification_checklist/2, parental_verification_decision_resolvable/1, parental_verification_status/2, parental_verification_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_queries, [gdpr_child_consent_age_fields_compliance_check/3, gdpr_child_consent_age_fields_justification/2, gdpr_child_consent_age_fields_profile_keys/1, gdpr_child_consent_age_fields_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_fixtures, [gdpr_child_consent_age_fields_assess/2, gdpr_child_consent_age_fields_profile_for/2, gdpr_child_consent_age_fields_subject/1]).

root_export(absent).
root_export(attestation).
root_export(attested).
root_export(austria).
root_export(belgium).
root_export(bulgaria).
root_export(child_age_years).
root_export(child_residence).
root_export(consent_date).
root_export(controller_establishment).
root_export(croatia).
root_export(cross_reference_unresolved).
root_export(cyprus).
root_export(czechia).
root_export(denmark).
root_export(document).
root_export(duplicate_key).
root_export(estonia).
root_export(fetched).
root_export(finland).
root_export(france).
root_export(germany).
root_export(greece).
root_export(hungary).
root_export(indeterminate).
root_export(information_society_service).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(ireland).
root_export(italy).
root_export(latvia).
root_export(lithuania).
root_export(luxembourg).
root_export(malta).
root_export(member_state).
root_export(member_state_digital_consent_age).
root_export(member_state_selection_test).
root_export(national_digital_consent_age).
root_export(needs_legal_review).
root_export(netherlands).
root_export(none).
root_export(not_attempted).
root_export(offered_directly_to_child).
root_export(open_textured).
root_export(outside_fact).
root_export(parental_consent_given).
root_export(poland).
root_export(portugal).
root_export(processing_rests_on_consent).
root_export(provenance).
root_export(resolution).
root_export(romania).
root_export(slovakia).
root_export(slovenia).
root_export(source).
root_export(spain).
root_export(sweden).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(verification_efforts_reasonable).
root_export(wrong_type).
