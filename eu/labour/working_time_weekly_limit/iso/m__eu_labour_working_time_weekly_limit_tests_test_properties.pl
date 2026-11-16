% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [decide_working_time_weekly_limit/2, weekly_working_time_average/6, required_reduction_minutes/6, working_time_weekly_limit_status_values/1]).
:- use_module(m__eu_labour_working_time_weekly_limit_citations, [citation/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_fixtures, [working_time_weekly_limit_subject/1, working_time_weekly_limit_profile_for/2]).

all_subjects(SubjectSet) :-
    findall(Subject, working_time_weekly_limit_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    working_time_weekly_limit_subject(Subject),
    working_time_weekly_limit_profile_for(Subject, SubjectCase),
    decide_working_time_weekly_limit(SubjectCase, _Verdict).

subject_has_one_verdict(Subject) :-
    working_time_weekly_limit_profile_for(Subject, SubjectCase),
    findall(Verdict, decide_working_time_weekly_limit(SubjectCase, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_average(Subject) :-
    working_time_weekly_limit_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Average, weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average), Averages),
    length(Averages, 1).

subject_has_one_reduction(Subject) :-
    working_time_weekly_limit_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Minutes, required_reduction_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes), Reductions),
    length(Reductions, 1).

subject_verdict_well_shaped(Subject) :-
    working_time_weekly_limit_profile_for(Subject, SubjectCase),
    decide_working_time_weekly_limit(SubjectCase, working_time_weekly_limit_verdict(Status, Citations)),
    verdict_shape(Status, Citations).

verdict_shape(Status, [Citation|Citations]) :-
    atom(Status),
    working_time_weekly_limit_status_values(StatusValues),
    member(Status, StatusValues),
    maplist(recorded_citation, [Citation|Citations]),
    sort([Citation|Citations], DistinctCitations),
    length([Citation|Citations], CitationCount),
    length(DistinctCitations, CitationCount).
verdict_shape(input_problems([_|_]), []).
verdict_shape(indeterminate([MissingKey]), []) :-
    atom(MissingKey).
verdict_shape(needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(PairList)]), []) :-
    atom(InputKey),
    recorded_citation(cite(CitationKey)),
    is_list(PairList).

recorded_citation(cite(CitationKey)) :-
    citation(CitationKey, _).

subject_average_well_shaped(Subject) :-
    working_time_weekly_limit_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average),
    average_shape(Average).

average_shape(minutes_per_seven_days(Numerator, Denominator)) :-
    integer(Numerator),
    integer(Denominator),
    Denominator #>= 1,
    Numerator #>= 0,
    greatest_common_divisor(Numerator, Denominator, Divisor),
    Divisor #= 1.
average_shape(no_countable_period).
average_shape(indeterminate([MissingKey])) :-
    atom(MissingKey).
average_shape(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)])).
average_shape(input_problems([_|_])).

greatest_common_divisor(First, 0, First).
greatest_common_divisor(First, Second, Divisor) :-
    Second #> 0,
    Remainder #= First mod Second,
    greatest_common_divisor(Second, Remainder, Divisor).

subject_reduction_agrees(Subject) :-
    working_time_weekly_limit_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    decide_working_time_weekly_limit(case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), working_time_weekly_limit_verdict(Status, _Citations)),
    required_reduction_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes),
    reduction_agrees(Status, Minutes).

reduction_agrees(within_weekly_limit, 0).
reduction_agrees(over_weekly_limit, Minutes) :-
    integer(Minutes),
    Minutes #> 0.
reduction_agrees(weekly_limit_not_applied_by_agreement, Minutes) :-
    integer(Minutes),
    Minutes #> 0.
reduction_agrees(reference_period_longer_than_allowed, _).
reduction_agrees(no_countable_period, no_countable_period).
reduction_agrees(indeterminate(_), _).
reduction_agrees(needs_legal_review(_, _), _).
reduction_agrees(input_problems(Problems), input_problems(Problems)).

boundary_pair(at_limit, one_minute_over).
boundary_pair(leave_day_at_limit, leave_day_one_minute_over).
boundary_pair(edge_shift_at_limit, edge_shift_one_minute_over).

pair_flips(WithinSubject - OverSubject) :-
    working_time_weekly_limit_profile_for(WithinSubject, WithinCase),
    working_time_weekly_limit_profile_for(OverSubject, OverCase),
    decide_working_time_weekly_limit(WithinCase, working_time_weekly_limit_verdict(within_weekly_limit, _)),
    decide_working_time_weekly_limit(OverCase, working_time_weekly_limit_verdict(over_weekly_limit, _)).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(the_subject_set_is_not_empty) :-
    all_subjects([_|_]).
test(determinism_every_subject_has_one_verdict) :-
    all_subjects(SubjectSet),
    maplist(subject_has_one_verdict, SubjectSet).
test(determinism_every_subject_has_one_average) :-
    all_subjects(SubjectSet),
    maplist(subject_has_one_average, SubjectSet).
test(determinism_every_subject_has_one_reduction) :-
    all_subjects(SubjectSet),
    maplist(subject_has_one_reduction, SubjectSet).
test(every_verdict_is_well_shaped_and_cited) :-
    all_subjects(SubjectSet),
    maplist(subject_verdict_well_shaped, SubjectSet).
test(every_average_is_exact_and_in_lowest_terms) :-
    all_subjects(SubjectSet),
    maplist(subject_average_well_shaped, SubjectSet).
test(the_reduction_agrees_with_the_status) :-
    all_subjects(SubjectSet),
    maplist(subject_reduction_agrees, SubjectSet).
test(one_minute_more_flips_within_to_over) :-
    findall(WithinSubject - OverSubject, boundary_pair(WithinSubject, OverSubject), PairList),
    PairList = [_|_],
    maplist(pair_flips, PairList).

test(a_bare_status_atom_outside_the_vocabulary_is_rejected, fail) :-
    verdict_shape(indeterminate, [cite(eu_dir_2003_88_art_6_b)]).
test(a_reducible_average_is_rejected, fail) :-
    average_shape(minutes_per_seven_days(5760, 2)).

cp_test_names([totality_every_subject_classifies, the_subject_set_is_not_empty, determinism_every_subject_has_one_verdict, determinism_every_subject_has_one_average, determinism_every_subject_has_one_reduction, every_verdict_is_well_shaped_and_cited, every_average_is_exact_and_in_lowest_terms, the_reduction_agrees_with_the_status, one_minute_more_flips_within_to_over]).
cp_test_fail_names([a_bare_status_atom_outside_the_vocabulary_is_rejected, a_reducible_average_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
