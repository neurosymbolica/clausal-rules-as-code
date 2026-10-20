:- module(m__eu_procurement_framework_agreements_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [decide_framework_agreements/2, decide_call_off/2, call_off_route/2]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_subject/1, framework_agreements_profile_for/2]).

has_verdict(Subject) :-
    framework_agreements_subject(Subject),
    framework_agreements_profile_for(Subject, Profile),
    findall(Verdict, decide_framework_agreements(Profile, Verdict), [_|_]).

unique_call_off_verdict(Subject) :-
    framework_agreements_subject(Subject),
    framework_agreements_profile_for(Subject, Profile),
    findall(V, decide_call_off(Profile, V), Verdicts),
    length(Verdicts, 1).

unique_route(Subject) :-
    framework_agreements_subject(Subject),
    framework_agreements_profile_for(Subject, Profile),
    findall(R, call_off_route(Profile, R), Routes),
    length(Routes, 1).

test('P1 totality: every subject classifies') :-
    findall(Subject, framework_agreements_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, has_verdict(Subject), ClassifiedList),
    length(ClassifiedList, SubjectCount).
test('P2 determinism: decide_call_off yields exactly one verdict per subject') :-
    findall(Subject, framework_agreements_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, unique_call_off_verdict(Subject), DeterministicList),
    length(DeterministicList, SubjectCount).
test('P3 route uniqueness: call_off_route yields exactly one route per subject') :-
    findall(Subject, framework_agreements_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, unique_route(Subject), UniqueList),
    length(UniqueList, SubjectCount).

cp_test_names(['P1 totality: every subject classifies', 'P2 determinism: decide_call_off yields exactly one verdict per subject', 'P3 route uniqueness: call_off_route yields exactly one route per subject']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
