% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_queries, [nis2_jurisdiction_registration_profile_keys/1, nis2_jurisdiction_registration_what_if/4, entity_category/0, established_in_union/0, offers_services_in_union/0, representative_designated_in_union/0, decisions_predominantly_taken_in_one_union_member_state/0, cybersecurity_operations_carried_out_in_one_union_member_state/0, sector_and_subsector_applicable/0, member_states_list_applicable/0, general_entity/0, public_electronic_communications_provider/0, main_establishment_provider/0, public_administration_entity/0, unsure/0, state_of_establishment/0, state_where_services_are_provided/0, state_of_main_establishment/0, state_that_established_the_entity/0, state_of_representative/0, any_member_state_where_services_are_provided_may_take_legal_action/0, no_rule_in_article_26/0, state_where_cybersecurity_risk_management_decisions_are_taken/0, state_where_cybersecurity_operations_are_carried_out/0, state_of_establishment_with_most_employees_in_the_union/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [nis2_jurisdiction_registration_status/2]).

nis2_jurisdiction_registration_profile_keys([entity_category, established_in_union, offers_services_in_union, representative_designated_in_union, decisions_predominantly_taken_in_one_union_member_state, cybersecurity_operations_carried_out_in_one_union_member_state, sector_and_subsector_applicable, member_states_list_applicable]).

nis2_jurisdiction_registration_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_jurisdiction_registration_status(Hypothesis, NewStatus).

override_attribute(Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(attribute_has_key(OverriddenKey), Profile, OtherAttributes),
    append(OtherAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

attribute_has_key(Key, attribute(ElementKey, _)) :-
    ElementKey == Key.

entity_category.

established_in_union.

offers_services_in_union.

representative_designated_in_union.

decisions_predominantly_taken_in_one_union_member_state.

cybersecurity_operations_carried_out_in_one_union_member_state.

sector_and_subsector_applicable.

member_states_list_applicable.

general_entity.

public_electronic_communications_provider.

main_establishment_provider.

public_administration_entity.

unsure.

state_of_establishment.

state_where_services_are_provided.

state_of_main_establishment.

state_that_established_the_entity.

state_of_representative.

any_member_state_where_services_are_provided_may_take_legal_action.

no_rule_in_article_26.

state_where_cybersecurity_risk_management_decisions_are_taken.

state_where_cybersecurity_operations_are_carried_out.

state_of_establishment_with_most_employees_in_the_union.
