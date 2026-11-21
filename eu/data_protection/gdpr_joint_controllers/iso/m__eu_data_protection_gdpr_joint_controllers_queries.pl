% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_queries, [gdpr_joint_controllers_profile_keys/1, gdpr_joint_controllers_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2]).

gdpr_joint_controllers_profile_keys([controllers_jointly_determine_purposes_and_means, responsible_under_article_82_2_and_3, other_responsible_parties, full_compensation_paid]).

gdpr_joint_controllers_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_joint_controllers_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|LaterElements]) :-
    ElementKey == Key,
    drop_attribute(Elements, Key, LaterElements).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|LaterElements]) :-
    ElementKey \== Key,
    override_attribute(Elements, Key, Value, LaterElements).

drop_attribute([], _, []).
drop_attribute([attribute(ElementKey, _)|Elements], Key, LaterElements) :-
    ElementKey == Key,
    drop_attribute(Elements, Key, LaterElements).
drop_attribute([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|LaterElements]) :-
    ElementKey \== Key,
    drop_attribute(Elements, Key, LaterElements).

test(the_profile_keys_are_the_four_contract_keys) :-
    gdpr_joint_controllers_profile_keys(Keys),
    Keys == [controllers_jointly_determine_purposes_and_means, responsible_under_article_82_2_and_3, other_responsible_parties, full_compensation_paid].
test(an_override_replaces_the_value) :-
    override_attribute([attribute(full_compensation_paid, false)], full_compensation_paid, true, Hypothesis),
    Hypothesis == [attribute(full_compensation_paid, true)].
test(an_override_adds_an_absent_key) :-
    override_attribute([attribute(other_responsible_parties, [])], full_compensation_paid, true, Hypothesis),
    Hypothesis == [attribute(other_responsible_parties, []), attribute(full_compensation_paid, true)].
test(an_override_drops_a_repeated_key) :-
    override_attribute([attribute(full_compensation_paid, true), attribute(full_compensation_paid, false)], full_compensation_paid, unsure, Hypothesis),
    Hypothesis == [attribute(full_compensation_paid, unsure)].
test(a_full_payment_turns_a_partial_payment_into_a_claim_back) :-
    Attested = attested(true, attestation(host_service, attested_moment, stated_reason, none)),
    gdpr_joint_controllers_what_if([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta]), attribute(full_compensation_paid, false)], full_compensation_paid, true, eligible).
test(a_partial_payment_is_not_eligible_without_the_override) :-
    Attested = attested(true, attestation(host_service, attested_moment, stated_reason, none)),
    gdpr_joint_controllers_status([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta]), attribute(full_compensation_paid, false)], ineligible).
