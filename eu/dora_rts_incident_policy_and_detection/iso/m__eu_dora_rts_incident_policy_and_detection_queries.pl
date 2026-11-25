% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_queries, [dora_rts_incident_policy_and_detection_profile_keys/1, dora_rts_incident_policy_and_detection_what_if/4, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0, unsure/0, ict_related_incident_policy/0, documentation_of_incident_management_process/0, list_of_relevant_contacts/0, incident_management_mechanisms/0, retention_of_incident_evidence/0, analysis_of_significant_or_recurring_incidents/0, secure_retention_of_incident_evidence/0, detection_and_response_roles_and_responsibilities/0, collection_monitoring_and_analysis/0, identification_of_anomalies_and_alerting_tools/0, prioritisation_of_alerts/0, recording_and_evaluation_of_anomalous_activities/0, automated_alerts_on_data_source_and_log_integrity/0, protection_of_records_of_anomalous_activities/0, logging_of_detected_anomalous_activities/0, consideration_of_incident_detection_criteria/0, consideration_of_criticality_of_affected_services/0, financial_entity_is_article_16_1_entity/0, ict_related_incident_policy_developed_documented_and_implemented/0, ict_related_incident_management_process_documented/0, list_of_relevant_internal_and_external_contacts_established/0, technical_organisational_and_operational_incident_management_mechanisms_operated/0, incident_evidence_retained_for_a_period_no_longer_than_necessary/0, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented/0, incident_evidence_retained_in_a_secure_manner/0, clear_roles_and_responsibilities_for_detection_and_response_set/0, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed/0, anomalous_activities_identified_and_alerting_tools_implemented/0, alerts_prioritised_within_expected_resolution_time/0, information_on_anomalous_activities_recorded_analysed_and_evaluated/0, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity/0, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access/0, information_on_each_detected_anomalous_activity_logged/0, criteria_triggering_incident_detection_and_response_considered/0, criticality_of_affected_services_considered/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_kernel, [dora_rts_incident_policy_and_detection_input_problems/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [dora_rts_incident_policy_and_detection_status/2, rts_incident_policy_and_detection_duties_required/3]).

dora_rts_incident_policy_and_detection_profile_keys([financial_entity_is_article_16_1_entity, ict_related_incident_policy_developed_documented_and_implemented, ict_related_incident_management_process_documented, list_of_relevant_internal_and_external_contacts_established, technical_organisational_and_operational_incident_management_mechanisms_operated, incident_evidence_retained_for_a_period_no_longer_than_necessary, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, incident_evidence_retained_in_a_secure_manner, clear_roles_and_responsibilities_for_detection_and_response_set, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, anomalous_activities_identified_and_alerting_tools_implemented, alerts_prioritised_within_expected_resolution_time, information_on_anomalous_activities_recorded_analysed_and_evaluated, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, information_on_each_detected_anomalous_activity_logged, criteria_triggering_incident_detection_and_response_considered, criticality_of_affected_services_considered]).

complete.

incomplete.

none_outstanding.

simplified_framework_entity.

unsure.

ict_related_incident_policy.

documentation_of_incident_management_process.

list_of_relevant_contacts.

incident_management_mechanisms.

retention_of_incident_evidence.

analysis_of_significant_or_recurring_incidents.

secure_retention_of_incident_evidence.

detection_and_response_roles_and_responsibilities.

collection_monitoring_and_analysis.

identification_of_anomalies_and_alerting_tools.

prioritisation_of_alerts.

recording_and_evaluation_of_anomalous_activities.

automated_alerts_on_data_source_and_log_integrity.

protection_of_records_of_anomalous_activities.

logging_of_detected_anomalous_activities.

consideration_of_incident_detection_criteria.

consideration_of_criticality_of_affected_services.

financial_entity_is_article_16_1_entity.

ict_related_incident_policy_developed_documented_and_implemented.

ict_related_incident_management_process_documented.

list_of_relevant_internal_and_external_contacts_established.

technical_organisational_and_operational_incident_management_mechanisms_operated.

incident_evidence_retained_for_a_period_no_longer_than_necessary.

mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented.

incident_evidence_retained_in_a_secure_manner.

clear_roles_and_responsibilities_for_detection_and_response_set.

factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed.

anomalous_activities_identified_and_alerting_tools_implemented.

alerts_prioritised_within_expected_resolution_time.

information_on_anomalous_activities_recorded_analysed_and_evaluated.

alerting_tools_include_automated_alerts_on_data_source_and_log_integrity.

records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access.

information_on_each_detected_anomalous_activity_logged.

criteria_triggering_incident_detection_and_response_considered.

criticality_of_affected_services_considered.

dora_rts_incident_policy_and_detection_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    clausal_is_list(Profile),
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_rts_incident_policy_and_detection_status(Hypothesis, NewStatus).

override_attribute(Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|KeptAttributes]) :-
    drop_attribute(Profile, OverriddenKey, KeptAttributes).

drop_attribute([], _, []).
drop_attribute([Element|Elements], OverriddenKey, KeptAttributes) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey,
    drop_attribute(Elements, OverriddenKey, KeptAttributes).
drop_attribute([Element|Elements], OverriddenKey, [Element|KeptAttributes]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey,
    drop_attribute(Elements, OverriddenKey, KeptAttributes).
drop_attribute([Element|Elements], OverriddenKey, [Element|KeptAttributes]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    drop_attribute(Elements, OverriddenKey, KeptAttributes).
drop_attribute([Element|Elements], OverriddenKey, [Element|KeptAttributes]) :-
    var(Element),
    drop_attribute(Elements, OverriddenKey, KeptAttributes).

test(what_if_the_entity_is_an_article_16_1_entity) :-
    dora_rts_incident_policy_and_detection_what_if([attribute(financial_entity_is_article_16_1_entity, false)], financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(what_if_the_gate_is_false_with_no_duty_answered) :-
    dora_rts_incident_policy_and_detection_what_if([], financial_entity_is_article_16_1_entity, false, indeterminate).
test(what_if_answers_once) :-
    findall(NewStatus, dora_rts_incident_policy_and_detection_what_if([attribute(financial_entity_is_article_16_1_entity, true)], financial_entity_is_article_16_1_entity, false, NewStatus), Statuses),
    Statuses == [indeterminate].
test(the_override_replaces_every_occurrence) :-
    override_attribute([attribute(alerts_prioritised_within_expected_resolution_time, true), attribute(alerts_prioritised_within_expected_resolution_time, false)], alerts_prioritised_within_expected_resolution_time, unsure, Hypothesis),
    Hypothesis == [attribute(alerts_prioritised_within_expected_resolution_time, unsure)].
test(the_schema_has_eighteen_keys) :-
    dora_rts_incident_policy_and_detection_profile_keys(ProfileKeys),
    length(ProfileKeys, 18).
test(every_profile_key_atom_is_served) :-
    dora_rts_incident_policy_and_detection_profile_keys(ProfileKeys),
    maplist(call, ProfileKeys).
test(every_duty_atom_of_the_required_list_is_served) :-
    rts_incident_policy_and_detection_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], required(DutyAtoms), _Citations),
    length(DutyAtoms, 17),
    maplist(call, DutyAtoms).
test(the_result_atoms_are_served) :-
    complete,
    incomplete,
    none_outstanding,
    simplified_framework_entity,
    unsure.
test(the_result_constructors_build_and_destructure) :-
    Result = needs_legal_review(open_textured(criticality_of_affected_services_considered, cite(eu_reg_2024_1774_art_23_6)), [inputs_relied_on([])]),
    Result = needs_legal_review(open_textured(JudgementKey, Citation), [inputs_relied_on(Pairs)]),
    JudgementKey == criticality_of_affected_services_considered,
    Citation == cite(eu_reg_2024_1774_art_23_6),
    Pairs == [].

test(what_if_the_gate_is_false_is_not_simplified, fail) :-
    dora_rts_incident_policy_and_detection_what_if([], financial_entity_is_article_16_1_entity, false, simplified_framework_entity).
