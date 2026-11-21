% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_dora_ict_risk_protection_and_detection, [ict_risk_protection_and_detection_duties_required/3, ict_risk_protection_and_detection_duties_complete/3, ict_risk_protection_and_detection_duties_outstanding/3, dora_ict_risk_protection_and_detection_status/2, dora_ict_risk_protection_and_detection_status_values/1]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_kernel, [dora_ict_risk_protection_and_detection_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_fixtures, [dora_ict_risk_protection_and_detection_subject/1, dora_ict_risk_protection_and_detection_profile_for/2]).

expected_status(credit_institution_all_duties_performed, complete).
expected_status(credit_institution_patch_policies_not_documented, incomplete).
expected_status(data_reporting_provider_all_duties_performed, complete).
expected_status(data_reporting_provider_trade_report_checking_not_in_place, incomplete).
expected_status(credit_institution_trade_report_checking_not_in_place, complete).
expected_status(credit_institution_trade_report_checking_unsure, complete).
expected_status(data_reporting_provider_trade_report_checking_unanswered, indeterminate([trade_report_checking_systems_in_place])).
expected_status(article_16_1_entity_with_duties_not_performed, simplified_framework_entity).
expected_status(article_16_1_status_unanswered, indeterminate([financial_entity_is_article_16_1_entity])).
expected_status(entity_type_and_trade_report_checking_unanswered, indeterminate([dora_entity_type])).
expected_status(entity_type_unanswered_trade_report_checking_in_place, complete).
expected_status(entity_type_monitoring_and_trade_report_checking_unanswered, indeterminate([monitors_and_controls_security_and_functioning_of_ict_systems])).
expected_status(entity_type_and_monitoring_unanswered_trade_report_checking_not_in_place, indeterminate([dora_entity_type])).
expected_status(security_tools_deployment_unsure, needs_legal_review(open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)), [inputs_relied_on(_)])).
expected_status(security_tools_deployment_unsure_patch_policies_not_documented, incomplete).
expected_status(security_tools_deployment_unsure_anomaly_detection_unanswered, indeterminate([anomaly_detection_mechanisms_in_place])).
expected_status(ict_third_party_service_provider_all_duties_performed, complete).
expected_status(article_16_1_status_given_as_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
expected_status(unknown_key_given, input_problems([unknown_key(colour)])).
expected_status(anomaly_detection_given_twice, input_problems([duplicate_key(anomaly_detection_mechanisms_in_place)])).

expected_status_holds(Subject) :-
    expected_status(Subject, Expected),
    dora_ict_risk_protection_and_detection_profile_for(Subject, Profile),
    dora_ict_risk_protection_and_detection_status(Profile, Expected).

duty_order([monitoring_and_control_of_ict_systems, ict_security_tools_policies_and_procedures, ict_security_policies_procedures_protocols_and_tools, appropriate_ict_solutions_and_processes, security_of_data_transfer, minimised_data_corruption_loss_and_unauthorised_access, prevention_of_unavailability_impairment_breaches_and_loss, protection_from_data_management_risks, information_security_policy, network_and_infrastructure_management, access_control_policies, strong_authentication_and_cryptographic_key_protection, ict_change_management, patch_and_update_policies, severable_network_connection_infrastructure, approved_ict_change_management_process, anomaly_detection_mechanisms, single_point_of_failure_identification, regular_testing_of_detection_mechanisms, detection_control_layers_alert_thresholds_and_automatic_alerts, resources_to_monitor_user_activity_anomalies_and_incidents, trade_report_checking_systems]).

eight_paragraph_citations([cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_10_4)]).

profile_of(Subject, Profile) :-
    dora_ict_risk_protection_and_detection_profile_for(Subject, Profile).

test(every_fixture_subject_has_an_expected_status) :-
    findall(Subject, dora_ict_risk_protection_and_detection_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), Expected),
    Expected == Subjects.
test(every_expected_status_holds_with_the_verdict_bound) :-
    findall(Subject, expected_status(Subject, _), Subjects),
    findall(Subject, expected_status_holds(Subject), Holding),
    Holding == Subjects.
test(status_holds_with_the_verdict_bound) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    findall(Status, dora_ict_risk_protection_and_detection_status(Profile, Status), [BaselineStatus]),
    dora_ict_risk_protection_and_detection_status(Profile, BaselineStatus).
test(required_bound_with_all_twenty_two_duties_for_a_data_reporting_service_provider) :-
    profile_of(data_reporting_provider_all_duties_performed, Profile),
    duty_order(Duties),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _).
test(required_bound_with_twenty_one_duties_for_a_credit_institution) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    duty_order(AllDuties),
    append(Duties, [trade_report_checking_systems], AllDuties),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _).
test(required_bound_with_the_gate_citation) :-
    profile_of(article_16_1_entity_with_duties_not_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(complete_bound_with_the_eight_paragraph_citations) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, complete, Citations),
    clausal_msort(Citations, Sorted),
    eight_paragraph_citations(Expected),
    clausal_msort(Expected, Sorted).
test(incomplete_bound_when_a_duty_is_not_performed) :-
    profile_of(credit_institution_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, incomplete, _).
test(outstanding_bound_with_its_duty_and_citation) :-
    profile_of(credit_institution_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, outstanding([patch_and_update_policies]), [cite(eu_reg_2022_2554_art_9_4_f)]).
test(none_outstanding_bound_when_every_duty_is_performed) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, none_outstanding, _).
test(input_check_bound_with_no_problem) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    dora_ict_risk_protection_and_detection_input_problems(Profile, []).
test(input_check_bound_with_the_duplicate) :-
    profile_of(anomaly_detection_given_twice, Profile),
    dora_ict_risk_protection_and_detection_input_problems(Profile, [duplicate_key(anomaly_detection_mechanisms_in_place)]).

test(every_other_bound_status_is_rejected, fail) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    findall(Status, dora_ict_risk_protection_and_detection_status(Profile, Status), [BaselineStatus]),
    dora_ict_risk_protection_and_detection_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_ict_risk_protection_and_detection_status(Profile, Other).
test(required_bound_with_twenty_two_duties_is_rejected_for_a_credit_institution, fail) :-
    profile_of(credit_institution_all_duties_performed, Profile),
    duty_order(Duties),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _).
test(complete_bound_is_rejected_when_a_duty_is_not_performed, fail) :-
    profile_of(credit_institution_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, complete, _).
test(none_outstanding_bound_is_rejected_when_a_duty_is_not_performed, fail) :-
    profile_of(credit_institution_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, none_outstanding, _).
test(input_check_bound_with_no_problem_is_rejected_for_a_duplicate, fail) :-
    profile_of(anomaly_detection_given_twice, Profile),
    dora_ict_risk_protection_and_detection_input_problems(Profile, []).

cp_test_names([every_fixture_subject_has_an_expected_status, every_expected_status_holds_with_the_verdict_bound, status_holds_with_the_verdict_bound, required_bound_with_all_twenty_two_duties_for_a_data_reporting_service_provider, required_bound_with_twenty_one_duties_for_a_credit_institution, required_bound_with_the_gate_citation, complete_bound_with_the_eight_paragraph_citations, incomplete_bound_when_a_duty_is_not_performed, outstanding_bound_with_its_duty_and_citation, none_outstanding_bound_when_every_duty_is_performed, input_check_bound_with_no_problem, input_check_bound_with_the_duplicate]).
cp_test_fail_names([every_other_bound_status_is_rejected, required_bound_with_twenty_two_duties_is_rejected_for_a_credit_institution, complete_bound_is_rejected_when_a_duty_is_not_performed, none_outstanding_bound_is_rejected_when_a_duty_is_not_performed, input_check_bound_with_no_problem_is_rejected_for_a_duplicate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
