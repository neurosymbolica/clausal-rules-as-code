% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_weekly_rest_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1, min_list/2, max_list/2]).
:- use_module(m__eu_labour_weekly_rest_weekly_rest, [decide_weekly_rest/2, weekly_rest_status_values/1, shortest_weekly_rest_minutes/6, first_period_without_weekly_rest/6]).
:- use_module(m__eu_labour_weekly_rest_fixtures, [weekly_rest_subject/1, weekly_rest_profile_for/2, weekly_rest_assess/2]).

subject_classifies(Subject) :-
    weekly_rest_subject(Subject),
    weekly_rest_profile_for(Subject, WeeklyRestCase),
    decide_weekly_rest(WeeklyRestCase, _Verdict).

verdict_count(Subject, VerdictCount) :-
    weekly_rest_subject(Subject),
    findall(Verdict, weekly_rest_assess(Subject, Verdict), Verdicts),
    length(Verdicts, VerdictCount).

minutes_count(Subject, AnswerCount) :-
    weekly_rest_subject(Subject),
    weekly_rest_profile_for(Subject, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Minutes, shortest_weekly_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes), Answers),
    length(Answers, AnswerCount).

day_count(Subject, AnswerCount) :-
    weekly_rest_subject(Subject),
    weekly_rest_profile_for(Subject, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(BlockDay, first_period_without_weekly_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, BlockDay), Answers),
    length(Answers, AnswerCount).

status_shape(Status, final) :-
    weekly_rest_status_values(StatusValues),
    member(Status, StatusValues).
status_shape(indeterminate([MissingKey]), open) :-
    atom(MissingKey).
status_shape(needs_legal_review(open_textured(ReviewKey, cite(CitationKey)), [inputs_relied_on(RelyPairs)]), open) :-
    atom(ReviewKey),
    atom(CitationKey),
    is_list(RelyPairs).
status_shape(input_problems([FirstProblem|OtherProblems]), refused) :-
    is_list([FirstProblem|OtherProblems]).

citations_fit(final, [FirstCitation|OtherCitations]) :-
    sort([FirstCitation|OtherCitations], SortedCitations),
    length(SortedCitations, CitationCount),
    length([FirstCitation|OtherCitations], CitationCount).
citations_fit(open, []).
citations_fit(refused, []).

well_shaped(Subject) :-
    weekly_rest_subject(Subject),
    weekly_rest_assess(Subject, weekly_rest_verdict(Status, Citations)),
    status_shape(Status, Shape),
    citations_fit(Shape, Citations).

subjects_with_status(Status, Subjects) :-
    findall(Subject, (weekly_rest_subject(Subject), weekly_rest_assess(Subject, weekly_rest_verdict(Status, _))), Subjects).

day_of_subject(Subject, BlockDay) :-
    weekly_rest_profile_for(Subject, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    first_period_without_weekly_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, BlockDay).

all_subjects(SubjectSet) :-
    findall(Subject, weekly_rest_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_status) :-
    findall(VerdictCount, verdict_count(_, VerdictCount), Counts),
    sort(Counts, [1]).
test(determinism_every_subject_has_exactly_one_figure) :-
    findall(AnswerCount, minutes_count(_, AnswerCount), Counts),
    sort(Counts, [1]).
test(determinism_every_subject_has_exactly_one_day) :-
    findall(AnswerCount, day_count(_, AnswerCount), Counts),
    sort(Counts, [1]).
test(every_status_has_a_contract_shape_and_fitting_citations) :-
    all_subjects(SubjectSet),
    findall(Subject, well_shaped(Subject), Shaped),
    sort(Shaped, SubjectSet).
test(given_exactly_when_there_is_no_period_without_weekly_rest) :-
    subjects_with_status(weekly_rest_given, GivenSubjects),
    GivenSubjects = [_|_],
    findall(Subject, (member(Subject, GivenSubjects), day_of_subject(Subject, no_period_without_weekly_rest)), Confirmed),
    Confirmed == GivenSubjects.
test(not_given_always_has_a_first_day) :-
    subjects_with_status(weekly_rest_not_given, ShortSubjects),
    ShortSubjects = [_|_],
    findall(Subject, (member(Subject, ShortSubjects), day_of_subject(Subject, date(_, _, _))), Confirmed),
    Confirmed == ShortSubjects.
test(every_settled_figure_lies_within_one_block) :-
    findall(Minutes, (weekly_rest_subject(Subject), weekly_rest_profile_for(Subject, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)), shortest_weekly_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes), integer(Minutes)), Figures),
    Figures = [_|_],
    min_list(Figures, Smallest),
    Smallest >= 0,
    max_list(Figures, Largest),
    Largest =< 10080.
test(more_work_never_gives_more_rest) :-
    Profile = [attribute(weekly_rest_reference_period, seven_day_period)],
    shortest_weekly_rest_minutes(Profile, worker_one, [], date(2026, 3, 2), date(2026, 3, 8), EmptyRota),
    shortest_weekly_rest_minutes(Profile, worker_one, [shift(worker_one, date_time(2026, 3, 4, 8, 0), date_time(2026, 3, 4, 16, 0), work)], date(2026, 3, 2), date(2026, 3, 8), OneShift),
    shortest_weekly_rest_minutes(Profile, worker_one, [shift(worker_one, date_time(2026, 3, 4, 8, 0), date_time(2026, 3, 4, 16, 0), work), shift(worker_one, date_time(2026, 3, 6, 8, 0), date_time(2026, 3, 6, 16, 0), work)], date(2026, 3, 2), date(2026, 3, 8), TwoShifts),
    EmptyRota >= OneShift,
    OneShift >= TwoShifts,
    EmptyRota =:= 10080.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_status, determinism_every_subject_has_exactly_one_figure, determinism_every_subject_has_exactly_one_day, every_status_has_a_contract_shape_and_fitting_citations, given_exactly_when_there_is_no_period_without_weekly_rest, not_given_always_has_a_first_day, every_settled_figure_lies_within_one_block, more_work_never_gives_more_rest]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
