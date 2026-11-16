% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_kernel, [dsa_art_28_minors_order_input_problems/2]).
:- use_module(m__eu_dsa_art_28_minors_order_citations, [citation/2, implements/1]).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [art_28_1_compliance_status/4, art_28_1_measures_compliant/0, art_28_1_measures_not_compliant/0, art_28_1_measures_not_required/0, art_28_1_obligation_applies/0, art_28_1_obligation_not_applicable/0, art_28_1_obligation_status/4, art_28_2_advertising_status/4, art_28_2_presentation_not_prohibited/0, art_28_2_presentation_prohibited/0, decide_dsa_art_28_minors_order/2, dsa_art_28_minors_order_checklist/2, dsa_art_28_minors_order_decision_resolvable/1, dsa_art_28_minors_order_status/2, dsa_art_28_minors_order_status_values/1, section_3_application_status/4, section_3_applies/0, section_3_not_applicable/0]).
:- use_module(m__eu_dsa_art_28_minors_order_queries, [absent/0, advertisements_based_on_profiling_of_recipient/0, advertisements_presented_to_recipient_on_interface/0, aware_with_reasonable_certainty_recipient_is_minor/0, designated_as_very_large_online_platform/0, dsa_art_28_minors_order_profile_keys/1, dsa_art_28_minors_order_what_if/4, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors/0, not_attempted/0, platform_accessible_to_minors/0, provider_qualifies_as_micro_or_small_enterprise/0, provider_within_12_months_after_losing_micro_or_small_status/0, unsure/0]).
:- use_module(m__eu_dsa_art_28_minors_order_fixtures, [dsa_art_28_minors_order_assess/2, dsa_art_28_minors_order_profile_for/2, dsa_art_28_minors_order_subject/1]).

root_export(absent).
root_export(advertisements_based_on_profiling_of_recipient).
root_export(advertisements_presented_to_recipient_on_interface).
root_export(art_28_1_measures_compliant).
root_export(art_28_1_measures_not_compliant).
root_export(art_28_1_measures_not_required).
root_export(art_28_1_obligation_applies).
root_export(art_28_1_obligation_not_applicable).
root_export(art_28_2_presentation_not_prohibited).
root_export(art_28_2_presentation_prohibited).
root_export(attestation).
root_export(attested).
root_export(aware_with_reasonable_certainty_recipient_is_minor).
root_export(cross_reference_unresolved).
root_export(designated_as_very_large_online_platform).
root_export(document).
root_export(duplicate_key).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors).
root_export(needs_legal_review).
root_export(not_attempted).
root_export(open_textured).
root_export(outside_fact).
root_export(platform_accessible_to_minors).
root_export(provenance).
root_export(provider_qualifies_as_micro_or_small_enterprise).
root_export(provider_within_12_months_after_losing_micro_or_small_status).
root_export(resolution).
root_export(section_3_applies).
root_export(section_3_not_applicable).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
