% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [rts_incident_policy_and_detection_duties_required/3, rts_incident_policy_and_detection_duties_complete/3, rts_incident_policy_and_detection_duties_outstanding/3, decide_dora_rts_incident_policy_and_detection/2, dora_rts_incident_policy_and_detection_status/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_fixtures, [dora_rts_incident_policy_and_detection_profile_for/2]).

expected_duties_in_order([ict_related_incident_policy, documentation_of_incident_management_process, list_of_relevant_contacts, incident_management_mechanisms, retention_of_incident_evidence, analysis_of_significant_or_recurring_incidents, secure_retention_of_incident_evidence, detection_and_response_roles_and_responsibilities, collection_monitoring_and_analysis, identification_of_anomalies_and_alerting_tools, prioritisation_of_alerts, recording_and_evaluation_of_anomalous_activities, automated_alerts_on_data_source_and_log_integrity, protection_of_records_of_anomalous_activities, logging_of_detected_anomalous_activities, consideration_of_incident_detection_criteria, consideration_of_criticality_of_affected_services]).

expected_fixed_citations([cite(eu_reg_2024_1774_art_22), cite(eu_reg_2024_1774_art_23_1), cite(eu_reg_2024_1774_art_23_2), cite(eu_reg_2024_1774_art_23_3), cite(eu_reg_2024_1774_art_23_4), cite(eu_reg_2024_1774_art_23_5), cite(eu_reg_2024_1774_art_23_6)]).

required_answers(Subject, Answers) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_required(Profile, Result, Citations), Answers).

complete_answers(Subject, Answers) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations), Answers).

outstanding_answers(Subject, Answers) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations), Answers).

test(required_lists_every_duty_in_duty_order_once) :-
    required_answers(complete_entity, Answers),
    expected_duties_in_order(DutyAtoms),
    Answers = [required(Listed) - Citations],
    Listed == DutyAtoms,
    clausal_msort(Citations, SortedCitations),
    expected_fixed_citations(Fixed),
    SortedCitations == Fixed.
test(required_reads_the_gate_only) :-
    required_answers(several_duties_not_performed, Answers),
    expected_duties_in_order(DutyAtoms),
    Answers = [required(Listed) - _],
    Listed == DutyAtoms.
test(required_for_an_article_16_1_entity) :-
    required_answers(simplified_entity_with_failures, Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(required_asks_the_gate) :-
    required_answers(gate_not_stated_with_failures, Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(required_never_refers) :-
    required_answers(prioritisation_unsure, Answers),
    Answers = [required(_) - _].
test(required_refuses_a_bad_profile) :-
    required_answers(not_an_attribute_list, Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(complete_for_every_duty_performed) :-
    complete_answers(complete_entity, Answers),
    Answers = [complete - Citations],
    clausal_msort(Citations, SortedCitations),
    expected_fixed_citations(Fixed),
    SortedCitations == Fixed.
test(incomplete_cites_the_fixed_seven) :-
    complete_answers(automated_alerts_not_performed, Answers),
    Answers = [incomplete - Citations],
    clausal_msort(Citations, SortedCitations),
    expected_fixed_citations(Fixed),
    SortedCitations == Fixed.
test(a_failure_decides_before_an_absent_key) :-
    complete_answers(failure_beside_unanswered, Answers),
    Answers = [incomplete - _].
test(a_failure_decides_before_an_unsure_key) :-
    complete_answers(unsure_beside_failure, Answers),
    Answers = [incomplete - _].
test(complete_names_the_absent_key) :-
    complete_answers(retention_not_answered, Answers),
    Answers == [indeterminate([incident_evidence_retained_for_a_period_no_longer_than_necessary]) - []].
test(complete_names_the_absent_key_before_the_unsure_one) :-
    complete_answers(unsure_beside_unanswered, Answers),
    Answers == [indeterminate([criticality_of_affected_services_considered]) - []].
test(complete_refers_the_unsure_judgement) :-
    complete_answers(prioritisation_unsure, Answers),
    Answers = [needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(Pairs)]) - []],
    length(Pairs, 18),
    member(alerts_prioritised_within_expected_resolution_time - unsure, Pairs).
test(complete_for_an_article_16_1_entity) :-
    complete_answers(simplified_entity_with_failures, Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(complete_refuses_a_duplicate_key) :-
    complete_answers(duplicate_duty_key, Answers),
    Answers == [input_problems([duplicate_key(alerts_prioritised_within_expected_resolution_time)]) - []].
test(outstanding_lists_failing_duties_in_duty_order) :-
    outstanding_answers(several_duties_not_performed, Answers),
    Answers = [outstanding(DutyAtoms) - Citations],
    DutyAtoms == [ict_related_incident_policy, secure_retention_of_incident_evidence, consideration_of_criticality_of_affected_services],
    clausal_msort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2024_1774_art_22), cite(eu_reg_2024_1774_art_23_6)].
test(outstanding_secure_retention_cites_article_22) :-
    outstanding_answers(secure_retention_not_performed, Answers),
    Answers == [outstanding([secure_retention_of_incident_evidence]) - [cite(eu_reg_2024_1774_art_22)]].
test(outstanding_automated_alerts_cites_article_23_2) :-
    outstanding_answers(automated_alerts_not_performed, Answers),
    Answers == [outstanding([automated_alerts_on_data_source_and_log_integrity]) - [cite(eu_reg_2024_1774_art_23_2)]].
test(outstanding_prioritisation_cites_its_point) :-
    outstanding_answers(prioritisation_not_performed, Answers),
    Answers == [outstanding([prioritisation_of_alerts]) - [cite(eu_reg_2024_1774_art_23_2_c)]].
test(none_outstanding_cites_the_fixed_seven) :-
    outstanding_answers(complete_entity, Answers),
    Answers = [none_outstanding - Citations],
    clausal_msort(Citations, SortedCitations),
    expected_fixed_citations(Fixed),
    SortedCitations == Fixed.
test(outstanding_needs_every_duty_known) :-
    outstanding_answers(failure_beside_unanswered, Answers),
    Answers == [indeterminate([incident_evidence_retained_for_a_period_no_longer_than_necessary]) - []].
test(outstanding_refers_before_the_final_list) :-
    outstanding_answers(unsure_beside_failure, Answers),
    Answers = [needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(Pairs)]) - []],
    member(list_of_relevant_internal_and_external_contacts_established - false, Pairs),
    length(Pairs, 18).
test(outstanding_refers_the_first_unsure_key) :-
    outstanding_answers(two_duties_unsure, Answers),
    Answers = [needs_legal_review(open_textured(ict_related_incident_policy_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_22)), [inputs_relied_on(_)]) - []].
test(outstanding_refuses_a_numeric_judgement) :-
    outstanding_answers(numeric_judgement_value, Answers),
    Answers == [input_problems([wrong_type(criticality_of_affected_services_considered)]) - []].
test(outstanding_asks_the_gate) :-
    outstanding_answers(gate_not_stated, Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(the_verdict_carries_a_citation) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    decide_dora_rts_incident_policy_and_detection(Profile, dora_rts_incident_policy_and_detection_verdict(complete, [_FirstCitation|_OtherCitations])).
test(the_status_is_read_out_once) :-
    dora_rts_incident_policy_and_detection_profile_for(unknown_key_present, Profile),
    findall(Status, dora_rts_incident_policy_and_detection_status(Profile, Status), Statuses),
    Statuses == [input_problems].

cp_test_names([required_lists_every_duty_in_duty_order_once, required_reads_the_gate_only, required_for_an_article_16_1_entity, required_asks_the_gate, required_never_refers, required_refuses_a_bad_profile, complete_for_every_duty_performed, incomplete_cites_the_fixed_seven, a_failure_decides_before_an_absent_key, a_failure_decides_before_an_unsure_key, complete_names_the_absent_key, complete_names_the_absent_key_before_the_unsure_one, complete_refers_the_unsure_judgement, complete_for_an_article_16_1_entity, complete_refuses_a_duplicate_key, outstanding_lists_failing_duties_in_duty_order, outstanding_secure_retention_cites_article_22, outstanding_automated_alerts_cites_article_23_2, outstanding_prioritisation_cites_its_point, none_outstanding_cites_the_fixed_seven, outstanding_needs_every_duty_known, outstanding_refers_before_the_final_list, outstanding_refers_the_first_unsure_key, outstanding_refuses_a_numeric_judgement, outstanding_asks_the_gate, the_verdict_carries_a_citation, the_status_is_read_out_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
