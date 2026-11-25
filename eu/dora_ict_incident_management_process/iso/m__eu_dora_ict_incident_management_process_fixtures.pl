% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_fixtures, [dora_ict_incident_management_process_subject/1, dora_ict_incident_management_process_profile_for/2, dora_ict_incident_management_process_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [decide_dora_ict_incident_management_process/2]).
:- use_module(m__eu_dora_ict_incident_management_process_queries, [dora_ict_incident_management_process_profile_keys/1]).

dora_ict_incident_management_process_subject(all_duties_performed).
dora_ict_incident_management_process_subject(early_warning_indicators_not_performed).
dora_ict_incident_management_process_subject(classification_of_significant_cyber_threats_not_performed).
dora_ict_incident_management_process_subject(both_article_17_2_duties_not_performed).
dora_ict_incident_management_process_subject(no_duty_answered).
dora_ict_incident_management_process_subject(last_duty_unanswered).
dora_ict_incident_management_process_subject(not_performed_and_unanswered).
dora_ict_incident_management_process_subject(communication_plans_unsure).
dora_ict_incident_management_process_subject(early_warning_unsure_and_response_unanswered).
dora_ict_incident_management_process_subject(unknown_key_present).
dora_ict_incident_management_process_subject(duplicate_key_present).
dora_ict_incident_management_process_subject(wrong_type_value).
dora_ict_incident_management_process_subject(not_an_attribute_list).

dora_ict_incident_management_process_profile_for(all_duties_performed, Profile) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, true], Profile).
dora_ict_incident_management_process_profile_for(early_warning_indicators_not_performed, Profile) :-
    profile_from_values([true, true, true, false, true, true, true, true, true, true], Profile).
dora_ict_incident_management_process_profile_for(classification_of_significant_cyber_threats_not_performed, Profile) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, false], Profile).
dora_ict_incident_management_process_profile_for(both_article_17_2_duties_not_performed, Profile) :-
    profile_from_values([true, false, false, true, true, true, true, true, true, true], Profile).
dora_ict_incident_management_process_profile_for(no_duty_answered, []).
dora_ict_incident_management_process_profile_for(last_duty_unanswered, Profile) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, absent], Profile).
dora_ict_incident_management_process_profile_for(not_performed_and_unanswered, Profile) :-
    profile_from_values([absent, true, true, true, true, false, true, true, true, true], Profile).
dora_ict_incident_management_process_profile_for(communication_plans_unsure, Profile) :-
    profile_from_values([true, true, true, true, true, true, unsure, true, true, true], Profile).
dora_ict_incident_management_process_profile_for(early_warning_unsure_and_response_unanswered, Profile) :-
    profile_from_values([true, true, true, unsure, true, true, true, true, absent, true], Profile).
dora_ict_incident_management_process_profile_for(unknown_key_present, Profile) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, true], ContractProfile),
    append(ContractProfile, [attribute(colour, red)], Profile).
dora_ict_incident_management_process_profile_for(duplicate_key_present, Profile) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, true], ContractProfile),
    append(ContractProfile, [attribute(incident_response_procedures_established, false)], Profile).
dora_ict_incident_management_process_profile_for(wrong_type_value, Profile) :-
    profile_from_values([true, true, true, yes, true, true, true, true, true, true], Profile).
dora_ict_incident_management_process_profile_for(not_an_attribute_list, not_a_list).

profile_from_values(Values, Profile) :-
    dora_ict_incident_management_process_profile_keys(Keys),
    pair_values(Keys, Values, Profile).

pair_values([], [], []).
pair_values([_Key|Keys], [absent|Values], Profile) :-
    pair_values(Keys, Values, Profile).
pair_values([Key|Keys], [Value|Values], [attribute(Key, Value)|Profile]) :-
    dif(Value, absent),
    pair_values(Keys, Values, Profile).

dora_ict_incident_management_process_assess(Subject, Result) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    decide_dora_ict_incident_management_process(Profile, Result).
