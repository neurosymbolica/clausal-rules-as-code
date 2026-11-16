% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, decide_gdpr_art36_3_consultation_request/2, gdpr_art36_3_consultation_request_checklist/2, gdpr_art36_3_consultation_request_decision_resolvable/1, gdpr_art36_3_consultation_request_status/2, gdpr_art36_3_consultation_request_status_values/1, missing_consultation_request_items/4]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_queries, [consultation_request_complete/0, consultation_request_incomplete/0, data_protection_impact_assessment/0, data_protection_officer_contact_details/0, gdpr_art36_3_consultation_request_profile_keys/1, gdpr_art36_3_consultation_request_what_if/4, measures_and_safeguards/0, not_governed_by_article_36_3/0, other_requested_information/0, purposes_and_means/0, respective_responsibilities/0]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_assess/2, gdpr_art36_3_consultation_request_profile_for/2, gdpr_art36_3_consultation_request_subject/1]).

root_export(absent).
root_export(consultation_request_complete).
root_export(consultation_request_incomplete).
root_export(consultation_under_article_36_1).
root_export(data_protection_impact_assessment).
root_export(data_protection_officer_contact_details).
root_export(data_protection_officer_contact_details_provided).
root_export(data_protection_officer_designated).
root_export(impact_assessment_provided).
root_export(joint_controllers_or_processors_involved).
root_export(measures_and_safeguards).
root_export(measures_and_safeguards_provided).
root_export(not_attempted).
root_export(not_governed_by_article_36_3).
root_export(other_information_requested_by_supervisory_authority).
root_export(other_requested_information).
root_export(purposes_and_means).
root_export(purposes_and_means_provided).
root_export(requested_other_information_provided).
root_export(respective_responsibilities).
root_export(respective_responsibilities_provided).
