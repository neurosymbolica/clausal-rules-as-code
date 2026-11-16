% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_queries, [gdpr_compensation_and_liability_profile_keys/1, gdpr_compensation_and_liability_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [gdpr_compensation_and_liability_status/2]).

gdpr_compensation_and_liability_profile_keys([party_role, involved_in_the_processing, processor_breached_obligations_directed_to_processors, processor_acted_outside_or_contrary_to_lawful_instructions, damage_suffered, infringement_of_the_regulation_occurred, damage_resulted_from_the_infringement, not_in_any_way_responsible_for_the_event]).

gdpr_compensation_and_liability_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_compensation_and_liability_status(Hypothesis, NewStatus).

attribute_override([], Key, Value, [attribute(Key, Value)]).
attribute_override([attribute(ElementKey, _)|Elements], Key, Value, Hypothesis) :-
    ElementKey == Key,
    attribute_override(Elements, Key, Value, Hypothesis).
attribute_override([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== Key,
    attribute_override(Elements, Key, Value, Hypothesis).

test(the_override_replaces_an_existing_entry) :-
    attribute_override([attribute(damage_suffered, true), attribute(party_role, controller)], damage_suffered, false, Hypothesis),
    Hypothesis == [attribute(party_role, controller), attribute(damage_suffered, false)].
test(the_override_adds_an_absent_entry) :-
    attribute_override([], party_role, processor, Hypothesis),
    Hypothesis == [attribute(party_role, processor)].
test(the_override_collapses_a_duplicate_key) :-
    attribute_override([attribute(damage_suffered, true), attribute(damage_suffered, false)], damage_suffered, unsure, Hypothesis),
    Hypothesis == [attribute(damage_suffered, unsure)].
test(a_false_judgement_by_what_if_refutes_the_right) :-
    gdpr_compensation_and_liability_what_if([attribute(damage_suffered, true)], damage_suffered, false, right_not_established).
test(a_true_judgement_by_what_if_names_the_next_key) :-
    gdpr_compensation_and_liability_what_if([attribute(damage_suffered, false)], damage_suffered, true, indeterminate([infringement_of_the_regulation_occurred])).
test(the_key_schema_has_eight_keys) :-
    gdpr_compensation_and_liability_profile_keys(Keys),
    length(Keys, 8).

test(a_true_judgement_by_what_if_is_not_refuted, fail) :-
    gdpr_compensation_and_liability_what_if([attribute(damage_suffered, false)], damage_suffered, true, right_not_established).
