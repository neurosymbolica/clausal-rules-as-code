% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_dora_ict_risk_protection_and_detection, [ict_risk_protection_and_detection_duties_required/3, ict_risk_protection_and_detection_duties_complete/3, ict_risk_protection_and_detection_duties_outstanding/3, decide_dora_ict_risk_protection_and_detection/2, dora_ict_risk_protection_and_detection_status/2, dora_ict_risk_protection_and_detection_checklist/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_kernel, [dora_ict_risk_protection_and_detection_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_fixtures, [dora_ict_risk_protection_and_detection_subject/1, dora_ict_risk_protection_and_detection_profile_for/2]).

profile_of(Subject, Profile) :-
    dora_ict_risk_protection_and_detection_profile_for(Subject, Profile).

with_value(Key, Value, Profile, [attribute(Key, Value)|Rest]) :-
    select(attribute(Key, _), Profile, Rest).

without_key(Key, Profile, Rest) :-
    select(attribute(Key, _), Profile, Rest).

status_count(Subject, Subject - Count) :-
    profile_of(Subject, Profile),
    findall(Status, dora_ict_risk_protection_and_detection_status(Profile, Status), Statuses),
    length(Statuses, Count).

duty_order([monitoring_and_control_of_ict_systems, ict_security_tools_policies_and_procedures, ict_security_policies_procedures_protocols_and_tools, appropriate_ict_solutions_and_processes, security_of_data_transfer, minimised_data_corruption_loss_and_unauthorised_access, prevention_of_unavailability_impairment_breaches_and_loss, protection_from_data_management_risks, information_security_policy, network_and_infrastructure_management, access_control_policies, strong_authentication_and_cryptographic_key_protection, ict_change_management, patch_and_update_policies, severable_network_connection_infrastructure, approved_ict_change_management_process, anomaly_detection_mechanisms, single_point_of_failure_identification, regular_testing_of_detection_mechanisms, detection_control_layers_alert_thresholds_and_automatic_alerts, resources_to_monitor_user_activity_anomalies_and_incidents, trade_report_checking_systems]).

test(every_subject_yields_exactly_one_status) :-
    findall(Row, (dora_ict_risk_protection_and_detection_subject(Subject), status_count(Subject, Row)), Rows),
    findall(Subject - 1, dora_ict_risk_protection_and_detection_subject(Subject), Expected),
    Rows == Expected.
test(the_baseline_profile_yields_exactly_one_status) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    findall(Status, dora_ict_risk_protection_and_detection_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_a_citation) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    decide_dora_ict_risk_protection_and_detection(Profile, dora_ict_risk_protection_and_detection_verdict(complete, [_FirstCitation|_OtherCitations])).
test(required_reads_out_every_duty_in_duty_order_for_a_data_reporting_service_provider) :-
    profile_of(data_reporting_provider_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, Result, Citations),
    duty_order(Duties),
    Result == required(Duties),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_10_4), cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4)].
test(required_reads_out_seven_citations_for_a_credit_institution) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), Citations),
    length(Duties, 21),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4)].
test(required_reads_out_the_missing_entity_type) :-
    profile_of(entity_type_unanswered_trade_report_checking_in_place, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, Result, Citations),
    Result == indeterminate([dora_entity_type]),
    Citations == [].
test(outstanding_reads_out_failing_duties_in_duty_order) :-
    profile_of(credit_institution_all_duties_performed, Base),
    with_value(patch_and_update_policies_documented, false, Base, WithPatch),
    with_value(monitors_and_controls_security_and_functioning_of_ict_systems, false, WithPatch, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([monitoring_and_control_of_ict_systems, patch_and_update_policies]),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_4_f)].
test(outstanding_writes_a_shared_citation_once) :-
    profile_of(credit_institution_all_duties_performed, Base),
    with_value(anomaly_detection_mechanisms_in_place, false, Base, WithAnomaly),
    with_value(detection_mechanisms_regularly_tested, false, WithAnomaly, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([anomaly_detection_mechanisms, regular_testing_of_detection_mechanisms]),
    Citations == [cite(eu_reg_2022_2554_art_10_1)].
test(outstanding_reads_out_the_trade_report_duty_for_a_provider) :-
    profile_of(data_reporting_provider_trade_report_checking_not_in_place, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([trade_report_checking_systems]),
    Citations == [cite(eu_reg_2022_2554_art_10_4)].
test(the_referral_reads_out_every_present_pair_in_root_order) :-
    profile_of(security_tools_deployment_unsure, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, needs_legal_review(Reason, [inputs_relied_on(Pairs)]), Citations),
    Reason == open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)),
    Citations == [],
    length(Pairs, 24),
    Pairs = [FirstPair, SecondPair, _, FourthPair|_],
    FirstPair == financial_entity_is_article_16_1_entity - false,
    SecondPair == dora_entity_type - credit_institution,
    FourthPair == deploys_ict_security_tools_policies_and_procedures - unsure.
test(the_referral_pairs_leave_out_an_absent_key) :-
    profile_of(credit_institution_all_duties_performed, Base),
    with_value(patch_and_update_policies_documented, unsure, Base, WithUnsure),
    without_key(trade_report_checking_systems_in_place, WithUnsure, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, needs_legal_review(open_textured(Key, _), [inputs_relied_on(Pairs)]), []),
    Key == patch_and_update_policies_documented,
    length(Pairs, 23).
test(the_checklist_reads_out_a_gate_row_and_one_row_per_duty) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    dora_ict_risk_protection_and_detection_checklist(Profile, [item(article_16_1_entity, met, cite(eu_reg_2022_2554_art_16_1))|DutyItems]),
    length(DutyItems, 22).
test(input_problems_come_in_contract_order_then_unknown_keys) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(colour, true), attribute(trade_report_checking_systems_in_place, maybe), attribute(financial_entity_is_article_16_1_entity, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity), wrong_type(trade_report_checking_systems_in_place), unknown_key(colour)].
test(a_repeated_unknown_key_is_named_once) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(colour, true), attribute(colour, false)], Problems),
    Problems == [unknown_key(colour)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(dora_entity_type, bank), attribute(dora_entity_type, credit_institution)], Problems),
    Problems == [duplicate_key(dora_entity_type)].
test(a_number_value_is_wrong_type) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(dora_entity_type, 1.0)], Problems),
    Problems == [wrong_type(dora_entity_type)].
test(an_unbound_value_is_wrong_type) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(detection_mechanisms_regularly_tested, _)], Problems),
    Problems == [wrong_type(detection_mechanisms_regularly_tested)].
test(an_unbound_key_is_named_as_given) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(Key, true)], [unknown_key(Named)]),
    Named == Key.
test(two_unbound_keys_are_two_keys) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(FirstKey, true), attribute(SecondKey, false)], [unknown_key(FirstNamed), unknown_key(SecondNamed)]),
    FirstNamed == FirstKey,
    SecondNamed == SecondKey.
test(a_number_key_is_unknown) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(an_unbound_profile_is_wrong_type) :-
    dora_ict_risk_protection_and_detection_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_wrong_type) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(colour, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_list_with_a_stray_element_is_wrong_type_alone) :-
    dora_ict_risk_protection_and_detection_input_problems([attribute(colour, true), stray], Problems),
    Problems == [wrong_type(profile)].
test(a_query_reads_out_the_input_problems_with_no_citation) :-
    ict_risk_protection_and_detection_duties_required([attribute(dora_entity_type, unsure)], Result, Citations),
    Result == input_problems([wrong_type(dora_entity_type)]),
    Citations == [].

cp_test_names([every_subject_yields_exactly_one_status, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, required_reads_out_every_duty_in_duty_order_for_a_data_reporting_service_provider, required_reads_out_seven_citations_for_a_credit_institution, required_reads_out_the_missing_entity_type, outstanding_reads_out_failing_duties_in_duty_order, outstanding_writes_a_shared_citation_once, outstanding_reads_out_the_trade_report_duty_for_a_provider, the_referral_reads_out_every_present_pair_in_root_order, the_referral_pairs_leave_out_an_absent_key, the_checklist_reads_out_a_gate_row_and_one_row_per_duty, input_problems_come_in_contract_order_then_unknown_keys, a_repeated_unknown_key_is_named_once, a_duplicate_key_is_never_also_wrong_type, a_number_value_is_wrong_type, an_unbound_value_is_wrong_type, an_unbound_key_is_named_as_given, two_unbound_keys_are_two_keys, a_number_key_is_unknown, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, a_list_with_a_stray_element_is_wrong_type_alone, a_query_reads_out_the_input_problems_with_no_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
