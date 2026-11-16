% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_queries, [nis2_information_sharing_voluntary_notification_profile_keys/1, nis2_information_sharing_voluntary_notification_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(library(reif), [if_/3]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [nis2_information_sharing_voluntary_notification_status/2]).

nis2_information_sharing_voluntary_notification_profile_keys([entity_class, event_kind, arrangement_event, information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity, arrangement_is_a_cybersecurity_information_sharing_arrangement]).

nis2_information_sharing_voluntary_notification_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_list_override(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_information_sharing_voluntary_notification_status(Hypothesis, NewStatus).

attribute_list_override([], Key, Value, [attribute(Key, Value)]).
attribute_list_override([attribute(ElementKey, ElementValue)|Elements], Key, Value, Overridden) :-
    if_(ElementKey = Key, Overridden = Rest, Overridden = [attribute(ElementKey, ElementValue)|Rest]),
    attribute_list_override(Elements, Key, Value, Rest).

test(the_key_schema_has_the_seven_contract_keys) :-
    nis2_information_sharing_voluntary_notification_profile_keys(ProfileKeys),
    length(ProfileKeys, 7).
test(an_override_replaces_the_key_once) :-
    findall(Overridden, attribute_list_override([attribute(entity_class, out_of_scope), attribute(event_kind, incident)], entity_class, essential_entity, Overridden), Answers),
    Answers == [[attribute(event_kind, incident), attribute(entity_class, essential_entity)]].
test(an_override_drops_every_repeat_of_the_key) :-
    findall(Overridden, attribute_list_override([attribute(entity_class, out_of_scope), attribute(entity_class, important_entity)], entity_class, essential_entity, Overridden), Answers),
    Answers == [[attribute(entity_class, essential_entity)]].
test(what_if_an_other_entity_were_essential) :-
    nis2_information_sharing_voluntary_notification_what_if([attribute(entity_class, out_of_scope), attribute(event_kind, incident)], entity_class, essential_entity, eligible).
test(what_if_the_incident_were_significant) :-
    nis2_information_sharing_voluntary_notification_what_if([attribute(entity_class, out_of_scope), attribute(event_kind, incident)], event_kind, significant_incident, eligible).
test(what_if_an_essential_entity_were_other_is_ineligible) :-
    nis2_information_sharing_voluntary_notification_what_if([attribute(entity_class, essential_entity), attribute(event_kind, incident)], entity_class, out_of_scope, ineligible).

test(what_if_an_essential_entity_were_other_is_not_eligible, fail) :-
    nis2_information_sharing_voluntary_notification_what_if([attribute(entity_class, essential_entity), attribute(event_kind, incident)], entity_class, out_of_scope, eligible).
