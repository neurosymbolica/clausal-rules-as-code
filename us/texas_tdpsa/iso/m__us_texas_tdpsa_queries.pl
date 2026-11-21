% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_texas_tdpsa_queries, [texas_tdpsa_profile_keys/1, texas_tdpsa_what_if/4, in_scope/0, out_of_scope/0, no_extension_available/0, cure_period_running/0, action_may_be_brought/0, no_action_for_cured_violation/0, no_civil_penalty/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_texas_tdpsa_kernel, [texas_tdpsa_input_problems/2]).
:- use_module(m__us_texas_tdpsa_texas_tdpsa, [texas_tdpsa_status/2]).

texas_tdpsa_profile_keys([entity_category, processes_or_sells_personal_data, conducts_business_in_texas_or_serves_texas_residents, small_business_as_defined_by_sba, extension_reasonably_necessary, extension_notice_given_within_initial_period, cured_within_cure_period, written_statement_provided, written_statement_breached, violation_after_cure_period_or_statement_breach, violation_count]).

texas_tdpsa_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    texas_tdpsa_status(Hypothesis, NewStatus).

override_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
override_attribute([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== OverriddenKey,
    override_attribute(Elements, OverriddenKey, NewValue, Hypothesis).
override_attribute([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Hypothesis) :-
    ElementKey == OverriddenKey,
    override_attribute(Elements, OverriddenKey, NewValue, Hypothesis).

in_scope.

out_of_scope.

no_extension_available.

cure_period_running.

action_may_be_brought.

no_action_for_cured_violation.

no_civil_penalty.
