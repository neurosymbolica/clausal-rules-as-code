% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_citations, [citation/2, citation_vocabulary/1, implements/1]).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [change_notification_limits/2, decide_nis2_jurisdiction_registration/2, entity_list_submission_items/2, jurisdiction_basis/3, main_establishment_rule/3, nis2_jurisdiction_registration_checklist/2, nis2_jurisdiction_registration_decision_resolvable/1, nis2_jurisdiction_registration_status/2, nis2_jurisdiction_registration_status_values/1, registry_submission_items/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_queries, [any_member_state_where_services_are_provided_may_take_legal_action/0, cybersecurity_operations_carried_out_in_one_union_member_state/0, decisions_predominantly_taken_in_one_union_member_state/0, entity_category/0, established_in_union/0, general_entity/0, main_establishment_provider/0, member_states_list_applicable/0, nis2_jurisdiction_registration_profile_keys/1, nis2_jurisdiction_registration_what_if/4, no_rule_in_article_26/0, offers_services_in_union/0, public_administration_entity/0, public_electronic_communications_provider/0, representative_designated_in_union/0, sector_and_subsector_applicable/0, state_of_establishment/0, state_of_establishment_with_most_employees_in_the_union/0, state_of_main_establishment/0, state_of_representative/0, state_that_established_the_entity/0, state_where_cybersecurity_operations_are_carried_out/0, state_where_cybersecurity_risk_management_decisions_are_taken/0, state_where_services_are_provided/0, unsure/0]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_assess/2, nis2_jurisdiction_registration_profile_for/2, nis2_jurisdiction_registration_subject/1]).

root_export(any_member_state_where_services_are_provided_may_take_legal_action).
root_export(cybersecurity_operations_carried_out_in_one_union_member_state).
root_export(decisions_predominantly_taken_in_one_union_member_state).
root_export(duplicate_key).
root_export(entity_category).
root_export(established_in_union).
root_export(general_entity).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(item).
root_export(limit).
root_export(main_establishment_provider).
root_export(member_states_list_applicable).
root_export(months_after_change).
root_export(needs_legal_review).
root_export(no_rule_in_article_26).
root_export(offers_services_in_union).
root_export(open_textured).
root_export(provenance).
root_export(public_administration_entity).
root_export(public_electronic_communications_provider).
root_export(representative_designated_in_union).
root_export(sector_and_subsector_applicable).
root_export(state_of_establishment).
root_export(state_of_establishment_with_most_employees_in_the_union).
root_export(state_of_main_establishment).
root_export(state_of_representative).
root_export(state_that_established_the_entity).
root_export(state_where_cybersecurity_operations_are_carried_out).
root_export(state_where_cybersecurity_risk_management_decisions_are_taken).
root_export(state_where_services_are_provided).
root_export(unknown_key).
root_export(unsure).
root_export(weeks_after_change).
root_export(wrong_type).
