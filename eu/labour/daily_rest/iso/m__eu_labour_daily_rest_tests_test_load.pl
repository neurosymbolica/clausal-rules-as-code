% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_daily_rest_kernel, [daily_rest_input_problems/2, daily_rest_argument_problems/6, date_time_absolute_minute/2, absolute_minute_date_time/2, period_bounds/4]).
:- use_module(m__eu_labour_daily_rest_citations, [citation/2, implements/1]).

test(the_four_status_atoms_are_distinct) :-
    dif(daily_rest_given, daily_rest_not_given),
    dif(daily_rest_given, daily_rest_not_applied_to_worker),
    dif(daily_rest_given, daily_rest_derogation_applies),
    dif(daily_rest_not_given, daily_rest_not_applied_to_worker),
    dif(daily_rest_not_given, daily_rest_derogation_applies),
    dif(daily_rest_not_applied_to_worker, daily_rest_derogation_applies).
test(the_two_none_atoms_are_distinct) :-
    dif(no_work_start_in_period, no_window_without_daily_rest).
test(the_verdict_term_carries_status_and_citations) :-
    VerdictTerm = daily_rest_verdict(daily_rest_given, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_3)]),
    VerdictTerm = daily_rest_verdict(Status, Citations),
    Status == daily_rest_given,
    length(Citations, CitationCount),
    CitationCount =:= 3.
test(an_indeterminate_answer_names_one_key) :-
    Answer = indeterminate([worker_category]),
    Answer = indeterminate([MissingKey]),
    MissingKey == worker_category.
test(a_referral_destructures) :-
    Answer = needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]),
    Answer = needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    InputKey == on_call_on_site_counts_as_working_time,
    CitationKey == eu_dir_2003_88_art_2_1,
    Pairs == [on_call_on_site_counts_as_working_time - unsure].
test(an_input_problems_answer_destructures) :-
    Answer = input_problems([wrong_type(worker)]),
    Answer = input_problems(Problems),
    Problems == [wrong_type(worker)].
test(the_article_3_citation_is_recorded) :-
    citation(eu_dir_2003_88_art_3, _Record).
test(every_citation_vocabulary_key_is_recorded) :-
    implements(eu_dir_2003_88_art_2_1),
    implements(eu_dir_2003_88_art_2_2),
    implements(eu_dir_2003_88_art_2_7),
    implements(eu_dir_2003_88_art_3),
    implements(eu_dir_2003_88_art_17_1),
    implements(eu_dir_2003_88_art_17_3),
    implements(eu_dir_2003_88_art_17_4),
    implements(eu_dir_2003_88_art_18_first_subpara),
    implements(eu_dir_2003_88_art_18_second_subpara),
    implements(eu_dir_2003_88_art_20_1),
    implements(eu_dir_2003_88_art_21_1).
test(a_minute_round_trips) :-
    date_time_absolute_minute(date_time(2026, 3, 2, 8, 0), AbsoluteMinute),
    absolute_minute_date_time(AbsoluteMinute, DateTime),
    DateTime == date_time(2026, 3, 2, 8, 0).
test(a_day_shift_lasts_its_exact_minutes) :-
    date_time_absolute_minute(date_time(2026, 3, 2, 8, 0), StartMinute),
    date_time_absolute_minute(date_time(2026, 3, 2, 16, 30), EndMinute),
    EndMinute - StartMinute =:= 510.
test(a_night_shift_crosses_midnight) :-
    date_time_absolute_minute(date_time(2026, 3, 2, 22, 0), StartMinute),
    date_time_absolute_minute(date_time(2026, 3, 3, 6, 0), EndMinute),
    EndMinute - StartMinute =:= 480.
test(a_leap_day_is_counted) :-
    date_time_absolute_minute(date_time(2028, 2, 28, 0, 0), StartMinute),
    date_time_absolute_minute(date_time(2028, 3, 1, 0, 0), EndMinute),
    EndMinute - StartMinute =:= 2880.
test(a_one_day_period_is_one_day_long) :-
    period_bounds(date(2026, 3, 2), date(2026, 3, 2), StartOfPeriodMinute, EndOfPeriodMinute),
    EndOfPeriodMinute - StartOfPeriodMinute =:= 1440.
test(an_empty_profile_has_no_problem) :-
    daily_rest_input_problems([], []).
test(an_atom_is_not_an_attribute_list) :-
    daily_rest_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(well_formed_arguments_have_no_problem) :-
    daily_rest_argument_problems([attribute(worker_category, other_worker)], worker_1, [shift(worker_1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work)], date(2026, 3, 2), date(2026, 3, 8), Problems),
    Problems == [].
test(overlapping_rows_are_a_wrong_type) :-
    daily_rest_argument_problems([], worker_1, [shift(worker_1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work), shift(worker_1, date_time(2026, 3, 2, 16, 0), date_time(2026, 3, 2, 20, 0), work)], date(2026, 3, 2), date(2026, 3, 8), Problems),
    Problems == [wrong_type(shifts)].
test(touching_rows_do_not_overlap) :-
    daily_rest_argument_problems([], worker_1, [shift(worker_1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 16, 30), work), shift(worker_1, date_time(2026, 3, 2, 16, 30), date_time(2026, 3, 2, 20, 0), on_call_on_site)], date(2026, 3, 2), date(2026, 3, 8), Problems),
    Problems == [].
test(a_period_ending_before_it_starts_is_a_wrong_type) :-
    daily_rest_argument_problems([], worker_1, [], date(2026, 3, 8), date(2026, 3, 2), Problems),
    Problems == [wrong_type(period_end)].

test(the_given_atom_is_not_the_not_given_atom, fail) :-
    daily_rest_given == daily_rest_not_given.
test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(art_3, _Record).
test(an_atom_profile_has_problems, fail) :-
    daily_rest_input_problems(profile, []).

cp_test_names([the_four_status_atoms_are_distinct, the_two_none_atoms_are_distinct, the_verdict_term_carries_status_and_citations, an_indeterminate_answer_names_one_key, a_referral_destructures, an_input_problems_answer_destructures, the_article_3_citation_is_recorded, every_citation_vocabulary_key_is_recorded, a_minute_round_trips, a_day_shift_lasts_its_exact_minutes, a_night_shift_crosses_midnight, a_leap_day_is_counted, a_one_day_period_is_one_day_long, an_empty_profile_has_no_problem, an_atom_is_not_an_attribute_list, well_formed_arguments_have_no_problem, overlapping_rows_are_a_wrong_type, touching_rows_do_not_overlap, a_period_ending_before_it_starts_is_a_wrong_type]).
cp_test_fail_names([the_given_atom_is_not_the_not_given_atom, a_shortened_citation_key_is_not_recorded, an_atom_profile_has_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
