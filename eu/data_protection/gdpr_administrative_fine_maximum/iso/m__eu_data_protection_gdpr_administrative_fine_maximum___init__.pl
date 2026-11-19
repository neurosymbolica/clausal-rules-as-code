% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, decide_gdpr_administrative_fine_maximum/2, duplicate_key/1, fine_maximum/3, gdpr_administrative_fine_maximum_checklist/2, gdpr_administrative_fine_maximum_decision_resolvable/1, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_status_values/1, indeterminate/1, infringement_maximum/4, input_problems/1, inputs_relied_on/1, needs_legal_review/2, not_governed_here/1, open_textured/2, separate_fine_maxima/1, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_queries, [gdpr_administrative_fine_maximum_cap_in_euro_cents/2, gdpr_administrative_fine_maximum_profile_keys/1, gdpr_administrative_fine_maximum_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_assess/2, gdpr_administrative_fine_maximum_profile_for/2, gdpr_administrative_fine_maximum_subject/1]).

root_export(infringed_provisions).
root_export(infringements_concern_same_or_linked_processing_operations).
root_export(infringements_intentional_or_negligent).
root_export(infringer_is_undertaking).
root_export(total_worldwide_annual_turnover_in_euros).
root_export(unsure).
