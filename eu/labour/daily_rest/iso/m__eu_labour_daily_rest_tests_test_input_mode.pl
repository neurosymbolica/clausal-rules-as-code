% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_daily_rest_daily_rest, [daily_rest_status/7, shortest_daily_rest_minutes/6, first_window_without_daily_rest/6]).
:- use_module(m__eu_labour_daily_rest_kernel, [daily_rest_input_problems/2]).
:- use_module(m__eu_labour_daily_rest_fixtures, [daily_rest_profile_for/2]).

day_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 3, 8, 0), date_time(2026, 3, 3, 16, 0), work)]).

overlapping_shifts([shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w1, date_time(2026, 3, 2, 15, 0), date_time(2026, 3, 2, 20, 0), work)]).

another_worker_overlapping_shifts([shift(w2, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work), shift(w2, date_time(2026, 3, 2, 15, 0), date_time(2026, 3, 2, 20, 0), work)]).

test(status_holds_with_the_verdict_bound) :-
    daily_rest_profile_for(day_shift_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, daily_rest_given, _).
test(status_and_citations_hold_bound) :-
    daily_rest_profile_for(short_rest_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, daily_rest_not_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)]).
test(the_shortest_rest_holds_bound) :-
    daily_rest_profile_for(short_rest_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, 480).
test(the_first_short_window_holds_bound) :-
    daily_rest_profile_for(short_rest_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, date_time(2026, 3, 2, 8, 0)).
test(day_shifts_have_no_window_without_rest_bound) :-
    daily_rest_profile_for(day_shift_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, no_window_without_daily_rest).
test(a_non_list_profile_is_a_wrong_type) :-
    daily_rest_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(a_non_attribute_element_is_a_wrong_type) :-
    daily_rest_input_problems([attribute(worker_category, other_worker), worker_category], Problems),
    Problems == [wrong_type(profile)].
test(a_number_key_is_an_unknown_key) :-
    daily_rest_input_problems([attribute(7, other_worker)], Problems),
    Problems == [unknown_key(7)].
test(a_repeated_unknown_key_is_named_once) :-
    daily_rest_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(a_duplicate_key_is_never_also_a_wrong_type) :-
    daily_rest_input_problems([attribute(worker_category, pilot), attribute(worker_category, pilot)], Problems),
    Problems == [duplicate_key(worker_category)].
test(a_boolean_is_not_a_worker_category) :-
    daily_rest_input_problems([attribute(worker_category, true)], Problems),
    Problems == [wrong_type(worker_category)].
test(an_absent_key_is_not_a_problem) :-
    daily_rest_input_problems([], Problems),
    Problems == [].
test(profile_problems_come_before_argument_problems) :-
    findall(Result - Citations, daily_rest_status([attribute(colour, red)], 3.5, [], date(2026, 3, 2), date(2026, 3, 2), Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour), wrong_type(worker)]) - []].
test(overlapping_rows_of_the_worker_are_a_wrong_type) :-
    overlapping_shifts(Shifts),
    findall(Minutes, shortest_daily_rest_minutes([], w1, Shifts, date(2026, 3, 2), date(2026, 3, 2), Minutes), Answers),
    Answers == [input_problems([wrong_type(shifts)])].
test(overlapping_rows_of_another_worker_are_not_read) :-
    another_worker_overlapping_shifts(Shifts),
    findall(Minutes, shortest_daily_rest_minutes([], w1, Shifts, date(2026, 3, 2), date(2026, 3, 2), Minutes), Answers),
    Answers == [no_work_start_in_period].
test(a_partial_shift_list_is_a_wrong_type) :-
    findall(Start, first_window_without_daily_rest([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), work)|_], date(2026, 3, 2), date(2026, 3, 2), Start), Answers),
    Answers == [input_problems([wrong_type(shifts)])].
test(a_shift_ending_before_it_starts_is_a_wrong_type) :-
    findall(Result, daily_rest_status([], w1, [shift(w1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 2, 8, 0), work)], date(2026, 3, 2), date(2026, 3, 2), Result, _), Answers),
    Answers == [input_problems([wrong_type(shifts)])].
test(an_unknown_shift_kind_is_a_wrong_type) :-
    findall(Result, daily_rest_status([], w1, [shift(w1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 0), training)], date(2026, 3, 2), date(2026, 3, 2), Result, _), Answers),
    Answers == [input_problems([wrong_type(shifts)])].
test(a_reversed_period_is_a_wrong_period_end) :-
    day_shifts(Shifts),
    findall(Result - Citations, daily_rest_status([], w1, Shifts, date(2026, 3, 3), date(2026, 3, 2), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(period_end)]) - []].
test(an_atom_worker_and_an_integer_worker_differ) :-
    day_shifts(Shifts),
    findall(Minutes, shortest_daily_rest_minutes([], 1, Shifts, date(2026, 3, 2), date(2026, 3, 3), Minutes), Answers),
    Answers == [no_work_start_in_period].

test(the_wrong_bound_status_is_rejected, fail) :-
    daily_rest_profile_for(day_shift_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, daily_rest_not_given, _).
test(a_wrong_bound_shortest_rest_is_rejected, fail) :-
    daily_rest_profile_for(short_rest_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, 481).
test(day_shifts_have_no_date_time_start, fail) :-
    daily_rest_profile_for(day_shift_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, date_time(_, _, _, _, _)).

cp_test_names([status_holds_with_the_verdict_bound, status_and_citations_hold_bound, the_shortest_rest_holds_bound, the_first_short_window_holds_bound, day_shifts_have_no_window_without_rest_bound, a_non_list_profile_is_a_wrong_type, a_non_attribute_element_is_a_wrong_type, a_number_key_is_an_unknown_key, a_repeated_unknown_key_is_named_once, a_duplicate_key_is_never_also_a_wrong_type, a_boolean_is_not_a_worker_category, an_absent_key_is_not_a_problem, profile_problems_come_before_argument_problems, overlapping_rows_of_the_worker_are_a_wrong_type, overlapping_rows_of_another_worker_are_not_read, a_partial_shift_list_is_a_wrong_type, a_shift_ending_before_it_starts_is_a_wrong_type, an_unknown_shift_kind_is_a_wrong_type, a_reversed_period_is_a_wrong_period_end, an_atom_worker_and_an_integer_worker_differ]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, a_wrong_bound_shortest_rest_is_rejected, day_shifts_have_no_date_time_start]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
