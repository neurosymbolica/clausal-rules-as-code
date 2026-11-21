% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_kernel, [gdpr_corrective_powers_named_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_gdpr_corrective_powers_named, [corrective_power_named/4, corrective_powers_named/3, decide_gdpr_corrective_powers_named/2, gdpr_corrective_powers_named_checklist/2, gdpr_corrective_powers_named_decision_resolvable/1, gdpr_corrective_powers_named_status/2, gdpr_corrective_powers_named_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_queries, [administrative_fine/0, authority_discretion/0, certification_body/0, controller/0, gdpr_corrective_powers_named_profile_keys/1, gdpr_corrective_powers_named_what_if/4, limitation_or_ban_on_processing/0, named/2, not_named/0, order_of_rectification_erasure_or_restriction/0, order_to_bring_processing_into_compliance/0, order_to_communicate_personal_data_breach/0, order_to_comply_with_data_subject_requests/0, powers_named/2, processor/0, reprimand/0, suspension_of_data_flows/0, warning/0, withdrawal_or_refusal_of_certification/0]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_fixtures, [gdpr_corrective_powers_named_assess/2, gdpr_corrective_powers_named_profile_for/2, gdpr_corrective_powers_named_subject/1]).

root_export(administrative_fine).
root_export(authority_discretion).
root_export(certification_body).
root_export(certification_issued_or_applied_for).
root_export(certification_requirements_not_met).
root_export(controller).
root_export(data_flows_to_third_country_or_international_organisation).
root_export(data_subject_request_to_exercise_rights_made).
root_export(duplicate_key).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(intended_processing_likely_to_infringe).
root_export(limitation_or_ban_on_processing).
root_export(needs_legal_review).
root_export(not_named).
root_export(order_of_rectification_erasure_or_restriction).
root_export(order_to_bring_processing_into_compliance).
root_export(order_to_communicate_personal_data_breach).
root_export(order_to_comply_with_data_subject_requests).
root_export(personal_data_breach_occurred).
root_export(power).
root_export(processing_has_infringed).
root_export(processing_not_in_compliance).
root_export(processor).
root_export(rectification_erasure_or_restriction_ground_met).
root_export(reprimand).
root_export(suspension_of_data_flows).
root_export(unknown_key).
root_export(unsure).
root_export(warning).
root_export(withdrawal_or_refusal_of_certification).
root_export(wrong_type).
