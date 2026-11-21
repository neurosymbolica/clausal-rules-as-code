% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, decide_gdpr_compensation_and_liability/2, gdpr_compensation_and_liability_checklist/2, gdpr_compensation_and_liability_decision_resolvable/1, gdpr_compensation_and_liability_status/2, gdpr_compensation_and_liability_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_queries, [exempt_from_liability/0, gdpr_compensation_and_liability_profile_keys/1, gdpr_compensation_and_liability_what_if/4, liable_for_damage/0, not_liable_for_damage/0, right_not_established/0]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_assess/2, gdpr_compensation_and_liability_profile_for/2, gdpr_compensation_and_liability_subject/1]).

root_export(absent).
root_export(attestation).
root_export(attested).
root_export(controller).
root_export(cross_reference_unresolved).
root_export(damage_resulted_from_the_infringement).
root_export(damage_suffered).
root_export(document).
root_export(duplicate_key).
root_export(exempt_from_liability).
root_export(indeterminate).
root_export(infringement_of_the_regulation_occurred).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(involved_in_the_processing).
root_export(liable_for_damage).
root_export(needs_legal_review).
root_export(not_attempted).
root_export(not_in_any_way_responsible_for_the_event).
root_export(not_liable_for_damage).
root_export(open_textured).
root_export(outside_fact).
root_export(party_role).
root_export(processor).
root_export(processor_acted_outside_or_contrary_to_lawful_instructions).
root_export(processor_breached_obligations_directed_to_processors).
root_export(provenance).
root_export(resolution).
root_export(right_not_established).
root_export(unknown_key).
root_export(unsure).
root_export(url).
root_export(wrong_type).
