% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [appeal_period/3, appeal_filing_requirements/3, appeal_disposal_target/3, information_call_status/3, non_disclosure_status/3]).
:- use_module(m__ind_dpdp_appeal_information_fixtures, [dpdp_appeal_information_profile_for/2]).

result_of(Query, Subject, Result) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    call(Query, Profile, Result, _).

test(on_the_last_day_is_in_time) :-
    result_of(appeal_period, appeal_filed_on_last_day, in_time(date(2027, 3, 11))).
test(the_day_after_needs_sufficient_cause) :-
    result_of(appeal_period, appeal_filed_day_after_last_day, out_of_time_sufficient_cause_needed(date(2027, 3, 11))).
test(across_the_year_on_the_last_day_is_in_time) :-
    result_of(appeal_period, appeal_across_year_on_last_day, in_time(date(2028, 1, 30))).
test(across_the_year_the_day_after_needs_sufficient_cause) :-
    result_of(appeal_period, appeal_across_year_day_after_last_day, out_of_time_sufficient_cause_needed(date(2028, 1, 30))).
test(section_29_not_in_force_is_not_in_force) :-
    result_of(appeal_period, section_29_not_in_force, not_in_force).
test(section_29_unstated_asks_for_it) :-
    result_of(appeal_period, section_29_unstated, indeterminate([section_29_in_force_on_filing_date])).
test(an_order_not_of_the_board_is_not_appealable) :-
    result_of(appeal_period, order_not_of_board, not_appealable).
test(an_appellant_not_aggrieved_is_not_appealable) :-
    result_of(appeal_period, appellant_not_aggrieved, not_appealable).
test(an_unsure_board_order_is_referred) :-
    result_of(appeal_period, board_order_unsure, needs_legal_review(open_textured(appeal_against_board_order_or_direction, _), _)).
test(an_unsure_aggrieved_is_referred) :-
    result_of(appeal_period, appellant_aggrieved_unsure, needs_legal_review(open_textured(appellant_aggrieved, _), _)).
test(a_missing_receipt_date_is_named) :-
    result_of(appeal_period, receipt_date_missing, indeterminate([order_receipt_date])).
test(filed_the_day_rule_22_starts_lists_the_requirements) :-
    result_of(appeal_filing_requirements, filed_on_day_rules_start, filing_requirements(_)).
test(filed_the_day_before_is_not_yet_prescribed) :-
    result_of(appeal_filing_requirements, filed_day_before_rules_start, not_yet_prescribed).
test(asked_on_the_target_day_has_not_passed) :-
    result_of(appeal_disposal_target, reference_on_target_day, disposal_target_not_yet_passed(date(2027, 9, 11))).
test(asked_the_day_after_requires_reasons) :-
    result_of(appeal_disposal_target, reference_day_after_target_day, reasons_in_writing_required(date(2027, 9, 11))).
test(disposed_within_target_is_met) :-
    result_of(appeal_disposal_target, disposed_within_target_leap_february, disposed_within_target(date(2028, 2, 29))).
test(a_scheduled_call_the_day_rule_23_starts_is_within_the_specified_period) :-
    result_of(information_call_status, scheduled_call_on_day_rules_start, required_to_furnish_within_specified_period).
test(a_call_the_day_before_is_under_section_36) :-
    result_of(information_call_status, call_day_before_rules_start, required_to_furnish_under_section_36).
test(the_board_must_furnish_under_section_36) :-
    result_of(information_call_status, call_to_board, required_to_furnish_under_section_36).
test(another_recipient_is_not_covered) :-
    result_of(information_call_status, call_to_other_recipient, not_covered).
test(section_36_not_in_force_is_not_in_force) :-
    result_of(information_call_status, section_36_not_in_force, not_in_force).
test(a_call_outside_the_schedule_is_referred) :-
    result_of(information_call_status, call_outside_schedule, needs_legal_review(not_governed_here(_), _)).
test(a_call_not_through_the_authorised_person_is_referred) :-
    result_of(information_call_status, call_not_through_authorised_person, needs_legal_review(not_governed_here(_), _)).
test(an_unsure_purpose_is_referred) :-
    result_of(information_call_status, schedule_purpose_unsure, needs_legal_review(open_textured(call_for_seventh_schedule_purpose, _), _)).
test(without_permission_disclosure_is_barred) :-
    result_of(non_disclosure_status, disclosure_barred, disclosure_barred_without_written_permission).
test(with_permission_disclosure_is_permitted) :-
    result_of(non_disclosure_status, disclosure_permitted, disclosure_permitted_by_written_permission).
test(no_requirement_is_not_barred) :-
    result_of(non_disclosure_status, non_disclosure_not_required, not_barred_by_rule_23).
test(a_call_before_rule_23_is_not_in_force) :-
    result_of(non_disclosure_status, non_disclosure_call_before_rules, not_in_force).
test(a_malformed_profile_gets_its_problems) :-
    result_of(appeal_period, malformed_profile, input_problems([wrong_type(appellant_aggrieved), unknown_key(colour)])).

test(the_day_after_is_not_in_time, fail) :-
    result_of(appeal_period, appeal_filed_day_after_last_day, in_time(_)).
test(across_the_year_the_day_after_is_not_in_time, fail) :-
    result_of(appeal_period, appeal_across_year_day_after_last_day, in_time(_)).
test(section_29_not_in_force_is_not_in_time, fail) :-
    result_of(appeal_period, section_29_not_in_force, in_time(_)).
test(section_29_unstated_is_not_in_force, fail) :-
    result_of(appeal_period, section_29_unstated, not_in_force).
test(an_order_not_of_the_board_is_not_in_time, fail) :-
    result_of(appeal_period, order_not_of_board, in_time(_)).
test(an_appellant_not_aggrieved_is_not_in_time, fail) :-
    result_of(appeal_period, appellant_not_aggrieved, in_time(_)).
test(an_unsure_board_order_is_not_in_time, fail) :-
    result_of(appeal_period, board_order_unsure, in_time(_)).
test(an_unsure_aggrieved_is_not_in_time, fail) :-
    result_of(appeal_period, appellant_aggrieved_unsure, in_time(_)).
test(a_missing_receipt_date_is_not_in_time, fail) :-
    result_of(appeal_period, receipt_date_missing, in_time(_)).
test(filed_the_day_before_lists_no_requirements, fail) :-
    result_of(appeal_filing_requirements, filed_day_before_rules_start, filing_requirements(_)).
test(asked_the_day_after_has_passed, fail) :-
    result_of(appeal_disposal_target, reference_day_after_target_day, disposal_target_not_yet_passed(_)).
test(not_disposed_is_not_within_target, fail) :-
    result_of(appeal_disposal_target, reference_on_target_day, disposed_within_target(_)).
test(a_call_the_day_before_is_not_under_rule_23, fail) :-
    result_of(information_call_status, call_day_before_rules_start, required_to_furnish_within_specified_period).
test(another_recipient_need_not_furnish, fail) :-
    result_of(information_call_status, call_to_other_recipient, required_to_furnish_under_section_36).
test(section_36_not_in_force_is_not_a_duty, fail) :-
    result_of(information_call_status, section_36_not_in_force, required_to_furnish_within_specified_period).
test(a_call_outside_the_schedule_is_not_a_scheduled_duty, fail) :-
    result_of(information_call_status, call_outside_schedule, required_to_furnish_within_specified_period).
test(a_call_not_through_the_authorised_person_is_not_a_scheduled_duty, fail) :-
    result_of(information_call_status, call_not_through_authorised_person, required_to_furnish_within_specified_period).
test(an_unsure_purpose_is_not_a_scheduled_duty, fail) :-
    result_of(information_call_status, schedule_purpose_unsure, required_to_furnish_within_specified_period).
test(with_permission_disclosure_is_not_barred, fail) :-
    result_of(non_disclosure_status, disclosure_permitted, disclosure_barred_without_written_permission).
test(no_requirement_bars_nothing, fail) :-
    result_of(non_disclosure_status, non_disclosure_not_required, disclosure_barred_without_written_permission).
test(a_call_before_rule_23_bars_nothing, fail) :-
    result_of(non_disclosure_status, non_disclosure_call_before_rules, disclosure_barred_without_written_permission).
test(a_malformed_profile_gets_no_final_answer, fail) :-
    result_of(appeal_period, malformed_profile, not_appealable).

cp_test_names([on_the_last_day_is_in_time, the_day_after_needs_sufficient_cause, across_the_year_on_the_last_day_is_in_time, across_the_year_the_day_after_needs_sufficient_cause, section_29_not_in_force_is_not_in_force, section_29_unstated_asks_for_it, an_order_not_of_the_board_is_not_appealable, an_appellant_not_aggrieved_is_not_appealable, an_unsure_board_order_is_referred, an_unsure_aggrieved_is_referred, a_missing_receipt_date_is_named, filed_the_day_rule_22_starts_lists_the_requirements, filed_the_day_before_is_not_yet_prescribed, asked_on_the_target_day_has_not_passed, asked_the_day_after_requires_reasons, disposed_within_target_is_met, a_scheduled_call_the_day_rule_23_starts_is_within_the_specified_period, a_call_the_day_before_is_under_section_36, the_board_must_furnish_under_section_36, another_recipient_is_not_covered, section_36_not_in_force_is_not_in_force, a_call_outside_the_schedule_is_referred, a_call_not_through_the_authorised_person_is_referred, an_unsure_purpose_is_referred, without_permission_disclosure_is_barred, with_permission_disclosure_is_permitted, no_requirement_is_not_barred, a_call_before_rule_23_is_not_in_force, a_malformed_profile_gets_its_problems]).
cp_test_fail_names([the_day_after_is_not_in_time, across_the_year_the_day_after_is_not_in_time, section_29_not_in_force_is_not_in_time, section_29_unstated_is_not_in_force, an_order_not_of_the_board_is_not_in_time, an_appellant_not_aggrieved_is_not_in_time, an_unsure_board_order_is_not_in_time, an_unsure_aggrieved_is_not_in_time, a_missing_receipt_date_is_not_in_time, filed_the_day_before_lists_no_requirements, asked_the_day_after_has_passed, not_disposed_is_not_within_target, a_call_the_day_before_is_not_under_rule_23, another_recipient_need_not_furnish, section_36_not_in_force_is_not_a_duty, a_call_outside_the_schedule_is_not_a_scheduled_duty, a_call_not_through_the_authorised_person_is_not_a_scheduled_duty, an_unsure_purpose_is_not_a_scheduled_duty, with_permission_disclosure_is_not_barred, no_requirement_bars_nothing, a_call_before_rule_23_bars_nothing, a_malformed_profile_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
