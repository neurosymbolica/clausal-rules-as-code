% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, decide_gdpr_administrative_fine_maximum/2, gdpr_administrative_fine_maximum_checklist/2, gdpr_administrative_fine_maximum_decision_resolvable/1, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_queries, [gdpr_administrative_fine_maximum_profile_keys/1, gdpr_administrative_fine_maximum_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_assess/2, gdpr_administrative_fine_maximum_profile_for/2, gdpr_administrative_fine_maximum_subject/1]).

root_export(duplicate_key).
root_export(fine_maximum).
root_export(indeterminate).
root_export(infringed_provisions).
root_export(infringement_maximum).
root_export(infringements_concern_same_or_linked_processing_operations).
root_export(infringements_intentional_or_negligent).
root_export(infringer_is_undertaking).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(open_textured).
root_export(separate_fine_maxima).
root_export(total_worldwide_annual_turnover_in_euros).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
