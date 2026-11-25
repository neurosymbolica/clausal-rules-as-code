% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [rts_incident_policy_and_detection_duties_required/3, rts_incident_policy_and_detection_duties_complete/3, rts_incident_policy_and_detection_duties_outstanding/3, decide_dora_rts_incident_policy_and_detection/2, dora_rts_incident_policy_and_detection_status/2, dora_rts_incident_policy_and_detection_checklist/2, dora_rts_incident_policy_and_detection_decision_resolvable/1, dora_rts_incident_policy_and_detection_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_kernel, [dora_rts_incident_policy_and_detection_input_problems/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_citations, [implements/1]).

dora_rts_incident_policy_and_detection_status_values([complete, incomplete, simplified_framework_entity, indeterminate, needs_legal_review, input_problems]).

duty_row(ict_related_incident_policy, ict_related_incident_policy_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_22)).
duty_row(documentation_of_incident_management_process, ict_related_incident_management_process_documented, cite(eu_reg_2024_1774_art_22_a)).
duty_row(list_of_relevant_contacts, list_of_relevant_internal_and_external_contacts_established, cite(eu_reg_2024_1774_art_22_b)).
duty_row(incident_management_mechanisms, technical_organisational_and_operational_incident_management_mechanisms_operated, cite(eu_reg_2024_1774_art_22_c)).
duty_row(retention_of_incident_evidence, incident_evidence_retained_for_a_period_no_longer_than_necessary, cite(eu_reg_2024_1774_art_22_d)).
duty_row(analysis_of_significant_or_recurring_incidents, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, cite(eu_reg_2024_1774_art_22_e)).
duty_row(secure_retention_of_incident_evidence, incident_evidence_retained_in_a_secure_manner, cite(eu_reg_2024_1774_art_22)).
duty_row(detection_and_response_roles_and_responsibilities, clear_roles_and_responsibilities_for_detection_and_response_set, cite(eu_reg_2024_1774_art_23_1)).
duty_row(collection_monitoring_and_analysis, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, cite(eu_reg_2024_1774_art_23_2_a)).
duty_row(identification_of_anomalies_and_alerting_tools, anomalous_activities_identified_and_alerting_tools_implemented, cite(eu_reg_2024_1774_art_23_2_b)).
duty_row(prioritisation_of_alerts, alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)).
duty_row(recording_and_evaluation_of_anomalous_activities, information_on_anomalous_activities_recorded_analysed_and_evaluated, cite(eu_reg_2024_1774_art_23_2_d)).
duty_row(automated_alerts_on_data_source_and_log_integrity, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, cite(eu_reg_2024_1774_art_23_2)).
duty_row(protection_of_records_of_anomalous_activities, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, cite(eu_reg_2024_1774_art_23_3)).
duty_row(logging_of_detected_anomalous_activities, information_on_each_detected_anomalous_activity_logged, cite(eu_reg_2024_1774_art_23_4)).
duty_row(consideration_of_incident_detection_criteria, criteria_triggering_incident_detection_and_response_considered, cite(eu_reg_2024_1774_art_23_5)).
duty_row(consideration_of_criticality_of_affected_services, criticality_of_affected_services_considered, cite(eu_reg_2024_1774_art_23_6)).

fixed_citations([cite(eu_reg_2024_1774_art_22), cite(eu_reg_2024_1774_art_23_1), cite(eu_reg_2024_1774_art_23_2), cite(eu_reg_2024_1774_art_23_3), cite(eu_reg_2024_1774_art_23_4), cite(eu_reg_2024_1774_art_23_5), cite(eu_reg_2024_1774_art_23_6)]).

gate_citations([cite(eu_reg_2022_2554_art_16_1)]).

referral_row(ict_related_incident_policy_unclear, open_textured, ict_related_incident_policy_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_22)).
referral_row(documentation_of_incident_management_process_unclear, open_textured, ict_related_incident_management_process_documented, cite(eu_reg_2024_1774_art_22_a)).
referral_row(list_of_relevant_contacts_unclear, open_textured, list_of_relevant_internal_and_external_contacts_established, cite(eu_reg_2024_1774_art_22_b)).
referral_row(incident_management_mechanisms_unclear, open_textured, technical_organisational_and_operational_incident_management_mechanisms_operated, cite(eu_reg_2024_1774_art_22_c)).
referral_row(retention_of_incident_evidence_unclear, open_textured, incident_evidence_retained_for_a_period_no_longer_than_necessary, cite(eu_reg_2024_1774_art_22_d)).
referral_row(analysis_of_significant_or_recurring_incidents_unclear, open_textured, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, cite(eu_reg_2024_1774_art_22_e)).
referral_row(secure_retention_of_incident_evidence_unclear, open_textured, incident_evidence_retained_in_a_secure_manner, cite(eu_reg_2024_1774_art_22)).
referral_row(detection_and_response_roles_and_responsibilities_unclear, open_textured, clear_roles_and_responsibilities_for_detection_and_response_set, cite(eu_reg_2024_1774_art_23_1)).
referral_row(collection_monitoring_and_analysis_unclear, open_textured, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, cite(eu_reg_2024_1774_art_23_2_a)).
referral_row(identification_of_anomalies_and_alerting_tools_unclear, open_textured, anomalous_activities_identified_and_alerting_tools_implemented, cite(eu_reg_2024_1774_art_23_2_b)).
referral_row(prioritisation_of_alerts_unclear, open_textured, alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)).
referral_row(recording_and_evaluation_of_anomalous_activities_unclear, open_textured, information_on_anomalous_activities_recorded_analysed_and_evaluated, cite(eu_reg_2024_1774_art_23_2_d)).
referral_row(automated_alerts_on_data_source_and_log_integrity_unclear, open_textured, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, cite(eu_reg_2024_1774_art_23_2)).
referral_row(protection_of_records_of_anomalous_activities_unclear, open_textured, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, cite(eu_reg_2024_1774_art_23_3)).
referral_row(logging_of_detected_anomalous_activities_unclear, open_textured, information_on_each_detected_anomalous_activity_logged, cite(eu_reg_2024_1774_art_23_4)).
referral_row(consideration_of_incident_detection_criteria_unclear, open_textured, criteria_triggering_incident_detection_and_response_considered, cite(eu_reg_2024_1774_art_23_5)).
referral_row(consideration_of_criticality_of_affected_services_unclear, open_textured, criticality_of_affected_services_considered, cite(eu_reg_2024_1774_art_23_6)).

referral_inputs([financial_entity_is_article_16_1_entity, ict_related_incident_policy_developed_documented_and_implemented, ict_related_incident_management_process_documented, list_of_relevant_internal_and_external_contacts_established, technical_organisational_and_operational_incident_management_mechanisms_operated, incident_evidence_retained_for_a_period_no_longer_than_necessary, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, incident_evidence_retained_in_a_secure_manner, clear_roles_and_responsibilities_for_detection_and_response_set, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, anomalous_activities_identified_and_alerting_tools_implemented, alerts_prioritised_within_expected_resolution_time, information_on_anomalous_activities_recorded_analysed_and_evaluated, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, information_on_each_detected_anomalous_activity_logged, criteria_triggering_incident_detection_and_response_considered, criticality_of_affected_services_considered]).

gate_route(Profile, refused([Problem|Problems])) :-
    dora_rts_incident_policy_and_detection_input_problems(Profile, [Problem|Problems]).
gate_route(Profile, simplified) :-
    implements(eu_reg_2022_2554_art_16_1),
    dora_rts_incident_policy_and_detection_input_problems(Profile, []),
    profile_get(Profile, financial_entity_is_article_16_1_entity, true).
gate_route(Profile, gate_absent) :-
    implements(eu_reg_2022_2554_art_16_1),
    dora_rts_incident_policy_and_detection_input_problems(Profile, []),
    profile_lacks(Profile, financial_entity_is_article_16_1_entity).
gate_route(Profile, duties_apply) :-
    implements(eu_reg_2022_2554_art_16_1),
    dora_rts_incident_policy_and_detection_input_problems(Profile, []),
    profile_get(Profile, financial_entity_is_article_16_1_entity, false).

key_value_state(Profile, ProfileKey, KeyValue) :-
    profile_get(Profile, ProfileKey, KeyValue).
key_value_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).

duty_states(Profile, States) :-
    findall(DutyAtom - ProfileKey - KeyState, (duty_row(DutyAtom, ProfileKey, _), key_value_state(Profile, ProfileKey, KeyState)), States).

keys_in_state(States, Wanted, ProfileKeys) :-
    findall(ProfileKey, member(_ - ProfileKey - Wanted, States), ProfileKeys).

all_duties(Duties) :-
    implements(eu_reg_2024_1774_art_22),
    findall(DutyAtom, duty_row(DutyAtom, _, _), Duties).

failing_duties(States, Duties) :-
    implements(eu_reg_2024_1774_art_22),
    findall(DutyAtom, member(DutyAtom - _ - false, States), Duties).

referral(Profile, InputKey, cite(CitationKey), Pairs) :-
    implements(eu_reg_2024_1774_art_22),
    referral_row(_, open_textured, InputKey, cite(CitationKey)),
    referral_inputs(InputKeys),
    findall(PresentKey - PresentValue, (member(PresentKey, InputKeys), profile_get(Profile, PresentKey, PresentValue)), Pairs).

rts_incident_policy_and_detection_duties_required(Profile, Result, Citations) :-
    gate_route(Profile, Route),
    required_answer(Route, Result, Citations).

required_answer(refused(Problems), input_problems(Problems), []).
required_answer(simplified, simplified_framework_entity, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    gate_citations(Citations).
required_answer(gate_absent, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
required_answer(duties_apply, required(Duties), Citations) :-
    implements(eu_reg_2024_1774_art_22),
    all_duties(Duties),
    fixed_citations(Citations).

rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations) :-
    gate_route(Profile, Route),
    complete_answer(Route, Profile, Result, Citations).

complete_answer(refused(Problems), _, input_problems(Problems), []).
complete_answer(simplified, _, simplified_framework_entity, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    gate_citations(Citations).
complete_answer(gate_absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
complete_answer(duties_apply, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_22),
    duty_states(Profile, States),
    keys_in_state(States, false, FalseKeys),
    keys_in_state(States, absent, AbsentKeys),
    keys_in_state(States, unsure, UnsureKeys),
    completion(FalseKeys, AbsentKeys, UnsureKeys, Profile, Result, Citations).

completion([_|_], _, _, _, incomplete, Citations) :-
    implements(eu_reg_2024_1774_art_22),
    fixed_citations(Citations).
completion([], [FirstAbsent|_], _, _, indeterminate([FirstAbsent]), []) :-
    implements(eu_reg_2024_1774_art_22).
completion([], [], [FirstUnsure|_], Profile, needs_legal_review(open_textured(FirstUnsure, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2024_1774_art_22),
    referral(Profile, FirstUnsure, Citation, Pairs).
completion([], [], [], _, complete, Citations) :-
    implements(eu_reg_2024_1774_art_22),
    fixed_citations(Citations).

rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations) :-
    gate_route(Profile, Route),
    outstanding_answer(Route, Profile, Result, Citations).

outstanding_answer(refused(Problems), _, input_problems(Problems), []).
outstanding_answer(simplified, _, simplified_framework_entity, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    gate_citations(Citations).
outstanding_answer(gate_absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
outstanding_answer(duties_apply, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_22),
    duty_states(Profile, States),
    keys_in_state(States, absent, AbsentKeys),
    keys_in_state(States, unsure, UnsureKeys),
    failing_duties(States, FailingDuties),
    outstanding_list(AbsentKeys, UnsureKeys, FailingDuties, Profile, Result, Citations).

outstanding_list([FirstAbsent|_], _, _, _, indeterminate([FirstAbsent]), []) :-
    implements(eu_reg_2024_1774_art_22).
outstanding_list([], [FirstUnsure|_], _, Profile, needs_legal_review(open_textured(FirstUnsure, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2024_1774_art_22),
    referral(Profile, FirstUnsure, Citation, Pairs).
outstanding_list([], [], [], _, none_outstanding, Citations) :-
    implements(eu_reg_2024_1774_art_22),
    fixed_citations(Citations).
outstanding_list([], [], [FirstFailing|LaterFailing], _, outstanding([FirstFailing|LaterFailing]), Citations) :-
    implements(eu_reg_2024_1774_art_22),
    findall(Citation, (member(DutyAtom, [FirstFailing|LaterFailing]), duty_row(DutyAtom, _, Citation)), CollectedCitations),
    sort(CollectedCitations, Citations).

decide_dora_rts_incident_policy_and_detection(Profile, dora_rts_incident_policy_and_detection_verdict(Status, Citations)) :-
    rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations),
    functor(Result, Status, _).

dora_rts_incident_policy_and_detection_status(Profile, Status) :-
    decide_dora_rts_incident_policy_and_detection(Profile, dora_rts_incident_policy_and_detection_verdict(Status, _Citations)).

dora_rts_incident_policy_and_detection_decision_resolvable(Profile) :-
    decide_dora_rts_incident_policy_and_detection(Profile, _Verdict).

dora_rts_incident_policy_and_detection_checklist(Profile, Items) :-
    gate_route(Profile, Route),
    checklist_items(Route, Profile, Items).

checklist_items(refused(Problems), _, [item(input_check, unmet(input_problems(Problems)), cite(eu_reg_2022_2554_art_16_1))]).
checklist_items(simplified, _, [item(article_16_1_entity, unmet(simplified_framework_entity), cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_items(gate_absent, _, [item(article_16_1_entity, unknown([financial_entity_is_article_16_1_entity]), cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_items(duties_apply, Profile, [item(article_16_1_entity, met, cite(eu_reg_2022_2554_art_16_1))|DutyItems]) :-
    implements(eu_reg_2024_1774_art_22),
    findall(item(DutyAtom, ItemStatus, Citation), (duty_row(DutyAtom, ProfileKey, Citation), key_value_state(Profile, ProfileKey, KeyState), item_status(KeyState, ProfileKey, ItemStatus)), DutyItems).

item_status(true, _, met).
item_status(false, _, unmet(not_performed)).
item_status(unsure, ProfileKey, unknown([ProfileKey])).
item_status(absent, ProfileKey, unknown([ProfileKey])).

duty_profile(GateValue, DutyValue, [attribute(financial_entity_is_article_16_1_entity, GateValue)|DutyAttributes]) :-
    findall(attribute(ProfileKey, DutyValue), duty_row(_, ProfileKey, _), DutyAttributes).

set_attribute([], _, _, []).
set_attribute([attribute(ProfileKey, _)|Attributes], Wanted, NewValue, [attribute(ProfileKey, NewValue)|Rest]) :-
    ProfileKey == Wanted,
    set_attribute(Attributes, Wanted, NewValue, Rest).
set_attribute([attribute(ProfileKey, KeyValue)|Attributes], Wanted, NewValue, [attribute(ProfileKey, KeyValue)|Rest]) :-
    ProfileKey \== Wanted,
    set_attribute(Attributes, Wanted, NewValue, Rest).

drop_attribute([], _, []).
drop_attribute([attribute(ProfileKey, _)|Attributes], Wanted, Rest) :-
    ProfileKey == Wanted,
    drop_attribute(Attributes, Wanted, Rest).
drop_attribute([attribute(ProfileKey, KeyValue)|Attributes], Wanted, [attribute(ProfileKey, KeyValue)|Rest]) :-
    ProfileKey \== Wanted,
    drop_attribute(Attributes, Wanted, Rest).

test(gate_true_is_simplified_framework_entity) :-
    duty_profile(true, false, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_absent_is_asked_first) :-
    rts_incident_policy_and_detection_duties_required([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(required_lists_all_seventeen_duties) :-
    rts_incident_policy_and_detection_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], required(Duties), Citations),
    length(Duties, 17),
    Duties = [ict_related_incident_policy|_],
    length(Citations, 7).
test(all_true_is_complete_once) :-
    duty_profile(false, true, Profile),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations), Answers),
    length(Answers, 1),
    Answers = [complete - _].
test(all_true_is_none_outstanding) :-
    duty_profile(false, true, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 7).
test(false_decides_before_absent_in_complete) :-
    duty_profile(false, true, Start),
    set_attribute(Start, list_of_relevant_internal_and_external_contacts_established, false, Changed),
    drop_attribute(Changed, incident_evidence_retained_for_a_period_no_longer_than_necessary, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(absent_is_named_in_outstanding) :-
    duty_profile(false, true, Start),
    set_attribute(Start, list_of_relevant_internal_and_external_contacts_established, false, Changed),
    drop_attribute(Changed, incident_evidence_retained_for_a_period_no_longer_than_necessary, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, indeterminate([incident_evidence_retained_for_a_period_no_longer_than_necessary]), []).
test(unsure_is_referred_with_all_pairs) :-
    duty_profile(false, true, Start),
    set_attribute(Start, alerts_prioritised_within_expected_resolution_time, unsure, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 18).
test(two_article_22_duties_outstanding_cite_once) :-
    duty_profile(false, true, Start),
    set_attribute(Start, ict_related_incident_policy_developed_documented_and_implemented, false, Changed),
    set_attribute(Changed, incident_evidence_retained_in_a_secure_manner, false, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, outstanding(Duties), Citations),
    Duties == [ict_related_incident_policy, secure_retention_of_incident_evidence],
    Citations == [cite(eu_reg_2024_1774_art_22)].
test(unknown_key_is_refused) :-
    rts_incident_policy_and_detection_duties_outstanding([attribute(mystery, 1)], input_problems([unknown_key(mystery)]), []).
test(facade_status_is_the_result_functor) :-
    duty_profile(false, true, Start),
    set_attribute(Start, criticality_of_affected_services_considered, unsure, Profile),
    dora_rts_incident_policy_and_detection_status(Profile, needs_legal_review).
test(checklist_has_gate_and_seventeen_rows) :-
    duty_profile(false, true, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, Items),
    length(Items, 18).

test(gate_true_is_not_incomplete, fail) :-
    duty_profile(true, false, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(unknown_key_is_not_complete, fail) :-
    rts_incident_policy_and_detection_duties_complete([attribute(mystery, 1)], complete, _).
