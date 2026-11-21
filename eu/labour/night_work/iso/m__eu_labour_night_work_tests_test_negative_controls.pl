% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_night_work_night_work, [night_work_status_values/1]).
:- use_module(m__eu_labour_night_work_fixtures, [night_work_assess/2]).

status_of(Subject, Status) :-
    night_work_assess(Subject, night_work_verdict(Status, _)).

test(the_status_table_has_a_near_miss_atom) :-
    night_work_status_values(StatusValues),
    StatusValues = [_, _|_].
test(average_at_the_limit_is_kept) :-
    status_of(average_at_the_limit_kept, average_night_hours_kept).
test(average_one_minute_over_is_exceeded) :-
    status_of(average_one_minute_over_exceeded, average_night_hours_exceeded).
test(a_cut_last_block_one_minute_over_is_exceeded) :-
    status_of(average_cut_last_block_exceeded, average_night_hours_exceeded).
test(a_cut_last_block_at_the_limit_is_kept) :-
    status_of(average_cut_last_block_at_the_limit_kept, average_night_hours_kept).
test(leave_is_not_working_time) :-
    status_of(average_leave_not_counted_kept, average_night_hours_kept).
test(the_same_hours_worked_are_exceeded) :-
    status_of(average_same_hours_worked_exceeded, average_night_hours_exceeded).
test(on_site_time_counted_exceeds) :-
    status_of(average_on_site_counted_exceeded, average_night_hours_exceeded).
test(on_site_time_not_counted_is_kept) :-
    status_of(average_on_site_not_counted_kept, average_night_hours_kept).
test(a_mobile_worker_over_the_average_is_outside_article_8) :-
    status_of(average_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker).
test(a_mobile_worker_at_the_limit_is_kept) :-
    status_of(average_mobile_worker_at_the_limit_kept, average_night_hours_kept).
test(a_fishing_vessel_worker_is_outside_article_8) :-
    status_of(average_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker).
test(a_hazardous_mobile_worker_is_outside_article_8) :-
    status_of(hazardous_mobile_worker_outside_article_8, night_work_limits_not_applied_to_worker).
test(a_hazardous_fishing_vessel_worker_is_outside_article_8) :-
    status_of(hazardous_fishing_vessel_worker_outside_article_8, night_work_limits_not_applied_to_worker).
test(a_worker_who_is_not_a_night_worker_is_outside_article_8_a) :-
    status_of(average_not_a_night_worker, not_a_night_worker).
test(a_worker_who_is_not_a_night_worker_is_outside_article_8_b) :-
    status_of(hazardous_not_a_night_worker, not_a_night_worker).
test(a_derogation_under_article_17_1_applies) :-
    night_work_assess(average_derogation_under_article_17_1, night_work_verdict(night_work_derogation_applies, Citations)),
    Citations == [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_17_1)].
test(a_derogation_under_article_17_3_applies) :-
    status_of(average_derogation_under_article_17_3, night_work_derogation_applies).
test(a_derogation_under_article_18_applies) :-
    status_of(average_derogation_under_article_18, night_work_derogation_applies).
test(a_hazardous_derogation_under_article_18_applies) :-
    status_of(hazardous_derogation_under_article_18, night_work_derogation_applies).
test(eight_hours_of_night_work_are_kept) :-
    status_of(hazardous_eight_hours_kept, hazardous_night_work_hours_kept).
test(one_minute_over_is_exceeded) :-
    status_of(hazardous_one_minute_over_exceeded, hazardous_night_work_hours_exceeded).
test(work_without_special_hazards_is_outside_article_8_b) :-
    status_of(hazardous_no_special_hazards, no_special_hazards_or_heavy_strain).
test(a_day_shift_ending_at_night_start_is_kept) :-
    status_of(hazardous_day_shift_ending_at_night_start_kept, hazardous_night_work_hours_kept).
test(one_night_minute_brings_the_window_under_the_limit) :-
    status_of(hazardous_day_shift_one_night_minute_exceeded, hazardous_night_work_hours_exceeded).
test(a_shift_from_night_end_is_kept) :-
    status_of(hazardous_shift_from_night_end_kept, hazardous_night_work_hours_kept).
test(a_shift_one_minute_before_night_end_is_exceeded) :-
    status_of(hazardous_shift_one_minute_before_night_end_exceeded, hazardous_night_work_hours_exceeded).
test(a_window_past_the_period_is_read) :-
    status_of(hazardous_window_past_period_exceeded, hazardous_night_work_hours_exceeded).
test(a_window_past_the_period_at_the_limit_is_kept) :-
    status_of(hazardous_window_past_period_at_the_limit_kept, hazardous_night_work_hours_kept).
test(touching_rows_are_one_run) :-
    status_of(hazardous_touching_rows_exceeded, hazardous_night_work_hours_exceeded).
test(touching_rows_at_the_limit_are_kept) :-
    status_of(hazardous_touching_rows_at_the_limit_kept, hazardous_night_work_hours_kept).
test(standby_counted_exceeds) :-
    status_of(hazardous_standby_counted_exceeded, hazardous_night_work_hours_exceeded).
test(standby_not_counted_is_kept) :-
    status_of(hazardous_standby_not_counted_kept, hazardous_night_work_hours_kept).
test(an_absent_night_time_that_decides_is_asked_for) :-
    status_of(hazardous_absent_night_time_asked, indeterminate([night_time_start])).
test(a_stated_night_time_is_kept) :-
    status_of(hazardous_stated_night_time_kept, hazardous_night_work_hours_kept).
test(an_absent_reference_period_that_decides_is_asked_for) :-
    status_of(average_absent_reference_period_asked, indeterminate([night_work_reference_period_days])).
test(a_one_day_reference_period_is_kept) :-
    status_of(average_one_day_reference_period_kept, average_night_hours_kept).
test(the_category_is_named_before_a_derogation_behind_it) :-
    status_of(average_category_named_before_derogation, indeterminate([worker_category])).
test(the_derogation_is_named_once_the_category_is_stated) :-
    status_of(average_derogation_named_once_category_stated, indeterminate([derogation_from_article_8])).
test(an_unsure_standby_key_goes_to_a_lawyer) :-
    status_of(hazardous_unsure_standby_referred, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), _)).
test(an_unsure_night_worker_goes_to_a_lawyer) :-
    status_of(average_unsure_night_worker_referred, needs_legal_review(open_textured(night_worker, cite(eu_dir_2003_88_art_2_4)), _)).
test(a_float_worker_is_an_input_problem) :-
    status_of(hazardous_float_worker_problem, input_problems([wrong_type(worker)])).
test(an_unknown_key_is_an_input_problem) :-
    status_of(average_unknown_key_problem, input_problems([unknown_key(colour)])).
test(a_period_end_before_its_start_is_an_input_problem) :-
    status_of(average_period_end_before_start_problem, input_problems([wrong_type(period_end)])).

test(average_one_minute_over_is_not_kept, fail) :-
    status_of(average_one_minute_over_exceeded, average_night_hours_kept).
test(average_at_the_limit_is_not_exceeded, fail) :-
    status_of(average_at_the_limit_kept, average_night_hours_exceeded).
test(a_cut_last_block_at_the_limit_is_not_exceeded, fail) :-
    status_of(average_cut_last_block_at_the_limit_kept, average_night_hours_exceeded).
test(the_same_hours_worked_are_not_kept, fail) :-
    status_of(average_same_hours_worked_exceeded, average_night_hours_kept).
test(on_site_time_not_counted_does_not_exceed, fail) :-
    status_of(average_on_site_not_counted_kept, average_night_hours_exceeded).
test(a_mobile_worker_at_the_limit_is_not_reported_outside_article_8, fail) :-
    status_of(average_mobile_worker_at_the_limit_kept, night_work_limits_not_applied_to_worker).
test(an_other_worker_over_the_average_is_not_outside_article_8, fail) :-
    status_of(average_one_minute_over_exceeded, night_work_limits_not_applied_to_worker).
test(a_hazardous_other_worker_is_not_outside_article_8, fail) :-
    status_of(hazardous_one_minute_over_exceeded, night_work_limits_not_applied_to_worker).
test(a_night_worker_is_not_reported_as_not_a_night_worker, fail) :-
    status_of(average_one_minute_over_exceeded, not_a_night_worker).
test(a_hazardous_night_worker_is_not_reported_as_not_a_night_worker, fail) :-
    status_of(hazardous_one_minute_over_exceeded, not_a_night_worker).
test(no_derogation_does_not_report_a_derogation, fail) :-
    status_of(average_one_minute_over_exceeded, night_work_derogation_applies).
test(a_hazardous_case_without_derogation_does_not_report_one, fail) :-
    status_of(hazardous_one_minute_over_exceeded, night_work_derogation_applies).
test(one_minute_over_is_not_kept, fail) :-
    status_of(hazardous_one_minute_over_exceeded, hazardous_night_work_hours_kept).
test(eight_hours_are_not_exceeded, fail) :-
    status_of(hazardous_eight_hours_kept, hazardous_night_work_hours_exceeded).
test(work_with_special_hazards_is_not_reported_without_them, fail) :-
    status_of(hazardous_one_minute_over_exceeded, no_special_hazards_or_heavy_strain).
test(a_day_shift_ending_at_night_start_is_not_exceeded, fail) :-
    status_of(hazardous_day_shift_ending_at_night_start_kept, hazardous_night_work_hours_exceeded).
test(a_shift_one_minute_before_night_end_is_not_kept, fail) :-
    status_of(hazardous_shift_one_minute_before_night_end_exceeded, hazardous_night_work_hours_kept).
test(a_window_past_the_period_at_the_limit_is_not_exceeded, fail) :-
    status_of(hazardous_window_past_period_at_the_limit_kept, hazardous_night_work_hours_exceeded).
test(touching_rows_at_the_limit_are_not_exceeded, fail) :-
    status_of(hazardous_touching_rows_at_the_limit_kept, hazardous_night_work_hours_exceeded).
test(standby_not_counted_does_not_exceed, fail) :-
    status_of(hazardous_standby_not_counted_kept, hazardous_night_work_hours_exceeded).
test(a_stated_night_time_is_not_asked_for, fail) :-
    status_of(hazardous_stated_night_time_kept, indeterminate(_)).
test(a_stated_reference_period_is_not_asked_for, fail) :-
    status_of(average_one_day_reference_period_kept, indeterminate(_)).
test(the_derogation_is_not_named_while_the_category_is_absent, fail) :-
    status_of(average_category_named_before_derogation, indeterminate([derogation_from_article_8])).
test(a_false_standby_key_does_not_go_to_a_lawyer, fail) :-
    status_of(hazardous_standby_not_counted_kept, needs_legal_review(_, _)).
test(a_true_night_worker_does_not_go_to_a_lawyer, fail) :-
    status_of(average_one_minute_over_exceeded, needs_legal_review(_, _)).
test(an_atom_worker_is_not_an_input_problem, fail) :-
    status_of(hazardous_one_minute_over_exceeded, input_problems(_)).

cp_test_names([the_status_table_has_a_near_miss_atom, average_at_the_limit_is_kept, average_one_minute_over_is_exceeded, a_cut_last_block_one_minute_over_is_exceeded, a_cut_last_block_at_the_limit_is_kept, leave_is_not_working_time, the_same_hours_worked_are_exceeded, on_site_time_counted_exceeds, on_site_time_not_counted_is_kept, a_mobile_worker_over_the_average_is_outside_article_8, a_mobile_worker_at_the_limit_is_kept, a_fishing_vessel_worker_is_outside_article_8, a_hazardous_mobile_worker_is_outside_article_8, a_hazardous_fishing_vessel_worker_is_outside_article_8, a_worker_who_is_not_a_night_worker_is_outside_article_8_a, a_worker_who_is_not_a_night_worker_is_outside_article_8_b, a_derogation_under_article_17_1_applies, a_derogation_under_article_17_3_applies, a_derogation_under_article_18_applies, a_hazardous_derogation_under_article_18_applies, eight_hours_of_night_work_are_kept, one_minute_over_is_exceeded, work_without_special_hazards_is_outside_article_8_b, a_day_shift_ending_at_night_start_is_kept, one_night_minute_brings_the_window_under_the_limit, a_shift_from_night_end_is_kept, a_shift_one_minute_before_night_end_is_exceeded, a_window_past_the_period_is_read, a_window_past_the_period_at_the_limit_is_kept, touching_rows_are_one_run, touching_rows_at_the_limit_are_kept, standby_counted_exceeds, standby_not_counted_is_kept, an_absent_night_time_that_decides_is_asked_for, a_stated_night_time_is_kept, an_absent_reference_period_that_decides_is_asked_for, a_one_day_reference_period_is_kept, the_category_is_named_before_a_derogation_behind_it, the_derogation_is_named_once_the_category_is_stated, an_unsure_standby_key_goes_to_a_lawyer, an_unsure_night_worker_goes_to_a_lawyer, a_float_worker_is_an_input_problem, an_unknown_key_is_an_input_problem, a_period_end_before_its_start_is_an_input_problem]).
cp_test_fail_names([average_one_minute_over_is_not_kept, average_at_the_limit_is_not_exceeded, a_cut_last_block_at_the_limit_is_not_exceeded, the_same_hours_worked_are_not_kept, on_site_time_not_counted_does_not_exceed, a_mobile_worker_at_the_limit_is_not_reported_outside_article_8, an_other_worker_over_the_average_is_not_outside_article_8, a_hazardous_other_worker_is_not_outside_article_8, a_night_worker_is_not_reported_as_not_a_night_worker, a_hazardous_night_worker_is_not_reported_as_not_a_night_worker, no_derogation_does_not_report_a_derogation, a_hazardous_case_without_derogation_does_not_report_one, one_minute_over_is_not_kept, eight_hours_are_not_exceeded, work_with_special_hazards_is_not_reported_without_them, a_day_shift_ending_at_night_start_is_not_exceeded, a_shift_one_minute_before_night_end_is_not_kept, a_window_past_the_period_at_the_limit_is_not_exceeded, touching_rows_at_the_limit_are_not_exceeded, standby_not_counted_does_not_exceed, a_stated_night_time_is_not_asked_for, a_stated_reference_period_is_not_asked_for, the_derogation_is_not_named_while_the_category_is_absent, a_false_standby_key_does_not_go_to_a_lawyer, a_true_night_worker_does_not_go_to_a_lawyer, an_atom_worker_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
