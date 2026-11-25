% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_fixtures, [dora_rts_simplified_policies_and_controls_subject/1, dora_rts_simplified_policies_and_controls_profile_for/2, dora_rts_simplified_policies_and_controls_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_queries, [dora_rts_simplified_policies_and_controls_profile_keys/1]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_dora_rts_simplified_policies_and_controls, [decide_dora_rts_simplified_policies_and_controls/2]).

fixture(all_duties_performed, [], []).
fixture(one_duty_not_performed, [premises_and_data_centres_protected - false], []).
fixture(gate_false_entity, [financial_entity_is_article_16_1_entity - false], []).
fixture(gate_false_with_duty_not_performed, [financial_entity_is_article_16_1_entity - false, premises_and_data_centres_protected - false], []).
fixture(gate_absent_entity, [financial_entity_is_article_16_1_entity - absent, user_accountability_ensured - false], []).
fixture(one_duty_absent, [access_operations_and_change_events_logged - absent], []).
fixture(one_duty_unsure, [cyber_threat_information_monitored - unsure], []).
fixture(false_and_absent, [user_accountability_ensured - false, access_operations_and_change_events_logged - absent], []).
fixture(false_and_unsure, [user_accountability_ensured - false, cyber_threat_information_monitored - unsure], []).
fixture(absent_before_unsure, [simplified_internal_governance_and_control_framework_in_place - unsure, teleworking_and_private_device_measures_implemented - absent], []).
fixture(several_duties_not_performed, [simplified_internal_governance_and_control_framework_in_place - false, premises_and_data_centres_protected - false, user_accountability_ensured - false], []).
fixture(gate_unsure_wrong_type, [financial_entity_is_article_16_1_entity - unsure], []).
fixture(duplicate_contract_key, [], [attribute(user_accountability_ensured, false)]).
fixture(microenterprise_key_unknown, [], [attribute(financial_entity_is_microenterprise, true)]).
fixture(numeric_value_wrong_type, [secure_data_deletion_process_in_place - 1], []).

dora_rts_simplified_policies_and_controls_subject(Subject) :-
    fixture(Subject, _, _).

dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile) :-
    fixture(Subject, Overrides, ExtraAttributes),
    built_profile(Overrides, BaseProfile),
    append(BaseProfile, ExtraAttributes, Profile).

built_profile(Overrides, Profile) :-
    dora_rts_simplified_policies_and_controls_profile_keys(ProfileKeys),
    pairs_keys(Overrides, OverrideKeys),
    findall(Attribute, (member(Key, ProfileKeys), key_attribute(Key, Overrides, OverrideKeys, Attribute)), Profile).

key_attribute(Key, Overrides, _, attribute(Key, Value)) :-
    member(Key - Value, Overrides),
    dif(Value, absent).
key_attribute(Key, _, OverrideKeys, attribute(Key, true)) :-
    not_member(Key, OverrideKeys).

dora_rts_simplified_policies_and_controls_assess(Subject, Result) :-
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    decide_dora_rts_simplified_policies_and_controls(Profile, Result).
