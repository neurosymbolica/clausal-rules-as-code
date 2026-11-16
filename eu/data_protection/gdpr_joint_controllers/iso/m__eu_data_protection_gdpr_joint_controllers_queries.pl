% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_queries, [gdpr_joint_controllers_profile_keys/1, gdpr_joint_controllers_what_if/4, controllers_jointly_determine_purposes_and_means/0, responsible_under_article_82_2_and_3/0, other_responsible_parties/0, full_compensation_paid/0, unsure/0, absent/0, not_attempted/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2]).

controllers_jointly_determine_purposes_and_means.

responsible_under_article_82_2_and_3.

other_responsible_parties.

full_compensation_paid.

unsure.

absent.

not_attempted.

gdpr_joint_controllers_profile_keys([controllers_jointly_determine_purposes_and_means, responsible_under_article_82_2_and_3, other_responsible_parties, full_compensation_paid]).

gdpr_joint_controllers_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_joint_controllers_status(Hypothesis, NewStatus).

attribute_override(Profile, Key, Value, Hypothesis) :-
    entries_without_key(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

entries_without_key([], _, []).
entries_without_key([attribute(ElementKey, _)|Elements], Key, Kept) :-
    ElementKey == Key,
    entries_without_key(Elements, Key, Kept).
entries_without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Kept]) :-
    ElementKey \== Key,
    entries_without_key(Elements, Key, Kept).
