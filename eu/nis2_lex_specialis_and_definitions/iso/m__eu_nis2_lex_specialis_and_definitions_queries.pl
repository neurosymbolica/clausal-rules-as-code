% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_queries, [nis2_lex_specialis_and_definitions_profile_keys/1, nis2_lex_specialis_and_definitions_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_kernel, [nis2_lex_specialis_and_definitions_input_problems/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [nis2_lex_specialis_and_definitions_status/2]).

nis2_lex_specialis_and_definitions_profile_keys([entity_class, dora_risk_management_measures_at_least_equivalent_in_effect, dora_gives_immediate_access_to_incident_notifications, dora_incident_notification_requirements_at_least_equivalent_in_effect]).

nis2_lex_specialis_and_definitions_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_with_override(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_lex_specialis_and_definitions_status(Hypothesis, NewStatus).

profile_with_override([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
profile_with_override([attribute(ElementKey, _ElementValue)|Elements], OverriddenKey, NewValue, Hypothesis) :-
    ElementKey == OverriddenKey,
    profile_with_override(Elements, OverriddenKey, NewValue, Hypothesis).
profile_with_override([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== OverriddenKey,
    profile_with_override(Elements, OverriddenKey, NewValue, Hypothesis).

test(profile_keys_follow_the_contract_order) :-
    nis2_lex_specialis_and_definitions_profile_keys(ProfileKeys),
    ProfileKeys == [entity_class, dora_risk_management_measures_at_least_equivalent_in_effect, dora_gives_immediate_access_to_incident_notifications, dora_incident_notification_requirements_at_least_equivalent_in_effect].
test(override_replaces_the_existing_attribute) :-
    profile_with_override([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, false)], dora_risk_management_measures_at_least_equivalent_in_effect, true, Hypothesis),
    Hypothesis == [attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true)].
test(override_appends_an_absent_key) :-
    profile_with_override([attribute(entity_class, essential_entity)], dora_gives_immediate_access_to_incident_notifications, false, Hypothesis),
    Hypothesis == [attribute(entity_class, essential_entity), attribute(dora_gives_immediate_access_to_incident_notifications, false)].
test(what_if_flips_the_risk_group_to_disapplied) :-
    findall(Status, nis2_lex_specialis_and_definitions_what_if([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, false)], dora_risk_management_measures_at_least_equivalent_in_effect, true, Status), Statuses),
    Statuses == [nis2_groups(nis2_provisions_disapplied, indeterminate([dora_gives_immediate_access_to_incident_notifications]))].
test(what_if_out_of_scope_decides_both_groups) :-
    findall(Status, nis2_lex_specialis_and_definitions_what_if([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true)], entity_class, out_of_scope, Status), Statuses),
    Statuses == [nis2_groups(out_of_scope, out_of_scope)].

test(what_if_out_of_scope_is_not_disapplied, fail) :-
    nis2_lex_specialis_and_definitions_what_if([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true)], entity_class, out_of_scope, nis2_groups(nis2_provisions_disapplied, _)).
