% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [decide_psa_licence_class/2, psa_licence_class_status/2]).
:- use_module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_subject/1, psa_licence_class_profile_for/2]).

subject_classifies(Subject) :-
    psa_licence_class_subject(Subject),
    psa_licence_class_profile_for(Subject, Profile),
    decide_psa_licence_class(Profile, _Result).

test(totality_every_subject_classifies) :-
    findall(Subject, psa_licence_class_subject(Subject), AllSubjects),
    sort(AllSubjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_status) :-
    findall(Subject, psa_licence_class_subject(Subject), AllSubjects),
    sort(AllSubjects, SubjectSet),
    findall(Subject, subject_deterministic(Subject), DeterministicSubjects),
    sort(DeterministicSubjects, SubjectSet).

subject_deterministic(Subject) :-
    psa_licence_class_subject(Subject),
    psa_licence_class_profile_for(Subject, Profile),
    findall(Status, psa_licence_class_status(Profile, Status), Statuses),
    length(Statuses, 1).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_status]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
