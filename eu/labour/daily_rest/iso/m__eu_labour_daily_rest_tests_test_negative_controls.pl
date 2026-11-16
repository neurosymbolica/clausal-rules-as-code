% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_daily_rest_daily_rest, [daily_rest_status/7, shortest_daily_rest_minutes/6, first_window_without_daily_rest/6, daily_rest_status_values/1]).
:- use_module(m__eu_labour_daily_rest_fixtures, [daily_rest_profile_for/2]).

status_of(Subject, Result, Citations) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

shortest_of(Subject, Minutes) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes).

first_window_of(Subject, Start) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Start).

test(every_near_miss_atom_is_a_status_value) :-
    daily_rest_status_values(Values),
    Values == [daily_rest_given, daily_rest_not_given, daily_rest_not_applied_to_worker, daily_rest_derogation_applies].
test(day_shifts_give_the_daily_rest) :-
    status_of(day_shift_worker, daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)]).
test(a_short_rest_is_not_given) :-
    status_of(short_rest_worker, daily_rest_not_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)]).
test(exactly_eleven_hours_is_enough) :-
    status_of(eleven_hour_rest_worker, daily_rest_given, _),
    shortest_of(eleven_hour_rest_worker, 660),
    first_window_of(eleven_hour_rest_worker, no_window_without_daily_rest).
test(one_minute_less_is_short) :-
    status_of(one_minute_short_rest_worker, daily_rest_not_given, _),
    shortest_of(one_minute_short_rest_worker, 659),
    first_window_of(one_minute_short_rest_worker, date_time(2026, 3, 2, 8, 0)).
test(a_mobile_worker_with_a_short_rest_is_not_applied) :-
    status_of(mobile_worker_short_rest, daily_rest_not_applied_to_worker, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]).
test(a_mobile_worker_on_day_shifts_is_given_the_rest) :-
    status_of(mobile_worker_day_shifts, daily_rest_given, _).
test(a_fishing_vessel_worker_with_a_short_rest_is_not_applied) :-
    status_of(fishing_vessel_worker_short_rest, daily_rest_not_applied_to_worker, [cite(eu_dir_2003_88_art_21_1)]).
test(a_fishing_vessel_worker_on_day_shifts_is_given_the_rest) :-
    status_of(fishing_vessel_worker_day_shifts, daily_rest_given, _).
test(a_derogation_under_article_17_1_applies) :-
    status_of(derogation_article_17_1_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_1)]).
test(a_derogation_under_article_17_3_applies) :-
    status_of(derogation_article_17_3_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_3)]).
test(a_derogation_under_article_17_4_applies) :-
    status_of(derogation_article_17_4_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_17_4)]).
test(a_derogation_under_article_18_applies) :-
    status_of(derogation_article_18_short_rest, daily_rest_derogation_applies, [cite(eu_dir_2003_88_art_3), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]).
test(a_derogation_on_day_shifts_is_given_the_rest) :-
    status_of(derogation_article_17_4_day_shifts, daily_rest_given, _).
test(a_short_rest_with_no_category_asks_for_it) :-
    status_of(missing_category_short_rest, indeterminate([worker_category]), []).
test(day_shifts_with_no_category_are_given_the_rest) :-
    status_of(missing_category_day_shifts, daily_rest_given, _).
test(a_short_rest_with_no_derogation_answer_asks_for_it) :-
    status_of(missing_derogation_short_rest, indeterminate([derogation_from_article_3]), []).
test(an_absent_on_site_judgement_that_matters_is_asked_for) :-
    status_of(on_call_on_site_absent, indeterminate([on_call_on_site_counts_as_working_time]), []).
test(on_site_time_counted_leaves_the_rest_short) :-
    status_of(on_call_on_site_counted, daily_rest_not_given, _),
    shortest_of(on_call_on_site_counted, 600).
test(on_site_time_not_counted_gives_the_rest) :-
    status_of(on_call_on_site_not_counted, daily_rest_given, _),
    shortest_of(on_call_on_site_not_counted, 960).
test(an_unsure_on_site_judgement_goes_to_a_lawyer) :-
    status_of(on_call_on_site_unsure, needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]), []).
test(an_unsure_on_site_judgement_with_no_category_asks_for_it) :-
    status_of(on_call_on_site_unsure_missing_category, indeterminate([worker_category]), []).
test(an_unsure_standby_judgement_goes_to_a_lawyer) :-
    status_of(on_call_standby_unsure, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - false, on_call_standby_counts_as_working_time - unsure])]), []).
test(the_measuring_query_names_the_standby_key) :-
    shortest_of(standby_behind_worker, indeterminate([on_call_standby_counts_as_working_time])).
test(the_status_is_settled_when_every_completion_holds_the_rest) :-
    status_of(standby_behind_worker, daily_rest_given, _).
test(the_status_names_the_on_site_key_when_each_is_behind_the_other) :-
    status_of(standby_behind_short_worker, indeterminate([on_call_on_site_counts_as_working_time]), []),
    shortest_of(standby_behind_short_worker, indeterminate([on_call_standby_counts_as_working_time])).
test(no_work_start_has_no_window) :-
    shortest_of(no_work_worker, no_work_start_in_period),
    status_of(no_work_worker, daily_rest_given, _).
test(a_single_shift_has_a_window) :-
    shortest_of(single_shift_worker, 930).
test(a_night_shift_across_the_period_start_leaves_the_rest) :-
    first_window_of(period_cut_worker, no_window_without_daily_rest),
    shortest_of(period_cut_worker, 1080).
test(an_evening_shift_after_it_makes_the_midnight_window_short) :-
    first_window_of(period_cut_short_worker, date_time(2026, 3, 2, 0, 0)),
    status_of(period_cut_short_worker, daily_rest_not_given, _).
test(leave_counts_as_rest) :-
    status_of(leave_as_rest_worker, daily_rest_given, _).
test(leave_replaced_by_work_is_short) :-
    status_of(leave_replaced_by_work_worker, daily_rest_not_given, _).
test(a_malformed_profile_is_answered_with_its_problems) :-
    status_of(malformed_profile_worker, input_problems([wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)]), []).
test(a_reversed_period_is_answered_with_its_problem) :-
    status_of(reversed_period_worker, input_problems([wrong_type(period_end)]), []),
    shortest_of(reversed_period_worker, input_problems([wrong_type(period_end)])),
    first_window_of(reversed_period_worker, input_problems([wrong_type(period_end)])).

test(day_shifts_are_not_short, fail) :-
    status_of(day_shift_worker, daily_rest_not_given, _).
test(a_short_rest_is_not_given_rest, fail) :-
    status_of(short_rest_worker, daily_rest_given, _).
test(exactly_eleven_hours_is_not_short, fail) :-
    status_of(eleven_hour_rest_worker, daily_rest_not_given, _).
test(one_minute_less_is_not_given_rest, fail) :-
    status_of(one_minute_short_rest_worker, daily_rest_given, _).
test(a_mobile_worker_with_a_short_rest_is_not_not_given, fail) :-
    status_of(mobile_worker_short_rest, daily_rest_not_given, _).
test(a_mobile_worker_on_day_shifts_is_not_reported_as_not_applied, fail) :-
    status_of(mobile_worker_day_shifts, daily_rest_not_applied_to_worker, _).
test(a_fishing_vessel_worker_does_not_cite_article_20, fail) :-
    status_of(fishing_vessel_worker_short_rest, daily_rest_not_applied_to_worker, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]).
test(a_fishing_vessel_worker_on_day_shifts_is_not_reported_as_not_applied, fail) :-
    status_of(fishing_vessel_worker_day_shifts, daily_rest_not_applied_to_worker, _).
test(a_derogation_with_a_short_rest_is_not_not_given, fail) :-
    status_of(derogation_article_17_4_short_rest, daily_rest_not_given, _).
test(a_derogation_on_day_shifts_is_not_reported, fail) :-
    status_of(derogation_article_17_4_day_shifts, daily_rest_derogation_applies, _).
test(a_short_rest_with_no_category_does_not_ask_for_the_derogation, fail) :-
    status_of(missing_category_short_rest, indeterminate([derogation_from_article_3]), _).
test(day_shifts_with_no_category_do_not_ask_for_it, fail) :-
    status_of(missing_category_day_shifts, indeterminate(_), _).
test(a_short_rest_with_no_derogation_answer_is_not_not_given, fail) :-
    status_of(missing_derogation_short_rest, daily_rest_not_given, _).
test(an_absent_on_site_judgement_is_not_given_rest, fail) :-
    status_of(on_call_on_site_absent, daily_rest_given, _).
test(on_site_time_not_counted_is_not_short, fail) :-
    status_of(on_call_on_site_not_counted, daily_rest_not_given, _).
test(an_unsure_on_site_judgement_with_no_category_is_not_referred, fail) :-
    status_of(on_call_on_site_unsure_missing_category, needs_legal_review(_, _), _).
test(an_unsure_standby_judgement_does_not_name_the_on_site_key, fail) :-
    status_of(on_call_standby_unsure, needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, _), _), _).
test(the_measuring_query_does_not_name_the_on_site_key, fail) :-
    shortest_of(standby_behind_worker, indeterminate([on_call_on_site_counts_as_working_time])).
test(the_status_does_not_name_the_standby_key_then, fail) :-
    status_of(standby_behind_short_worker, indeterminate([on_call_standby_counts_as_working_time]), _).
test(a_single_shift_is_not_without_a_work_start, fail) :-
    shortest_of(single_shift_worker, no_work_start_in_period).
test(the_midnight_window_is_not_without_a_short_rest, fail) :-
    first_window_of(period_cut_short_worker, no_window_without_daily_rest).
test(leave_is_not_working_time, fail) :-
    status_of(leave_as_rest_worker, daily_rest_not_given, _).
test(a_malformed_profile_gets_no_status, fail) :-
    status_of(malformed_profile_worker, daily_rest_given, _).
test(a_reversed_period_gets_no_status, fail) :-
    status_of(reversed_period_worker, daily_rest_given, _).

cp_test_names([every_near_miss_atom_is_a_status_value, day_shifts_give_the_daily_rest, a_short_rest_is_not_given, exactly_eleven_hours_is_enough, one_minute_less_is_short, a_mobile_worker_with_a_short_rest_is_not_applied, a_mobile_worker_on_day_shifts_is_given_the_rest, a_fishing_vessel_worker_with_a_short_rest_is_not_applied, a_fishing_vessel_worker_on_day_shifts_is_given_the_rest, a_derogation_under_article_17_1_applies, a_derogation_under_article_17_3_applies, a_derogation_under_article_17_4_applies, a_derogation_under_article_18_applies, a_derogation_on_day_shifts_is_given_the_rest, a_short_rest_with_no_category_asks_for_it, day_shifts_with_no_category_are_given_the_rest, a_short_rest_with_no_derogation_answer_asks_for_it, an_absent_on_site_judgement_that_matters_is_asked_for, on_site_time_counted_leaves_the_rest_short, on_site_time_not_counted_gives_the_rest, an_unsure_on_site_judgement_goes_to_a_lawyer, an_unsure_on_site_judgement_with_no_category_asks_for_it, an_unsure_standby_judgement_goes_to_a_lawyer, the_measuring_query_names_the_standby_key, the_status_is_settled_when_every_completion_holds_the_rest, the_status_names_the_on_site_key_when_each_is_behind_the_other, no_work_start_has_no_window, a_single_shift_has_a_window, a_night_shift_across_the_period_start_leaves_the_rest, an_evening_shift_after_it_makes_the_midnight_window_short, leave_counts_as_rest, leave_replaced_by_work_is_short, a_malformed_profile_is_answered_with_its_problems, a_reversed_period_is_answered_with_its_problem]).
cp_test_fail_names([day_shifts_are_not_short, a_short_rest_is_not_given_rest, exactly_eleven_hours_is_not_short, one_minute_less_is_not_given_rest, a_mobile_worker_with_a_short_rest_is_not_not_given, a_mobile_worker_on_day_shifts_is_not_reported_as_not_applied, a_fishing_vessel_worker_does_not_cite_article_20, a_fishing_vessel_worker_on_day_shifts_is_not_reported_as_not_applied, a_derogation_with_a_short_rest_is_not_not_given, a_derogation_on_day_shifts_is_not_reported, a_short_rest_with_no_category_does_not_ask_for_the_derogation, day_shifts_with_no_category_do_not_ask_for_it, a_short_rest_with_no_derogation_answer_is_not_not_given, an_absent_on_site_judgement_is_not_given_rest, on_site_time_not_counted_is_not_short, an_unsure_on_site_judgement_with_no_category_is_not_referred, an_unsure_standby_judgement_does_not_name_the_on_site_key, the_measuring_query_does_not_name_the_on_site_key, the_status_does_not_name_the_standby_key_then, a_single_shift_is_not_without_a_work_start, the_midnight_window_is_not_without_a_short_rest, leave_is_not_working_time, a_malformed_profile_gets_no_status, a_reversed_period_gets_no_status]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
