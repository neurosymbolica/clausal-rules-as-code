% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_kernel, [nis2_lex_specialis_and_definitions_input_problems/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_citations, [citation/2, implements/1]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [decide_nis2_lex_specialis_and_definitions/2, essential_entity/0, important_entity/0, nis2_incident_notification_provisions_status/3, nis2_lex_specialis_and_definitions_checklist/2, nis2_lex_specialis_and_definitions_decision_resolvable/1, nis2_lex_specialis_and_definitions_status/2, nis2_lex_specialis_and_definitions_status_values/1, nis2_provisions_apply/0, nis2_provisions_disapplied/0, nis2_risk_management_provisions_status/3, out_of_scope/0]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_queries, [nis2_lex_specialis_and_definitions_profile_keys/1, nis2_lex_specialis_and_definitions_what_if/4]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_fixtures, [nis2_lex_specialis_and_definitions_assess/2, nis2_lex_specialis_and_definitions_profile_for/2, nis2_lex_specialis_and_definitions_subject/1]).

root_export(dora_gives_immediate_access_to_incident_notifications).
root_export(dora_incident_notification_requirements_at_least_equivalent_in_effect).
root_export(dora_risk_management_measures_at_least_equivalent_in_effect).
root_export(duplicate_key).
root_export(entity_class).
root_export(essential_entity).
root_export(important_entity).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(nis2_provisions_apply).
root_export(nis2_provisions_disapplied).
root_export(open_textured).
root_export(out_of_scope).
root_export(provenance).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
