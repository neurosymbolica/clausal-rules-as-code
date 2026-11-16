% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_daily_rest_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_labour_daily_rest_daily_rest, [decide_daily_rest/6, daily_rest_status/7, shortest_daily_rest_minutes/6, first_window_without_daily_rest/6, daily_rest_status_values/1, daily_rest_threshold/1]).
:- use_module(m__eu_labour_daily_rest_fixtures, [daily_rest_subject/1, daily_rest_profile_for/2]).

subject_set(SubjectSet) :-
    findall(Subject, daily_rest_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    daily_rest_subject(Subject),
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    decide_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, _Verdict).

status_answers(Subject, Answers) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Result - Citations, daily_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations), Answers).

shortest_answers(Subject, Answers) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Minutes, shortest_daily_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes), Answers).

first_window_answers(Subject, Answers) :-
    daily_rest_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Start, first_window_without_daily_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Start), Answers).

not_final(indeterminate(_)).
not_final(needs_legal_review(_, _)).
not_final(input_problems(_)).

final_measure(no_work_start_in_period).
final_measure(Minutes) :-
    integer(Minutes).

allowed_citation(cite(eu_dir_2003_88_art_2_1)).
allowed_citation(cite(eu_dir_2003_88_art_2_2)).
allowed_citation(cite(eu_dir_2003_88_art_2_7)).
allowed_citation(cite(eu_dir_2003_88_art_3)).
allowed_citation(cite(eu_dir_2003_88_art_17_1)).
allowed_citation(cite(eu_dir_2003_88_art_17_3)).
allowed_citation(cite(eu_dir_2003_88_art_17_4)).
allowed_citation(cite(eu_dir_2003_88_art_18_first_subpara)).
allowed_citation(cite(eu_dir_2003_88_art_18_second_subpara)).
allowed_citation(cite(eu_dir_2003_88_art_20_1)).
allowed_citation(cite(eu_dir_2003_88_art_21_1)).

citations_allowed([]).
citations_allowed([Citation|Citations]) :-
    allowed_citation(Citation),
    citations_allowed(Citations).

citations_set_like(Citations) :-
    sort(Citations, Distinct),
    length(Citations, Count),
    length(Distinct, Count).

citations_fit(Result, [Citation|Citations]) :-
    daily_rest_status_values(Values),
    member(Result, Values),
    citations_allowed([Citation|Citations]),
    citations_set_like([Citation|Citations]).
citations_fit(indeterminate([_]), []).
citations_fit(needs_legal_review(open_textured(_, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on(_)]), []).
citations_fit(input_problems([_|_]), []).

shortest_in_range(Minutes) :-
    integer(Minutes),
    Minutes #>= 0,
    Minutes #< 1440.
shortest_in_range(no_work_start_in_period).
shortest_in_range(Status) :-
    not_final(Status).

measure_pair_consistent(no_work_start_in_period, no_window_without_daily_rest).
measure_pair_consistent(Minutes, date_time(_, _, _, _, _)) :-
    integer(Minutes),
    daily_rest_threshold(threshold(_, MinimumMinutes, _)),
    Minutes #< MinimumMinutes.
measure_pair_consistent(Minutes, no_window_without_daily_rest) :-
    integer(Minutes),
    daily_rest_threshold(threshold(_, MinimumMinutes, _)),
    Minutes #>= MinimumMinutes.
measure_pair_consistent(Shortest, _) :-
    not_final(Shortest).
measure_pair_consistent(Shortest, First) :-
    final_measure(Shortest),
    not_final(First).

subject_is_deterministic(Subject) :-
    daily_rest_subject(Subject),
    status_answers(Subject, [_]),
    shortest_answers(Subject, [_]),
    first_window_answers(Subject, [_]).

subject_citations_fit(Subject) :-
    daily_rest_subject(Subject),
    status_answers(Subject, [Result - Citations]),
    citations_fit(Result, Citations).

subject_shortest_in_range(Subject) :-
    daily_rest_subject(Subject),
    shortest_answers(Subject, [Minutes]),
    shortest_in_range(Minutes).

subject_measures_consistent(Subject) :-
    daily_rest_subject(Subject),
    shortest_answers(Subject, [Shortest]),
    first_window_answers(Subject, [First]),
    measure_pair_consistent(Shortest, First).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_answer_per_query) :-
    subject_set(SubjectSet),
    findall(Subject, subject_is_deterministic(Subject), DeterministicSubjects),
    sort(DeterministicSubjects, SubjectSet).
test(every_status_carries_fitting_citations) :-
    subject_set(SubjectSet),
    findall(Subject, subject_citations_fit(Subject), FittingSubjects),
    sort(FittingSubjects, SubjectSet).
test(every_shortest_rest_is_in_range) :-
    subject_set(SubjectSet),
    findall(Subject, subject_shortest_in_range(Subject), InRangeSubjects),
    sort(InRangeSubjects, SubjectSet).
test(the_two_measures_agree_on_every_subject) :-
    subject_set(SubjectSet),
    findall(Subject, subject_measures_consistent(Subject), ConsistentSubjects),
    sort(ConsistentSubjects, SubjectSet).
test(a_given_status_has_no_short_window_on_day_shifts) :-
    status_answers(day_shift_worker, [daily_rest_given - _]),
    first_window_answers(day_shift_worker, [no_window_without_daily_rest]).

test(a_given_status_never_has_a_short_window, fail) :-
    daily_rest_subject(Subject),
    status_answers(Subject, [daily_rest_given - _]),
    first_window_answers(Subject, [date_time(_, _, _, _, _)]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_answer_per_query, every_status_carries_fitting_citations, every_shortest_rest_is_in_range, the_two_measures_agree_on_every_subject, a_given_status_has_no_short_window_on_day_shifts]).
cp_test_fail_names([a_given_status_never_has_a_short_window]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
