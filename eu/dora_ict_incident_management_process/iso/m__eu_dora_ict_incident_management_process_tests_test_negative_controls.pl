% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [ict_incident_management_process_duties_required/3, ict_incident_management_process_duties_complete/3, ict_incident_management_process_duties_outstanding/3, dora_ict_incident_management_process_status/2, dora_ict_incident_management_process_status_values/1]).
:- use_module(m__eu_dora_ict_incident_management_process_fixtures, [dora_ict_incident_management_process_profile_for/2]).

complete_result(Subject, Result) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    ict_incident_management_process_duties_complete(Profile, Result, _).

outstanding_result(Subject, Result) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    ict_incident_management_process_duties_outstanding(Profile, Result, _).

test(the_status_table_has_a_near_miss_atom) :-
    dora_ict_incident_management_process_status_values(StatusValues),
    StatusValues = [_, _|_].
test(every_route_status_is_in_the_table) :-
    dora_ict_incident_management_process_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(indeterminate, StatusValues),
    member(needs_legal_review, StatusValues),
    member(input_problems, StatusValues).
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    findall(Status, dora_ict_incident_management_process_status(Profile, Status), [_]).
test(all_performed_is_complete) :-
    complete_result(all_duties_performed, complete).
test(one_duty_not_performed_is_incomplete) :-
    complete_result(early_warning_indicators_not_performed, incomplete).
test(a_false_duty_decides_before_an_absent_key) :-
    complete_result(not_performed_and_unanswered, incomplete).
test(an_unanswered_duty_is_indeterminate) :-
    complete_result(last_duty_unanswered, indeterminate([cyber_threats_classified_as_significant_on_the_article_18_2_criteria])).
test(an_unsure_duty_is_referred) :-
    complete_result(communication_plans_unsure, needs_legal_review(open_textured(communication_notification_escalation_and_counterpart_information_plans_set_out, cite(eu_reg_2022_2554_art_17_3_d)), _)).
test(an_absent_key_is_named_before_an_unsure_one) :-
    complete_result(early_warning_unsure_and_response_unanswered, indeterminate([incident_response_procedures_established])).
test(an_unknown_key_is_refused) :-
    complete_result(unknown_key_present, input_problems([unknown_key(colour)])).
test(a_wrong_type_value_is_refused) :-
    complete_result(wrong_type_value, input_problems([wrong_type(early_warning_indicators_put_in_place)])).
test(an_empty_profile_has_every_duty_required) :-
    ict_incident_management_process_duties_required([], required(Duties), _),
    length(Duties, 10).
test(two_failing_duties_are_outstanding) :-
    outstanding_result(both_article_17_2_duties_not_performed, outstanding([recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures])).
test(all_performed_is_none_outstanding) :-
    outstanding_result(all_duties_performed, none_outstanding).
test(outstanding_names_the_absent_key_despite_a_false_one) :-
    outstanding_result(not_performed_and_unanswered, indeterminate([ict_related_incident_management_process_defined_established_and_implemented])).
test(outstanding_refers_an_unsure_duty) :-
    outstanding_result(communication_plans_unsure, needs_legal_review(open_textured(communication_notification_escalation_and_counterpart_information_plans_set_out, cite(eu_reg_2022_2554_art_17_3_d)), _)).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    findall(Status, dora_ict_incident_management_process_status(Profile, Status), [BaselineStatus]),
    dora_ict_incident_management_process_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_ict_incident_management_process_status(Profile, Other).
test(one_duty_not_performed_is_not_complete, fail) :-
    complete_result(early_warning_indicators_not_performed, complete).
test(all_performed_is_not_incomplete, fail) :-
    complete_result(all_duties_performed, incomplete).
test(a_false_duty_with_an_absent_key_is_not_indeterminate, fail) :-
    complete_result(not_performed_and_unanswered, indeterminate(_)).
test(all_answered_is_not_indeterminate, fail) :-
    complete_result(all_duties_performed, indeterminate(_)).
test(an_unanswered_duty_is_not_read_as_performed, fail) :-
    complete_result(last_duty_unanswered, complete).
test(a_sure_profile_is_not_referred, fail) :-
    complete_result(all_duties_performed, needs_legal_review(_, _)).
test(an_unsure_duty_is_not_read_as_performed, fail) :-
    complete_result(communication_plans_unsure, complete).
test(an_absent_key_blocks_the_referral, fail) :-
    complete_result(early_warning_unsure_and_response_unanswered, needs_legal_review(_, _)).
test(a_well_formed_profile_is_not_refused, fail) :-
    complete_result(all_duties_performed, input_problems(_)).
test(a_wrong_type_value_gets_no_final_answer, fail) :-
    complete_result(wrong_type_value, incomplete).
test(a_bad_profile_has_no_duty_list, fail) :-
    ict_incident_management_process_duties_required(not_a_list, required(_), _).
test(all_performed_has_nothing_outstanding, fail) :-
    outstanding_result(all_duties_performed, outstanding(_)).
test(a_failing_duty_is_not_none_outstanding, fail) :-
    outstanding_result(classification_of_significant_cyber_threats_not_performed, none_outstanding).
test(outstanding_gives_no_list_while_a_key_is_absent, fail) :-
    outstanding_result(not_performed_and_unanswered, outstanding(_)).
test(outstanding_does_not_read_unsure_as_performed, fail) :-
    outstanding_result(communication_plans_unsure, none_outstanding).

cp_test_names([the_status_table_has_a_near_miss_atom, every_route_status_is_in_the_table, the_baseline_profile_yields_exactly_one_status, all_performed_is_complete, one_duty_not_performed_is_incomplete, a_false_duty_decides_before_an_absent_key, an_unanswered_duty_is_indeterminate, an_unsure_duty_is_referred, an_absent_key_is_named_before_an_unsure_one, an_unknown_key_is_refused, a_wrong_type_value_is_refused, an_empty_profile_has_every_duty_required, two_failing_duties_are_outstanding, all_performed_is_none_outstanding, outstanding_names_the_absent_key_despite_a_false_one, outstanding_refers_an_unsure_duty]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, one_duty_not_performed_is_not_complete, all_performed_is_not_incomplete, a_false_duty_with_an_absent_key_is_not_indeterminate, all_answered_is_not_indeterminate, an_unanswered_duty_is_not_read_as_performed, a_sure_profile_is_not_referred, an_unsure_duty_is_not_read_as_performed, an_absent_key_blocks_the_referral, a_well_formed_profile_is_not_refused, a_wrong_type_value_gets_no_final_answer, a_bad_profile_has_no_duty_list, all_performed_has_nothing_outstanding, a_failing_duty_is_not_none_outstanding, outstanding_gives_no_list_while_a_key_is_absent, outstanding_does_not_read_unsure_as_performed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
