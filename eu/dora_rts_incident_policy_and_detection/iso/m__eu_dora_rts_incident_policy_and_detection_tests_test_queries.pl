% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_queries, [dora_rts_incident_policy_and_detection_profile_keys/1, dora_rts_incident_policy_and_detection_what_if/4]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_kernel, [dora_rts_incident_policy_and_detection_input_problems/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [rts_incident_policy_and_detection_duties_complete/3, decide_dora_rts_incident_policy_and_detection/2, dora_rts_incident_policy_and_detection_status/2, dora_rts_incident_policy_and_detection_checklist/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_fixtures, [dora_rts_incident_policy_and_detection_profile_for/2]).

item_cited(item(_, _, cite(_))).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_incident_policy_and_detection_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, ict_related_incident_policy_developed_documented_and_implemented, ict_related_incident_management_process_documented, list_of_relevant_internal_and_external_contacts_established, technical_organisational_and_operational_incident_management_mechanisms_operated, incident_evidence_retained_for_a_period_no_longer_than_necessary, mechanisms_to_analyse_significant_or_recurring_incidents_and_patterns_implemented, incident_evidence_retained_in_a_secure_manner, clear_roles_and_responsibilities_for_detection_and_response_set, factors_threats_and_provider_incident_notifications_collected_monitored_and_analysed, anomalous_activities_identified_and_alerting_tools_implemented, alerts_prioritised_within_expected_resolution_time, information_on_anomalous_activities_recorded_analysed_and_evaluated, alerting_tools_include_automated_alerts_on_data_source_and_log_integrity, records_of_anomalous_activities_protected_against_tampering_and_unauthorised_access, information_on_each_detected_anomalous_activity_logged, criteria_triggering_incident_detection_and_response_considered, criticality_of_affected_services_considered].
test(the_reexported_input_check_accepts_a_clean_profile) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_input_problems(Profile, []).
test(the_reexported_input_check_names_an_unknown_key) :-
    dora_rts_incident_policy_and_detection_profile_for(unknown_key_present, Profile),
    dora_rts_incident_policy_and_detection_input_problems(Profile, [unknown_key(financial_entity_is_microenterprise)]).
test(what_if_one_duty_fails) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, alerts_prioritised_within_expected_resolution_time, false, incomplete).
test(what_if_the_failing_duty_is_performed) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, alerts_prioritised_within_expected_resolution_time, true, complete).
test(what_if_the_entity_is_an_article_16_1_entity) :-
    dora_rts_incident_policy_and_detection_profile_for(several_duties_not_performed, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(what_if_a_judgement_is_unsure) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, criteria_triggering_incident_detection_and_response_considered, unsure, needs_legal_review).
test(what_if_a_value_is_out_of_type) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, financial_entity_is_article_16_1_entity, unsure, input_problems).
test(what_if_answers_once) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    findall(NewStatus, dora_rts_incident_policy_and_detection_what_if(Profile, incident_evidence_retained_in_a_secure_manner, false, NewStatus), Statuses),
    Statuses == [incomplete].
test(compliance_check_all_duties_performed) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, complete, _).
test(compliance_check_one_duty_not_performed) :-
    dora_rts_incident_policy_and_detection_profile_for(automated_alerts_not_performed, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, incomplete, _).
test(eligibility_verdict_with_citations) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    decide_dora_rts_incident_policy_and_detection(Profile, dora_rts_incident_policy_and_detection_verdict(complete, [_|_])).
test(eligibility_status_of_an_article_16_1_entity) :-
    dora_rts_incident_policy_and_detection_profile_for(simplified_entity, Profile),
    dora_rts_incident_policy_and_detection_status(Profile, simplified_framework_entity).
test(justification_every_item_is_cited) :-
    dora_rts_incident_policy_and_detection_profile_for(several_duties_not_performed, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, Items),
    length(Items, 18),
    maplist(item_cited, Items).
test(justification_gate_row_first) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, [item(article_16_1_entity, met, cite(eu_reg_2022_2554_art_16_1))|_]).
test(justification_names_the_failing_duty_with_its_citation) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, Items),
    member(item(prioritisation_of_alerts, unmet(not_performed), cite(eu_reg_2024_1774_art_23_2_c)), Items).
test(justification_marks_the_unsure_duty_unknown) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_unsure, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, Items),
    member(item(prioritisation_of_alerts, unknown([alerts_prioritised_within_expected_resolution_time]), cite(eu_reg_2024_1774_art_23_2_c)), Items).
test(justification_for_an_article_16_1_entity_is_one_row) :-
    dora_rts_incident_policy_and_detection_profile_for(simplified_entity, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, [item(article_16_1_entity, unmet(simplified_framework_entity), cite(eu_reg_2022_2554_art_16_1))]).

test(what_if_the_failing_duty_is_performed_is_not_incomplete, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, alerts_prioritised_within_expected_resolution_time, true, incomplete).
test(what_if_needs_a_list_profile, fail) :-
    dora_rts_incident_policy_and_detection_what_if(not_a_profile, financial_entity_is_article_16_1_entity, false, _).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_accepts_a_clean_profile, the_reexported_input_check_names_an_unknown_key, what_if_one_duty_fails, what_if_the_failing_duty_is_performed, what_if_the_entity_is_an_article_16_1_entity, what_if_a_judgement_is_unsure, what_if_a_value_is_out_of_type, what_if_answers_once, compliance_check_all_duties_performed, compliance_check_one_duty_not_performed, eligibility_verdict_with_citations, eligibility_status_of_an_article_16_1_entity, justification_every_item_is_cited, justification_gate_row_first, justification_names_the_failing_duty_with_its_citation, justification_marks_the_unsure_duty_unknown, justification_for_an_article_16_1_entity_is_one_row]).
cp_test_fail_names([what_if_the_failing_duty_is_performed_is_not_incomplete, what_if_needs_a_list_profile]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
