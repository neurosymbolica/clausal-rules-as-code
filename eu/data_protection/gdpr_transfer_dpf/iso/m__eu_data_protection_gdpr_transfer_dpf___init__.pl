% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_kernel, [gdpr_transfer_dpf_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [data_privacy_framework_adequacy/4, decide_gdpr_transfer_dpf/2, gdpr_transfer_dpf_checklist/2, gdpr_transfer_dpf_decision_resolvable/1, gdpr_transfer_dpf_status/2, gdpr_transfer_dpf_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_queries, [covered_by_data_privacy_framework_adequacy/0, gdpr_transfer_dpf_compliance_check/2, gdpr_transfer_dpf_profile_keys/1, gdpr_transfer_dpf_what_if/4, not_covered_by_data_privacy_framework_adequacy/0]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_fixtures, [gdpr_transfer_dpf_assess/2, gdpr_transfer_dpf_profile_for/2, gdpr_transfer_dpf_subject/1]).

root_export(absent).
root_export(attestation).
root_export(attested).
root_export(certification_covers_transferred_data).
root_export(cite).
root_export(covered_by_data_privacy_framework_adequacy).
root_export(cross_reference_unresolved).
root_export(data_privacy_framework_decision_in_force).
root_export(document).
root_export(duplicate_key).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(not_attempted).
root_export(not_covered_by_data_privacy_framework_adequacy).
root_export(outside_fact).
root_export(recipient_is_organisation_in_united_states).
root_export(recipient_on_data_privacy_framework_list).
root_export(resolution).
root_export(transfer_from_union).
root_export(unknown_key).
root_export(url).
root_export(wrong_type).
