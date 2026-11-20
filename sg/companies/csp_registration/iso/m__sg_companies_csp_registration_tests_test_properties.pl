% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_csp_registration_csp_registration, [csp_registration_status/2, csp_registration_status_values/1]).
:- use_module(m__sg_companies_csp_registration_fixtures, [csp_registration_subject/1, csp_registration_profile_for/2]).

subject_classifies(Subject) :-
    csp_registration_subject(Subject),
    csp_registration_profile_for(Subject, Profile),
    csp_registration_status(Profile, _Status).

test(totality_every_subject_classifies) :-
    findall(Subject, csp_registration_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_status) :-
    findall(Subject, csp_registration_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_is_deterministic(Subject), DeterministicSubjects),
    sort(DeterministicSubjects, SubjectSet).
test(every_status_is_a_valid_atom) :-
    findall(Subject, csp_registration_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_status_is_valid(Subject), ValidSubjects),
    sort(ValidSubjects, SubjectSet).

subject_is_deterministic(Subject) :-
    csp_registration_subject(Subject),
    csp_registration_profile_for(Subject, Profile),
    findall(Status, csp_registration_status(Profile, Status), Statuses),
    length(Statuses, 1).

subject_status_is_valid(Subject) :-
    csp_registration_subject(Subject),
    csp_registration_profile_for(Subject, Profile),
    csp_registration_status(Profile, Status),
    csp_registration_status_values(ValidStatuses),
    member(Status, ValidStatuses).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_status, every_status_is_a_valid_atom]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
