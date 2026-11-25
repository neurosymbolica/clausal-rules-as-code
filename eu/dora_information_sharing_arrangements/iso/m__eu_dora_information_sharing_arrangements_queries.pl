% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_queries, [dora_information_sharing_arrangements_profile_keys/1, dora_information_sharing_arrangements_what_if/4, information_is_cyber_threat_information_and_intelligence/0, sharing_aims_to_enhance_digital_operational_resilience/0, sharing_takes_place_within_trusted_community_of_financial_entities/0, arrangement_protects_sensitive_information_and_has_rules_of_conduct/0, arrangement_defines_participation_conditions_and_appropriate_details/0, membership_event/0, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1/0, membership_validated/0, membership_cessation_took_effect/0, no_membership_event/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_information_sharing_arrangements_kernel, [dora_information_sharing_arrangements_input_problems/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_dora_information_sharing_arrangements, [dora_information_sharing_arrangements_status/2]).

information_is_cyber_threat_information_and_intelligence.

sharing_aims_to_enhance_digital_operational_resilience.

sharing_takes_place_within_trusted_community_of_financial_entities.

arrangement_protects_sensitive_information_and_has_rules_of_conduct.

arrangement_defines_participation_conditions_and_appropriate_details.

membership_event.

arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1.

membership_validated.

membership_cessation_took_effect.

no_membership_event.

unsure.

dora_information_sharing_arrangements_profile_keys([information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details, membership_event, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1]).

dora_information_sharing_arrangements_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_information_sharing_arrangements_status(Hypothesis, NewStatus).

override_attribute(Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|Kept]) :-
    drop_attribute(Profile, OverriddenKey, Kept).

drop_attribute([], _OverriddenKey, []).
drop_attribute([attribute(ElementKey, _Value)|Elements], OverriddenKey, Kept) :-
    ElementKey == OverriddenKey,
    drop_attribute(Elements, OverriddenKey, Kept).
drop_attribute([attribute(ElementKey, Value)|Elements], OverriddenKey, [attribute(ElementKey, Value)|Kept]) :-
    ElementKey \== OverriddenKey,
    drop_attribute(Elements, OverriddenKey, Kept).
