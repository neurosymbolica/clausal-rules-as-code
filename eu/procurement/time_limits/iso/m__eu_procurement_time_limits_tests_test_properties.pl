:- module(m__eu_procurement_time_limits_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_time_limits_time_limits, [decide_time_limits/2, time_limits_status_values/1, time_limits_conformity_values/1, minimum_time_limit_days/5]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_subject/1, time_limits_profile_for/2]).
:- use_module(formalize_lib, [profile_lacks/2]).

has_verdict(Subject) :-
    time_limits_subject(Subject),
    time_limits_profile_for(Subject, Profile),
    findall(Verdict, decide_time_limits(Profile, Verdict), [_|_]).

test('P1 totality: every subject classifies') :-
    findall(Subject, time_limits_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, has_verdict(Subject), ClassifiedSubjectList),
    length(ClassifiedSubjectList, SubjectCount).
test('P2 determinism: every subject yields exactly one verdict') :-
    findall(Subject, time_limits_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, deterministic_subject(Subject), DeterministicSubjectList),
    length(DeterministicSubjectList, SubjectCount).
test('P3 status validity: every verdict status is in the closed vocabulary') :-
    findall(Subject, time_limits_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, status_valid_subject(Subject), ValidSubjectList),
    length(ValidSubjectList, SubjectCount).
test('P4 citation completeness: every verdict carries at least one citation') :-
    findall(Subject, time_limits_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, cited_subject(Subject), CitedSubjectList),
    length(CitedSubjectList, SubjectCount).
test('P7 conformity validity: every verdict\'s conformity slot is in the closed vocabulary') :-
    findall(Subject, time_limits_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, conformity_valid_subject(Subject), ValidSubjectList),
    length(ValidSubjectList, SubjectCount).
test('P8 conformity soundness: nothing meets a minimum without supplied days and a prescribed minimum') :-
    findall(Subject, unsupported_conformity_claim(Subject), []).
test('P5 table sanity: every published figure is within 10..35 days') :-
    findall(row(ProcedureType, Stage, ReductionCondition), out_of_range_row(ProcedureType, Stage, ReductionCondition), []).
test('P6 reduction monotonicity: no reduced row exceeds its baseline row') :-
    findall(row(ProcedureType, Stage, ReductionCondition), reduction_exceeds_baseline(ProcedureType, Stage, ReductionCondition), []).

deterministic_subject(Subject) :-
    time_limits_subject(Subject),
    time_limits_profile_for(Subject, Profile),
    findall(Verdict, decide_time_limits(Profile, Verdict), VerdictList),
    length(VerdictList, 1).

status_valid_subject(Subject) :-
    time_limits_subject(Subject),
    time_limits_profile_for(Subject, Profile),
    decide_time_limits(Profile, time_limits_verdict(Status, _, _, _)),
    time_limits_status_values(StatusValues),
    member(Status, StatusValues).

cited_subject(Subject) :-
    time_limits_subject(Subject),
    time_limits_profile_for(Subject, Profile),
    decide_time_limits(Profile, time_limits_verdict(_, _, _, Citations)),
    dif(Citations, []).

conformity_valid_subject(Subject) :-
    time_limits_subject(Subject),
    time_limits_profile_for(Subject, Profile),
    decide_time_limits(Profile, time_limits_verdict(_, _, Conformity, _)),
    time_limits_conformity_values(ConformityValues),
    member(Conformity, ConformityValues).

unsupported_conformity_claim(Subject) :-
    time_limits_subject(Subject),
    time_limits_profile_for(Subject, Profile),
    decide_time_limits(Profile, time_limits_verdict(_, _, Conformity, _)),
    Conformity = meets_prescribed_minimum,
    profile_lacks(Profile, observed_time_limit_days).
unsupported_conformity_claim(Subject) :-
    time_limits_subject(Subject),
    time_limits_profile_for(Subject, Profile),
    decide_time_limits(Profile, time_limits_verdict(Status, _, Conformity, _)),
    Conformity = meets_prescribed_minimum,
    dif(Status, minimum_days_prescribed).

out_of_range_row(ProcedureType, Stage, ReductionCondition) :-
    minimum_time_limit_days(ProcedureType, Stage, ReductionCondition, Days, _),
    Days #< 10.
out_of_range_row(ProcedureType, Stage, ReductionCondition) :-
    minimum_time_limit_days(ProcedureType, Stage, ReductionCondition, Days, _),
    Days #> 35.

reduction_exceeds_baseline(ProcedureType, Stage, ReductionCondition) :-
    minimum_time_limit_days(ProcedureType, Stage, ReductionCondition, ReducedDays, _),
    dif(ReductionCondition, baseline_minimum),
    minimum_time_limit_days(ProcedureType, Stage, baseline_minimum, BaselineDays, _),
    ReducedDays #> BaselineDays.

cp_test_names(['P1 totality: every subject classifies', 'P2 determinism: every subject yields exactly one verdict', 'P3 status validity: every verdict status is in the closed vocabulary', 'P4 citation completeness: every verdict carries at least one citation', 'P7 conformity validity: every verdict\'s conformity slot is in the closed vocabulary', 'P8 conformity soundness: nothing meets a minimum without supplied days and a prescribed minimum', 'P5 table sanity: every published figure is within 10..35 days', 'P6 reduction monotonicity: no reduced row exceeds its baseline row']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
