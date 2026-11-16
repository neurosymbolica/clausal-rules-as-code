% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_daily_rest_daily_rest, [decide_daily_rest/6, daily_rest_status/7, shortest_daily_rest_minutes/6, first_window_without_daily_rest/6, daily_rest_checklist/6]).
:- use_module(m__eu_labour_daily_rest_kernel, [daily_rest_input_problems/2]).
:- use_module(m__eu_labour_daily_rest_fixtures, [daily_rest_profile_for/2]).

status_answers(Subject, Answers) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Result - Citations, daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations), Answers).

shortest_answers(Subject, Answers) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Minutes, shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes), Answers).

first_window_answers(Subject, Answers) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Start, first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Start), Answers).

test(the_short_rest_case_yields_exactly_one_status) :-
    daily_rest_profile_for(short_rest_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Status, daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Status, _), Statuses),
    Statuses == [daily_rest_not_given].
test(the_verdict_carries_a_citation) :-
    daily_rest_profile_for(day_shift_worker, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    decide_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, daily_rest_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(the_given_status_is_read_out_with_its_citations) :-
    status_answers(day_shift_worker, Answers),
    Answers == [daily_rest_given - [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)]].
test(the_shortest_rest_is_read_out_as_a_bare_integer) :-
    shortest_answers(short_rest_worker, Answers),
    Answers == [480].
test(the_day_shift_shortest_rest_is_sixteen_hours) :-
    shortest_answers(day_shift_worker, Answers),
    Answers == [960].
test(the_first_short_window_is_read_out) :-
    first_window_answers(short_rest_worker, Answers),
    Answers == [date_time(2026, 3, 2, 8, 0)].
test(a_period_start_that_cuts_a_shift_opens_a_window_at_midnight) :-
    first_window_answers(period_cut_short_worker, Starts),
    Starts == [date_time(2026, 3, 2, 0, 0)],
    shortest_answers(period_cut_short_worker, Minutes),
    Minutes == [600].
test(leave_replaced_by_work_shortens_the_rest) :-
    shortest_answers(leave_replaced_by_work_worker, Answers),
    Answers == [480].
test(a_worker_without_work_has_no_window) :-
    shortest_answers(no_work_worker, Minutes),
    Minutes == [no_work_start_in_period],
    first_window_answers(no_work_worker, Starts),
    Starts == [no_window_without_daily_rest].
test(the_review_context_lists_both_present_judgement_pairs) :-
    status_answers(on_call_standby_unsure, Answers),
    Answers == [needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - false, on_call_standby_counts_as_working_time - unsure])]) - []].
test(the_review_is_the_answer_of_the_measuring_queries_too) :-
    shortest_answers(on_call_on_site_unsure, Answers),
    Answers == [needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])])].
test(input_problems_are_read_out_with_no_citation) :-
    status_answers(malformed_profile_worker, Answers),
    Answers == [input_problems([wrong_type(worker_category), duplicate_key(derogation_from_article_3), unknown_key(colour)]) - []].
test(the_input_check_reads_out_a_bare_list) :-
    findall(Problems, daily_rest_input_problems([attribute(worker_category, pilot), attribute(colour, red)], Problems), Answers),
    Answers == [[wrong_type(worker_category), unknown_key(colour)]].
test(the_checklist_is_read_out_for_a_mobile_worker) :-
    daily_rest_profile_for(mobile_worker_short_rest, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Items, daily_rest_checklist(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Items), Answers),
    Answers == [[item(daily_rest_in_every_window, unmet(daily_rest_short), cite(eu_dir_2003_88_art_3)), item(article_3_applies_to_worker, unmet(mobile_worker), cite(eu_dir_2003_88_art_20_1)), item(no_derogation_from_article_3, unknown([derogation_from_article_3]), cite(eu_dir_2003_88_art_3))]].

cp_test_names([the_short_rest_case_yields_exactly_one_status, the_verdict_carries_a_citation, the_given_status_is_read_out_with_its_citations, the_shortest_rest_is_read_out_as_a_bare_integer, the_day_shift_shortest_rest_is_sixteen_hours, the_first_short_window_is_read_out, a_period_start_that_cuts_a_shift_opens_a_window_at_midnight, leave_replaced_by_work_shortens_the_rest, a_worker_without_work_has_no_window, the_review_context_lists_both_present_judgement_pairs, the_review_is_the_answer_of_the_measuring_queries_too, input_problems_are_read_out_with_no_citation, the_input_check_reads_out_a_bare_list, the_checklist_is_read_out_for_a_mobile_worker]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
