% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_fixtures, [dora_rts_incident_policy_and_detection_subject/1, dora_rts_incident_policy_and_detection_profile_for/2, dora_rts_incident_policy_and_detection_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [decide_dora_rts_incident_policy_and_detection/2]).

dora_rts_incident_policy_and_detection_subject(complete_entity).
dora_rts_incident_policy_and_detection_subject(simplified_entity).
dora_rts_incident_policy_and_detection_subject(simplified_entity_with_failures).
dora_rts_incident_policy_and_detection_subject(gate_not_stated).
dora_rts_incident_policy_and_detection_subject(gate_not_stated_with_failures).
dora_rts_incident_policy_and_detection_subject(prioritisation_not_performed).
dora_rts_incident_policy_and_detection_subject(secure_retention_not_performed).
dora_rts_incident_policy_and_detection_subject(automated_alerts_not_performed).
dora_rts_incident_policy_and_detection_subject(several_duties_not_performed).
dora_rts_incident_policy_and_detection_subject(retention_not_answered).
dora_rts_incident_policy_and_detection_subject(failure_beside_unanswered).
dora_rts_incident_policy_and_detection_subject(prioritisation_unsure).
dora_rts_incident_policy_and_detection_subject(unsure_beside_unanswered).
dora_rts_incident_policy_and_detection_subject(unsure_beside_failure).
dora_rts_incident_policy_and_detection_subject(two_duties_unsure).
dora_rts_incident_policy_and_detection_subject(unknown_key_present).
dora_rts_incident_policy_and_detection_subject(gate_unsure).
dora_rts_incident_policy_and_detection_subject(duplicate_duty_key).
dora_rts_incident_policy_and_detection_subject(numeric_judgement_value).
dora_rts_incident_policy_and_detection_subject(several_input_problems).
dora_rts_incident_policy_and_detection_subject(not_an_attribute_list).

duty_keys([ict_related_incident_policy_developed_documented_and_implemented, ict_related_incident_management_process_documented, list_of_relevant_internal_and_external_contacts_established, technical_organisational_and_operational_incident_management_mechanisms_operated, incident_evidence_retained_for_a_period_no_longer_than_necessary, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, incident_evidence_retained_in_a_secure_manner, clear_roles_and_responsibilities_for_detection_and_response_set, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, anomalous_activities_identified_and_alerting_tools_implemented, alerts_prioritised_within_expected_resolution_time, information_on_anomalous_activities_recorded_analysed_and_evaluated, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, information_on_each_detected_anomalous_activity_logged, criteria_triggering_incident_detection_and_response_considered, criticality_of_affected_services_considered]).

duty_attribute(DutyValue, ProfileKey, attribute(ProfileKey, DutyValue)).

duty_attributes(DutyValue, DutyAttributes) :-
    duty_keys(DutyKeys),
    maplist(duty_attribute(DutyValue), DutyKeys, DutyAttributes).

entity_profile(GateValue, DutyValue, [attribute(financial_entity_is_article_16_1_entity, GateValue)|DutyAttributes]) :-
    duty_attributes(DutyValue, DutyAttributes).

with_value([], _, _, []).
with_value([attribute(ProfileKey, _)|Attributes], Wanted, NewValue, [attribute(ProfileKey, NewValue)|Rest]) :-
    ProfileKey == Wanted,
    with_value(Attributes, Wanted, NewValue, Rest).
with_value([attribute(ProfileKey, KeyValue)|Attributes], Wanted, NewValue, [attribute(ProfileKey, KeyValue)|Rest]) :-
    ProfileKey \== Wanted,
    with_value(Attributes, Wanted, NewValue, Rest).

without_key([], _, []).
without_key([attribute(ProfileKey, _)|Attributes], Wanted, Rest) :-
    ProfileKey == Wanted,
    without_key(Attributes, Wanted, Rest).
without_key([attribute(ProfileKey, KeyValue)|Attributes], Wanted, [attribute(ProfileKey, KeyValue)|Rest]) :-
    ProfileKey \== Wanted,
    without_key(Attributes, Wanted, Rest).

dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile) :-
    entity_profile(false, true, Profile).
dora_rts_incident_policy_and_detection_profile_for(simplified_entity, Profile) :-
    entity_profile(true, true, Profile).
dora_rts_incident_policy_and_detection_profile_for(simplified_entity_with_failures, Profile) :-
    entity_profile(true, false, Profile).
dora_rts_incident_policy_and_detection_profile_for(gate_not_stated, Profile) :-
    duty_attributes(true, Profile).
dora_rts_incident_policy_and_detection_profile_for(gate_not_stated_with_failures, Profile) :-
    duty_attributes(false, Profile).
dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, alerts_prioritised_within_expected_resolution_time, false, Profile).
dora_rts_incident_policy_and_detection_profile_for(secure_retention_not_performed, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, incident_evidence_retained_in_a_secure_manner, false, Profile).
dora_rts_incident_policy_and_detection_profile_for(automated_alerts_not_performed, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, false, Profile).
dora_rts_incident_policy_and_detection_profile_for(several_duties_not_performed, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, ict_related_incident_policy_developed_documented_and_implemented, false, FirstChange),
    with_value(FirstChange, incident_evidence_retained_in_a_secure_manner, false, SecondChange),
    with_value(SecondChange, criticality_of_affected_services_considered, false, Profile).
dora_rts_incident_policy_and_detection_profile_for(retention_not_answered, Profile) :-
    entity_profile(false, true, BaseProfile),
    without_key(BaseProfile, incident_evidence_retained_for_a_period_no_longer_than_necessary, Profile).
dora_rts_incident_policy_and_detection_profile_for(failure_beside_unanswered, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, list_of_relevant_internal_and_external_contacts_established, false, Changed),
    without_key(Changed, incident_evidence_retained_for_a_period_no_longer_than_necessary, Profile).
dora_rts_incident_policy_and_detection_profile_for(prioritisation_unsure, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, alerts_prioritised_within_expected_resolution_time, unsure, Profile).
dora_rts_incident_policy_and_detection_profile_for(unsure_beside_unanswered, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, alerts_prioritised_within_expected_resolution_time, unsure, Changed),
    without_key(Changed, criticality_of_affected_services_considered, Profile).
dora_rts_incident_policy_and_detection_profile_for(unsure_beside_failure, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, alerts_prioritised_within_expected_resolution_time, unsure, Changed),
    with_value(Changed, list_of_relevant_internal_and_external_contacts_established, false, Profile).
dora_rts_incident_policy_and_detection_profile_for(two_duties_unsure, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, clear_roles_and_responsibilities_for_detection_and_response_set, unsure, Changed),
    with_value(Changed, ict_related_incident_policy_developed_documented_and_implemented, unsure, Profile).
dora_rts_incident_policy_and_detection_profile_for(unknown_key_present, Profile) :-
    entity_profile(false, true, BaseProfile),
    append(BaseProfile, [attribute(financial_entity_is_microenterprise, true)], Profile).
dora_rts_incident_policy_and_detection_profile_for(gate_unsure, Profile) :-
    entity_profile(unsure, true, Profile).
dora_rts_incident_policy_and_detection_profile_for(duplicate_duty_key, Profile) :-
    entity_profile(false, true, BaseProfile),
    append(BaseProfile, [attribute(alerts_prioritised_within_expected_resolution_time, false)], Profile).
dora_rts_incident_policy_and_detection_profile_for(numeric_judgement_value, Profile) :-
    entity_profile(false, true, BaseProfile),
    with_value(BaseProfile, criticality_of_affected_services_considered, 1, Profile).
dora_rts_incident_policy_and_detection_profile_for(several_input_problems, Profile) :-
    entity_profile(unsure, true, BaseProfile),
    append(BaseProfile, [attribute(financial_entity_is_microenterprise, true), attribute(alerts_prioritised_within_expected_resolution_time, true)], Profile).
dora_rts_incident_policy_and_detection_profile_for(not_an_attribute_list, [attribute(financial_entity_is_article_16_1_entity, false), entity_type(credit_institution)]).

dora_rts_incident_policy_and_detection_assess(Subject, Result) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    decide_dora_rts_incident_policy_and_detection(Profile, Result).
