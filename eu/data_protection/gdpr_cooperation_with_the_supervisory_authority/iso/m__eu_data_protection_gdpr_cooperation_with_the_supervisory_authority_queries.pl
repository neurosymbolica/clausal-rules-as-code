% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_queries, [gdpr_cooperation_with_the_supervisory_authority_profile_keys/1, gdpr_cooperation_with_the_supervisory_authority_what_if/4, acts_as_controller/0, acts_as_processor/0, acts_as_representative_of_controller_or_processor/0, authority_request_made/0, request_is_in_performance_of_authority_tasks/0, cooperation_given/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [gdpr_cooperation_with_the_supervisory_authority_status/2]).

acts_as_controller.

acts_as_processor.

acts_as_representative_of_controller_or_processor.

authority_request_made.

request_is_in_performance_of_authority_tasks.

cooperation_given.

unsure.

gdpr_cooperation_with_the_supervisory_authority_profile_keys([acts_as_controller, acts_as_processor, acts_as_representative_of_controller_or_processor, authority_request_made, request_is_in_performance_of_authority_tasks, cooperation_given]).

gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_cooperation_with_the_supervisory_authority_status(Hypothesis, NewStatus).

override_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
override_attribute([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|Elements]) :-
    ElementKey == OverriddenKey.
override_attribute([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== OverriddenKey,
    override_attribute(Elements, OverriddenKey, NewValue, Remaining).
