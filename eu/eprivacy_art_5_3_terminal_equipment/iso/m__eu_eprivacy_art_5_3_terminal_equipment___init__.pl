% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_kernel, [eprivacy_art_5_3_terminal_equipment_contract_keys/1, eprivacy_art_5_3_terminal_equipment_input_problems/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_citations, [citation/2, implements/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [decide_eprivacy_art_5_3_terminal_equipment/2, duplicate_key/1, eprivacy_art_5_3_terminal_equipment_checklist/2, eprivacy_art_5_3_terminal_equipment_decision_resolvable/1, eprivacy_art_5_3_terminal_equipment_status/2, eprivacy_art_5_3_terminal_equipment_status_values/1, indeterminate/1, input_problems/1, inputs_relied_on/1, needs_legal_review/2, open_textured/2, provenance/2, terminal_equipment_storage_or_access_permitted/3, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_queries, [eprivacy_art_5_3_terminal_equipment_profile_keys/1, eprivacy_art_5_3_terminal_equipment_what_if/4]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_fixtures, [eprivacy_art_5_3_terminal_equipment_assess/2, eprivacy_art_5_3_terminal_equipment_profile_for/2, eprivacy_art_5_3_terminal_equipment_subject/1]).

root_export(clear_and_comprehensive_information_provided).
root_export(service_explicitly_requested_by_user).
root_export(storage_or_access_in_terminal_equipment).
root_export(storage_or_access_solely_for_transmission).
root_export(strictly_necessary_to_provide_requested_service).
root_export(unsure).
root_export(user_consent_given).
