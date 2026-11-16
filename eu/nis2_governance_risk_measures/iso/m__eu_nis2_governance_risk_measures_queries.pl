% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_queries, [nis2_governance_risk_measures_profile_keys/1, nis2_governance_risk_measures_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_kernel, [nis2_governance_risk_measures_input_problems/2]).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [nis2_governance_risk_measures_status/2]).

nis2_governance_risk_measures_profile_keys([entity_class, multi_factor_authentication_and_secured_communications_appropriate, relevant_european_or_international_standards_apply, coordinated_supply_chain_risk_assessment_carried_out, non_compliance_with_the_art_21_2_measures_found]).

nis2_governance_risk_measures_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_governance_risk_measures_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, NewProfile) :-
    drop_attribute(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], NewProfile).

drop_attribute([], _, []).
drop_attribute([attribute(ElementKey, _)|Elements], Key, Kept) :-
    ElementKey == Key,
    drop_attribute(Elements, Key, Kept).
drop_attribute([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Kept]) :-
    ElementKey \== Key,
    drop_attribute(Elements, Key, Kept).
drop_attribute([Element|Elements], Key, [Element|Kept]) :-
    Element \= attribute(_, _),
    drop_attribute(Elements, Key, Kept).
