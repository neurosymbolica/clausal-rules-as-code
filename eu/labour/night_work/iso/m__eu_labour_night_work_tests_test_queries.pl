% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_night_work_queries, [night_work_profile_keys/1, night_work_what_if/4, night_work_block_limit_minutes/2, night_work_span_working_minutes/6, unsure/0, work/0, mobile_worker/0, derogation_under_article_18/0, special_hazards_or_heavy_strain/0]).
:- use_module(m__eu_labour_night_work_night_work, [night_work_status/2]).
:- use_module(m__eu_labour_night_work_fixtures, [night_work_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    night_work_profile_keys(ProfileKeys),
    ProfileKeys == [on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, night_time_start, night_time_end, night_work_reference_period_days, worker_category, night_worker, special_hazards_or_heavy_strain, derogation_from_article_8].
test(the_root_export_atoms_are_reachable) :-
    unsure,
    work,
    mobile_worker,
    derogation_under_article_18,
    special_hazards_or_heavy_strain.
test(the_status_query_answers_a_fixture) :-
    night_work_profile_for(hazardous_eight_hours_kept, Case),
    night_work_status(Case, hazardous_night_work_hours_kept).
test(what_if_a_mobile_worker_over_the_average) :-
    night_work_profile_for(average_one_minute_over_exceeded, Case),
    night_work_what_if(Case, worker_category, mobile_worker, night_work_limits_not_applied_to_worker).
test(what_if_a_one_day_reference_period_keeps_the_average) :-
    night_work_profile_for(average_one_minute_over_exceeded, Case),
    night_work_what_if(Case, night_work_reference_period_days, 1, average_night_hours_kept).
test(what_if_an_unsure_night_worker_goes_to_a_lawyer) :-
    night_work_profile_for(average_one_minute_over_exceeded, Case),
    night_work_what_if(Case, night_worker, unsure, needs_legal_review(open_textured(night_worker, cite(eu_dir_2003_88_art_2_4)), _)).
test(what_if_a_night_time_breaking_the_rule_is_an_input_problem) :-
    night_work_profile_for(hazardous_one_minute_over_exceeded, Case),
    night_work_what_if(Case, night_time_start, 0, input_problems([wrong_type(night_time_end)])).
test(what_if_a_derogation_under_article_18) :-
    night_work_profile_for(hazardous_one_minute_over_exceeded, Case),
    night_work_what_if(Case, derogation_from_article_8, derogation_under_article_18, night_work_derogation_applies).
test(what_if_yields_exactly_one_status) :-
    night_work_profile_for(hazardous_one_minute_over_exceeded, Case),
    findall(Status, night_work_what_if(Case, special_hazards_or_heavy_strain, false, Status), Statuses),
    Statuses == [no_special_hazards_or_heavy_strain].
test(the_block_limits_follow_the_weekly_rest_divisor) :-
    findall(Days - Limit, (member(Days, [1, 6, 7, 8, 13, 14, 15]), night_work_block_limit_minutes(Days, Limit)), Limits),
    Limits == [1 - 480, 6 - 2880, 7 - 2880, 8 - 3360, 13 - 5760, 14 - 5760, 15 - 6240].
test(the_week_at_the_limit_holds_exactly_the_block_limit) :-
    night_work_block_limit_minutes(7, Limit),
    night_work_profile_for(average_at_the_limit_kept, average_case(_, Worker, Shifts, _, _)),
    night_work_span_working_minutes(Worker, Shifts, [work], date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 9, 0, 0), Minutes),
    Minutes =:= Limit.
test(the_week_one_minute_over_holds_one_minute_more) :-
    night_work_block_limit_minutes(7, Limit),
    night_work_profile_for(average_one_minute_over_exceeded, average_case(_, Worker, Shifts, _, _)),
    night_work_span_working_minutes(Worker, Shifts, [work], date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 9, 0, 0), Minutes),
    Minutes =:= Limit + 1.
test(standby_minutes_count_only_when_their_kind_is_counted) :-
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work), shift(worker_1, date_time(2026, 3, 3, 2, 0), date_time(2026, 3, 3, 8, 0), on_call_standby)],
    night_work_span_working_minutes(worker_1, Shifts, [work], date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), WorkOnly),
    night_work_span_working_minutes(worker_1, Shifts, [work, on_call_standby], date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 0), WithStandby),
    WorkOnly =:= 240,
    WithStandby =:= 600.
test(a_span_without_rows_holds_no_minutes) :-
    night_work_span_working_minutes(worker_1, [], [work], date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 0, 0), Minutes),
    Minutes =:= 0.

test(what_if_a_one_day_reference_period_is_not_exceeded, fail) :-
    night_work_profile_for(average_one_minute_over_exceeded, Case),
    night_work_what_if(Case, night_work_reference_period_days, 1, average_night_hours_exceeded).
test(a_zero_day_block_has_no_limit, fail) :-
    night_work_block_limit_minutes(0, _).

cp_test_names([profile_keys_are_the_contract_keys, the_root_export_atoms_are_reachable, the_status_query_answers_a_fixture, what_if_a_mobile_worker_over_the_average, what_if_a_one_day_reference_period_keeps_the_average, what_if_an_unsure_night_worker_goes_to_a_lawyer, what_if_a_night_time_breaking_the_rule_is_an_input_problem, what_if_a_derogation_under_article_18, what_if_yields_exactly_one_status, the_block_limits_follow_the_weekly_rest_divisor, the_week_at_the_limit_holds_exactly_the_block_limit, the_week_one_minute_over_holds_one_minute_more, standby_minutes_count_only_when_their_kind_is_counted, a_span_without_rows_holds_no_minutes]).
cp_test_fail_names([what_if_a_one_day_reference_period_is_not_exceeded, a_zero_day_block_has_no_limit]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
