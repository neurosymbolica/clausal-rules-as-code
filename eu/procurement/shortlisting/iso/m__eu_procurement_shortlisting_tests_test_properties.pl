:- module(m__eu_procurement_shortlisting_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [decide_shortlisting/2, shortlisting_status/2]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_subject/1, shortlisting_profile_for/2]).

has_verdict(Subject) :-
    shortlisting_subject(Subject),
    shortlisting_profile_for(Subject, Profile),
    decide_shortlisting(Profile, _).

test('P1 totality: every subject classifies') :-
    findall(Subject, shortlisting_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, has_verdict(Subject), ClassifiedSubjectList),
    length(ClassifiedSubjectList, SubjectCount).
test('P2 determinism: each subject yields exactly one status') :-
    findall(Subject, shortlisting_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, deterministic(Subject), DeterministicList),
    length(DeterministicList, SubjectCount).
test('P3 invariant: number_to_invite is always non-negative') :-
    findall(Subject, shortlisting_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, non_negative_floor(Subject), ValidList),
    length(ValidList, SubjectCount).
test('P4 invariant: defect_ids and citations are parallel') :-
    findall(Subject, shortlisting_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, parallel_lists(Subject), ParallelList),
    length(ParallelList, SubjectCount).

deterministic(Subject) :-
    shortlisting_profile_for(Subject, Profile),
    findall(Status, decide_shortlisting(Profile, shortlisting_verdict(Status, _, _, _)), StatusList),
    length(StatusList, 1).

non_negative_floor(Subject) :-
    shortlisting_profile_for(Subject, Profile),
    decide_shortlisting(Profile, shortlisting_verdict(_Status, _Defects, NumberToInvite, _Citations)),
    NumberToInvite #>= 0.

parallel_lists(Subject) :-
    shortlisting_profile_for(Subject, Profile),
    decide_shortlisting(Profile, shortlisting_verdict(_Status, DefectIds, _Number, Citations)),
    length(DefectIds, DefectCount),
    length(Citations, CitationCount),
    DefectCount #= CitationCount.

cp_test_names(['P1 totality: every subject classifies', 'P2 determinism: each subject yields exactly one status', 'P3 invariant: number_to_invite is always non-negative', 'P4 invariant: defect_ids and citations are parallel']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
