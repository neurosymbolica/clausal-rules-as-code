% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_citations, [citation/2, implements/1]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [arrangement_notification_duty/3, cyber_threat/0, decide_nis2_information_sharing_voluntary_notification/2, entered/0, essential_entity/0, important_entity/0, incident/0, information_exchange_not_permitted/0, information_exchange_permitted/0, information_exchange_permitted/3, must_notify_on_entering/0, must_notify_on_withdrawal_taking_effect/0, near_miss/0, nis2_information_sharing_voluntary_notification_checklist/2, nis2_information_sharing_voluntary_notification_decision_resolvable/1, nis2_information_sharing_voluntary_notification_status/2, nis2_information_sharing_voluntary_notification_status_values/1, no_arrangement_event/0, no_notification_duty/0, out_of_scope/0, significant_incident/0, voluntary_notification_not_possible/0, voluntary_notification_possible/0, voluntary_notification_possible/3, withdrew/0]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_queries, [nis2_information_sharing_voluntary_notification_profile_keys/1, nis2_information_sharing_voluntary_notification_what_if/4]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_fixtures, [nis2_information_sharing_voluntary_notification_assess/2, nis2_information_sharing_voluntary_notification_profile_for/2, nis2_information_sharing_voluntary_notification_subject/1]).

root_export(arrangement_event).
root_export(arrangement_is_a_cybersecurity_information_sharing_arrangement).
root_export(cyber_threat).
root_export(duplicate_key).
root_export(entered).
root_export(entity_class).
root_export(essential_entity).
root_export(event_kind).
root_export(important_entity).
root_export(incident).
root_export(indeterminate).
root_export(information_exchange_not_permitted).
root_export(information_is_relevant_cybersecurity_information).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(must_notify_on_entering).
root_export(must_notify_on_withdrawal_taking_effect).
root_export(near_miss).
root_export(needs_legal_review).
root_export(no_arrangement_event).
root_export(no_notification_duty).
root_export(open_textured).
root_export(out_of_scope).
root_export(provenance).
root_export(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact).
root_export(sharing_enhances_the_level_of_cybersecurity).
root_export(significant_incident).
root_export(unknown_key).
root_export(unsure).
root_export(voluntary_notification_not_possible).
root_export(withdrew).
root_export(wrong_type).
